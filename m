From: Vipin Sharma <vipinsh@google.com>
Subject: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Wed,  9 Dec 2020 12:54:11 -0800
Message-ID: <20201209205413.3391139-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=eyAf9tPh5kwa3NPR7RusvbbsQzwJzLjle+w/qgwIjD0=;
        b=Xh+cDnP4DoT5owh0/0HIm4Z8CAhhPYD263reDQNel9C7pyR9gOBxcvWO1X4IndEzBo
         7qit/pbm/xw+nUhXMQHMHo4ZOSnJURBK6g4JlEQGbr9TaCusAVM7X9Vfa0z/dW5DpIBI
         rqMBWuvl00va7X5MtLz55B492M6+6mfoJ9Uk2Fi+pHbJskFwKGDDup9dcxmjXNO/LKVA
         Rh03vIm2GpQtTy9xl6oJJ2JuYoFUe1sdme9kePmiHMD8hAAxZqjYYZUw2qS4/eUfb3Wv
         pulYP0O+TmrLVyxcMzc6hGb24eBry7Icr/iCipBtYKBepUWMk7/TWkK7kFIar6lVMn3x
         zrEA==
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net
Cc: joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>

Hello,

This patch adds a new cgroup controller, Encryption IDs, to track and
limit the usage of encryption IDs on a host.

AMD provides Secure Encrypted Virtualization (SEV) and SEV with
Encrypted State (SEV-ES) to encrypt the guest OS's memory using limited
number of Address Space Identifiers (ASIDs).

This limited number of ASIDs creates issues like SEV ASID starvation and
unoptimized scheduling in the cloud infrastucture.

In the RFC patch v1, I provided only SEV cgroup controller but based
on the feedback and discussion it became clear that this cgroup
controller can be extended to be used by Intel's Trusted Domain
Extension (TDX) and s390's protected virtualization Secure Execution IDs
(SEID)

This patch series provides a generic Encryption IDs controller with
tracking support of the SEV ASIDs.

Changes in v3:
- Fixes a build error when CONFIG_CGROUP is disabled.

Changes in v2:
- Changed cgroup name from sev to encryption_ids.
- Replaced SEV specific names in APIs and documentations with generic
  encryption IDs.
- Providing 3 cgroup files per encryption ID type. For example in SEV,
  - encryption_ids.sev.stat (only in the root cgroup directory).
  - encryption_ids.sev.max
  - encryption_ids.sev.current

Thanks
Vipin Sharma

[1] https://lore.kernel.org/lkml/20200922004024.3699923-1-vipinsh@google.com/#r
[2] https://lore.kernel.org/lkml/20201208213531.2626955-1-vipinsh@google.com/

 .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 +++++
 Documentation/admin-guide/cgroup-v2.rst       |  78 +++-
 arch/x86/kvm/svm/sev.c                        |  28 +-
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/encryption_ids_cgroup.h         |  71 +++
 include/linux/kvm_host.h                      |   4 +
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/encryption_ids.c                | 430 ++++++++++++++++++
 9 files changed, 729 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/encryption_ids.rst
 create mode 100644 include/linux/encryption_ids_cgroup.h
 create mode 100644 kernel/cgroup/encryption_ids.c

-- 
2.29.2.576.ga3fc446d84-goog

