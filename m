From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Fri, 3 Jun 2022 12:42:15 -0400
Message-ID: <Ypo550pGxmnJnGBe@cmpxchg.org>
References: <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
 <Yo7MHA2aUaprvgl8@google.com>
 <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pZiq+DaP0uIJbqmhpHEQocGuha+dXUbZZZqTwIB2IaE=;
        b=rrQxT3vbT7GMAWiBE8NKh82hTKWmXoBOIgjSoB8gWHlxJCtpicQfJi6YHcKEu0Skmg
         abttTcfRqmTOcz4L3ohQC6WWhlA31fuHxoEfeuJpbUAg7kX6/vtplGcJ9j4IrzJVxD9O
         vdLoYfObodGls9T269h7hJyDm997n4snH1eyk5q8lGm0DuwzVfKoDQFEQSeKxajjX2Yz
         5TiL9zM/J27+HT1KqOA1cB9necDYn5jb3A6o3ARG7LxeA2ES2j5uBkLAZdLyHaiO4lvt
         ER/oF7LY8Hxyq/pFtt8IclZxYPm5bLZuRep0Ojk6gIJnuU/og9qHiw7H4aRy54/0OtvI
         pIJA==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM9gwCICpdfJQ@public.gmane.org

On Fri, May 27, 2022 at 11:33:27AM -0700, Yosry Ahmed wrote:
> On Wed, May 25, 2022 at 5:39 PM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Wed, May 25, 2022, Johannes Weiner wrote:
> > > On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > > > I don't have enough context to say whether we should piggyback KVM MMU
> > > > pages to the existing NR_PAGETABLE item, but from a high level it
> > > > seems like it would be more helpful if they are a separate stat.
> > > > Anyway, I am willing to go with whatever Sean thinks is best.
> > >
> > > Somebody should work this out and put it into a changelog. It's
> > > permanent ABI.
> >
> > After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.
> >
> > It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
> > scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> > bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
> > allocate a large number of page tables even though the guest isn't accessing that
> > much memory.
> >
> > But, someone would need to either understand how KVM works to make that connection,
> > or know (or be told) to go look at KVM's stats if they're running VMs to better
> > decipher the stats.
> >
> > And even in the little bit of time I played with this, I found having
> > nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
> > informative.  E.g. when backing a VM with THP versus HugeTLB,
> > nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
> > order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
> > something triggering DoubleMap, but now I want to find out why that's happening.
> >
> > So while I'm pretty sure a clever user could glean the same info by cross-referencing
> > NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
> > very least prove to be helpful for understanding tradeoffs between VM backing types,
> > and likely even steer folks towards potential optimizations.
> >
> > Baseline:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 2830
> >   nr_secondary_page_table_pages 0
> >
> > THP:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 7584
> >   nr_secondary_page_table_pages 140
> >
> > HugeTLB:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 3153
> >   nr_secondary_page_table_pages 153
> >
> 
> Interesting findings! Thanks for taking the time to look into this, Sean!
> I will refresh this patchset and summarize the discussion in the
> commit message, and also fix some nits on the KVM side. Does this
> sound good to everyone?

Yes, thanks for summarizing this. Sounds good to me!

