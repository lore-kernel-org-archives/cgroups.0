From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Thu, 19 May 2022 18:56:54 -0700
Message-ID: <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com> <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/NS3+bOivmdn/Z8oAqTayRG5MjC4lANEwiPrpSX5IA=;
        b=lC1A71c86K3b210P5MINYKI+0nEPTtRGK3LeWj2Npew4lX9mJGgrpWWegiuNtMwlJO
         P1IlUwgqu95jwD3J+mnRGelGqXz+HoaJ7VCJk9hhvvF66jPz+hrvF0dmKSe2LLL2Vgq/
         rwXqca2l71+mfz5tl8pRhTv4LCsg9QGocKsxdwCfWXbGVabJpfgNFG9+rBVSpj/uhude
         6hLQ+JpxChsTxgZBARTq2zFr80q+S2jttKKsRPO0P7o9moE/Iyx8K/oNzwHCGA7J5UxE
         CJjZ0hW/O6s0vTeoubWTNpA5gAfGug3OjBmx35+8T9dkzXFSpzM7/kEn0mCCEAR9GuP4
         zRlQ==
In-Reply-To: <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Oliver Upton <oupton@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infrad

On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> [...]
> >
> > It was mostly an honest question, I too am trying to understand what userspace
> > wants to do with this information.  I was/am also trying to understand the benefits
> > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > already has specific stats for the number of leaf pages mapped into a VM, why not
> > do the same for non-leaf pages?
>
> Let me answer why a more general stat is useful and the potential
> userspace reaction:
>
> For a memory type which is significant enough, it is useful to expose
> it in the general interfaces, so that the general data/stat collection
> infra can collect them instead of having workload dependent stat
> collectors. In addition, not necessarily that stat has to have a
> userspace reaction in an online fashion. We do collect stats for
> offline analysis which greatly influence the priority order of
> optimization workitems.
>
> Next the question is do we really need a separate stat item
> (secondary_pagetable instead of just plain pagetable) exposed in the
> stable API? To me secondary_pagetable is general (not kvm specific)
> enough and can be significant, so having a separate dedicated stat
> should be ok. Though I am ok with lump it with pagetable stat for now
> but we do want it to be accounted somewhere.

Any thoughts on this? Johannes?
