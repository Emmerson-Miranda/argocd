# OpenLDAP

Source: https://www.youtube.com/watch?v=7xbCICmB5co




## Install LDAP

```bash
kubectl apply -f deployment-ldap.yml 
```

Username and Password are environment variables:
- LDAP_ADMIN_DN
- LDAP_ADMIN_PASSWORD

open -a firefox -g http://localhost:30080


## Shell into openldap pod

```bash
kubectl exec -ti $(kubectl get po -l app.kubernetes.io/name=openldap -o=jsonpath='{.items..metadata.name}') -- /bin/bash
```

## Verify all entries below your base DN (See groups, users, OUs, etc.)
```bash
ldapsearch -x -H ldap://127.0.0.1:389 -D "cn=admin,dc=example,dc=org" -w admin -b "dc=example,dc=org" -s sub "(objectclass=*)"
```


## View users

```bash
ldapsearch -x -H ldap://127.0.0.1:389 -D "cn=admin,dc=example,dc=org" -W -b "dc=example,dc=org" -s sub "(objectclass=inetOrgPerson)"
```

## View groups

```bash
ldapsearch -x -H ldap://127.0.0.1:389 -D "cn=admin,dc=example,dc=org" -W -b "dc=example,dc=org" -s sub "(objectclass=organizationalUnit)"
```

## Hashing your password to place in password field of your ldif file:

```bash
slappasswd -s yourpassword
```

## LDIF Add objects

```bash
# "-w admin" is the password for user admin
ldapadd -x -H ldap://127.0.0.1:389  -D "cn=admin,dc=example,dc=org" -w admin -f /ldif/users.ldif
```
Output:
```
Enter LDAP Password: 
adding new entry "ou=groups,dc=example,dc=org"
adding new entry "cn=devops,ou=groups,dc=example,dc=org"
adding new entry "cn=devs,ou=groups,dc=example,dc=org"
adding new entry "ou=people,dc=example,dc=org"
adding new entry "cn=dmiranda,ou=people,dc=example,dc=org"
adding new entry "cn=emiranda,ou=people,dc=example,dc=org"
```

## View specif user

```bash
ldapsearch -x -H ldap://127.0.0.1:389  -D "cn=admin,dc=example,dc=org" -W -b "dc=example,dc=org" "(uid=emiranda)"
```

Output:
```
Enter LDAP Password: 
# extended LDIF
#
# LDAPv3
# base <dc=example,dc=org> with scope subtree
# filter: (uid=emiranda)
# requesting: ALL
#

# emiranda, people, example.org
dn: cn=emiranda,ou=people,dc=example,dc=org
cn: emiranda
gidNumber: 503
givenName: Emmerson
homeDirectory: /home/users/emiranda
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
sn: Miranda
uid: emiranda
uidNumber: 1000
userPassword:: e01ENX1mUkJlMVlsVHRKdWwwV3RERjR4V1VBPT0=

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```

## Changing a user's password:

```
ldappasswd -x -H ldap://127.0.0.1:389  -D "cn=ldap_admin,dc=example,dc=org" -W -S "cn=emiranda,ou=people,dc=example,dc=org"
```

## Modifying existing LDAP Configuration:

```bash
ldapmodify -x -H ldap://127.0.0.1:389  -D "cn=ldap_admin,dc=example,dc=org" -W -f groupmod.ldif
```