From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: non-hierarchical mode is deprecated
Date: Tue, 5 Apr 2022 08:26:59 +0200
Message-ID: <YkvhMx2EVVisfjRG@dhcp22.suse.cz>
References: <20220403020833.26164-1-richard.weiyang@gmail.com>
 <Ykq6Gbt5MX9GCiKM@dhcp22.suse.cz>
 <20220405022218.53idmvm2ha2tzmy2@master>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649140020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yh3Ex3Th+gF9Cqk/K++VhrpMY2seww3cQSgR3bJT/Hg=;
        b=Oi2QIer3acnB2qh/3gKgxeQvPSaRTPBE8h7WnJQCGkxdTcMy+Db8yjuRi5DAxorBEcAfCL
        hKdfWigOSnr9C7qSjjWpf9thxyS/fKtFkzS/LcxhoxwawIFl/VD3vOsV/1tqEkFfvUSjBQ
        BQNyPpSpioYZBU9cYrbtoMLG1w+zYrE=
Content-Disposition: inline
In-Reply-To: <20220405022218.53idmvm2ha2tzmy2@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue 05-04-22 02:22:18, Wei Yang wrote:
> On Mon, Apr 04, 2022 at 11:27:53AM +0200, Michal Hocko wrote:
> >On Sun 03-04-22 02:08:33, Wei Yang wrote:
> >> After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
> >> mode"), we won't have a NULL parent except root_mem_cgroup. And this
> >> case is handled when (memcg == root).
> >> 
> >> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> CC: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> >> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >
> >Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> >Thanks!
> >
> 
> Thanks for the ack. When reading the code, I found one redundant check in
> shrink_node_memcgs().
> 
>   shrink_node_memcgs
>     mem_cgroup_below_min
>       mem_cgroup_supports_protection
>     mem_cgroup_below_low
>       mem_cgroup_supports_protection
> 
> I am not sure it worthwhile to take it out.
> 
>   shrink_node_memcgs
>     mem_cgroup_supports_protection
>       mem_cgroup_below_min
>       mem_cgroup_below_low
> 
> Look forward your opinion.

I guess you refer to mem_cgroup_is_root check in mem_cgroup_supports_protection,
right?

You are right that the check is not really required because e{min,low}
should always stay at 0 for the root memcg AFAICS. On the other hand the
check is not in any hot path and it really adds clarity here because
protection is not really supported on the root memcg. So I am not this
is an overall win.
-- 
Michal Hocko
SUSE Labs
