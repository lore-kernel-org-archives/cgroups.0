From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm/workingset: do not forget to unlock page
Date: Wed, 3 Feb 2016 13:19:39 -0800
Message-ID: <20160203131939.1a35d9bc03f13b2b143d27c0@linux-foundation.org>
References: <1454493513-19316-1-git-send-email-sergey.senozhatsky@gmail.com>
	<20160203104136.GA517@swordfish>
	<20160203162400.GB10440@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203162400.GB10440-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 3 Feb 2016 11:24:00 -0500 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> On Wed, Feb 03, 2016 at 07:41:36PM +0900, Sergey Senozhatsky wrote:
> > From 1d6315221f2f81c53c99f9980158f8ae49dbd582 Mon Sep 17 00:00:00 2001
> > From: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Date: Wed, 3 Feb 2016 18:49:16 +0900
> > Subject: [PATCH] mm/workingset: do not forget to unlock_page in workingset_activation
> > 
> > Do not return from workingset_activation() with locked rcu and page.
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Thanks Sergey. Even though I wrote this function, my brain must have
> gone "it can't be locking anything when it returns NULL, right?" It's
> a dumb interface. Luckily, that's fixed with follow-up patches in -mm.
> 
> As for this one:
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Fixes: mm: workingset: per-cgroup cache thrash detection
> 
> Andrew, can you please fold this?

Yup.  I turned it into a fix against
mm-workingset-per-cgroup-cache-thrash-detection.patch, which is where
the bug was added.  And I did the goto thing instead, so the final
result will be

void workingset_activation(struct page *page)
{
	struct lruvec *lruvec;

	lock_page_memcg(page);
	/*
	 * Filter non-memcg pages here, e.g. unmap can call
	 * mark_page_accessed() on VDSO pages.
	 *
	 * XXX: See workingset_refault() - this should return
	 * root_mem_cgroup even for !CONFIG_MEMCG.
	 */
	if (!mem_cgroup_disabled() && !page_memcg(page))
		goto out;
	lruvec = mem_cgroup_zone_lruvec(page_zone(page), page_memcg(page));
	atomic_long_inc(&lruvec->inactive_age);
out:
	unlock_page_memcg(page);
}

