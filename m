From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 03/11] mm: memcontrol: make lruvec lock safe when LRU
 pages are reparented
Date: Wed, 25 May 2022 17:53:30 +0800
Message-ID: <Yo38mlkMBFz2h+yP@FVFYT0MHHV2J.googleapis.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-4-songmuchun@bytedance.com>
 <Yo0xmKOkBkhRy+bq@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9rlBY3PNi6qAmOpJr9mzzdY/bjGa01SJNfhk40so+9E=;
        b=wB/9UutLwYmlC+hqMcMe5v7VpbPZIPOASKIhNz9TI/rIZ1iZqhiPzsV3k6XUuyFwVl
         wW4IxGffPtaW4/prC4C2aAqCJtfPlalwcq8Wv6vEefOE0/fBUVRKpEkfooGCniuHL7Pz
         dSwf18AUMYPjciMSpPEeI6qjH0O1BNyMXPddZuPwMzFuNxhX1pEXGhJK3jLVr/FSBi9f
         BXe5+QYLLLBMeSOAY9p5fmkKulrpayS+1qpMnGy2lQUMgQMQLCzwa/34Ucu8uhyBHr6m
         92ICCkyEyw4C1v419exrTlpxo7R6iBrLAV6Jxrg9bEPC+S/khe/tSeTeAkXmrlrsIqqM
         lUYA==
Content-Disposition: inline
In-Reply-To: <Yo0xmKOkBkhRy+bq-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 03:27:20PM -0400, Johannes Weiner wrote:
> On Tue, May 24, 2022 at 02:05:43PM +0800, Muchun Song wrote:
> > The diagram below shows how to make the folio lruvec lock safe when LRU
> > pages are reparented.
> > 
> > folio_lruvec_lock(folio)
> >     retry:
> > 	lruvec = folio_lruvec(folio);
> > 
> >         // The folio is reparented at this time.
> >         spin_lock(&lruvec->lru_lock);
> > 
> >         if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio)))
> >             // Acquired the wrong lruvec lock and need to retry.
> >             // Because this folio is on the parent memcg lruvec list.
> >             goto retry;
> > 
> >         // If we reach here, it means that folio_memcg(folio) is stable.
> > 
> > memcg_reparent_objcgs(memcg)
> >     // lruvec belongs to memcg and lruvec_parent belongs to parent memcg.
> >     spin_lock(&lruvec->lru_lock);
> >     spin_lock(&lruvec_parent->lru_lock);
> > 
> >     // Move all the pages from the lruvec list to the parent lruvec list.
> > 
> >     spin_unlock(&lruvec_parent->lru_lock);
> >     spin_unlock(&lruvec->lru_lock);
> > 
> > After we acquire the lruvec lock, we need to check whether the folio is
> > reparented. If so, we need to reacquire the new lruvec lock. On the
> > routine of the LRU pages reparenting, we will also acquire the lruvec
> > lock (will be implemented in the later patch). So folio_memcg() cannot
> > be changed when we hold the lruvec lock.
> > 
> > Since lruvec_memcg(lruvec) is always equal to folio_memcg(folio) after
> > we hold the lruvec lock, lruvec_memcg_debug() check is pointless. So
> > remove it.
> > 
> > This is a preparation for reparenting the LRU pages.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> This looks good to me. Just one question:
> 
> > @@ -1230,10 +1213,23 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
> >   */
> >  struct lruvec *folio_lruvec_lock(struct folio *folio)
> >  {
> > -	struct lruvec *lruvec = folio_lruvec(folio);
> > +	struct lruvec *lruvec;
> >  
> > +	rcu_read_lock();
> > +retry:
> > +	lruvec = folio_lruvec(folio);
> >  	spin_lock(&lruvec->lru_lock);
> > -	lruvec_memcg_debug(lruvec, folio);
> > +
> > +	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
> > +		spin_unlock(&lruvec->lru_lock);
> > +		goto retry;
> > +	}
> > +
> > +	/*
> > +	 * Preemption is disabled in the internal of spin_lock, which can serve
> > +	 * as RCU read-side critical sections.
> > +	 */
> > +	rcu_read_unlock();
> 
> The code looks right to me, but I don't understand the comment: why do
> we care that the rcu read-side continues? With the lru_lock held,
> reparenting is on hold and the lruvec cannot be rcu-freed anyway, no?
>

Right. We could hold rcu read lock until end of reparting.  So you mean
we do rcu_read_unlock in folio_lruvec_lock()?

Thanks.
