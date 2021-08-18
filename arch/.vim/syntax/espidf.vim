" Vim syntax file
" Author: Breno Cunha Queiroz
" Creation: 2020-07-25
" Notes: Esp-idf vim syntax highlighting


" Core
syntax match constant /\C\<[A-Z0-9]\+[A-Z]\w*\>/ 
syntax keyword constant ESP_GATT_OK
syntax keyword type esp_err_t 

" SPI
syntax keyword type spi_bus_config_t 
syntax keyword type spi_device_interface_config_t 
syntax keyword type spi_device_handle_t 
syntax keyword type spi_transaction_t 

" GPIO
syntax keyword type gpio_config_t 
syntax keyword type gpio_num_t 
syntax keyword type gpio_pulldown_t
syntax keyword type gpio_pullup_t

" Ledc
syntax keyword type ledc_channel_t
syntax keyword type ledc_channel_config_t 
syntax keyword type ledc_timer_config_t 

" Camera
syntax keyword type camera_config_t
syntax keyword type camera_fb_t  

" Bluetooth
syntax keyword constant ESP_BT_MODE_BLE
syntax keyword constant ESP_BT_MODE_IDLE
syntax keyword constant ESP_BT_MODE_CLASSIC_BT
syntax keyword constant ESP_BT_MODE_BTDM
syntax keyword constant SCAN_RSP_CONFIG_FLAG
syntax keyword constant ESP_GAP_BLE_SCAN_RSP_DATA_SET_COMPLETE_EVT
syntax keyword constant SCAN_RSP_CONFIG_FLAG
syntax keyword constant ESP_GAP_BLE_SCAN_RSP_DATA_SET_COMPLETE_EVT
syntax keyword constant SCAN_RSP_CONFIG_FLAG
syntax keyword constant ESP_GAP_BLE_ADV_START_COMPLETE_EVT
syntax keyword constant ESP_BT_STATUS_SUCCESS
syntax keyword constant ESP_GAP_BLE_ADV_STOP_COMPLETE_EVT
syntax keyword constant ESP_GAP_BLE_UPDATE_CONN_PARAMS_EVT
syntax keyword constant ESP_GATTS_REG_EVT
syntax keyword constant ESP_GATTS_READ_EVT 
syntax keyword constant ESP_GATTS_WRITE_EVT
syntax keyword constant ESP_GATTS_EXEC_WRITE_EVT
syntax keyword constant ESP_GATTS_MTU_EVT
syntax keyword constant ESP_GATTS_CONF_EVT
syntax keyword constant ESP_GATTS_START_EVT
syntax keyword constant ESP_GATTS_CONNECT_EVT
syntax keyword constant ESP_GATTS_DISCONNECT_EVT
syntax keyword constant ESP_GATTS_CREAT_ATTR_TAB_EVT
syntax keyword constant ESP_GATTS_STOP_EVT
syntax keyword constant ESP_GATTS_OPEN_EVT
syntax keyword constant ESP_GATTS_CANCEL_OPEN_EVT
syntax keyword constant ESP_GATTS_CLOSE_EVT
syntax keyword constant ESP_GATTS_LISTEN_EVT
syntax keyword constant ESP_GATTS_CONGEST_EVT
syntax keyword constant ESP_GATTS_UNREG_EVT
syntax keyword constant ESP_GATTS_DELETE_EVT
syntax keyword constant ESP_GATT_NO_RESOURCES
syntax keyword constant ESP_GATT_INVALID_ATTR_LEN
syntax keyword constant ESP_GATT_INVALID_OFFSET
syntax keyword constant ESP_GATT_AUTH_REQ_NONE
syntax keyword constant ESP_GATT_PREP_WRITE_EXEC 
syntax keyword constant ESP_GATT_AUTO_RSP
syntax keyword constant ESP_UUID_LEN_16
syntax keyword constant ESP_GATT_PERM_READ 
syntax keyword constant ESP_GATT_PERM_WRITE
syntax keyword constant ESP_GATT_UUID_PRI_SERVICE
syntax keyword constant ESP_GATT_UUID_CHAR_DECLARE
syntax keyword constant ESP_GATT_UUID_CHAR_CLIENT_CONFIG
syntax keyword constant ESP_GATT_CHAR_PROP_BIT_READ
syntax keyword constant ESP_GATT_CHAR_PROP_BIT_WRITE
syntax keyword constant ESP_GATT_CHAR_PROP_BIT_NOTIFY
syntax keyword constant ESP_GATT_IF_NONE

syntax keyword constant ESP_BLE_ADV_FLAG_GEN_DISC 
syntax keyword constant ESP_BLE_ADV_FLAG_BREDR_NOT_SPT
syntax keyword constant ESP_GAP_BLE_SCAN_RSP_DATA_RAW_SET_COMPLETE_EVT
syntax keyword constant ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT
syntax keyword constant ADV_CONFIG_FLAG
syntax keyword constant ESP_GAP_BLE_ADV_DATA_RAW_SET_COMPLETE_EVT

syntax keyword type esp_ble_adv_data_t 
syntax keyword type esp_gap_ble_cb_event_t 
syntax keyword type esp_ble_gap_cb_param_t 
syntax keyword type esp_gatt_status_t 
syntax keyword type esp_gatt_if_t 
syntax keyword type esp_gatt_rsp_t 
syntax keyword type esp_ble_gatts_cb_param_t 

hi def link constant        Comment
hi def link function        Function
hi def link type         	Type
