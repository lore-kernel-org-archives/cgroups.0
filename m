From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcomtrol: add warning in case of rtpn = NULL
Date: Mon, 21 Aug 2023 16:30:31 +0200
Message-ID: <ZON1B73mUMbAecvO@dhcp22.suse.cz>
References: <20230821142051.31889-1-abelova@astralinux.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692628232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55pk6v33OK9OzwCS+RZYme2GhdpxeZdl+Vots/3Gr40=;
        b=NFNkWou9yCKMtM4A+fTSD3pJcYqSXNQY8TuZxWTgaoRkSpFUW609I//QIv5RPncrQuugYP
        aC2zhVzsiaZyfZal4hA0+E6VzWOEbuZQr1pfsrInz2dmgn1akTWs+mDFG8G0y4q92YtzEm
        CvVXAIlgPY5z3Vrc8u4B0kTMm7K9GRY=
Content-Disposition: inline
In-Reply-To: <20230821142051.31889-1-abelova-5XX0/9e/aDUTdZ/Q6W51Bg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anastasia Belova <abelova-5XX0/9e/aDUTdZ/Q6W51Bg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lvc-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org

On Mon 21-08-23 17:20:51, Anastasia Belova wrote:
> kzalloc_node may return NULL. So rtpn should be
> checked before dereference in mem_cgroup_init.

I do not think this is an appropriate fix. If the allocation really
fails (which is essentially impossible as this is an early boot code and
failing 24B req. this early means the system will likely die anyway)
then we will crash on NULL ptr dereference right afterwards so WARN will
not give us anything usefull on top. So either this needs a graceful way
to deal with the allocation failure or considering the previously said
just keep the code alone and teach the tooling that this should be
ignored.

> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 95a045f63d98 ("mm: memcontrol: consolidate memory controller initialization")
> Signed-off-by: Anastasia Belova <abelova-5XX0/9e/aDUTdZ/Q6W51Bg@public.gmane.org>

Nacked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8ca4bdcb03c..7998dbf3c7cd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7377,6 +7377,7 @@ static int __init mem_cgroup_init(void)
>  		struct mem_cgroup_tree_per_node *rtpn;
>  
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> +		WARN_ON(!rtpn);
>  
>  		rtpn->rb_root = RB_ROOT;
>  		rtpn->rb_rightmost = NULL;
> -- 
> 2.30.2

-- 
Michal Hocko
SUSE Labs
