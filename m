From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcg: Do not count memory.low reclaim if it
 does not happen
Date: Wed, 23 Mar 2022 14:44:24 -0700
Message-ID: <YjuUuLW+8iRtYOmP@carbon.dhcp.thefacebook.com>
References: <20220322182248.29121-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648071872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XY5kMoTXHmqmiVy2HYgdwsUIAUgV0f+WD3Zq9NZ1rig=;
        b=tIkhyUwCj21h679R74DUEqJYdwnu60YleSAUF//3fNmiqt+PYVpSZRINK+Jhl6RkUQIqws
        q7cnt3gzzC1vcMomxCfEn/iGbAeykyC28Ki3sc7uHV5FoNBJJar3asnQl+BeYWwl12EbDB
        hjQEpEuUhpu0HrV0NM+eJwzG3K2B00c=
Content-Disposition: inline
In-Reply-To: <20220322182248.29121-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Tue, Mar 22, 2022 at 07:22:48PM +0100, Michal Koutny wrote:
> This was observed with memcontrol selftest/new LTP test but can be also
> reproduced in simplified setup of two siblings:
> 
> 	`parent .low=50M
> 	  ` s1	.low=50M  .current=50M+ε
> 	  ` s2  .low=0M   .current=50M
> 
> The expectation is that s2/memory.events:low will be zero under outer
> reclaimer since no protection should be given to cgroup s2 (even with
> memory_recursiveprot).
> 
> However, this does not happen. The apparent reason is that when s1 is
> considered for (proportional) reclaim the scanned proportion is rounded
> up to SWAP_CLUSTER_MAX and slightly over-proportional amount is
> reclaimed. Consequently, when the effective low value of s2 is
> calculated, it observes unclaimed parent's protection from s1
> (ε-SWAP_CLUSTER_MAX in theory) and effectively appropriates it.
> The effect is slightly regularized protection (workload dependent)
> between siblings and misreported MEMCG_LOW event when reclaiming s2 with
> this protection.
> 
> Fix the behavior by not reporting breached memory.low in such
> situations. (This affects also setups where all siblings have
> memory.low=0, parent's memory.events:low will still be non-zero when
> parent's memory.low is breached but it will be reduced by the events
> originated in children.)
> 
> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
> Reported-by: Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>
> Link: https://lore.kernel.org/all/20220321101429.3703-1-rpalethorpe-IBi9RG/b67k@public.gmane.org/
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>

Hi Michal!

Does it mean that in the following configuration:
	`parent .low=50M
	  ` s1	.low=0M   .current=50M
	  ` s2  .low=0M   .current=50M
there will be no memory.events::low at all? (assuming the recursive thing is on)

Thanks!
