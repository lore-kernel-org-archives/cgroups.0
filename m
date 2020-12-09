From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v2 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Wed, 9 Dec 2020 12:33:22 -0800
Message-ID: <X9E0kl0+9zGSnIu/@google.com>
References: <20201208213531.2626955-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S+Qm1Txt09YzglGXS4N1LSBJ4tWItqAD7fi2vPq4Ppk=;
        b=Fcyib7dQRAzrbHKqf1ilBMCQA3ASKgY3eBGvWNNpQ2PWuhwZP7jncRukeZDZK7gNRC
         CLogErUqYuG/4O4ZooIPcL7abErRyDIy66cTt8GojzDTjrUiYFeHTKrO6aMD1WDI9JlW
         5PE5pASI+ez65+RAMHh/Tokz7aQmiZlYZ5ysIHKy3/XkYWkj0/WO08Rkydyrp3RTHipD
         VtZiMrn4tRVC1a/rn0KW6Hv8wmhIacpe+jJg3wcIR/v7gh+8dcLKfbVfibYEhsZFXS8n
         Lb8j0m49jLCtbalkgpy44iXb1DNYGxD3ff5RSRGwQ1xYp83RXUJrSQOB8QADW1SpvgJ3
         BaiA==
Content-Disposition: inline
In-Reply-To: <20201208213531.2626955-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net
Cc: joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 08, 2020 at 01:35:29PM -0800, Vipin Sharma wrote:
> Hello,
> 
> This patch adds a new cgroup controller, Encryption IDs, to track and
> limit the usage of encryption IDs on a host.
> 
> AMD provides Secure Encrypted Virtualization (SEV) and SEV with
> Encrypted State (SEV-ES) to encrypt the guest OS's memory using limited
> number of Address Space Identifiers (ASIDs).
> 
> This limited number of ASIDs creates issues like SEV ASID starvation and
> unoptimized scheduling in the cloud infrastucture.
> 
> In the RFC patch v1, I provided only SEV cgroup controller but based
> on the feedback and discussion it became clear that this cgroup
> controller can be extended to be used by Intel's Trusted Domain
> Extension (TDX) and s390's protected virtualization Secure Execution IDs
> (SEID)
> 
> This patch series provides a generic Encryption IDs controller with
> tracking support of the SEV ASIDs.
> 
> Changes in v2:
> - Changed cgroup name from sev to encryption_ids.
> - Replaced SEV specific names in APIs and documentations with generic
>   encryption IDs.
> - Providing 3 cgroup files per encryption ID type. For example in SEV,
>   - encryption_ids.sev.stat (only in the root cgroup directory).
>   - encryption_ids.sev.max
>   - encryption_ids.sev.current
> 
> Thanks
> Vipin Sharma
> 
> [1] https://lore.kernel.org/lkml/20200922004024.3699923-1-vipinsh@google.com/#r
> 
> Vipin Sharma (2):
>   cgroup: svm: Add Encryption ID controller
>   cgroup: svm: Encryption IDs cgroup documentation.
> 
>  .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 +++++
>  Documentation/admin-guide/cgroup-v2.rst       |  78 +++-
>  arch/x86/kvm/svm/sev.c                        |  28 +-
>  include/linux/cgroup_subsys.h                 |   4 +
>  include/linux/encryption_ids_cgroup.h         |  70 +++
>  include/linux/kvm_host.h                      |   4 +
>  init/Kconfig                                  |  14 +
>  kernel/cgroup/Makefile                        |   1 +
>  kernel/cgroup/encryption_ids.c                | 430 ++++++++++++++++++
>  9 files changed, 728 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/admin-guide/cgroup-v1/encryption_ids.rst
>  create mode 100644 include/linux/encryption_ids_cgroup.h
>  create mode 100644 kernel/cgroup/encryption_ids.c
> 
> --
> 2.29.2.576.ga3fc446d84-goog
> 

Please ignore this version of patch series, I will send out v3 soon. v2
has build failure when CONFIG_CGROUP is disabled.
