# XSD files for the DK Hostmaster EPP service

<!-- MarkdownTOC depth=4 -->

- [XSD file references](#xsd-file-references)
- [XSD files](#xsd-files)
- [XSD History](#xsd-history)
	- [2.1](#21)
	- [2.0](#20)
	- [1.6](#16)
	- [1.5](#15)
	- [1.4](#14)
	- [1.3](#13)
	- [1.2](#12)
	- [1.1](#11)
	- [1.0](#10)

<!-- /MarkdownTOC -->

The current actively used XSD file is indicated in the [EPP service specification](https://github.com/DK-Hostmaster/epp-service-specification), this repository might contain changes not actively used by the service.

<a name="xsd-file-references"></a>
## XSD file references

Please note that the following files have been lifted from their respective RFCs. These files are copyrighted 
by their respective authors, please refer to the RFCs for more information.

* contact-1.0.xsd [RFC 5733](http://datatracker.ietf.org/doc/rfc5733/)
* domain-1.0.xsd [RFC 5731](http://datatracker.ietf.org/doc/rfc5731/)
* epp-1.0.xsd [RFC 5730](http://datatracker.ietf.org/doc/rfc5730/)
* eppcom-1.0.xsd [RFC 5730](http://datatracker.ietf.org/doc/rfc5730/)
* host-1.0.xsd [RFC 5732](http://datatracker.ietf.org/doc/rfc5732/)
* secDNS-1.0.xsd [RFC 4310](http://datatracker.ietf.org/doc/rfc4310/)
* secDNS-1.1.xsd [RFC 5910](http://datatracker.ietf.org/doc/rfc5910/)

The following files are owned and copyright by DK Hostmaster A/S under the MIT License, please see the LICENSE file.

<a name="xsd-files"></a>
## XSD files

* dkhm-1.0.xsd, DK Hostmaster EPP extensions version 1.0
* dkhm-1.1.xsd, DK Hostmaster EPP extensions version 1.1
* dkhm-1.2.xsd, DK Hostmaster EPP extensions version 1.2
* dkhm-1.3.xsd, DK Hostmaster EPP extensions version 1.3
* dkhm-1.4.xsd, DK Hostmaster EPP extensions version 1.4
* dkhm-1.5.xsd, DK Hostmaster EPP extensions version 1.5
* dkhm-1.6.xsd, DK Hostmaster EPP extensions version 1.6
* dkhm-2.0.xsd, DK Hostmaster EPP extensions version 2.0
* dkhm-2.1.xsd, DK Hostmaster EPP extensions version 2.1
* epp.xsd (a collection files for easier test, validation and maintenance)

The DK Hostmaster [EPP service specification](https://github.com/DK-Hostmaster/epp-service-specification) describes the use and contents of the files in more detail.

The file `epp.xsd` is just for easier test and validation as mentioned, it can be used together with [`xmllint`](http://xmlsoft.org/xmllint.html):

```bash
$ xml --schema xsd/epp.xsd your_xml_file.xml
```
It will then either omit an error message or the success message: `your_xml_file.xml validates`.

<a name="xsd-history"></a>
## XSD History

<a name="21"></a>
### 2.1

- **Warning!** This release includes a change to the standard XSD from [RFC:5730](https://tools.ietf.org/html/rfc5730), aligning the values for the password type. It has not been possible to get the patch applied using the XML Schema feature: `redefine` or `overwrite`. When this succeeds this change will have to be rolled-back. The change has been applied so the schema file conforms with the schema file used at DK Hostmaster A/S.

- The DKHM Schema file has been updated to revision 2.1, the file does not contain any changes apart from the import, this file was created for a uniform communication in regard to revision numbers etc.

<a name="20"></a>
### 2.0

- Official release of changes proposed in revisions 1.5 and 1.6

<a name="16"></a>
### 1.6

- Development use only
- Introduction of `dkhm:requestedNsAdmin` for update host and create host

<a name="15"></a>
### 1.5

- Development use only
- Introduction of `dkhm:mobilephone` on update contact
- Introduction of `dkhm:secondaryEmail` on update contact

<a name="14"></a>
### 1.4

- EPP Service version 1.3.X
- Introduction of `dkhm:pnumber` for production unit number information for create contact

<a name="13"></a>
### 1.3

- EPP Service version 1.2.X
- Introduction of `dkhm:domain_confirmed` for information for create domain
- Introduction of `dkhm:contact_validated` for information for info contact
- Introduction of `dkhm:registrant_validated` for information for create domain

<a name="12"></a>
### 1.2

- EPP Service version 1.1.X
- Introduction of `dkhm:orderConfirmation` for create domain and support of [Pre-activation Service](#pre-activation-service)

<a name="11"></a>
### 1.1

- EPP Service version 1.0.9
- Introduction of `dkhm:domainAdvisory` for support of blocked status for create domain for blocked domain names

<a name="10"></a>
### 1.0

- EPP Service version 1.0.0
- Released 2014-02-25
