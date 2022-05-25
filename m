From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 02/11] mm: memcontrol: introduce
 compact_folio_lruvec_lock_irqsave
Date: Wed, 25 May 2022 17:38:41 +0800
Message-ID: <Yo35ITjnDUrvLpfC@FVFYT0MHHV2J.googleapis.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-3-songmuchun@bytedance.com>
 <Yo0wj9OAPptmUoWM@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sl7ih2YcYfsKEJm1KeaU131K5lwzTZba3+OLLF53Vww=;
        b=Rn2pap2S0KViSmWOIIHDkjxdgyfSovtzuKxNe2Ls2oS3VWSeEsTOBJ7CaNAkB8SxJo
         gCC717pKh8MadpjyqV8DcX8KykwT4iGOgd66to1uZTIxylcRuPrzke0u5sn2RHbXhCM0
         yy/02qaaTXJyJlqE/KyvV9jXXe7H6GdcX9qcNV9ovWcGxqfw5acK3KAh3EAPjtm9fxZv
         4WtI49bHN3Y/EV44y9ND2e4WUKF1EQxQX381CosCpZiOhaw6JWbF++Cxnv3sQRKq7Stq
         KlHpR4b8Ab1tvHM2RpmS3ctwg2v9j3oYfsnU8Bu+djUNashMDbSsk/LuKGGz7vylEvab
         LwMA==
Content-Disposition: inline
In-Reply-To: <Yo0wj9OAPptmUoWM-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 03:22:55PM -0400, Johannes Weiner wrote:
> On Tue, May 24, 2022 at 02:05:42PM +0800, Muchun Song wrote:
> > If we reuse the objcg APIs to charge LRU pages, the folio_memcg()
> > can be changed when the LRU pages reparented. In this case, we need
> > to acquire the new lruvec lock.
> > 
> >     lruvec = folio_lruvec(folio);
> > 
> >     // The page is reparented.
> > 
> >     compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
> > 
> >     // Acquired the wrong lruvec lock and need to retry.
> > 
> > But compact_lock_irqsave() only take lruvec lock as the parameter,
> > we cannot aware this change. If it can take the page as parameter
> > to acquire the lruvec lock. When the page memcg is changed, we can
> > use the folio_memcg() detect whether we need to reacquire the new
> > lruvec lock. So compact_lock_irqsave() is not suitable for us.
> > Similar to folio_lruvec_lock_irqsave(), introduce
> > compact_folio_lruvec_lock_irqsave() to acquire the lruvec lock in
> > the compaction routine.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> This looks generally good to me.
> 
> It did raise the question how deferencing lruvec is safe before the
> lock is acquired when reparenting can race. The answer is in the next
> patch when you add the rcu_read_lock(). Since the patches aren't big,
> it would probably be better to merge them.
>

Will do in v5.
 
> > @@ -509,6 +509,29 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> >  	return true;
> >  }
> >  
> > +static struct lruvec *
> > +compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long *flags,
> > +				  struct compact_control *cc)
> > +{
> > +	struct lruvec *lruvec;
> > +
> > +	lruvec = folio_lruvec(folio);
> > +
> > +	/* Track if the lock is contended in async mode */
> > +	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
> > +		if (spin_trylock_irqsave(&lruvec->lru_lock, *flags))
> > +			goto out;
> > +
> > +		cc->contended = true;
> > +	}
> > +
> > +	spin_lock_irqsave(&lruvec->lru_lock, *flags);
> 
> Can you implement this on top of the existing one?
> 
> 	lruvec = folio_lruvec(folio);
> 	compact_lock_irqsave(&lruvec->lru_lock, flags);
> 	lruvec_memcg_debug(lruvec, folio);
> 	return lruvec;
> 

I'll do a try. Thanks for your suggestions.
