![DK Hostmaster Logo](https://www.dk-hostmaster.dk/sites/default/files/dk-logo_0.png)

# XSD files for the DK Hostmaster EPP service

![GitHub Workflow build status badge markdownlint](https://github.com/DK-Hostmaster/epp-xsd-files/workflows/Markdownlint%20Workflow/badge.svg)
![GitHub Workflow build status badge xmllint](https://github.com/DK-Hostmaster/epp-xsd-files/workflows/XMLlint%20Workflow/badge.svg)

## Table of Contents

<!-- MarkdownTOC bracket=round levels="1,2,3,4" indent="  " autolink="true" autoanchor="true" -->

- [XSD file references](#xsd-file-references)
- [XSD files](#xsd-files)
- [XSD History](#xsd-history)
  - [3.2](#32)
  - [3.1](#31)
  - [3.0](#30)
  - [2.6](#26)
  - [2.5](#25)
  - [2.4](#24)
  - [2.3](#23)
  - [2.2](#22)
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

:exclamation: The current actively used XSD file is indicated in the [EPP service specification](https://github.com/DK-Hostmaster/epp-service-specification), this repository might contain changes not actively used by the service. Please see the [EPP Service Specification Wiki](https://github.com/DK-Hostmaster/epp-service-specification/wiki) for exact details.

<a id="xsd-file-references"></a>
## XSD file references

Please note that the following files have been lifted from their respective RFCs. These files are copyrighted
by their respective authors, please refer to the RFCs for more information.

- `contact-1.0.xsd` [RFC 5733](http://datatracker.ietf.org/doc/rfc5733/)
- `domain-1.0.xsd` [RFC 5731](http://datatracker.ietf.org/doc/rfc5731/)
- `epp-1.0.xsd` [RFC 5730](http://datatracker.ietf.org/doc/rfc5730/)
- `eppcom-1.0.xsd` [RFC 5730](http://datatracker.ietf.org/doc/rfc5730/)
- `host-1.0.xsd` [RFC 5732](http://datatracker.ietf.org/doc/rfc5732/)
- `secDNS-1.0.xsd` [RFC 4310](http://datatracker.ietf.org/doc/rfc4310/)
- `secDNS-1.1.xsd` [RFC 5910](http://datatracker.ietf.org/doc/rfc5910/)

The following files are owned and copyright by DK Hostmaster A/S under the MIT License, please see the LICENSE file.

<a id="xsd-files"></a>
## XSD files

- `dkhm-1.0.xsd`, DK Hostmaster EPP extensions version 1.0
- `dkhm-1.1.xsd`, DK Hostmaster EPP extensions version 1.1
- `dkhm-1.2.xsd`, DK Hostmaster EPP extensions version 1.2
- `dkhm-1.3.xsd`, DK Hostmaster EPP extensions version 1.3
- `dkhm-1.4.xsd`, DK Hostmaster EPP extensions version 1.4
- `dkhm-1.5.xsd`, DK Hostmaster EPP extensions version 1.5
- `dkhm-1.6.xsd`, DK Hostmaster EPP extensions version 1.6
- `dkhm-2.0.xsd`, DK Hostmaster EPP extensions version 2.0
- `dkhm-2.1.xsd`, DK Hostmaster EPP extensions version 2.1
- `dkhm-2.2.xsd`, DK Hostmaster EPP extensions version 2.2
- `dkhm-2.3.xsd`, DK Hostmaster EPP extensions version 2.3
- `dkhm-2.4.xsd`, DK Hostmaster EPP extensions version 2.4
- `dkhm-2.5.xsd`, DK Hostmaster EPP extensions version 2.5
- `dkhm-2.6.xsd`, DK Hostmaster EPP extensions version 2.6
- `dkhm-3.0.xsd`, DK Hostmaster EPP extensions version 3.0 (_pre-release_)
- `dkhm-3.1.xsd`, DK Hostmaster EPP extensions version 3.1 (_pre-release_)
- `dkhm-3.2.xsd`, DK Hostmaster EPP extensions version 3.2 (_pre-release_)
- `epp.xsd` (a collection files for easier test, validation and maintenance, see below)

The DK Hostmaster [EPP service specification](https://github.com/DK-Hostmaster/epp-service-specification) describes the use and contents of the files in more detail.

The file `epp.xsd` is just for easier test and validation as mentioned, it can be used together with [`xmllint`](http://xmlsoft.org/xmllint.html):

```bash
$ xmllint --schema epp.xsd your_file.xml
your_file.xml validates
```

It will then either omit an error message or the success message: `your_file.xml validates`.

<a id="xsd-history"></a>
## XSD History

<a id="32"></a>
### 3.2 _pre-release_

- Introducing DK Hostmaster optional extension for EPP delete domain command request: `dkhm:delDate`
- Introducing DK Hostmaster optional extension for automatic renewal: `dkhm:autoRenew`

<a id="31"></a>
### 3.1 _pre-release_

- EPP Service version 3.5.X
- Introducing DK Hostmaster AuthInfo extension for EPP info domain command response

<a id="30"></a>
### 3.0 _pre-release_

- EPP Service version 3.4.0
- The XSD does not contain changes as such, but removes excessive import statements, where one should suffice
- This revision of the schema file, eliminates support for older schema versions

<a id="26"></a>
### 2.6

- EPP Service version 2.3.X
- Reinstated excessive import statements, since this might break interaction with the existing service (2.3.X), which has some XSD schema issues triggered by this clean up
- The clean up will be completed and announced as **3.0**, since the XSD as a stand-alone breaks support for older schema versions and `epp.xsd` will be the only entry-point to support the older schema versions
- More XML cleaned up and formatted, mostly by automation

<a id="25"></a>
### 2.5

- EPP Service version 2.3.X
- Clearing out some minor issues in the DK Hostmaster XSD
- Removed excessive import statements, one should suffice
- XML cleaned up and formatted, mostly by automation

<a id="24"></a>
### 2.4

- EPP Service version 2.3.X
- Minor bug fix release as 2.4, since 2.3 had some minor issues

<a id="23"></a>
### 2.3

- EPP Service version 2.3.X
- Introduction of `dkhm:url` for poll messages in relation to domain creation, where a URL is communicated, which can be presented to the end-user as part of the domain creation process.

<a id="22"></a>
### 2.2

- EPP Service version 2.3.X
- Introduction of `dkhm:risk_assessment` for poll messages in relation to domain creation, where the risk assessment is communicated as part of the domain creation process.

<a id="21"></a>
### 2.1

- EPP Service version 2.3.X
- **Warning!** This release includes a change to the standard XSD from [RFC:5730](https://tools.ietf.org/html/rfc5730), aligning the values for the password type. It has not been possible to get the patch applied using the XML Schema feature: `redefine` or `overwrite`. When this succeeds this change will have to be rolled-back. The change has been applied so the schema file conforms with the schema file used at DK Hostmaster A/S.

- The DKHM Schema file has been updated to revision 2.1, the file does not contain any changes apart from the import, this file was created for a uniform communication in regard to revision numbers etc.

<a id="20"></a>
### 2.0

- Official release of changes proposed in revisions 1.5 and 1.6

<a id="16"></a>
### 1.6

- Development use only
- Introduction of `dkhm:requestedNsAdmin` for update host and create host

<a id="15"></a>
### 1.5

- Development use only
- Introduction of `dkhm:mobilephone` on update contact
- Introduction of `dkhm:secondaryEmail` on update contact

<a id="14"></a>
### 1.4

- EPP Service version 1.3.X
- Introduction of `dkhm:pnumber` for production unit number information for create contact

<a id="13"></a>
### 1.3

- EPP Service version 1.2.X
- Introduction of `dkhm:domain_confirmed` for information for create domain
- Introduction of `dkhm:contact_validated` for information for info contact
- Introduction of `dkhm:registrant_validated` for information for create domain

<a id="12"></a>
### 1.2

- EPP Service version 1.1.X
- Introduction of `dkhm:orderConfirmation` for create domain and support of [Pre-activation Service](#pre-activation-service)

<a id="11"></a>
### 1.1

- EPP Service version 1.0.9
- Introduction of `dkhm:domainAdvisory` for support of blocked status for create domain for blocked domain names

<a id="10"></a>
### 1.0

- EPP Service version 1.0.0
- Released 2014-02-25
