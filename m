From: Vipin Sharma <vipinsh@google.com>
Subject: [RFC v2 0/2] cgroup: New misc cgroup controller
Date: Tue,  2 Mar 2021 00:17:03 -0800
Message-ID: <20210302081705.1990283-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=J5nM/aBIL0ud17qxWddLzc4+65+ykqSEziPOIHoR18E=;
        b=CLaHSQRRQuhzlrNUHt+Ee6dvdh/pvhmKVL23Vm4bjLSGpL9t3yxCRmBAVgHL6lsIyn
         05iAFmfLfOZZR9GHkYRXKHrHC0SJlD8qUu+AAvO9gfMPcV4vhR646pp/hEvI68QeA2Mb
         DBYpEVQWeUFHdRFXaub06Vwhv8jjJysBUfgnKx9+1KwWwrDjmMYv+jozyxcKVieG9COH
         DE7ZHKblBdBpTi6HTjHtr7iiM5+8AIUrueg5HzDkJVCaHvkxaOHcB1vGO3bNgFMavgSK
         JIqmGJgz7qn0J+SwCsXUdzaYEdBIOPxEJJe80J4+INK+OSDVp9jhM5+vKb5bRxmRrTWt
         lYag==
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
Cc: corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>

Hello

This patch series is creating a new misc cgroup controller for limiting
and tracking of resources which are not abstract like other cgroup
controllers.

This controller was initially proposed as encryption_id but after
the feedbacks, it is now changed to misc cgroup.
https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/

Changes in RFC v2:
1. Documentation fixes.
2. Added kernel log messages.
3. Changed charge API to treat misc_cg as input parameter.
4. Added helper APIs to get and release references on the cgroup.

[1] https://lore.kernel.org/lkml/20210218195549.1696769-1-vipinsh@google.com
Vipin Sharma (2):
  cgroup: sev: Add misc cgroup controller
  cgroup: sev: Miscellaneous cgroup documentation.

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |   4 +
 Documentation/admin-guide/cgroup-v2.rst       |  69 ++-
 arch/x86/kvm/svm/sev.c                        |  65 ++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/misc_cgroup.h                   | 122 +++++
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/misc.c                          | 423 ++++++++++++++++++
 10 files changed, 692 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
2.30.1.766.gb4fecdf3b7-goog

