From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Mon, 3 Oct 2022 16:27:00 +0200
Message-ID: <YzrxNGpf7sSwSWy2@dhcp22.suse.cz>
References: <1664546131660.1777662787.1655319815@gmail.com>
 <Yzc0yZwDB8GG+4t7@P9FQF9L96D.corp.robot.car>
 <b91e75f4-b09c-85aa-c6ad-2364dab9af92@gmail.com>
 <Yzm5cukBe6IfyAs7@P9FQF9L96D.lan>
 <d3cf9c69-19a1-53f9-cf97-5d40ce5cda44@gmail.com>
 <YzrkaKZKYqx+c325@dhcp22.suse.cz>
 <821923d8-17c3-f1c2-4d6a-5653c88db3e8@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664807221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aLlkpgbxGZRMNBxuPIGalwtLBIi7tqsIbhglT3gkCtE=;
        b=ZaYAqscq9DPqSdfPYl7g0L7ZKm7z8h31kFJ9l89bcayffbVyeEqX/uXywgl2u7P8wyGleU
        mYDUrIrM26hJ63fFc0/NF9Cbj2lk1J4MtvjxAvdtWDg/GwD1BadGV4D6xpGzlFyy5RM6qS
        hn/LjFfv5NyNd0Tvc2nBDbpT+D7krOw=
Content-Disposition: inline
In-Reply-To: <821923d8-17c3-f1c2-4d6a-5653c88db3e8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 03-10-22 17:09:15, Alexander Fedorov wrote:
> On 03.10.2022 16:32, Michal Hocko wrote:
> > On Mon 03-10-22 15:47:10, Alexander Fedorov wrote:
> >> @@ -3197,17 +3197,30 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
> >>  		stock->nr_bytes = 0;
> >>  	}
> >>  
> >> -	obj_cgroup_put(old);
> >> +	/*
> >> +	 * Clear pointer before freeing memory so that
> >> +	 * drain_all_stock() -> obj_stock_flush_required()
> >> +	 * does not see a freed pointer.
> >> +	 */
> >>  	stock->cached_objcg = NULL;
> >> +	obj_cgroup_put(old);
> > 
> > Do we need barrier() or something else to ensure there is no reordering?
> > I am not reallyu sure what kind of barriers are implied by the pcp ref
> > counting.
> 
> obj_cgroup_put() -> kfree_rcu() -> synchronize_rcu() should take care
> of this:

This is a very subtle guarantee. Also it would only apply if this is the
last reference, right? Is there any reason to not use
	WRITE_ONCE(stock->cached_objcg, NULL);
	obj_cgroup_put(old);

IIRC this should prevent any reordering. 
-- 
Michal Hocko
SUSE Labs
