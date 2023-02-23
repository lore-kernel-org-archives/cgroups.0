From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 09:18:23 -0800
Message-ID: <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg@mail.gmail.com>
References: <Y/T+pw25oGmKqz1k@nvidia.com> <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com> <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com> <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com> <87o7pmnd0p.fsf@nvidia.com> <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com> <Y/bHNO7A8T3QQ5T+@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fXkdUZpJKaU09VaQ11AXT4xG/p6acp3mSex2EZ+R/lU=;
        b=amR2wqzsiprwfbFfrHgh/xz4XLutJ3c00Gafi0Ekj78VHQ5IN4mpuEdlqhd28ZVClG
         NDVIiG3v9u7xZUsI/c1zW8Op2nY4ImR5hHrbVIXKjbh3AhUWJjKBUun5hc4jk5M6whAH
         XohUicGhtRUkFJX5+lGP5KjRtM8AK0HfOk/5JreQGUPbXNDo0IaxOHgDftk2gatqvc28
         MxifB1DnuNVrochCNXSxYqoarvF5v0iZSGIiWU+RZF4ZkxVkv8H0uZaA3FArkHB2wh1N
         zNo5avGuoaprTtskjyY7JRz9BnJ+04L8/3li4c2c3ASaRx0txg3+0DmfnIF4Nu+Xx/QI
         7nfA==
In-Reply-To: <Y/bHNO7A8T3QQ5T+@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Wed, Feb 22, 2023 at 5:54 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Feb 23, 2023 at 09:59:35AM +1100, Alistair Popple wrote:
> >
> > Jason Gunthorpe <jgg@nvidia.com> writes:
> >
> > > On Wed, Feb 22, 2023 at 10:38:25PM +1100, Alistair Popple wrote:
> > >> When a driver unpins a page we scan the pinners list and assign
> > >> ownership to the next driver pinning the page by updating memcg_data and
> > >> removing the vm_account from the list.
> > >
> > > I don't see how this works with just the data structure you outlined??
> > > Every unique page needs its own list_head in the vm_account, it is
> > > doable just incredibly costly.
> >
> > The idea was every driver already needs to allocate a pages array to
> > pass to pin_user_pages(), and by necessity drivers have to keep a
> > reference to the contents of that in one form or another. So
> > conceptually the equivalent of:
> >
> > struct vm_account {
> >        struct list_head possible_pinners;
> >        struct mem_cgroup *memcg;
> >        struct pages **pages;
> >        [...]
> > };
> >
> > Unpinnig involves finding a new owner by traversing the list of
> > page->memcg_data->possible_pinners and iterating over *pages[] to figure
> > out if that vm_account actually has this page pinned or not and could
> > own it.
>
> Oh, you are focusing on Tejun's DOS scenario.
>
> The DOS problem is to prevent a pin users in cgroup A from keeping
> memory charged to cgroup B that it isn't using any more.
>
> cgroup B doesn't need to be pinning the memory, it could just be
> normal VMAs and "isn't using anymore" means it has unmapped all the
> VMAs.
>
> Solving that problem means figuring out when every cgroup stops using
> the memory - pinning or not. That seems to be very costly.
>
This is the current behavior of accounting for memfds, and I suspect
any kind of shared memory.

If cgroup A creates a memfd, maps and faults in pages, shares the
memfd with cgroup B and then A unmaps and closes the memfd, then
cgroup A is still charged for the pages it faulted in.

FWIW this is also the behavior I was trying to use to attribute
dma-buffers to their original allocators. Whoever touches it first
gets charged as long as the memory is alive somewhere.

Can't we do the same thing for pins?

> AFAIK this problem also already exists today as the memcg of a page
> doesn't change while it is pinned. So maybe we don't need to address
> it.
>
> Arguably the pins are not the problem. If we want to treat the pin
> like allocation then we simply charge the non-owning memcg's for the
> pin as though it was an allocation. Eg go over every page and if the
> owning memcg is not the current memcg then charge the current memcg
> for an allocation of the MAP_SHARED memory. Undoing this is trivial
> enoug.
>
> This doesn't fix the DOS problem but it does sort of harmonize the pin
> accounting with the memcg by multi-accounting every pin of a
> MAP_SHARED page.
>
> The other drawback is that this isn't the same thing as the current
> rlimit. The rlimit is largely restricting the creation of unmovable
> memory.
>
> Though, AFAICT memcg seems to bundle unmovable memory (eg GFP_KERNEL)
> along with movable user pages so it would be self-consistent.
>
> I'm unclear if this is OK for libvirt..
>
> > Agree this is costly though. And I don't think all drivers keep the
> > array around so "iterating over *pages[]" may need to be a callback.
>
> I think searching lists of pages is not reasonable. Things like VFIO &
> KVM use cases effectively pin 90% of all system memory, that is
> potentially TB of page lists that might need linear searching!
>
> Jason
