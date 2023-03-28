From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v1 7/9] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Tue, 28 Mar 2023 14:47:46 -0400
Message-ID: <ZCM2UseWAhahYVtS@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-8-yosryahmed@google.com>
 <CALvZod5_NVTrYUhLjc3Me=CC6y3R4bhA71mCt-jXo0rX+2zUxw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680029267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I8WAHPAOnoIsGbAeWRafsGc8bwd2YsHJNAiOdGspwD8=;
        b=2tUg7yrV99oGL+e/zjpM6igGege2u9YnHOxxfFKTkkGmkvvsMuO5PP2CzmH4hK514p
         OzAsp3rsWzlACLUdxakQBAEu3DoNf1m1iEqZVmxkPC4lkUAa1iTtcOp79RuXlJUkXN4G
         1Lm8am1hQ0KiyAtiXbahXpw30N5l7giyxjPWyz9NmYZx7HpzMdk3Vmqu5d4MOCcUyFVu
         RFjgUxlRIctgglXcHpHZI8WvxXkJJVPGw5ub8PRTGm7qCnNEMvs+AVviN3pW1AWwMm6/
         ma702djNMmmFeEwEYG6dbvKLFpzQm7B7QJvUgM6JKqGvshMPXh32s/FylmX7wpm3S4tS
         Y63w==
Content-Disposition: inline
In-Reply-To: <CALvZod5_NVTrYUhLjc3Me=CC6y3R4bhA71mCt-jXo0rX+2zUxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 08:18:11AM -0700, Shakeel Butt wrote:
> > @@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *shadow)
> >         unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
> >         eviction <<= bucket_order;
> >
> > +       /* Flush stats (and potentially sleep) before holding RCU read lock */
> 
> I think the only reason we use rcu lock is due to
> mem_cgroup_from_id(). Maybe we should add mem_cgroup_tryget_from_id().
> The other caller of mem_cgroup_from_id() in vmscan is already doing
> the same and could use mem_cgroup_tryget_from_id().

Good catch. Nothing else in there is protected by RCU. We can just
hold the ref instead.

> Though this can be done separately to this series (if we decide to do
> it at all).

Agreed
