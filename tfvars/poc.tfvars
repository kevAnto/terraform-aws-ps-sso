permissions_list = [
    {
        name              = "AdministratorAccess"
        description       = "AdministratorAccess"
        session_duration  = null
        managed_policies  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
        aws_accounts      = ["557870048537"]
        sso_groups        = ["AdministratorGroup", "PS-Administrator"]
    },
    {
        name              = "ViewOnlyAccess"
        description       = "ViewOnlyAccess"
        session_duration  = null
        managed_policies  = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
        aws_accounts      = ["557870048537"]
        sso_groups        = ["ReadOnlyGroup"]
    }
]
