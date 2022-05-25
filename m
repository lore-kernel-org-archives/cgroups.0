From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Wed, 25 May 2022 07:56:43 -0400
Message-ID: <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
References: <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lEk6v60gkjFT68Gj4bJNaNs7k2gNzwxPhiEY5nNwaQQ=;
        b=XXcCcSNfXU4ZumvEofzKMhDBd7cN4uUTScIpzCQEM+hzYYKUfsKNiF4P7UVF51FKtd
         5RMh2GAnDESjADbuXOd1AqGedzaXh0w5A9T12BqTWJPxR4mUsbYzVpqI1DeLqcj+jRCv
         g4Mbz8Isqpigexjq2xgBfxvEZ6XOCfbhrEWV/D3mKfrw49MZYSOCSMLcFNY4bPWoBIIQ
         R5QYWFwAz8og1bHFYOMrTQ4s+e/PEPEozRRHKxlX3pJQbF9dxpvlI9pbg9wJj7C5geki
         qkYRTvMTxuO0dTaFgb5ZebuX4LpE/ZIxHighxOWhBpx05saqXnbfuwd4MPhQ1tJOvxUj
         hZDw==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM9gwCICpdfJQ@public.gmane.org

On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 7:39 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > I agree that this memory should show up in vmstat/memory.stat in some
> > form or another.
> >
> > The arguments on whether this should be part of NR_PAGETABLE or a
> > separate entry seem a bit vague to me. I was hoping somebody more
> > familiar with KVM could provide a better picture of memory consumption
> > in that area.
> >
> > Sean had mentioned that these allocations already get tracked through
> > GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
> > track, they should be represented in memory.stat in some form. Sean
> > also pointed out though that those allocations tend to scale rather
> > differently than the page tables, so it probably makes sense to keep
> > those two things separate at least.
> >
> > Any thoughts on putting shadow page tables and iommu page tables into
> > the existing NR_PAGETABLE item? If not, what are the cons?
> >
> > And creating (maybe later) a separate NR_VIRT for the other
> > GPF_KERNEL_ACCOUNT allocations in kvm?
> 
> I agree with Sean that a NR_VIRT stat would be inaccurate by omission,
> unless we account for all KVM allocations under this stat. This might
> be an unnecessary burden according to what Sean said, as most other
> allocations scale linearly with the number of vCPUs or the memory
> assigned to the VM.

I think it's fine to table the addition of NR_VIRT for now. My
conclusion from this discussion was just that if we do want to add
more KVM-related allocation sites later on, they likely would be
something separate and not share an item with the shadow tables. This
simplifies the discussion around how to present the shadow tables.

That said, stats can be incremental and still useful. memory.current
itself lies by ommission. It's more important to catch what's of
significance and allow users to narrow down pathological cases.

> I don't have enough context to say whether we should piggyback KVM MMU
> pages to the existing NR_PAGETABLE item, but from a high level it
> seems like it would be more helpful if they are a separate stat.
> Anyway, I am willing to go with whatever Sean thinks is best.

Somebody should work this out and put it into a changelog. It's
permanent ABI.
