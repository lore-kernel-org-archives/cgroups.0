From: Odin Hultgren van der Horst <odin-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org>
Subject: Re: Re: [Question] io cgroup subsystem threaded support
Date: Thu, 7 Oct 2021 15:39:16 +0200
Message-ID: <20211007133916.mgk6qb65d2r57fc2@T580.localdomain>
References: <20211001110645.uzw2w5t4rknwqhma@T580.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211001110645.uzw2w5t4rknwqhma-3Hjs5a4P6Kh82hYKe6nXyg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> The biggest is the fact that page cache pagse are owned by processes not
> threads. A related issue is that writeback tracks ownership per inode with a
> mechanism for transferring ownership when majority writer changes. Splitting
> IO control per-thread would increase friction there. So, the summary is that
> the kernel doesn't track related resource consumptions at thread
> granularity.

So mainly the writeback functionality or is it ingrained in all
functionality like latency and priority?

If not, is there a subset of io cgroup subsys that could easily support threading?

And if so, could one either split the subsystem into two subsystems a
io_threaded and io or possibly add an option to disable the functionality
that restricts it from supporting threading?

Thanks.
