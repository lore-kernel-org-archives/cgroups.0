From: Vipin Sharma <vipinsh@google.com>
Subject: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Mon, 21 Sep 2020 17:40:22 -0700
Message-ID: <20200922004024.3699923-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=V3Xr2zBCrWRdkK+k7x0nVhZayUYo5UZWzWiSfnS90fI=;
        b=kdyVgyusZNzoXrTJhguQAb+Mx6TJNWHRXlrjar7ZHpeVOaXSPFcnqpBVcrKSj7jdY/
         Z9S2h73yYxQ9ye0LpN+CnHJtEkvDKrW9dX9pf4gz/5JYMJcccJoedfYoOR8AT6arrG/0
         ux966VV/bda9j4D3905gY+7QxO5ycI5EIzvDsYywy96gVK8JhFGFJMy2GicwDum9X/7W
         5AEWANjjafFjdR3tEOf/Btn3rFXzJXaLz1TU4p2opSJylwS9O8Y07YUPXzdI/9WSkVZ9
         xceQndQbqE8aM4VfKijgA1/KGV6BKYHLXzO7PTdnAOW4uHnL0OrmfA8n9UcoRW9J8H5E
         Wt1A==
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: thomas.lendacky@amd.com, pbonzini@redhat.com, sean.j.christopherson@intel.com, tj@kernel.org, lizefan@huawei.com
Cc: joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>

Hello,

This patch series adds a new SEV controller for tracking and limiting
the usage of SEV ASIDs on the AMD SVM platform.

SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
but this resource is in very limited quantity on a host.

This limited quantity creates issues like SEV ASID starvation and
unoptimized scheduling in the cloud infrastructure.

SEV controller provides SEV ASID tracking and resource control
mechanisms.

Patch 1 - Overview, motivation, and implementation details of the SEV
          controller.
Patch 2 - Kernel documentation of the SEV controller for both
	  cgroup v1 and v2.

Thanks

Vipin Sharma (2):
  KVM: SVM: Create SEV cgroup controller.
  KVM: SVM: SEV cgroup controller documentation

 Documentation/admin-guide/cgroup-v1/sev.rst |  94 +++++
 Documentation/admin-guide/cgroup-v2.rst     |  56 ++-
 arch/x86/kvm/Makefile                       |   1 +
 arch/x86/kvm/svm/sev.c                      |  16 +-
 arch/x86/kvm/svm/sev_cgroup.c               | 414 ++++++++++++++++++++
 arch/x86/kvm/svm/sev_cgroup.h               |  40 ++
 include/linux/cgroup_subsys.h               |   3 +
 init/Kconfig                                |  14 +
 8 files changed, 634 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/sev.rst
 create mode 100644 arch/x86/kvm/svm/sev_cgroup.c
 create mode 100644 arch/x86/kvm/svm/sev_cgroup.h

-- 
2.28.0.681.g6f77f65b4e-goog

