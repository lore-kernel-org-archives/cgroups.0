From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Fri, 20 May 2022 10:39:40 -0400
Message-ID: <YoeoLJNQTam5fJSu@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TTmi/1xkgT1AjVxJzskAr+COf/0zmPlsvxgfjW6STHE=;
        b=Gxvhl+k8BBXk02rLhNHh59M59iKaZySmrURL5ViwDbexkz4AQDcT1PrTxGRwwIA9b6
         /1f2ADWNgafFMzN43IhcFiyinqNnehHn/mS0YJbtMR6z731PyisnndoOkG4QNw19YD3d
         5k+xSboSMaMN7QvahZpDuaMGQOESeBd5F4Bx3mh8jgB1uyY3ssyoK0Xq2S2xeP72/K83
         PKpXip7h0Y+PpB3dm95FI4ngwmEccKM7+EXoqGyFtJ1eCsv33X6U8TW4FvS5JNrN09KR
         w9b5Y7kbJX4XTJASFVGfGrpW2a4CWNMPykU0xVE8Gyft/WvrlN09/Biji8rIPx+RUWjW
         tCtA==
Content-Disposition: inline
In-Reply-To: <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM9gwCICpdfJQ@public.gmane.org

On Thu, May 19, 2022 at 06:56:54PM -0700, Yosry Ahmed wrote:
> On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > [...]
> > >
> > > It was mostly an honest question, I too am trying to understand what userspace
> > > wants to do with this information.  I was/am also trying to understand the benefits
> > > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > > already has specific stats for the number of leaf pages mapped into a VM, why not
> > > do the same for non-leaf pages?
> >
> > Let me answer why a more general stat is useful and the potential
> > userspace reaction:
> >
> > For a memory type which is significant enough, it is useful to expose
> > it in the general interfaces, so that the general data/stat collection
> > infra can collect them instead of having workload dependent stat
> > collectors. In addition, not necessarily that stat has to have a
> > userspace reaction in an online fashion. We do collect stats for
> > offline analysis which greatly influence the priority order of
> > optimization workitems.
> >
> > Next the question is do we really need a separate stat item
> > (secondary_pagetable instead of just plain pagetable) exposed in the
> > stable API? To me secondary_pagetable is general (not kvm specific)
> > enough and can be significant, so having a separate dedicated stat
> > should be ok. Though I am ok with lump it with pagetable stat for now
> > but we do want it to be accounted somewhere.
> 
> Any thoughts on this? Johannes?

I agree that this memory should show up in vmstat/memory.stat in some
form or another.

The arguments on whether this should be part of NR_PAGETABLE or a
separate entry seem a bit vague to me. I was hoping somebody more
familiar with KVM could provide a better picture of memory consumption
in that area.

Sean had mentioned that these allocations already get tracked through
GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
track, they should be represented in memory.stat in some form. Sean
also pointed out though that those allocations tend to scale rather
differently than the page tables, so it probably makes sense to keep
those two things separate at least.

Any thoughts on putting shadow page tables and iommu page tables into
the existing NR_PAGETABLE item? If not, what are the cons?

And creating (maybe later) a separate NR_VIRT for the other
GPF_KERNEL_ACCOUNT allocations in kvm?
