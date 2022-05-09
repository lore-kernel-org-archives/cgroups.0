From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 9 May 2022 09:38:17 -0700
Message-ID: <CAJD7tkbfT-FRs3LE2GPddqrQSWw_eC1R6k3z04x=z9Zvt5yLpg@mail.gmail.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zHCy33IfC5TyILOeQkmukBylQEbte8TBRw0A+aY3Nnw=;
        b=H6nlUcikiCWMQ0NyQpEOvAX9YWAzxJVOMo8TCOD+MTF5x++KFtykM38ezcNgkrqf/k
         HsEf3EJd5U1zetXK4vcQ2qXVxKjVLLmxk64eVHzC1lhLd+csiUOWanUBOMc0ehk+lL8Z
         8kMOXwBH5hATNTPogQUXQIImHkrg03NEi/77hdTa1677HBxwaUfkv/QQ7yLseBE1HcJE
         YPtPpea4ak7+T4Dqx7q3oWEasv5JJswYYW1+IlWiL+SM1CpjXzbyzq9KKAOv4Z51ZAoC
         p4WvvEjdiEI05l2ZOHE80zU68Yi/ftR+9e3AoP2yMz5PBJyRJ0fD1vQ47PM6C0czbLOE
         9nDg==
In-Reply-To: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvma

On Mon, May 2, 2022 at 11:46 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Fri, 29 Apr 2022 21:11:28 +0100,
> > Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > > KVM mmu. This provides more insights on the kernel memory used
> > > by a workload.
> > >
> > > This stat will be used by subsequent patches to count KVM mmu
> > > memory usage.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  Documentation/admin-guide/cgroup-v2.rst | 5 +++++
> > >  Documentation/filesystems/proc.rst      | 4 ++++
> > >  drivers/base/node.c                     | 2 ++
> > >  fs/proc/meminfo.c                       | 2 ++
> > >  include/linux/mmzone.h                  | 1 +
> > >  mm/memcontrol.c                         | 1 +
> > >  mm/page_alloc.c                         | 6 +++++-
> > >  mm/vmstat.c                             | 1 +
> > >  8 files changed, 21 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > > index 69d7a6983f78..828cb6b6f918 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
> > >         pagetables
> > >                  Amount of memory allocated for page tables.
> > >
> > > +       secondary_pagetables
> > > +             Amount of memory allocated for secondary page tables,
> > > +             this currently includes KVM mmu allocations on x86
> > > +             and arm64.
> >
> > Can you please explain what the rationale is for this? We already
> > account for the (arm64) S2 PTs as a userspace allocation (see
>
> This can be considered as continuation for that work. The mentioned
> commit accounts S2 PTs to the VM process cgroup kernel memory. We have
> stats for the total kernel memory, and some fine-grained categories of
> that, like (pagetables, stack, slab, etc.).
>
> This patch just adds another category to give further insights into
> what exactly is using kernel memory.
>
> > 115bae923ac8bb29ee635). You are saying that this is related to a
> > 'workload', but given that the accounting is global, I fail to see how
> > you can attribute these allocations on a particular VM.
>
> The main motivation is having the memcg stats, which give attribution
> to workloads. If you think it's more appropriate, we can add it as a
> memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
> per-memcg vmalloc stat")). The only reason I made this as a global
> stat too is to be consistent with NR_PAGETABLE.
>
> >
> > What do you plan to do for IOMMU page tables? After all, they serve
> > the exact same purpose, and I'd expect these to be handled the same
> > way (i.e. why is this KVM specific?).
>
> The reason this was named NR_SECONDARY_PAGTABLE instead of
> NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> account other types of secondary page tables to this stat. It is just
> that we are currently interested in the KVM MMU usage.
>


Any thoughts on this? Do you think MEMCG_SECONDARY_PAGETABLE would be
more appropriate here?
