From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Wed, 22 Feb 2023 22:38:25 +1100
Message-ID: <87o7pmnd0p.fsf@nvidia.com>
References: <Y+0tWZxMUx/NZ3Ne@nvidia.com> <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com> <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com> <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com> <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com> <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/J2SwDBtKM0rMVHMgsxfFOGyPRVQvdH0dlElN3WvE0=;
 b=dmrFMrylJDmeUBjHxti8ni7nIurDKzJiWNwef+HFUdt8NyZ/6g63dmlbBNQGtjovhwIx02QHTpdCsPKQVphXpdnsT/jAPJa2BWTx7LTILATGyEWwYDkaJaCVh/Q+HlwIzsIueD4GSeEjBptFMGv8hdY6sqPlY8YmsBoakazmzeSFzq/Xyw6knuKrRHeKNjKh+IkMrr4Mu205afdC13+L5JnEOXh3Wcj5cssrFmBJiyIgBx4nuUlAj+yIjMgXrAIZGqspIMokuSimJUz7fgaitTMrPGAmMk6KIh0zF03w90+B9/91WiGczpFKX28tKS8sw3kRKWLcFdJ997uAammEGw==
In-reply-to: <Y/UiQmuVwh2eqrfA-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:

>> the owner and pinner disagreeing with each other. At least
>> conceptually, the solution is rather straight-forward - whoever pins
>> a page should also claim the ownership of it.
>
> If the answer is pinner is owner, then multi-pinners must mean
> multi-owner too. We probably can't block multi-pinner without causing
> uAPI problems.

It seems the problem is how to track multiple pinners of the page. At
the moment memcg ownership is stored in folio->memcg_data which
basically points to the owning struct mem_cgroup *.

For pinning this series already introduces this data structure:

struct vm_account {
	struct task_struct *task;
	struct mm_struct *mm;
	struct user_struct *user;
	enum vm_account_flags flags;
};

We could modify it to something like:

struct vm_account {
       struct list_head possible_pinners;
       struct mem_cgroup *memcg;
       [...]
};

When a page is pinned the first pinner takes ownership and stores it's
memcg there, updating memcg_data to point to it. This would require a
new page_memcg_data_flags but I think we have one left. Subsequent
pinners create a vm_account and add it to the pinners list.

When a driver unpins a page we scan the pinners list and assign
ownership to the next driver pinning the page by updating memcg_data and
removing the vm_account from the list.

The problem with this approach is each pinner (ie. struct vm_account)
may cover different subsets of pages. Drivers have to store a list of
pinned pages somewhere, so we could query drivers or store the list of
pinned pages in the vm_account. That seems like a fair bit of overhead
though and would make unpinning expensive as we'd have to traverse
several lists.

We'd also have to ensure possible owners had enough free memory in the
owning memcg to accept having the page charged when another pinner
unpins. That could be done by reserving space during pinning.

And of course it only works for pin_user_pages() - other users don't
always have a list of pages conveniently available although I suppose
they could walk the rmap, but again that adds overhead. So not sure it's
a great solution but figured I'd leave it here in case it triggers other
ideas.

> You are not wrong on any of these remarks, but this looses sight of
> the point - it is take the existing broken RLIMIT scheme and make it
> incrementally better by being the same broken scheme just with
> cgroups.

Right. RLIMIT_MEMLOCK is pretty broken because most uses enforce it
against a specific task so it can be easily bypassed. The aim here was
to make it at least possible to enforce a meaningful limit.

> If we eventually fix everything so memcg can do multi-pinners/owners
> then would it be reasonable to phase out the new pincg at that time?
>
> Jason

