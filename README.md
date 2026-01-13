![Punktum dk Logo](https://www.dk-hostmaster.dk/sites/default/files/dk-logo_0.png)

# XSD files for the Punktum dk EPP service

![Markdownlint Action status badge](https://github.com/DK-Hostmaster/epp-xsd-files/workflows/Markdownlint%20Action/badge.svg)
![XMLlint Action status badge](https://github.com/DK-Hostmaster/epp-xsd-files/workflows/XMLlint%20Action/badge.svg)
![Spellcheck Action](https://github.com/DK-Hostmaster/epp-xsd-files/workflows/Spellcheck%20Action/badge.svg)

## Table of Contents

<!-- MarkdownTOC bracket=round levels="1,2,3,4" indent="  " autolink="true" autoanchor="true" -->

- [XSD file references](#xsd-file-references)
- [XSD files](#xsd-files)
- [XSD History](#xsd-history)
  - [4.5](#44)
  - [4.4](#44)
  - [4.3](#43)
  - [4.2](#42)
  - [4.1](#41)
  - [4.0](#40)
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
- [Resources and References](#references_and_resources)

<!-- /MarkdownTOC -->

:exclamation: The current actively used XSD file is indicated in the [EPP service specification][DKHMEPPSPEC], this repository might contain changes not actively used by the service. Please see the [EPP Service Specification Wiki][DKHMEPPWIKI] for exact details.

<a id="xsd-file-references"></a>
## XSD file references

Please note that the following files have been lifted from their respective RFCs. These files are copyrighted
by their respective authors, please refer to the RFCs for more information.

- `contact-1.0.xsd` [RFC:5733]
- `domain-1.0.xsd` [RFC:5731]
- `epp-1.0.xsd` [RFC:5730]
- `eppcom-1.0.xsd` [RFC:5730]
- `host-1.0.xsd` [RFC:5732]
- `secDNS-1.0.xsd` [RFC:4310]
- `secDNS-1.1.xsd` [RFC:5910]
- `verisign-epp-balance` [VeriSign EPP Balance][VeriSignEPPBalance]
- `rgp-1.0.xsd` [RFC:3915]

The following files are owned and copyright by Punktum dk A/S under the MIT License, please see the LICENSE file.

<a id="xsd-files"></a>
## XSD files

- `dkhm-1.0.xsd`, Punktum dk EPP extensions version 1.0
- `dkhm-1.1.xsd`, Punktum dk EPP extensions version 1.1
- `dkhm-1.2.xsd`, Punktum dk EPP extensions version 1.2
- `dkhm-1.3.xsd`, Punktum dk EPP extensions version 1.3
- `dkhm-1.4.xsd`, Punktum dk EPP extensions version 1.4
- `dkhm-1.5.xsd`, Punktum dk EPP extensions version 1.5
- `dkhm-1.6.xsd`, Punktum dk EPP extensions version 1.6
- `dkhm-2.0.xsd`, Punktum dk EPP extensions version 2.0
- `dkhm-2.1.xsd`, Punktum dk EPP extensions version 2.1
- `dkhm-2.2.xsd`, Punktum dk EPP extensions version 2.2
- `dkhm-2.3.xsd`, Punktum dk EPP extensions version 2.3
- `dkhm-2.4.xsd`, Punktum dk EPP extensions version 2.4
- `dkhm-2.5.xsd`, Punktum dk EPP extensions version 2.5
- `dkhm-2.6.xsd`, Punktum dk EPP extensions version 2.6
- `dkhm-3.0.xsd`, Punktum dk EPP extensions version 3.0
- `dkhm-3.1.xsd`, Punktum dk EPP extensions version 3.1
- `dkhm-4.0.xsd`, Punktum dk EPP extensions version 4.0
- `dkhm-domain-4.0.xsd`, Punktum dk EPP Domain extension version 4.0
- `dkhm-4.1.xsd`, Punktum dk EPP extensions version 4.1
- `dkhm-domain-4.1.xsd`, Punktum dk EPP Domain extension version 4.1
- `dkhm-4.2.xsd`, Punktum dk EPP extensions version 4.2
- `dkhm-domain-4.2.xsd`, Punktum dk EPP Domain extension version 4.2
- `dkhm-4.3.xsd`, Punktum dk EPP extensions version 4.3
- `dkhm-domain-4.3.xsd`, Punktum dk EPP Domain extension version 4.3
- `dkhm-4.4.xsd`, Punktum dk EPP extensions version 4.4
- `dkhm-domain-4.4.xsd`, Punktum dk EPP Domain extension version 4.4
- `epp.xsd` (a collection files for easier test, validation and maintenance, see below)
- `dkhm-4.5.xsd`, Punktum dk EPP extensions version 4.5

The Punktum dk [EPP service specification][DKHMEPPSPEC] describes the use and contents of the files in more detail.

The file `epp.xsd` is just for easier test and validation as mentioned, it can be used together with [`xmllint`][xmllint]:

```bash
$ xmllint --schema epp.xsd your_file.xml
your_file.xml validates
```

It will then either omit an error message or the success message: `your_file.xml validates`.

<a id="xsd-history"></a>
## XSD History

<a id="45"></a>
### 4.5

- Introduced in EPP service version 5.2.0
- Adding extension `dkhm:contact_verification` complex type containing information regarding the contact verification process and status, including who is responsible for performing the verification process (registrar/registry), which type and verification process (identity/e-mail) and status of the verification process.
- Adding extension `dkhm:sole_proprietorship` simple type containing information if the contact is a sole proprietorship company and therefore needs to have contact email hidden from public available WHOIS information.

<a id="44"></a>
### 4.4

- EPP Service version 4.11.0
- Added extension `dkhm:vid` for communication of choice of VID, a registry lock service for registrant managed domain names

<a id="43"></a>
### 4.3

- EPP Service version 4.0.0
- Added proposed extension `dkhm:management` for communication of choice of management model

<a id="42"></a>
### 4.2

- EPP Service version 4.0.0
- Addressing a minor issue of XML invalid namespace references [#20](https://github.com/DK-Hostmaster/epp-xsd-files/issues/20)

<a id="41"></a>
### 4.1

- EPP Service version 4.0.0
- Introducing use of the restore capability described in [RFC:3915]

<a id="40"></a>
### 4.0

- EPP Service version 4.0.0
- Introducing Punktum dk optional extension for EPP delete domain command request: `dkhm:delDate`
- Introducing Punktum dk optional extension for automatic renewal: `dkhm:autoRenew`
- Introducing Punktum dk optional command extension for transfer back to Punktum dk: `withdraw`
- Introducing use of the VeriSign EPP Balance: `info balance`
- Added proper Resources and References chapter

<a id="31"></a>
### 3.1

- EPP Service version 4.0.0
- Introducing Punktum dk AuthInfo expiration: `dkhm:authInfoExDate` extension for EPP info domain command response and authorizations for AuthInfo

<a id="30"></a>
### 3.0

- EPP Service version 3.4.0 and 3.5.X
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
- Clearing out some minor issues in the Punktum dk XSD
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
- **Warning!** This release includes a change to the standard XSD from [RFC:5730], aligning the values for the password type. It has not been possible to get the patch applied using the XML Schema feature: `redefine` or `overwrite`. When this succeeds this change will have to be rolled-back. The change has been applied so the schema file conforms with the schema file used at Punktum dk A/S.

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
- Introduction of `dkhm:orderConfirmation` for create domain and support of Pre-activation Service (deprecated)

<a id="11"></a>
### 1.1

- EPP Service version 1.0.9
- Introduction of `dkhm:domainAdvisory` for support of blocked status for create domain for blocked domain names

<a id="10"></a>
### 1.0

- EPP Service version 1.0.0
- Released 2014-02-25

<a id="references_and_resources"></a>
## References and Resources

- [RFC:3915: "Domain Registry Grace Period Mapping for the Extensible Provisioning Protocol (EPP)"][RFC:3915]
- [RFC:4310: "Domain Name System (DNS) Security Extensions Mapping for the Extensible Provisioning Protocol (EPP)"][RFC:4310]
- [RFC:5730: Extensible Provisioning Protocol (EPP)][RFC:5730]
- [RFC:5731: "Extensible Provisioning Protocol (EPP) Domain Name Mapping"][RFC:5731]
- [RFC:5732: "Extensible Provisioning Protocol (EPP) Host Mapping"][RFC:5732]
- [RFC:5733: "Extensible Provisioning Protocol (EPP) Contact Mapping"][RFC:5733]
- [RFC:5910: "Domain Name System (DNS) Security Extensions Mapping for the Extensible Provisioning Protocol (EPP)"][RFC:5910]
- [VeriSign: "Balance Mapping for the Extensible Provisioning Protocol (EPP)"][VeriSignEppBalance]
- [xmlsoft.org: xmllint][xmllint]
- [Punktum dk EPP Service Specification][DKHMEPPSPEC]
- [Punktum dk EPP Service Wiki][DKHMEPPWIKI]

[RFC:3915]: https://tools.ietf.org/html/rfc3915
[RFC:4310]: https://tools.ietf.org/html/rfc4310
[RFC:5730]: https://tools.ietf.org/html/rfc5730
[RFC:5731]: https://tools.ietf.org/html/rfc5731
[RFC:5732]: https://tools.ietf.org/html/rfc5732
[RFC:5733]: https://tools.ietf.org/html/rfc5733
[RFC:5910]: https://tools.ietf.org/html/rfc5910
[VeriSignEppBalance]: https://www.verisign.com/assets/epp-sdk/verisign_epp-extension_balance_v01.html
[xmllint]: http://xmlsoft.org/xmllint.html
[DKHMEPPSPEC]: https://github.com/DK-Hostmaster/epp-service-specification
[DKHMEPPWIKI]: https://github.com/DK-Hostmaster/epp-service-specification/wiki
