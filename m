From: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Thu, 26 May 2022 00:38:52 +0000
Message-ID: <Yo7MHA2aUaprvgl8@google.com>
References: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7P8MdhBUHeNYERj02eaiVlo3+1akuXNgpyLjujYYpb0=;
        b=nGnImQMrxcKuAMPfn2cnaf9VK34koPZI6BdWd8L/dvJkOmKEczFMWc8Yx7hsQFZeVL
         9KLxd0tBqQk1/z15iyaTJQGyj+rpJcqO/oigF6/cI0x8g+X/Xo/VBfVgAonu8k6z7tAw
         rX3SONGBqur0M8KowUWh/wmc3aYT+yOgmGgvthbF1GbnQhkOPFYSCTfv0l7sg5kj2jls
         D/lYOdddeRohuY3mRJGYNVA5mDFRmRi5K+xU9HMyUH4O1+TPylZTZEwi6U0ynqv/r7ZQ
         PEcsEwLY3XMn7/TlPZPqXhp0uzspbOfW5miRUT3ck3ZbCGUmofEeJzc2ijyz7b5LJr0L
         9x9Q==
Content-Disposition: inline
In-Reply-To: <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeelb@google.com>, Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Oliver Upton <oupton@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.or

On Wed, May 25, 2022, Johannes Weiner wrote:
> On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > I don't have enough context to say whether we should piggyback KVM MMU
> > pages to the existing NR_PAGETABLE item, but from a high level it
> > seems like it would be more helpful if they are a separate stat.
> > Anyway, I am willing to go with whatever Sean thinks is best.
> 
> Somebody should work this out and put it into a changelog. It's
> permanent ABI.

After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.

It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
allocate a large number of page tables even though the guest isn't accessing that
much memory.

But, someone would need to either understand how KVM works to make that connection,
or know (or be told) to go look at KVM's stats if they're running VMs to better
decipher the stats.

And even in the little bit of time I played with this, I found having
nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
informative.  E.g. when backing a VM with THP versus HugeTLB,
nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
something triggering DoubleMap, but now I want to find out why that's happening.

So while I'm pretty sure a clever user could glean the same info by cross-referencing
NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
very least prove to be helpful for understanding tradeoffs between VM backing types,
and likely even steer folks towards potential optimizations.

Baseline:
  # grep page_table /proc/vmstat 
  nr_page_table_pages 2830
  nr_secondary_page_table_pages 0

THP:
  # grep page_table /proc/vmstat 
  nr_page_table_pages 7584
  nr_secondary_page_table_pages 140

HugeTLB:
  # grep page_table /proc/vmstat
  nr_page_table_pages 3153
  nr_secondary_page_table_pages 153

