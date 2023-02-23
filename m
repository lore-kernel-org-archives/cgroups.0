From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 14:17:18 -0400
Message-ID: <Y/etrtvyaiwRIo6f@nvidia.com>
References: <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com>
 <Y/bHNO7A8T3QQ5T+@nvidia.com>
 <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg@mail.gmail.com>
 <Y/eiLBo88pgr2IUm@nvidia.com>
 <CAJD7tkadBRP22qP63-SjKSch1im9sHLoMzc6c2h10+ggbuxqMg@mail.gmail.com>
 <Y/esMBOyTaJnv5CW@nvidia.com>
 <Y/etNfwxHv8XO3iC@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efqBFXFYB3TD5OXzbuQQGRR8J7gFjiqrmSMRmH8gpCg=;
 b=VM0d1iVhndA5EMWwMhsSM2OSyY3n8vKE3pkdCEEoCmXdd5ud3A+aXX/Xf5ONANZSdgPytPHoihp+1/CHSq2C3MoPPEJPaX+5MEhXDUsv5zib/pVZnDCJO5s1k7AxG+s0E4ekRKZk4L5b+mrE5qPvr8gqz6hrmBtKa3wRyUvuAhcfBacCmDd039UG4L9oR0Sksheddzo7cjdcOkm2X6BEwznOx7pWXlIBZGMsE1vJBB0/NjJ7AAdvYYCRVbyy/5a5ReMSFM9wRlqHck7935OQcd5WgY0SR0q9EImKVKbRiehUtx2r7CJjGAmSYYUpPxfxXZN5lNy1QsD01HPfLKDD6Q==
Content-Disposition: inline
In-Reply-To: <Y/etNfwxHv8XO3iC-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 23, 2023 at 08:15:17AM -1000, Tejun Heo wrote:
> On Thu, Feb 23, 2023 at 02:10:56PM -0400, Jason Gunthorpe wrote:
> > > I am not familiar with memfd, but based on
> > > mem_cgroup_swapin_charge_folio() it seems like if cgroup B swapped in
> > > the pages they will remain charged to cgroup A, unless cgroup A is
> > > removed/offlined. Am I missing something?
> > 
> > Ah, I don't know, Tejun said:
> > 
> > "but it can converge when page usage transfers across cgroups
> > if needed."
> > 
> > Which I assumed was swap related but I don't know how convergence
> > works.
> 
> That'd work for pagecache. For swap-backed, I think Yosry is right. Is
> MAP_SHARED | MAP_ANONYMOUS a concern? Such mappings can only be shared
> through forking, so it's not a common thing to be shared across different
> resource domains.

Isn't memfd also in the same boat?

Jason
