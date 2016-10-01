# epp-xsd-files

<!-- MarkdownTOC -->

- [XSD files for the DK Hostmaster EPP service](#xsd-files-for-the-dk-hostmaster-epp-service)
    - [XSD file references](#xsd-file-references)
    - [XSD files](#xsd-files)
    - [XSD History](#xsd-history)

<!-- /MarkdownTOC -->

<a name="xsd-files-for-the-dk-hostmaster-epp-service"></a>
# XSD files for the DK Hostmaster EPP service

The current actively used XSD file is indicated in the [EPP service specification](https://github.com/DK-Hostmaster/epp-service-specification), this repository might contain changes not actively used in the service.

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
* epp.xsd (a collection files for easier test, validation and maintenance)

The DK Hostmaster [EPP service specification](https://github.com/DK-Hostmaster/epp-service-specification) describes the use and contents of the files in more detail.

<a name="xsd-history"></a>
## XSD History

### 1.4

  * EPP Service version 1.3.X
  * Introduction of `dkhm:pnumber` for production unit number information for create contact

### 1.3

  * EPP Service version 1.2.X
  * Introduction of `dkhm:domain_confirmed` for information for create domain
  * Introduction of `dkhm:contact_validated` for information for info contact
  * Introduction of `dkhm:registrant_validated` for information for create domain

### 1.2

  * EPP Service version 1.1.X
  * Introduction of `dkhm:orderConfirmation` for create domain and support of [Pre-activation Service](#pre-activation-service)

### 1.1

  * EPP Service version 1.0.9
  * Introduction of `dkhm:domainAdvisory` for support of blocked status for create domain for blocked domain names

### 1.0

  * EPP Service version 1.0.0
  * Released 2014-02-25
