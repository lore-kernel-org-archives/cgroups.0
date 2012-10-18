From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
Date: Thu, 18 Oct 2012 14:59:44 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210181454100.30894@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171515290.20712@chino.kir.corp.google.com> <507FCA90.8060307@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=7z1Gqu9XWeIBTcmLE+mRnGR8nNgcNHHZAY+n5B99sjU=;
        b=HV3aJgAc6/K0ieqGBCdy5blJLeHOXTC9zECGmX2ABcwKnAb1fwn9jixLFsiiaikccU
         ZzFmLsL7QQQAISTRhL3M843p0qptGGgm1ITemkRtsYyD68YB81XewBgzHNEf6m1ziqkv
         siHMdoxK6HGN2wUPJlWnjJyGJFG0V1qxKtE+yDgCRP4+0uyniZyFSVJ8l+VQOFjdr9iH
         dekjjxHT5n3+tQ6LpVd2/I6x0kK1nUg2tBkocDwDa2SpXtZ/K/0asIUUcxvhpZLD3uhN
         QW0QwKWwYvRDbGl7fXN1t3RKxEUZU/HSiYrLp/ZJCSoa/v9z4FBON9SdsAQlmE9dJtxE
         1Yjw==
In-Reply-To: <507FCA90.8060307-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Thu, 18 Oct 2012, Glauber Costa wrote:

> >> @@ -2630,6 +2634,171 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
> >>  	memcg_check_events(memcg, page);
> >>  }
> >>  
> >> +#ifdef CONFIG_MEMCG_KMEM
> >> +static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
> >> +{
> >> +	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
> >> +		(memcg->kmem_accounted & KMEM_ACCOUNTED_MASK);
> >> +}
> >> +
> >> +static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
> >> +{
> >> +	struct res_counter *fail_res;
> >> +	struct mem_cgroup *_memcg;
> >> +	int ret = 0;
> >> +	bool may_oom;
> >> +
> >> +	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/*
> >> +	 * Conditions under which we can wait for the oom_killer.
> >> +	 * We have to be able to wait, but also, if we can't retry,
> >> +	 * we obviously shouldn't go mess with oom.
> >> +	 */
> >> +	may_oom = (gfp & __GFP_WAIT) && !(gfp & __GFP_NORETRY);
> > 
> > What about gfp & __GFP_FS?
> >
> 
> Do you intend to prevent or allow OOM under that flag? I personally
> think that anything that accepts to be OOM-killed should have GFP_WAIT
> set, so that ought to be enough.
> 

The oom killer in the page allocator cannot trigger without __GFP_FS 
because direct reclaim has little chance of being very successful and 
thus we end up needlessly killing processes, and that tends to happen 
quite a bit if we dont check for it.  Seems like this would also happen 
with memcg if mem_cgroup_reclaim() has a large probability of failing?
