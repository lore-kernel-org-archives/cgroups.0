From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/3] cgroup: New misc cgroup controller
Date: Mon, 29 Mar 2021 21:42:03 -0700
Message-ID: <20210330044206.2864329-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sfHXJbbxb6p3TEWQ8tzYZSEzCbGd5MPRFw754wGnO9M=;
        b=TTKZd5jbX64Rbx+dgGmFRdeRnmF8AD7bOmTLS2z53CveoKd38s4zHorjlWhT7JWttc
         W/4AYxcvnetv6zEBZYnCLLwDw/n0+NMSmznlECeNN386pQMDpBp4tAkUmypuy690YhbX
         MUJZ5LuwMKBNRdfciczq43ArGC3OCKUJ3QO4oD3Y2cx4JDMR46cTE+wD46kDhx1s1eQi
         BCVe4G/w1rxiIqWKYuh9XRd2X4XFgxFOga84xCkanZwHE8wax3F1kzF+jGb1H1j6pCKN
         N/nXSaOUfTOeOvgZgsdJwf4qCgPRhbqT7Cz7dmTglQ23YrQf8/aRU/gRgyKet03i1zWN
         AnpQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, jacob.jun.pan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

This patch series is creating a new misc cgroup controller for limiting
and tracking of resources which are not abstract like other cgroup
controllers.

This controller was initially proposed as encryption_id but after the
feedbacks and use cases for other resources, it is now changed to misc
cgroup.
https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Most of the cloud infrastructure use cgroups for knowing the host state,
track the resources usage, enforce limits on them, etc. They use this
info to optimize work allocation in the fleet and make sure no rogue job
consumes more than it needs and starves others.

There are resources on a system which are not abstract enough like other
cgroup controllers and are available in a limited quantity on a host.

One of them is Secure Encrypted Virtualization (SEV) ASID on AMD CPU.
SEV ASIDs are used for creating encrypted VMs. SEV is mostly be used by
the cloud providers for providing confidential VMs. Since SEV ASIDs are
limited, there is a need to schedule encrypted VMs in a cloud
infrastructure based on SEV ASIDs availability and also to limit its
usage.

There are similar requirements for other resource types like TDX keys,
IOASIDs and SEID.

Adding these resources to a cgroup controller is a natural choice with
least amount of friction. Cgroup itself says it is a mechanism to
distribute system resources along the hierarchy in a controlled
mechanism and configurable manner. Most of the resources in cgroups are
abstracted enough but there are still some resources which are not
abstract but have limited availability or have specific use cases.

Misc controller is a generic controller which can be used by these
kinds of resources.

One suggestion was to use BPF for this purpose, however, there are
couple of things which might not be addressed with BPF:
1. Which controller to use in v1 case? These are not abstract resources
   so in v1 where each controller have their own hierarchy it might not
   be easy to identify the best controller to use for BPF.

2. Abstracting out a single BPF program which can help with all of the
   resources types might not be possible, because resources we are
   working with are not similar and abstract enough, for example network
   packets, and there will be different places in the source code to use
   these resources.

A new cgroup controller tends to give much easier and well integrated
solution when it comes to scheduling and limiting a resource with
existing tools in a cloud infrastructure.

Changes in RFC v4:
1. Misc controller patch is split into two patches. One for generic misc
   controller and second for adding SEV and SEV-ES resource.
2. Using READ_ONCE and WRITE_ONCE for variable accesses.
3. Updated documentation.
4. Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.
5. Included cgroup header in misc_cgroup.h.
6. misc_cg_reduce_charge changed to misc_cg_cancel_charge.
7. misc_cg set to NULL after uncharge.
8. Added WARN_ON if misc_cg not NULL before charging in SEV/SEV-ES.

Changes in RFC v3:
1. Changed implementation to support 64 bit counters.
2. Print kernel logs only once per resource per cgroup.
3. Capacity can be set less than the current usage.

Changes in RFC v2:
1. Documentation fixes.
2. Added kernel log messages.
3. Changed charge API to treat misc_cg as input parameter.
4. Added helper APIs to get and release references on the cgroup.

[1] https://lore.kernel.org/lkml/20210218195549.1696769-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
[2] https://lore.kernel.org/lkml/20210302081705.1990283-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
[3] https://lore.kernel.org/lkml/20210304231946.2766648-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Vipin Sharma (3):
  cgroup: Add misc cgroup controller
  cgroup: Miscellaneous cgroup documentation.
  svm/sev: Register SEV and SEV-ES ASIDs to the misc controller

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |   4 +
 Documentation/admin-guide/cgroup-v2.rst       |  73 +++-
 arch/x86/kvm/svm/sev.c                        |  70 ++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/misc_cgroup.h                   | 132 ++++++
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/misc.c                          | 407 ++++++++++++++++++
 10 files changed, 695 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
2.31.0.291.g576ba9dcdaf-goog

