From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Tue, 12 Jul 2022 16:03:02 -0700
Message-ID: <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHwuHViFSN86tj0ChYoibxcY4E2c7D4JyTppJFZI4so=;
        b=Lhh55GnSdOjPhbJGduTnxEGnWccw6kHOeEeY08jAZgJe0VqjmPoBdTPnONumi/pAun
         p+cHg4gHnhGSvibmw9wIMHwGbOMlbmWVVet0lyBNoQFKw49iIOLl44zlrlp+lgOkWr4N
         nI06n4Ji3hwluei1aEEzHQyZHr8WFbhVYRiJlwQVHmUD64NqpTZjoyhfvNHbS2GCc5aR
         uNpAcmjt7Eo2ZLV4iQ/jGK1hfJ4aVbxJui0znZqX9547wQXUukqWF8+PFEtZcDsj6osq
         cNrlBGb2ZoHRdeHJDRKTLI+onjdNABpheW4De5nAankciyk7viUqVbyzzoaaEs5liuGY
         qvhw==
In-Reply-To: <YsdJPeVOqlj4cf2a-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel>

Thanks for taking another look at this!

On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > We keep track of several kernel memory stats (total kernel memory, page
> > tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> > per-memcg, etc). These stats give insights to users to how much memory
> > is used by the kernel and for what purposes.
> >
> > Currently, memory used by kvm mmu is not accounted in any of those
>
> Nit, capitalize KVM (mainly to be consistent).
>
> > @@ -1085,6 +1086,9 @@ KernelStack
> >                Memory consumed by the kernel stacks of all tasks
> >  PageTables
> >                Memory consumed by userspace page tables
> > +SecPageTables
> > +              Memory consumed by secondary page tables, this currently
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Nit, this line has a tab instead of eight spaces.  Not sure if it actually matters,
> there are plenty of tabs elsewhere in the file, but all the entries in this block
> use only spaces.
>

Will fix it.

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index aab70355d64f3..13190d298c986 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -216,6 +216,7 @@ enum node_stat_item {
> >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> >  #endif
> >       NR_PAGETABLE,           /* used for pagetables */
> > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
>
> Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> is messy, so I totally understand why you included it, but in this case it's unnecessary
> and potentially confusing.
>
> And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> stats the depend on a single feature seems to be the status quo for this code.
>

I will #ifdef the stat, but I will emphasize in the docs that is
currently *only* used for KVM so that it makes sense if users without
KVM don't see the stat at all. I will also remove the stat from
show_free_areas() in mm/page_alloc.c as it seems like none of the
#ifdefed stats show up there.

> >  #ifdef CONFIG_SWAP
> >       NR_SWAPCACHE,
> >  #endif
