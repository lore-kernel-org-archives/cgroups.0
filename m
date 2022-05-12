From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Thu, 12 May 2022 19:07:04 -0400
Message-ID: <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cUck+cVE4Zxuay2oogDnSAcnKGvRjnTdnpV0Wo1py44=;
        b=Dj1JULLJRgmUJGyzT66YmWR2bXmVOPWjKovt19K15mjhXg3HwFYBwEJuzTGwKaAq9s
         UlYZ0/IUYcAg2aRR26LgYG0/HAiOUXbRTrjNR+Wc4SxPVT5MXbauCdL2/WDBI7QN0Gh0
         c2v6RoCDtzZcEzCwRaxfIkuXKgKFQmfp7WteHFGn9yxB7UXbRpwFXrmu9mN6KLIniXYn
         E6Ng4kcGK1aHvRPzZUSVA18lIbBd/twXGFM4i7KmkNJcxCIrUG0eta5gQ+Zhk4sMsbTs
         bfvIMBQOMEqF/RWs5LYTgoZiIZ4OfdOx64M8r+ZkVp/WNmWSvYEJZ9cPVzcTwYawUn43
         j07A==
Content-Disposition: inline
In-Reply-To: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm@list

Hey Yosry,

On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > 115bae923ac8bb29ee635). You are saying that this is related to a
> > 'workload', but given that the accounting is global, I fail to see how
> > you can attribute these allocations on a particular VM.
> 
> The main motivation is having the memcg stats, which give attribution
> to workloads. If you think it's more appropriate, we can add it as a
> memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
> per-memcg vmalloc stat")). The only reason I made this as a global
> stat too is to be consistent with NR_PAGETABLE.

Please no memcg-specific stats if a regular vmstat item is possible
and useful at the system level as well, like in this case. It's extra
memcg code, extra callbacks, and it doesn't have NUMA node awareness.

> > What do you plan to do for IOMMU page tables? After all, they serve
> > the exact same purpose, and I'd expect these to be handled the same
> > way (i.e. why is this KVM specific?).
> 
> The reason this was named NR_SECONDARY_PAGTABLE instead of
> NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> account other types of secondary page tables to this stat. It is just
> that we are currently interested in the KVM MMU usage.

Do you actually care at the supervisor level that this memory is used
for guest page tables?

It seems to me you primarily care that it is reported *somewhere*
(hence the piggybacking off of NR_PAGETABLE at first). And whether
it's page tables or iommu tables or whatever else allocated for the
purpose of virtualization, it doesn't make much of a difference to the
host/cgroup that is tracking it, right?

(The proximity to nr_pagetable could also be confusing. A high page
table count can be a hint to userspace to enable THP. It seems
actionable in a different way than a high number of kvm page tables or
iommu page tables.)

How about NR_VIRT? It's shorter, seems descriptive enough, less room
for confusion, and is more easily extensible in the future.
