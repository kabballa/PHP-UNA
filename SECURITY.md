# Security Release Process

The community has adopted this security disclosure and response policy to responsibly handle critical issues.

## Supported Versions

For a list of supported versions that this project will potentially create security fixes for, please refer to the Releases page on this project's GitHub and/or the related project documentation on release cadence and support.

## Reporting a Vulnerability - Private Disclosure Process

Security is of utmost importance. All security vulnerabilities or suspected vulnerabilities should be reported privately to minimize risks to current users before they are addressed. Vulnerabilities will be investigated and patched in the next patch (or minor) release as soon as possible. This information will remain internal to the project.

If you are aware of a publicly disclosed security vulnerability for this project, please **IMMEDIATELY** contact the maintainers privately. The use of encrypted email is encouraged.

**IMPORTANT: Do not file public issues on GitHub for security vulnerabilities.**

### Reporting Channels

To report a vulnerability or security-related issue, please contact the maintainers with sufficient details through one of the following channels:

- Directly via their individual email addresses.
- Open a [GitHub Security Advisory](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability). This allows anyone to report security vulnerabilities directly and privately to the maintainers via GitHub. Note that this option may not be available for every repository.

The report will be handled by maintainers with committer and release permissions. Feedback will be provided within 3 business days, including a detailed plan to investigate the issue and any potential workarounds.

Do not report non-security-impacting bugs through this channel; use GitHub issues for all non-security-related bugs.

## Proposed Report Content

When reporting a vulnerability, please provide a descriptive title and include the following information in the description:

- **Identity Information**: Your name and affiliation or company.
- **Reproduction Steps**: Detailed steps to reproduce the vulnerability (POC scripts, screenshots, and logs are all helpful).
- **Impact Description**: A description of the effects of the vulnerability on this project and related hardware/software configurations.
- **Usage Impact**: Explanation of how the vulnerability affects the project's usage and an estimation of the attack surface.
- **Dependencies**: A list of other projects or dependencies that were used in conjunction with this project to produce the vulnerability.

## When to Report a Vulnerability

You should report a vulnerability:

- When you believe this project has a potential security vulnerability.
- When you suspect a potential vulnerability but are unsure if it impacts this project.
- When you know of or suspect a potential vulnerability in another project that is used by this project.

## Patch, Release, and Disclosure

The maintainers will respond to vulnerability reports as follows:

1. Investigate the vulnerability and determine its effects and criticality.
2. If the issue is not deemed a vulnerability, provide a detailed reason for rejection.
3. Initiate a conversation with the reporter within 3 business days.
4. If a vulnerability is acknowledged, determine the timeline for a fix and communicate with the community, including identifying mitigating steps for affected users.
5. Create a [Security Advisory](https://docs.github.com/en/code-security/repository-security-advisories/publishing-a-repository-security-advisory) using the [CVSS Calculator](https://www.first.org/cvss/calculator/3.0) if it has not yet been created. The maintainers will make the final call on the calculated CVSS; it is better to act quickly than to perfect the CVSS. Issues may also be reported to [Mitre](https://cve.mitre.org/) using this [scoring calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator). The draft advisory will initially be set to private.
6. Work on fixing the vulnerability and perform internal testing before preparing to roll out the fix.
7. Once the fix is confirmed, patch the vulnerability in the next patch or minor release, and backport the patch to all earlier supported releases.

## Public Disclosure Process

The maintainers will publish the public advisory to the project's community via GitHub. In most cases, additional communication through Slack, Twitter, mailing lists, blogs, and other channels will assist in educating users and rolling out the patched release.

Maintainers will also publish any mitigating steps users can take until the fix can be applied to their instances. Distributors of this project will handle creating and publishing their own security advisories.

## Confidentiality, Integrity, and Availability

We prioritize vulnerabilities that compromise data confidentiality, elevation of privilege, or integrity. Availability, particularly concerning DoS and resource exhaustion, is also a significant security concern. The maintainer team takes all vulnerabilities, potential vulnerabilities, and suspected vulnerabilities seriously and will investigate them promptly.

Please note that we do not currently consider the default settings for this project to be secure by default. It is essential for operators to explicitly configure settings, role-based access control, and other resource-related features to provide a hardened environment. We will not act on any security disclosure related to a lack of safe defaults. Over time, we will work towards improved secure-by-default configurations while considering backward compatibility.