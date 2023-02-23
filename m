From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 10:03:50 -0800
Message-ID: <CAJD7tkadBRP22qP63-SjKSch1im9sHLoMzc6c2h10+ggbuxqMg@mail.gmail.com>
References: <Y/UEkNn0O65Pfi4e@nvidia.com> <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com> <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com> <87o7pmnd0p.fsf@nvidia.com> <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com> <Y/bHNO7A8T3QQ5T+@nvidia.com> <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg@mail.gmail.com>
 <Y/eiLBo88pgr2IUm@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=USwxvTrM3itz7MA/18FaPbrVGvaCj22AfDbh21ZkNzo=;
        b=BhTeM1KHPOiptIazaVYWZ4TGpZCI3Iui0ngWB6eT0QeLw3/KHRkUGPvpKPPYJxhlnO
         NDPPOe0WuiZKWa7BgQM8O/0xv3ESGdUO1ScZfovh1kfSoZTrAN0yP0WgT+6kzNWAn7Bi
         dlc4rYkysGymNVLdZdBUXgsGHTKpLkcIgo+UKDhMc1VgBZVmSrd3WUN7Ph8QdE9s5OF6
         fdPLSGbTNGyuE7Jzkc+FB9u78owmdgvub7Vp9a0vBCR0KkVX8SpThqay5zCYt6ZY+1jH
         7VIubHXsT2NOpaCJ/rtJK/L9Eq9tVCW+5Q1FZQ0ij6uyqm4vr7VKfpVLT2k3L8kQWIKv
         16mg==
In-Reply-To: <Y/eiLBo88pgr2IUm@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Alistair Popple <apopple@nvidia.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Feb 23, 2023 at 9:28 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Feb 23, 2023 at 09:18:23AM -0800, T.J. Mercier wrote:
>
> > > Solving that problem means figuring out when every cgroup stops using
> > > the memory - pinning or not. That seems to be very costly.
> > >
> > This is the current behavior of accounting for memfds, and I suspect
> > any kind of shared memory.
> >
> > If cgroup A creates a memfd, maps and faults in pages, shares the
> > memfd with cgroup B and then A unmaps and closes the memfd, then
> > cgroup A is still charged for the pages it faulted in.
>
> As we discussed, as long as the memory is swappable then eventually
> memory pressure on cgroup A will evict the memfd pages and then cgroup
> B will swap it in and be charged for it.

I am not familiar with memfd, but based on
mem_cgroup_swapin_charge_folio() it seems like if cgroup B swapped in
the pages they will remain charged to cgroup A, unless cgroup A is
removed/offlined. Am I missing something?

>
> > FWIW this is also the behavior I was trying to use to attribute
> > dma-buffers to their original allocators. Whoever touches it first
> > gets charged as long as the memory is alive somewhere.
> >
> > Can't we do the same thing for pins?
>
> If pins are tracked independently from memcg then definately not,
> a process in cgroup A should never be able to make a charge on cgroup
> B as a matter of security.
>
> If pins are part of the memcg then we can't always turn the pin
> request in to a NOP - the current cgroup always has to be charged for
> the memory. Otherwise what is the point from a security perspective?
>
> Jason
