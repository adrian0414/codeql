use crate::language::Language;
use crate::ql;
use std::collections::BTreeSet;
use std::fs::File;
use std::io::LineWriter;

/// Writes the QL AST library for the given library.
///
/// # Arguments
///
/// `language` - the language for which we're generating a library
/// `classes` - the list of classes to write.
pub fn write(language: &Language, classes: &[ql::TopLevel]) -> std::io::Result<()> {
    println!(
        "Writing QL library for {} to '{}'",
        &language.name,
        match language.ql_library_path.to_str() {
            None => "<undisplayable>",
            Some(p) => p,
        }
    );
    let file = File::create(&language.ql_library_path)?;
    let mut file = LineWriter::new(file);
    ql::write(&language.name, &mut file, &classes)
}

/// Creates the hard-coded `AstNode` class that acts as a supertype of all
/// classes we generate.
fn create_ast_node_class<'a>() -> ql::Class<'a> {
    // Default implementation of `toString` calls `this.getAPrimaryQlClass()`
    let to_string = ql::Predicate {
        name: "toString",
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::Dot(
                Box::new(ql::Expression::Var("this")),
                "getAPrimaryQlClass",
                vec![],
            )),
        ),
    };
    let get_location =
        create_none_predicate("getLocation", false, Some(ql::Type::Normal("Location")));
    let get_a_field_or_child =
        create_none_predicate("getAFieldOrChild", false, Some(ql::Type::Normal("AstNode")));
    let get_parent = create_none_predicate("getParent", false, Some(ql::Type::Normal("AstNode")));
    let get_parent_index = create_none_predicate("getParentIndex", false, Some(ql::Type::Int));
    let get_a_primary_ql_class = ql::Predicate {
        name: "getAPrimaryQlClass",
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::String("???")),
        ),
    };
    ql::Class {
        name: "AstNode",
        is_abstract: false,
        supertypes: vec![ql::Type::AtType("ast_node")].into_iter().collect(),
        characteristic_predicate: None,
        predicates: vec![
            to_string,
            get_location,
            get_parent,
            get_parent_index,
            get_a_field_or_child,
            get_a_primary_ql_class,
        ],
    }
}

fn create_token_class<'a>() -> ql::Class<'a> {
    let get_parent = ql::Predicate {
        name: "getParent",
        overridden: true,
        return_type: Some(ql::Type::Normal("AstNode")),
        formal_parameters: vec![],
        body: create_get_field_expr_for_column_storage("result", "tokeninfo", 0, 8),
    };
    let get_parent_index = ql::Predicate {
        name: "getParentIndex",
        overridden: true,
        return_type: Some(ql::Type::Int),
        formal_parameters: vec![],
        body: create_get_field_expr_for_column_storage("result", "tokeninfo", 1, 8),
    };
    let get_value = ql::Predicate {
        name: "getValue",
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: create_get_field_expr_for_column_storage("result", "tokeninfo", 5, 8),
    };
    let get_location = ql::Predicate {
        name: "getLocation",
        overridden: true,
        return_type: Some(ql::Type::Normal("Location")),
        formal_parameters: vec![],
        body: create_get_field_expr_for_column_storage("result", "tokeninfo", 6, 8),
    };
    let to_string = ql::Predicate {
        name: "toString",
        overridden: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::Pred("getValue", vec![])),
        ),
    };
    ql::Class {
        name: "Token",
        is_abstract: false,
        supertypes: vec![ql::Type::AtType("token"), ql::Type::Normal("AstNode")]
            .into_iter()
            .collect(),
        characteristic_predicate: None,
        predicates: vec![
            get_parent,
            get_parent_index,
            get_value,
            get_location,
            to_string,
            create_get_a_primary_ql_class("Token"),
        ],
    }
}

// Creates the `ReservedWord` class.
fn create_reserved_word_class<'a>() -> ql::Class<'a> {
    let db_name = "reserved_word";
    let class_name = "ReservedWord";
    let get_a_primary_ql_class = create_get_a_primary_ql_class(&class_name);
    ql::Class {
        name: class_name,
        is_abstract: false,
        supertypes: vec![ql::Type::AtType(db_name), ql::Type::Normal("Token")]
            .into_iter()
            .collect(),
        characteristic_predicate: None,
        predicates: vec![get_a_primary_ql_class],
    }
}

/// Creates a predicate whose body is `none()`.
fn create_none_predicate<'a>(
    name: &'a str,
    overridden: bool,
    return_type: Option<ql::Type<'a>>,
) -> ql::Predicate<'a> {
    ql::Predicate {
        name: name,
        overridden,
        return_type,
        formal_parameters: Vec::new(),
        body: ql::Expression::Pred("none", vec![]),
    }
}

/// Creates an overridden `getAPrimaryQlClass` predicate that returns the given
/// name.
fn create_get_a_primary_ql_class<'a>(class_name: &'a str) -> ql::Predicate<'a> {
    ql::Predicate {
        name: "getAPrimaryQlClass",
        overridden: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::String(class_name)),
        ),
    }
}

/// Creates the `getLocation` predicate.
///
/// # Arguments
///
/// `def_table` - the name of the table that defines the entity and its location.
/// `arity` - the total number of columns in the table
fn create_get_location_predicate<'a>(def_table: &'a str, arity: usize) -> ql::Predicate<'a> {
    ql::Predicate {
        name: "getLocation",
        overridden: true,
        return_type: Some(ql::Type::Normal("Location")),
        formal_parameters: vec![],
        // body of the form: foo_bar_def(_, _, ..., result)
        body: ql::Expression::Pred(
            def_table,
            [
                vec![ql::Expression::Var("this")],
                vec![ql::Expression::Var("_"); arity - 2],
                vec![ql::Expression::Var("result")],
            ]
            .concat(),
        ),
    }
}

/// Creates the `getText` predicate for a leaf node.
///
/// # Arguments
///
/// `def_table` - the name of the table that defines the entity and its text.
fn create_get_text_predicate<'a>(def_table: &'a str) -> ql::Predicate<'a> {
    ql::Predicate {
        name: "getText",
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Pred(
            def_table,
            vec![
                ql::Expression::Var("this"),
                ql::Expression::Var("result"),
                ql::Expression::Var("_"),
            ],
        ),
    }
}

/// Returns an expression to get a field that's defined as a column in the parent's table.
///
/// # Arguments
///
/// * `result_var_name` - the name of the variable to which the resulting value should be bound
/// * `table_name` - the name of parent's defining table
/// * `column_index` - the index in that table that defines the field
/// * `arity` - the total number of columns in the table
fn create_get_field_expr_for_column_storage<'a>(
    result_var_name: &'a str,
    table_name: &'a str,
    column_index: usize,
    arity: usize,
) -> ql::Expression<'a> {
    let num_underscores_before = column_index;
    let num_underscores_after = arity - 2 - num_underscores_before;
    ql::Expression::Pred(
        table_name,
        [
            vec![ql::Expression::Var("this")],
            vec![ql::Expression::Var("_"); num_underscores_before],
            vec![ql::Expression::Var(result_var_name)],
            vec![ql::Expression::Var("_"); num_underscores_after],
        ]
        .concat(),
    )
}

/// Returns an expression to get the field with the given index from its
/// auxiliary table. The index name can be "_" so the expression will hold for
/// all indices.
fn create_get_field_expr_for_table_storage<'a>(
    result_var_name: &'a str,
    table_name: &'a str,
    index_var_name: Option<&'a str>,
) -> ql::Expression<'a> {
    ql::Expression::Pred(
        table_name,
        match index_var_name {
            Some(index_var_name) => vec![
                ql::Expression::Var("this"),
                ql::Expression::Var(index_var_name),
                ql::Expression::Var(result_var_name),
            ],
            None => vec![ql::Expression::Var("this"), ql::Expression::Var("result")],
        },
    )
}

/// Creates a pair consisting of a predicate to get the given field, and an
/// optional expression that will get the same field. When the field can occur
/// multiple times, the predicate will take an index argument, while the
/// expression will use the "don't care" expression to hold for all occurrences.
///
/// # Arguments
///
/// `main_table_name` - the name of the defining table for the parent node
/// `main_table_arity` - the number of columns in the main table
/// `main_table_column_index` - a mutable reference to a column index indicating
/// where the field is in the main table. If this is used (i.e. the field has
/// column storage), then the index is incremented.
/// `parent_name` - the name of the parent node
/// `field` - the field whose getters we are creating
/// `field_type` - the db name of the field's type (possibly being a union we created)
fn create_field_getters<'a>(
    main_table_name: &'a str,
    main_table_arity: usize,
    main_table_column_index: &mut usize,
    field: &'a node_types::Field,
    nodes: &'a node_types::NodeTypeMap,
) -> (ql::Predicate<'a>, Option<ql::Expression<'a>>) {
    let return_type = match &field.type_info {
        node_types::FieldTypeInfo::Single(t) => {
            Some(ql::Type::Normal(&nodes.get(&t).unwrap().ql_class_name))
        }
        node_types::FieldTypeInfo::Multiple {
            types: _,
            dbscheme_union: _,
            ql_class,
        } => Some(ql::Type::Normal(&ql_class)),
        node_types::FieldTypeInfo::ReservedWordInt(_) => Some(ql::Type::String),
    };
    let formal_parameters = match &field.storage {
        node_types::Storage::Column { .. } => vec![],
        node_types::Storage::Table { has_index, .. } => {
            if *has_index {
                vec![ql::FormalParameter {
                    name: "i",
                    param_type: ql::Type::Int,
                }]
            } else {
                vec![]
            }
        }
    };

    // For the expression to get a value, what variable name should the result
    // be bound to?
    let get_value_result_var_name = match &field.type_info {
        node_types::FieldTypeInfo::ReservedWordInt(_) => "value",
        node_types::FieldTypeInfo::Single(_) => "result",
        node_types::FieldTypeInfo::Multiple { .. } => "result",
    };

    // Two expressions for getting the value. One that's suitable use in the
    // getter predicate (where there may be a specific index), and another for
    // use in `getAFieldOrChild` (where we use a "don't care" expression to
    // match any index).
    let (get_value, get_value_any_index) = match &field.storage {
        node_types::Storage::Column { name: _ } => {
            let column_index = *main_table_column_index;
            *main_table_column_index += 1;
            (
                create_get_field_expr_for_column_storage(
                    get_value_result_var_name,
                    &main_table_name,
                    column_index,
                    main_table_arity,
                ),
                create_get_field_expr_for_column_storage(
                    get_value_result_var_name,
                    &main_table_name,
                    column_index,
                    main_table_arity,
                ),
            )
        }
        node_types::Storage::Table {
            name: field_table_name,
            has_index,
        } => (
            create_get_field_expr_for_table_storage(
                get_value_result_var_name,
                &field_table_name,
                if *has_index { Some("i") } else { None },
            ),
            create_get_field_expr_for_table_storage(
                get_value_result_var_name,
                &field_table_name,
                if *has_index { Some("_") } else { None },
            ),
        ),
    };
    let (body, optional_expr) = match &field.type_info {
        node_types::FieldTypeInfo::ReservedWordInt(int_mapping) => {
            // Create an expression that binds the corresponding string to `result` for each `value`, e.g.:
            //   result = "foo" and value = 0 or
            //   result = "bar" and value = 1 or
            //   result = "baz" and value = 2
            let disjuncts = int_mapping
                .iter()
                .map(|(token_str, (value, _))| {
                    ql::Expression::And(vec![
                        ql::Expression::Equals(
                            Box::new(ql::Expression::Var("result")),
                            Box::new(ql::Expression::String(token_str)),
                        ),
                        ql::Expression::Equals(
                            Box::new(ql::Expression::Var("value")),
                            Box::new(ql::Expression::Integer(*value)),
                        ),
                    ])
                })
                .collect();
            (
                ql::Expression::Aggregate(
                    "exists",
                    vec![ql::FormalParameter {
                        name: "value",
                        param_type: ql::Type::Int,
                    }],
                    Box::new(get_value),
                    Box::new(ql::Expression::Or(disjuncts)),
                ),
                // Since the getter returns a string and not an AstNode, it won't be part of getAFieldOrChild:
                None,
            )
        }
        node_types::FieldTypeInfo::Single(_) | node_types::FieldTypeInfo::Multiple { .. } => {
            (get_value, Some(get_value_any_index))
        }
    };
    (
        ql::Predicate {
            name: &field.getter_name,
            overridden: false,
            return_type,
            formal_parameters,
            body,
        },
        optional_expr,
    )
}

/// Converts the given node types into CodeQL classes wrapping the dbscheme.
pub fn convert_nodes<'a>(nodes: &'a node_types::NodeTypeMap) -> Vec<ql::TopLevel<'a>> {
    let mut classes: Vec<ql::TopLevel> = vec![
        ql::TopLevel::Import("codeql.files.FileSystem"),
        ql::TopLevel::Import("codeql.Locations"),
        ql::TopLevel::Class(create_ast_node_class()),
        ql::TopLevel::Class(create_token_class()),
        ql::TopLevel::Class(create_reserved_word_class()),
    ];
    let mut token_kinds = BTreeSet::new();
    for (type_name, node) in nodes {
        if let node_types::EntryKind::Token { .. } = &node.kind {
            if type_name.named {
                token_kinds.insert(&type_name.kind);
            }
        }
    }

    for (type_name, node) in nodes {
        match &node.kind {
            node_types::EntryKind::Token { kind_id: _ } => {
                if type_name.named {
                    let get_a_primary_ql_class = create_get_a_primary_ql_class(&node.ql_class_name);
                    let mut supertypes: BTreeSet<ql::Type> = BTreeSet::new();
                    supertypes.insert(ql::Type::AtType(&node.dbscheme_name));
                    supertypes.insert(ql::Type::Normal("Token"));
                    classes.push(ql::TopLevel::Class(ql::Class {
                        name: &node.ql_class_name,
                        is_abstract: false,
                        supertypes,
                        characteristic_predicate: None,
                        predicates: vec![get_a_primary_ql_class],
                    }));
                }
            }
            node_types::EntryKind::Union { members: _ } => {
                // It's a tree-sitter supertype node, so we're wrapping a dbscheme
                // union type.
                classes.push(ql::TopLevel::Class(ql::Class {
                    name: &node.ql_class_name,
                    is_abstract: false,
                    supertypes: vec![
                        ql::Type::AtType(&node.dbscheme_name),
                        ql::Type::Normal("AstNode"),
                    ]
                    .into_iter()
                    .collect(),
                    characteristic_predicate: None,
                    predicates: vec![],
                }));
            }
            node_types::EntryKind::Table {
                name: main_table_name,
                fields,
            } => {
                // Count how many columns there will be in the main table.
                // There will be:
                // - one for the id
                // - one for the parent
                // - one for the parent index
                // - one for the location
                // - one for each field that's stored as a column
                // - if there are no fields, one for the text column.
                let main_table_arity = 4 + if fields.is_empty() {
                    1
                } else {
                    fields
                        .iter()
                        .filter(|&f| matches!(f.storage, node_types::Storage::Column { .. }))
                        .count()
                };

                let main_class_name = &node.ql_class_name;
                let mut main_class = ql::Class {
                    name: &main_class_name,
                    is_abstract: false,
                    supertypes: vec![
                        ql::Type::AtType(&node.dbscheme_name),
                        ql::Type::Normal("AstNode"),
                    ]
                    .into_iter()
                    .collect(),
                    characteristic_predicate: None,
                    predicates: vec![
                        create_get_a_primary_ql_class(&main_class_name),
                        create_get_location_predicate(&main_table_name, main_table_arity),
                    ],
                };

                if fields.is_empty() {
                    main_class
                        .predicates
                        .push(create_get_text_predicate(&main_table_name));
                } else {
                    let mut main_table_column_index: usize = 2;
                    let mut get_child_exprs: Vec<ql::Expression> = Vec::new();

                    // Iterate through the fields, creating:
                    // - classes to wrap union types if fields need them,
                    // - predicates to access the fields,
                    // - the QL expressions to access the fields that will be part of getAFieldOrChild.
                    for field in fields {
                        let (get_pred, get_child_expr) = create_field_getters(
                            &main_table_name,
                            main_table_arity,
                            &mut main_table_column_index,
                            field,
                            nodes,
                        );
                        main_class.predicates.push(get_pred);
                        if let Some(get_child_expr) = get_child_expr {
                            get_child_exprs.push(get_child_expr)
                        }
                    }

                    main_class.predicates.push(ql::Predicate {
                        name: "getParent",
                        overridden: true,
                        return_type: Some(ql::Type::Normal("AstNode")),
                        formal_parameters: vec![],
                        body: create_get_field_expr_for_column_storage(
                            "result",
                            &main_table_name,
                            0,
                            main_table_arity,
                        ),
                    });

                    main_class.predicates.push(ql::Predicate {
                        name: "getParentIndex",
                        overridden: true,
                        return_type: Some(ql::Type::Int),
                        formal_parameters: vec![],
                        body: create_get_field_expr_for_column_storage(
                            "result",
                            &main_table_name,
                            1,
                            main_table_arity,
                        ),
                    });

                    main_class.predicates.push(ql::Predicate {
                        name: "getAFieldOrChild",
                        overridden: true,
                        return_type: Some(ql::Type::Normal("AstNode")),
                        formal_parameters: vec![],
                        body: ql::Expression::Or(get_child_exprs),
                    });
                }

                classes.push(ql::TopLevel::Class(main_class));
            }
        }
    }

    classes
}
