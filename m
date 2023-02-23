From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 13:28:12 -0400
Message-ID: <Y/eiLBo88pgr2IUm@nvidia.com>
References: <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com>
 <Y/bHNO7A8T3QQ5T+@nvidia.com>
 <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EKAwc/LgahAvTgYhXdUvHgORsVMsXkpCftdguy998aI=;
 b=ppKcvQhMyE+wTM8JZCjY9g/3iU21+KFmkyth0kNxOctyRwQoqg6epC3+FYpbG9cRH0MHYlesqB6oyMyvzyu45FQ3bZkjSgbMJaVYthTId+Xolp7s1ff3UJtpWvrQGHrgfa9CcoeBpOrwVADqxD8m1KWXecaum4T8b/UsFwmIMgEcfAHRyhIBzw9bDw+qg97CCjDYolBcm3Jzxtz8Jc20aG3DONNR65ZvAR5+D4BAfwXGfLHbumXRght1LTX/IvurZhdEB0/92kUTUC+n+LgZ34kmpEZuRxWyYigTrTw/2675DKm7uHvmFrUKC62aAl/1SENLCNhMxtEYA8WLQue5uQ==
Content-Disposition: inline
In-Reply-To: <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 23, 2023 at 09:18:23AM -0800, T.J. Mercier wrote:

> > Solving that problem means figuring out when every cgroup stops using
> > the memory - pinning or not. That seems to be very costly.
> >
> This is the current behavior of accounting for memfds, and I suspect
> any kind of shared memory.
> 
> If cgroup A creates a memfd, maps and faults in pages, shares the
> memfd with cgroup B and then A unmaps and closes the memfd, then
> cgroup A is still charged for the pages it faulted in.

As we discussed, as long as the memory is swappable then eventually
memory pressure on cgroup A will evict the memfd pages and then cgroup
B will swap it in and be charged for it.
 
> FWIW this is also the behavior I was trying to use to attribute
> dma-buffers to their original allocators. Whoever touches it first
> gets charged as long as the memory is alive somewhere.
>
> Can't we do the same thing for pins?

If pins are tracked independently from memcg then definately not,
a process in cgroup A should never be able to make a charge on cgroup
B as a matter of security.

If pins are part of the memcg then we can't always turn the pin
request in to a NOP - the current cgroup always has to be charged for
the memory. Otherwise what is the point from a security perspective?

Jason
