From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Tue, 24 May 2022 15:31:52 -0700
Message-ID: <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com> <YoeoLJNQTam5fJSu@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/hjeyXIou+bR7sgCBUUS9KBiw7ITkpAtyGQPK8WkjHQ=;
        b=E47CS0uk7HJ3B0+amVIKreQyHTGL6Id/MNM0NxjP7X6opvCgl1WcdBa5SnwKc3EDWw
         V2RSBPZ5PBv0+cdx0NAoNLXYDyjDup9mou8/UiOBU++4DVMVZrHzrWd+ZVhZFW2K8uMW
         p9b4jxU7DGV0i8n8hpbveKXjRPZjF7JZfelsg33lCxe6KvbM/3Kw2gy36RExYeMQcSnp
         QyMMPOr6T3TA59Xk7ew90wKydoDBGM28Fu7tgOmM6JcjUpxvmSbhb9njgSwtUUkrwV/Z
         SDvlO42njKkIejaVhIiCDGW4sF9Mf28i9mQR4sp9xyvJ2C1xtsrbm5Tfz8hGqHkzJQq/
         IEHg==
In-Reply-To: <YoeoLJNQTam5fJSu-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM9gwCICpdfJQ@public.gmane.org

On Fri, May 20, 2022 at 7:39 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Thu, May 19, 2022 at 06:56:54PM -0700, Yosry Ahmed wrote:
> > On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > [...]
> > > >
> > > > It was mostly an honest question, I too am trying to understand what userspace
> > > > wants to do with this information.  I was/am also trying to understand the benefits
> > > > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > > > already has specific stats for the number of leaf pages mapped into a VM, why not
> > > > do the same for non-leaf pages?
> > >
> > > Let me answer why a more general stat is useful and the potential
> > > userspace reaction:
> > >
> > > For a memory type which is significant enough, it is useful to expose
> > > it in the general interfaces, so that the general data/stat collection
> > > infra can collect them instead of having workload dependent stat
> > > collectors. In addition, not necessarily that stat has to have a
> > > userspace reaction in an online fashion. We do collect stats for
> > > offline analysis which greatly influence the priority order of
> > > optimization workitems.
> > >
> > > Next the question is do we really need a separate stat item
> > > (secondary_pagetable instead of just plain pagetable) exposed in the
> > > stable API? To me secondary_pagetable is general (not kvm specific)
> > > enough and can be significant, so having a separate dedicated stat
> > > should be ok. Though I am ok with lump it with pagetable stat for now
> > > but we do want it to be accounted somewhere.
> >
> > Any thoughts on this? Johannes?
>
> I agree that this memory should show up in vmstat/memory.stat in some
> form or another.
>
> The arguments on whether this should be part of NR_PAGETABLE or a
> separate entry seem a bit vague to me. I was hoping somebody more
> familiar with KVM could provide a better picture of memory consumption
> in that area.
>
> Sean had mentioned that these allocations already get tracked through
> GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
> track, they should be represented in memory.stat in some form. Sean
> also pointed out though that those allocations tend to scale rather
> differently than the page tables, so it probably makes sense to keep
> those two things separate at least.
>
> Any thoughts on putting shadow page tables and iommu page tables into
> the existing NR_PAGETABLE item? If not, what are the cons?
>
> And creating (maybe later) a separate NR_VIRT for the other
> GPF_KERNEL_ACCOUNT allocations in kvm?

I agree with Sean that a NR_VIRT stat would be inaccurate by omission,
unless we account for all KVM allocations under this stat. This might
be an unnecessary burden according to what Sean said, as most other
allocations scale linearly with the number of vCPUs or the memory
assigned to the VM.

I don't have enough context to say whether we should piggyback KVM MMU
pages to the existing NR_PAGETABLE item, but from a high level it
seems like it would be more helpful if they are a separate stat.
Anyway, I am willing to go with whatever Sean thinks is best.
