From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 03/11] mm: memcontrol: make lruvec lock safe when LRU
 pages are reparented
Date: Wed, 25 May 2022 10:48:54 -0400
Message-ID: <Yo5B1tLcYPUoaACS@cmpxchg.org>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-4-songmuchun@bytedance.com>
 <Yo0xmKOkBkhRy+bq@cmpxchg.org>
 <Yo38mlkMBFz2h+yP@FVFYT0MHHV2J.googleapis.com>
 <Yo4hVw7B+bUlMzLX@cmpxchg.org>
 <Yo4pPw+IHPBZvZUv@FVFYT0MHHV2J.googleapis.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EC3qSzV90yIEpJPSb9gAka294lEXNvP+jK/k6V2VkwY=;
        b=sP6nIiJRj1gRoaVX7vHfBXwVVy5eYYU++U485svk6SpXKrAg619n1A96DqCaV5FkTy
         w5w3iKKMFkLE4auXFj/aXfZJ5LPy5up3GbiHdOpKNiIE2VFqSozTMNo8Z5JrGnlrPSxr
         FGBkY22R8Ok4K4xbXLOtAw+5WpvMIZnnDRImsKSd8fZ6krbHAwyGN5O/1zXBg7t2iiKd
         6QUp7DCaIcUgitzRn19UEloMeMIf222lzADnzLtWyvg1k1G6/IvzHz7fDWDjcRMCUJh4
         XmmmhpgKWvFtDkJT7EDuBJkZ21628wMOPAE7wtEyiNB5/GOfFuje3Xy9mAPkwzShrjmb
         xE+g==
Content-Disposition: inline
In-Reply-To: <Yo4pPw+IHPBZvZUv-t1y1lxtqHnkkxugUQmjJ3WroNbXEc4rFQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 25, 2022 at 09:03:59PM +0800, Muchun Song wrote:
> On Wed, May 25, 2022 at 08:30:15AM -0400, Johannes Weiner wrote:
> > On Wed, May 25, 2022 at 05:53:30PM +0800, Muchun Song wrote:
> > > On Tue, May 24, 2022 at 03:27:20PM -0400, Johannes Weiner wrote:
> > > > On Tue, May 24, 2022 at 02:05:43PM +0800, Muchun Song wrote:
> > > > > @@ -1230,10 +1213,23 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
> > > > >   */
> > > > >  struct lruvec *folio_lruvec_lock(struct folio *folio)
> > > > >  {
> > > > > -	struct lruvec *lruvec = folio_lruvec(folio);
> > > > > +	struct lruvec *lruvec;
> > > > >  
> > > > > +	rcu_read_lock();
> > > > > +retry:
> > > > > +	lruvec = folio_lruvec(folio);
> > > > >  	spin_lock(&lruvec->lru_lock);
> > > > > -	lruvec_memcg_debug(lruvec, folio);
> > > > > +
> > > > > +	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
> > > > > +		spin_unlock(&lruvec->lru_lock);
> > > > > +		goto retry;
> > > > > +	}
> > > > > +
> > > > > +	/*
> > > > > +	 * Preemption is disabled in the internal of spin_lock, which can serve
> > > > > +	 * as RCU read-side critical sections.
> > > > > +	 */
> > > > > +	rcu_read_unlock();
> > > > 
> > > > The code looks right to me, but I don't understand the comment: why do
> > > > we care that the rcu read-side continues? With the lru_lock held,
> > > > reparenting is on hold and the lruvec cannot be rcu-freed anyway, no?
> > > >
> > > 
> > > Right. We could hold rcu read lock until end of reparting.  So you mean
> > > we do rcu_read_unlock in folio_lruvec_lock()?
> > 
> > The comment seems to suggest that disabling preemption is what keeps
> > the lruvec alive. But it's the lru_lock that keeps it alive. The
> > cgroup destruction path tries to take the lru_lock long before it even
> > gets to synchronize_rcu(). Once you hold the lru_lock, having an
> > implied read-side critical section as well doesn't seem to matter.
> >
> 
> Well, I thought that spinlocks have implicit read-side critical sections
> because it disables preemption (I learned from the comments above
> synchronize_rcu() that says interrupts, preemption, or softirqs have been
> disabled also serve as RCU read-side critical sections).  So I have a
> question: is it still true in a PREEMPT_RT kernel (I am not familiar with
> this)?

Yes, but you're missing my point.

> > Should the comment be deleted?
> 
> I think we could remove the comments. If the above question is false, seems
> like we should continue holding rcu read lock.

It's true.

But assume it's false for a second. Why would you need to continue
holding it? What would it protect? The lruvec would be pinned by the
spinlock even if it DIDN'T imply an RCU lock, right?

So I don't understand the point of the comment. If the implied RCU
lock is protecting something not covered by the bare spinlock itself,
it should be added to the comment. Otherwise, the comment should go.
