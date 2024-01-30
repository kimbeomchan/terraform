variable "linux_distribution_list" {
  description = "Pre-defined Azure Linux VM images list"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    rocky86free = {
      publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
      offer     = "rockylinux"
      sku       = "free"
      version   = "latest"
    }

    ubuntu1604 = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    },

    ubuntu1804 = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },

    ubuntu1904 = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "19.04"
      version   = "latest"
    },

    ubuntu2004 = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal-daily"
      sku       = "20_04-daily-lts"
      version   = "latest"
    },

    ubuntu2004-gen2 = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal-daily"
      sku       = "20_04-daily-lts-gen2"
      version   = "latest"
    },

    centos77 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7.7"
      version   = "latest"
    },

    centos78-gen2 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7_8-gen2"
      version   = "latest"
    },

    centos79-gen2 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7_9-gen2"
      version   = "latest"
    },

    centos81 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_1"
      version   = "latest"
    },

    centos81-gen2 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_1-gen2"
      version   = "latest"
    },

    centos82-gen2 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_2-gen2"
      version   = "latest"
    },

    centos83-gen2 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_3-gen2"
      version   = "latest"
    },

    centos84-gen2 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_4-gen2"
      version   = "latest"
    },

    coreos = {
      publisher = "CoreOS"
      offer     = "CoreOS"
      sku       = "Stable"
      version   = "latest"
    },

    rhel78 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "7.8"
      version   = "latest"
    },

    rhel78-gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "78-gen2"
      version   = "latest"
    },

    rhel79 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "7.9"
      version   = "latest"
    },

    rhel79-gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "79-gen2"
      version   = "latest"
    },

    rhel81 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "8.1"
      version   = "latest"
    },

    rhel81-gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "81gen2"
      version   = "latest"
    },

    rhel82 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "8.2"
      version   = "latest"
    },

    rhel82-gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "82gen2"
      version   = "latest"
    },

    rhel83 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "8.3"
      version   = "latest"
    },

    rhel83-gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "83gen2"
      version   = "latest"
    },

    rhel84 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "8.4"
      version   = "latest"
    },

    rhel84-gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "84gen2"
      version   = "latest"
    },

    rhel84-byos = {
      publisher = "RedHat"
      offer     = "rhel-byos"
      sku       = "rhel-lvm84"
      version   = "latest"
    },

    rhel84-byos-gen2 = {
      publisher = "RedHat"
      offer     = "rhel-byos"
      sku       = "rhel-lvm84-gen2"
      version   = "latest"
    },

    mssql2019ent-rhel8 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-rhel8"
      sku       = "enterprise"
      version   = "latest"
    },

    mssql2019std-rhel8 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-rhel8"
      sku       = "standard"
      version   = "latest"
    },

    mssql2019dev-rhel8 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-rhel8"
      sku       = "sqldev"
      version   = "latest"
    },

    mssql2019ent-ubuntu1804 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ubuntu1804"
      sku       = "enterprise"
      version   = "latest"
    },

    mssql2019std-ubuntu1804 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ubuntu1804"
      sku       = "standard"
      version   = "latest"
    },

    mssql2019dev-ubuntu1804 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ubuntu1804"
      sku       = "sqldev"
      version   = "latest"
    },

    mssql2019ent-ubuntu2004 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ubuntu2004"
      sku       = "enterprise"
      version   = "latest"
    },

    mssql2019std-ubuntu2004 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ubuntu2004"
      sku       = "standard"
      version   = "latest"
    },

    mssql2019dev-ubuntu2004 = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ubuntu2004"
      sku       = "sqldev"
      version   = "latest"
    },
  }
}