From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Thu, 12 May 2022 23:29:38 +0000
Message-ID: <Yn2YYl98Vhh/UL0w@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/iy7DvZiK8nafA5XKuXqSqcNqBCZjj9/qjUXXJFqGpQ=;
        b=cWZf8gG13SFYJAbym+C3jUQYUcEqHiEmBSGcMRkGeKtHJpoPVjCJpboc2DabP5dHl4
         t2pGv+CgDWDeHxJP9tx6pCY9dSjjnguG4ekrfcrEUPi+LIH60qOBWqDT9YCyqkQV8C4/
         dSaySBo05+qtz5foTJQ9KZOVML5d+2f0Q7XlTuBAcMKJyVliAc9S9Hsa6xjkW2Sp6kD0
         1UgaKp+HBuU30LUTW23SGQf4o5bUWN8CesvUXR+7waPEQ995rJuJyEfEpi5J8hby+7Aj
         Cx1uoQ+692VdjLzjahYMHQzslw6xA739laCwIfxc6iaGRPPEF0WSqEC8fNXQchv8WP2x
         CzyQ==
Content-Disposition: inline
In-Reply-To: <Yn2TGJ4vZ/fst+CY-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6Ug@public.gmane.org

On Thu, May 12, 2022, Johannes Weiner wrote:
> Hey Yosry,
> 
> On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > 115bae923ac8bb29ee635). You are saying that this is related to a
> > > 'workload', but given that the accounting is global, I fail to see how
> > > you can attribute these allocations on a particular VM.
> > 
> > The main motivation is having the memcg stats, which give attribution
> > to workloads. If you think it's more appropriate, we can add it as a
> > memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
> > per-memcg vmalloc stat")). The only reason I made this as a global
> > stat too is to be consistent with NR_PAGETABLE.
> 
> Please no memcg-specific stats if a regular vmstat item is possible
> and useful at the system level as well, like in this case. It's extra
> memcg code, extra callbacks, and it doesn't have NUMA node awareness.
> 
> > > What do you plan to do for IOMMU page tables? After all, they serve
> > > the exact same purpose, and I'd expect these to be handled the same
> > > way (i.e. why is this KVM specific?).
> > 
> > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > account other types of secondary page tables to this stat. It is just
> > that we are currently interested in the KVM MMU usage.
> 
> Do you actually care at the supervisor level that this memory is used
> for guest page tables?

Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
for page tables, but except for page tables, the number/size of those allocations
scales linearly with either the number of vCPUs or the amount of memory assigned
to the VM (with no room for improvement barring KVM changes).

Off the top of my head, KVM's secondary page tables are the only allocations that
don't scale linearly, especially when nested virtualization is in use.

> It seems to me you primarily care that it is reported *somewhere*
> (hence the piggybacking off of NR_PAGETABLE at first). And whether
> it's page tables or iommu tables or whatever else allocated for the
> purpose of virtualization, it doesn't make much of a difference to the
> host/cgroup that is tracking it, right?
> 
> (The proximity to nr_pagetable could also be confusing. A high page
> table count can be a hint to userspace to enable THP. It seems
> actionable in a different way than a high number of kvm page tables or
> iommu page tables.)

I don't know about iommu page tables, but on the KVM side a high count can also
be a good signal that enabling THP would be beneficial.  It's definitely actionable
in a different way though too.

> How about NR_VIRT? It's shorter, seems descriptive enough, less room
> for confusion, and is more easily extensible in the future.

I don't like NR_VIRT because VFIO/iommu can be used for non-virtualization things,
and we'd be lying by omission unless KVM (and other users) updates all of its
large-ish allocations to account them correctly.
