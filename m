From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Wed, 7 Jul 2021 16:41:05 -0400
Message-ID: <YOYRYXATm2gHoGGq@cmpxchg.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-14-willy@infradead.org>
 <YOXfozcU8M/x2RQ4@cmpxchg.org>
 <YOYAZ5+xDFK0Slc8@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R4P0KNfgWIHNUMQeKArxNiZXWY4TL6SD38burZdGtmU=;
        b=jxcBI4tRdXz8lueNWijVft6b8D9Bs/Ztrx6y/abhbFp/1koc4S09E5BLEuvjihUSlV
         44gQzlL6BNXxn1NhWf9bM3ZwXXByfzIj6qfBavenyQQO3BW04/c/oW9WpaXTwr72wHDe
         XExZc+OZQbvQ3SXVOqOqpyz+Og2mAaCFUCZxpVI6siymiro/itdnoB54RINqCWRif1rO
         xVd0QlGQZIh7EwKTD2c0uw86WIX7r06KfxDLxql/OR1hpgtjsYfAtRpBiaNtAVSBC2EI
         8wJ+ynVom4czdgqpPyT7yKvBv97YH5anfQkzZ6mhgQ7k5d0MZL66cw3TcC9AvwtB7JFZ
         f0Mg==
Content-Disposition: inline
In-Reply-To: <YOYAZ5+xDFK0Slc8-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jul 07, 2021 at 08:28:39PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 07, 2021 at 01:08:51PM -0400, Johannes Weiner wrote:
> > On Wed, Jun 30, 2021 at 05:00:29AM +0100, Matthew Wilcox (Oracle) wrote:
> > > -static void __unlock_page_memcg(struct mem_cgroup *memcg)
> > > +static void __memcg_unlock(struct mem_cgroup *memcg)
> > 
> > This is too generic a name. There are several locks in the memcg, and
> > this one only locks the page->memcg bindings in the group.
> 
> Fair.  __memcg_move_unlock looks like the right name to me?

Could you please elaborate what the problem with the current name is?

mem_cgroup_move_account() does this:

	lock_page_memcg(page);
	page->memcg = to;
	__unlock_page_memcg(from);

It locks and unlocks the page->memcg binding which can be done coming
from the page or the memcg. The current names are symmetrical to
reflect that it's the same lock.

We could switch them both to move_lock, but as per the other email,
lock_page_memcg() was chosen to resemble lock_page(). Because from a
memcg POV they're interchangeable - the former is just a more narrowly
scoped version for contexts that don't hold the page lock. It used to
be called something else and we had several contexts taking redundant
locks on accident because this hierarchy wasn't clear.

I don't mind fixing poorly chosen or misleading naming schemes, but I
think we need better explanations to overcome the reasoning behind the
existing names, not just the assumption that there weren't any.
