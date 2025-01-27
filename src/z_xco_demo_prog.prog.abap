*&---------------------------------------------------------------------*
*& Report Z_XCO_DEMO_PROG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_XCO_DEMO_PROG.

DATA(lo_package) = xco_cp_abap_repository=>package->for( 'Z_XCO_PACKAGE' ).
*
*DATA(lo_transport_target) = lo_package->read(
*  )-property-transport_layer->get_transport_target(
*  )->value.


"or

CONSTANTS:
  co_package   TYPE sxco_package VALUE 'Z_XCO_PACKAGE'.

" Before being able to create a new transport request the transport target
"which is usually derived from the transport layer of a development package needs to be known

" Set up transport target
DATA(lo_transport_target) = xco_abap_repository=>package->for( co_package
        )->read(
        )-property-transport_layer->get_transport_target( ).

"Create a TR
DATA(lo_transport_request) = xco_cp_cts=>transports->workbench( lo_transport_target->value
        )->create_request( 'My generated transport request for XCO Demo Library' ).


*" Add tasks to transport request (if needed)
*" by default while creating TR it will automatically assign Task to the TR
*"if we want to add extra Task then using below code we can assign task to the TR
* lo_transport_request->create_task(
*   RECEIVING
*    ro_task = data(lo_task)
* ).

*lo_task->if_xco_cp_transport~
 "Release transport request
*lo_transport_request->release( ).

" delete request- ??

*create simple data base table

DATA(lo_put_operation) = xco_cp_generation=>environment->dev_system( lo_transport_request->value
  )->create_put_operation( ).

DATA(lo_put_operation1) = xco_CP_generation=>environment->dev_system( lo_transport_request->value
  )->create_put_operation( ).

" Add the database table to the PUT operation.
DATA(lo_database_table) = lo_put_operation->for-tabl-for-database_table->add_object( 'ZMY_DBT'
  )->set_package( lo_package->name
  )->create_form_specification( ).
lo_database_table->set_short_description( 'My generated database table' ).
lo_database_table->set_delivery_class( xco_cp_database_table=>delivery_class->l ).
lo_database_table->set_data_maintenance( xco_cp_database_table=>data_maintenance->allowed ).

lo_database_table->add_field( 'KEY_FIELD'
  )->set_key_indicator(
  )->set_type( xco_cp_abap_dictionary=>built_in_type->char( 30 )
  )->set_not_null( ).


DATA: oref   TYPE REF TO cx_root,
      text   TYPE string.

*TRY.
*lo_put_operation->execute( ).
*CATCH cx_xco_gen_put_exception INTO DATA(LV_ERROR).
*  cl_demo_output=>display( LV_ERROR ).
*  ENDTRY.

TRY.
  lo_put_operation->execute( ).
  CATCH cx_xco_gen_put_exception INTO oref.
    text = oref->get_text( ).
    WRITE TEXT.
    CATCH cx_root INTO oref.
      text = oref->get_text( ).
      WRITE TEXT.
      ENDTRY.

**  DATA(lo_put_operation) = xco_cp_generation=>environment->dev_system( lo_transport_request->value
**      )->create_put_operation( ).
**
**    "Add copied domains to the PUT operation.
**    DATA(lo_template) = xco_cp_generation_doma=>template->for_domain(
**   iv_name       = '/DMO/CUSTOMER_ID'
**   io_read_state = xco_cp_abap_dictionary=>object_read_state->active_version
** ).
**
**    lo_put_operation->for-doma->add_object( 'ZCOPIEDID_DOMAIN'
**  )->set_package( co_package
**  )->set_template( lo_template ).
**
**    "Add data elements(with copied domain) to the PUT operation.
**
**    DATA(lo_specification) = lo_put_operation->for-dtel->add_object( 'ZDATA_ELEMENT'
**      )->set_package( co_package
**      )->create_form_specification( ).
**    lo_specification->set_short_description( 'My generated data element with XCO' ).
**
**    lo_specification->set_data_type( xco_cp_abap_dictionary=>domain( 'ZCOPIEDID_DOMAIN'  ) ).
**    lo_specification->field_label-short->set_text( 'ID' ).
**    lo_specification->field_label-medium->set_text( 'New ID' ).
**    lo_specification->field_label-long->set_text( 'New User identifier' ).
**    lo_specification->field_label-heading->set_text( 'New User identifier' ).
**
**    " Add the database table and data elements to the PUT operation.
**    DATA(lo_database_table) = lo_put_operation->for-tabl-for-database_table->add_object( 'ZTBL_XCO_EXAMPLE'
**      )->set_package( co_package
**      )->create_form_specification( ).
**    lo_database_table->set_short_description( 'My generated database table with XCO' ).
**    lo_database_table->set_delivery_class( xco_cp_database_table=>delivery_class->l ).
**    lo_database_table->set_data_maintenance( xco_cp_database_table=>data_maintenance->allowed ).
**
**    lo_database_table->add_field( 'MANDT'
**      )->set_key_indicator(
**      )->set_type( xco_cp_abap_dictionary=>built_in_type->clnt
**      )->set_not_null( ).
**
**    lo_database_table->add_field( 'ID'
**      )->set_key_indicator(
**      )->set_type( xco_cp_abap_dictionary=>data_element( 'ZDATA_ELEMENT' )
**      )->set_not_null( ).
**
**    " Further fields (including information about foreign keys, search helps, etc.) can be
**    " added following the same pattern.
**
**    lo_put_operation->execute( ).

" Add the data definition for the CDS view entity to the PUT operation
*DATA(lo_data_definition) = lo_put_operation->for-ddls->add_object( 'Z_XCO_VIEW_ENTITY'
*  )->set_package( lo_package->name
*  )->create_form_specification( ).
*lo_data_definition->set_short_description( 'My generated XCO Demo view entity' ).
*
*DATA(lo_view_entity) = lo_data_definition->add_view_entity( ).
*lo_view_entity->data_source->set_view_entity( 'Z_XCO_DEMOTABLE' ).
*
*DATA(lo_key_field) = lo_view_entity->add_field( xco_cp_ddl=>field( 'Emp_Number' ) ).
*lo_key_field->set_key( )->set_alias( 'EmployeeNumber' ).
*lo_key_field->add_annotation( 'EndUserText.label' )->value->build( )->add_string( 'Employee Number' ).
*
*lo_put_operation->execute( ).
