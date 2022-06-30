From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/4] KVM: mm: count KVM mmu usage in memory stats
Date: Thu, 30 Jun 2022 14:01:52 -0700
Message-ID: <CAJD7tkb3bDwt0gzOhS+3sSiy20Qy=G_AD8jZeY5DYh4=NyX3Bg@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VtUlpkuhliUwoUgmaGEH+kEoEeunaS6PJnDK/W1XYz4=;
        b=JfrrtzAQjyLxnw8RtQ5sQiSNUfohoaMNZW2kYvifXlmGWgHr7XJMl/LQ5yWh4ZDLRh
         EIUPHXZDb5Va4mirbCSRVDZCPMlakbWCUXbrVx3s9CYunFEZ1slL1J+n0+lLyBmkjvq6
         dywxS4/phRbyRQsua97BR94hWDn23Q49DbtcSC9+zkt3E5pfCOfz49pW3hhqdvrjGdv+
         pKKf1x3hKQqAQrlbcPos/8s8jUYluEAVcvGGsPGpoOXyv0wrj0LnCa606tZy9ddxQBAt
         cF8lFcME2E999BhE7foEKF9XdpoRPCaTJec6Ks6Sa9LMwb5hg+yO+AGHFhUc1+iXyNs+
         Ct9g==
In-Reply-To: <20220628220938.3657876-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

If/when this patchset gets merged, would it be through the mm tree or
kvm tree? It is based on the kvm-queue branch so I am guessing it
could be easier to go through kvm but I am not sure what the policy is
here. Andrew or Paolo, do you mind clarifying the policy on such
patchsets? Thanks!

On Tue, Jun 28, 2022 at 3:09 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Add NR_SECONDARY_PAGETABLE memory stat and use it to account KVM mmu
> usage as the first type of accounted secondary page tables. This stat
> can be later extended to account for other types of secondary pages
> tables (e.g. iommu page tables).
>
> Rationale behind why this is useful and link to extended discussion in
> the first patch.
>
> ---
>
> Changes in V6:
> - Rebased on top of kvm/queue and fixed conflicts.
> - Fixed docs spaces and tabs (Sean).
> - More narrative commit logs (Sean and Oliver).
> - Updated kvm_account_pgtable_pages() documentation to describe the
>   rules of using it more clearly (Sean).
> - Collected Acks and Reviewed-by's by Shakeel and Oliver (Thanks!)
>
> Changes in V5:
> - Updated cover letter to explain more the rationale behind the change
>   (Thanks to contributions by Sean Christopherson).
> - Removed extraneous + in arm64 patch (Oliver Upton, Marc Zyngier).
> - Shortened secondary_pagetables to sec_pagetables (Shakeel Butt).
> - Removed dependency on other patchsets (applies to queue branch).
>
> Changes in V4:
> - Changed accounting hooks in arm64 to only account s2 page tables and
>   refactored them to a much cleaner form, based on recommendations from
>   Oliver Upton and Marc Zyngier.
> - Dropped patches for mips and riscv. I am not interested in those archs
>   anyway and don't have the resources to test them. I posted them for
>   completeness but it doesn't seem like anyone was interested.
>
> Changes in V3:
> - Added NR_SECONDARY_PAGETABLE instead of piggybacking on NR_PAGETABLE
>   stats.
>
> Changes in V2:
> - Added accounting stats for other archs than x86.
> - Changed locations in the code where x86 KVM page table stats were
>   accounted based on suggestions from Sean Christopherson.
>
> ---
>
> Yosry Ahmed (4):
>   mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
>   KVM: mmu: add a helper to account memory used by KVM MMU.
>   KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
>   KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats
>
>  Documentation/admin-guide/cgroup-v2.rst |  5 ++++
>  Documentation/filesystems/proc.rst      |  4 +++
>  arch/arm64/kvm/mmu.c                    | 36 ++++++++++++++++++++++---
>  arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c              | 12 +++++++++
>  drivers/base/node.c                     |  2 ++
>  fs/proc/meminfo.c                       |  2 ++
>  include/linux/kvm_host.h                | 10 +++++++
>  include/linux/mmzone.h                  |  1 +
>  mm/memcontrol.c                         |  1 +
>  mm/page_alloc.c                         |  6 ++++-
>  mm/vmstat.c                             |  1 +
>  12 files changed, 89 insertions(+), 7 deletions(-)
>
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
