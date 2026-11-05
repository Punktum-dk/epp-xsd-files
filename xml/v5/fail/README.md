# Examples that must fail

The examples in this folder must be rejected by `epp.xsd`. Both checks, `prove t/runtests.t` and `.github/actions/xmllint/entrypoint.sh`, fail if one of them validates.

Each example is valid apart from one error, so it shows exactly one rule of the 5.0 extensions. A file that fails for another reason, for example a typo, still counts as rejected, so check the error with `xmllint --noout --schema epp.xsd <file>` when adding or changing an example.

## Rules of the 5.0 extensions

| Example | Why it must fail |
|---|---|
| `create_contact_duplicate_userType.xml` | `dotdk-contact:userType` may occur only once |
| `create_contact_legacy_userType.xml` | The legacy `userType` values `C`, `P`, `A` and `I` are gone, only `company`, `publicOrganization`, `association` and `individual` are allowed |
| `info_contact_incomplete_publicStatus.xml` | `dotdk-contact:publicStatus` must have all of `publicAddress`, `publicPhone` and `publicEmail` |
| `info_contact_update_address_bad_status.xml` | The `status` of `dotdk-contact:updateAddress` must be `pending`, `completed` or `expired` |
| `transfer_domain_without_token.xml` | `dotdk-domain:transfer` must have an `orderConfirmationToken` (PM-1481). The XSD cannot require the wrapper itself, so the service must reject a transfer without it |

## Differences from 4.x

These examples are made from a valid v4 example with one change, converted to v5 with `bin/convert-example.pl`. The v4 version validates, the v5 version does not, so they show what cannot be converted directly from 4.x. Each file starts with a comment with the reason.

| Example | Why it must fail | In 4.x |
|---|---|---|
| `create_contact_mobilephone_with_x.xml` | `dotdk-contact:mobilePhone` has no `x` attribute (PM-714) | `dkhm:mobilephone` is a `contact:e164Type` with `x` |
| `create_domain_without_token.xml` | `orderConfirmationToken` is required in `dotdk-domain:create` | `dkhm:orderconfirmationToken` is optional |
| `info_domain_response_advisory_without_domain.xml` | The `domain` attribute of `dotdk-domain:domainAdvisory` is required | `domain` and `advisory` are optional |
| `info_domain_response_three_authinfo.xml` | `dotdk-domain:infData` allows at most 2 `authInfo` | No limit |
| `info_domain_response_with_risk_assessment.xml` | `riskAssessment` is only allowed in `dotdk-domain:creData`, not in `infData` | `dkhm:risk_assessment` is allowed in any extension |
| `info_domain_response_with_tracking_no.xml` | `trackingNo` is only allowed in `dotdk-domain:creData`, not in `infData` | `dkhm:trackingNo` is allowed in any extension |
| `update_contact_with_management.xml` | `management` is only allowed in `dotdk-contact:create` and `infData`, not in `update` | `dkhm:management` is allowed in any extension |
| `update_contact_with_pnumber.xml` | `pNumber` is only allowed in `dotdk-contact:create` and `infData`, not in `update` | `dkhm:pnumber` is allowed in any extension |
| `update_domain_with_order_confirmation_token.xml` | `dotdk-domain:update` has no `orderConfirmationToken` | Sent when changing the registrant, see `xml/v4/update_domain_change_registrant_with_token.xml` |

`update_domain_with_order_confirmation_token.xml` documents an open question: if `dotdk-domain:update` gets an `orderConfirmationToken`, the example validates and must move out of this folder.

Elements that were removed in 5.0 (`authInfoExDate`, `delDate`, `domain_confirmed`, `url`, `contact` and the `withdraw` command) have no examples here, as they have no 5.0 name to convert to. `bin/convert-example.pl` stops with an error for them.
