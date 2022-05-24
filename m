From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 02/11] mm: memcontrol: introduce
 compact_folio_lruvec_lock_irqsave
Date: Tue, 24 May 2022 15:22:55 -0400
Message-ID: <Yo0wj9OAPptmUoWM@cmpxchg.org>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eBZErP5czN+01wncC3vU6ANkkXJCnBdE/nLZtn+4no4=;
        b=Ud5kMRHcsdoYSkO0HP8seo+5h8qtDRtoKNaGP9nfR8+ds9MnDJ6WSJaq2UWUXOET9K
         Jw9+WsOb+cRJuXQDbo/gnz31Cw1KnFqB2MrLxptKAlyjIzx/VnKAaOdduG0J8Zj2YSi2
         lTeihSOkv3MJjoQXRYaYHZeSI+P7ygyIcpSwgEiIkaZXpVwgexkowHJiiAed1Mi1r+U3
         esI/F7rw+Nxy0NeRFtqOkxT9Qgl9lpS3jvGj8iTUJO2HG+lTdnnUGKxDbiMovr90icXe
         kQ/se6khCaSSViH2cyEnQtPuk56rfMbiRiy6vccXBphwfOgDKMgIh62neEVNenYUBh9D
         YlEQ==
Content-Disposition: inline
In-Reply-To: <20220524060551.80037-3-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 02:05:42PM +0800, Muchun Song wrote:
> If we reuse the objcg APIs to charge LRU pages, the folio_memcg()
> can be changed when the LRU pages reparented. In this case, we need
> to acquire the new lruvec lock.
> 
>     lruvec = folio_lruvec(folio);
> 
>     // The page is reparented.
> 
>     compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
> 
>     // Acquired the wrong lruvec lock and need to retry.
> 
> But compact_lock_irqsave() only take lruvec lock as the parameter,
> we cannot aware this change. If it can take the page as parameter
> to acquire the lruvec lock. When the page memcg is changed, we can
> use the folio_memcg() detect whether we need to reacquire the new
> lruvec lock. So compact_lock_irqsave() is not suitable for us.
> Similar to folio_lruvec_lock_irqsave(), introduce
> compact_folio_lruvec_lock_irqsave() to acquire the lruvec lock in
> the compaction routine.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

This looks generally good to me.

It did raise the question how deferencing lruvec is safe before the
lock is acquired when reparenting can race. The answer is in the next
patch when you add the rcu_read_lock(). Since the patches aren't big,
it would probably be better to merge them.

> @@ -509,6 +509,29 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
>  	return true;
>  }
>  
> +static struct lruvec *
> +compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long *flags,
> +				  struct compact_control *cc)
> +{
> +	struct lruvec *lruvec;
> +
> +	lruvec = folio_lruvec(folio);
> +
> +	/* Track if the lock is contended in async mode */
> +	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
> +		if (spin_trylock_irqsave(&lruvec->lru_lock, *flags))
> +			goto out;
> +
> +		cc->contended = true;
> +	}
> +
> +	spin_lock_irqsave(&lruvec->lru_lock, *flags);

Can you implement this on top of the existing one?

	lruvec = folio_lruvec(folio);
	compact_lock_irqsave(&lruvec->lru_lock, flags);
	lruvec_memcg_debug(lruvec, folio);
	return lruvec;
