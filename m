From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Date: Thu, 28 Apr 2022 16:49:09 -0700
Message-ID: <CAJD7tkY1sdjXFAhftWG+ZV1B4z_HR9mf4QZGA-EJWeKaRQGs4Q@mail.gmail.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com> <YmegoB/fBkfwaE5z@google.com>
 <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com> <YmrSywSU1ezREvT6@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=focMG0Yvzu8kTNlJIkjfWrJiugje96+mCpIttRqo5P4=;
        b=GOeTnHyfLUj1kYuuIm0Y/SV6rdbaURUuZyug5U8+bM9txNVDB4zqvMsTo6LgWxqqJ+
         EJzVOKlCGbXzZnVXdg3zImUfxT1mhWA8cbxLRGVt1mE5eBxCAY3hnU4fMZFKFe1/ysTG
         cyomFq/31PJ7L9dLLImNGTzmHFLpGkzqWJGCsZd6ESc2YMwmrym/vaV+ntsJIKN6uPzN
         GHJN6ZJmWTueQxTkthcuYUVcXcDsF4uUX/S+zj4KBcwgIjmuet5DXc3NMlNVPJ+MF4Jl
         g76wI45mkRhG8Ow9F+ienA/5IabcbdIA62pAqypAHshKR/CNShI7i+XFMGHcSQdqfi8n
         ZW7w==
In-Reply-To: <YmrSywSU1ezREvT6@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oliver Upton <oupton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Marc Zyngier <maz@kernel.org>

On Thu, Apr 28, 2022 at 10:45 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Apr 26, 2022 at 12:27:57PM -0700, Yosry Ahmed wrote:
> > > What page tables do we want to account? KVM on ARM manages several page
> > > tables.
> > >
> > > For regular KVM, the host kernel manages allocations for the hyp stage 1
> > > tables in addition to the stage 2 tables used for a particular VM. The
> > > former is system overhead whereas the latter could be attributed to a
> > > guest VM.
> >
> > Honestly I would love to get your input on this. The main motivation
> > here is to give users insights on the kernel memory usage on their
> > system (or in a cgroup). We currently have NR_PAGETABLE stats for
> > normal kernel page tables (allocated using
> > __pte_alloc_one()/pte_free()), this shows up in /proc/meminfo,
> > /path/to/cgroup/memory.stat, and node stats. The idea is to add
> > NR_SECONDARY_PAGETABLE that should include the memory used for kvm
> > pagetables, which should be a separate category (no overlap). What
> > gets included or not depends on the semantics of KVM and what exactly
> > falls under the category of secondary pagetables from the user's pov.
> >
> > Currently it looks like s2 page table allocations get accounted to
> > kmem of memory control groups (GFP_KERNEL_ACCOUNT), while hyp page
> > table allocations do not (GFP_KERNEL). So we could either follow this
> > and only account s2 page table allocations in the stats, or make hyp
> > allocations use GFP_KERNEL_ACCOUNT as well and add them to the stats.
> > Let me know what you think.
>
> I think it is reasonable to just focus on stage 2 table allocations and
> ignore all else. As Marc pointed out it isn't workable in other
> contexts anyway (pKVM), and keeps the patch tidy too.
>
> GFP_KERNEL_ACCOUNT for hyp allocations wouldn't make sense, as it is
> done at init to build out the system page tables for EL2.

Thanks so much for the insights, will send out v4 according to our discussion.

>
> --
> Thanks,
> Oliver
