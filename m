From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Fri, 9 Jul 2021 20:37:27 +0100
Message-ID: <YOild62fNH5TwEpf@casper.infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-14-willy@infradead.org>
 <YOXfozcU8M/x2RQ4@cmpxchg.org>
 <YOYAZ5+xDFK0Slc8@casper.infradead.org>
 <YOYRYXATm2gHoGGq@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NSCopvszCC1CSQBihfy/wQ6YKMewMTvEX+BC7Lge88Y=; b=p1R0mSzekt6b2fbhE2L/zRNEPk
        KsD46kJcmtCk5eFykGuqZQPpQuh7+2fcMbExrZWUNEB11is1B8Mn3qqMttBjr72E7F3UNiSilUmrS
        5CaFFXiu/c2MjTq1ye+tzTK10Y5cKPz2SEJqsAwOu3rp/xInhpj11Ej3ST1eQji1w7eHZN4mGMFDy
        Rx5tW6v9ZTOmzRpIeq0sNGE5l7JW8gOfjN1/R7WdZwGcUc1lg9QTq9R60xRY4LZjvW9Oc2AW+cinx
        SuhT7vR97NNGLaK0QSLQdGX7tWjtQUvslD7MN5ybfBxudP8YKgOPRHDYSL4YyvnMS2qEyHB+zqH/o
        e9SDkdiw==;
Content-Disposition: inline
In-Reply-To: <YOYRYXATm2gHoGGq-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jul 07, 2021 at 04:41:05PM -0400, Johannes Weiner wrote:
> On Wed, Jul 07, 2021 at 08:28:39PM +0100, Matthew Wilcox wrote:
> > On Wed, Jul 07, 2021 at 01:08:51PM -0400, Johannes Weiner wrote:
> > > On Wed, Jun 30, 2021 at 05:00:29AM +0100, Matthew Wilcox (Oracle) wrote:
> > > > -static void __unlock_page_memcg(struct mem_cgroup *memcg)
> > > > +static void __memcg_unlock(struct mem_cgroup *memcg)
> > > 
> > > This is too generic a name. There are several locks in the memcg, and
> > > this one only locks the page->memcg bindings in the group.
> > 
> > Fair.  __memcg_move_unlock looks like the right name to me?
> 
> Could you please elaborate what the problem with the current name is?
> 
> mem_cgroup_move_account() does this:
> 
> 	lock_page_memcg(page);
> 	page->memcg = to;
> 	__unlock_page_memcg(from);
> 
> It locks and unlocks the page->memcg binding which can be done coming
> from the page or the memcg. The current names are symmetrical to
> reflect that it's the same lock.

OK, so in the prerequisite series to this patch, lock_page() becomes
folio_lock().  This series turns lock_page_memcg() into
folio_memcg_lock().  As a minimum, then, this needs to turn into
__folio_memcg_unlock().

> We could switch them both to move_lock, but as per the other email,
> lock_page_memcg() was chosen to resemble lock_page(). Because from a
> memcg POV they're interchangeable - the former is just a more narrowly
> scoped version for contexts that don't hold the page lock. It used to
> be called something else and we had several contexts taking redundant
> locks on accident because this hierarchy wasn't clear.

Unfortunately, it's still not clear.  I've answered questions from
people who think that they have the page locked because they called
lock_page_memcg() ;-(
