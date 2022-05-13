From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Fri, 13 May 2022 11:50:18 -0400
Message-ID: <Yn5+OtZSSUZZgTQj@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kye4TfWEBKeNkvsN1Z8PpM0cIuVevPyfJP2pQ+b2OJ0=;
        b=ZZ/JJCRDz3yE4ILSty048bcbPErmsDUK3HlgCxPZevGvO0s7lKzzyxYdFDw1dJf9ph
         MIp+dwz/aXhjTfmLJaPj/lFR5KENnPsRIaVfRdKCuXnMx6qMaG0uPs9glvL+IiheyQV+
         I8N0k1bffzWgc5Xm+tBeTXdy8CbQJfgCaMsHgTm1sfLVt/+VGnsbnrEpzH2RKA967Lgp
         i0c6ZYtdpmtmfZZuTg2GnWU+ABJlGS07aIDJN1CLeOQkEF/JyGUWyE+RbOazEYEr/CaR
         3SpCLEHRQ4pi9gjxDfMWcHE6xNgzt5GERI+gy2A1oDXWEszhLZUV5HDLMnSPDj/P5+Pq
         xL0Q==
Content-Disposition: inline
In-Reply-To: <Yn2YYl98Vhh/UL0w-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6Ug@public.gmane.org

On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> On Thu, May 12, 2022, Johannes Weiner wrote:
> > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > the exact same purpose, and I'd expect these to be handled the same
> > > > way (i.e. why is this KVM specific?).
> > > 
> > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > account other types of secondary page tables to this stat. It is just
> > > that we are currently interested in the KVM MMU usage.
> > 
> > Do you actually care at the supervisor level that this memory is used
> > for guest page tables?
> 
> Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> for page tables, but except for page tables, the number/size of those allocations
> scales linearly with either the number of vCPUs or the amount of memory assigned
> to the VM (with no room for improvement barring KVM changes).
> 
> Off the top of my head, KVM's secondary page tables are the only allocations that
> don't scale linearly, especially when nested virtualization is in use.

Thanks, that's useful information.

Are these other allocations accounted somewhere? If not, are they
potential containment holes that will need fixing eventually?

> > It seems to me you primarily care that it is reported *somewhere*
> > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > it's page tables or iommu tables or whatever else allocated for the
> > purpose of virtualization, it doesn't make much of a difference to the
> > host/cgroup that is tracking it, right?
> > 
> > (The proximity to nr_pagetable could also be confusing. A high page
> > table count can be a hint to userspace to enable THP. It seems
> > actionable in a different way than a high number of kvm page tables or
> > iommu page tables.)
> 
> I don't know about iommu page tables, but on the KVM side a high count can also
> be a good signal that enabling THP would be beneficial.

Well, maybe.

It might help, but ultimately it's the process that's in control in
all cases: it's unmovable kernel memory allocated to manage virtual
address space inside the task.

So I'm still a bit at a loss whether these things should all be lumped
in together or kept separately. meminfo and memory.stat are permanent
ABI, so we should try to establish in advance whether the new itme is
really a first-class consumer or part of something bigger.

The patch initially piggybacked on NR_PAGETABLE. I found an email of
you asking why it couldn't be a separate item, but it didn't provide a
reasoning for that decision. Could you share your thoughts on that?

Thanks
