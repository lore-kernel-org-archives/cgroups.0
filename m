From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Fri, 13 May 2022 10:13:54 -0700
Message-ID: <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VM6L7CzHZq+DP15ACyDCNeBcnTiw96jhTORnn16Mcn8=;
        b=m7gQomUnSLOq+9pE4q9ffHGKLb3L3GE/tyqnZaMpqmJHNyG5wt5m5mpVnrt/R5fltk
         yK5RyYuw70QdsT3xpjionXDVduKVwIkENV/Mv5F0EHktzxJsXpmHkKAWfcOwy5gVtQvt
         Jb9aF197MUvc/8VfJWEKOA0A5W6r7Y5jyFAxdXtd+z7v8GihBIgqkMzUgDgmRLDEQBOl
         8CqLPCu3zlaWk59USw4+jqNDxNbSsUsyKPMu7PWzekJIARr0BRZnv82P4+e07sbtFdHd
         l7nGCtA297XhzYezBsDN16APQINq+JlpmHHYdQbrAp93SyhwC2tFFlzq6Ax51hV8P071
         YexA==
In-Reply-To: <Yn6DeEGLyR4Q0cDp-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XQ@public.gmane.org

On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
>
> It was mostly an honest question, I too am trying to understand what userspace
> wants to do with this information.  I was/am also trying to understand the benefits
> of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> already has specific stats for the number of leaf pages mapped into a VM, why not
> do the same for non-leaf pages?

Let me answer why a more general stat is useful and the potential
userspace reaction:

For a memory type which is significant enough, it is useful to expose
it in the general interfaces, so that the general data/stat collection
infra can collect them instead of having workload dependent stat
collectors. In addition, not necessarily that stat has to have a
userspace reaction in an online fashion. We do collect stats for
offline analysis which greatly influence the priority order of
optimization workitems.

Next the question is do we really need a separate stat item
(secondary_pagetable instead of just plain pagetable) exposed in the
stable API? To me secondary_pagetable is general (not kvm specific)
enough and can be significant, so having a separate dedicated stat
should be ok. Though I am ok with lump it with pagetable stat for now
but we do want it to be accounted somewhere.
