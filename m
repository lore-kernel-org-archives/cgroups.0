From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm/memcontrol: use kstrtobool for swapaccount param
 parsing
Date: Mon, 19 Sep 2022 17:01:16 +0200
Message-ID: <YyiEPPecoqsinebe@dhcp22.suse.cz>
References: <20220909145308.f2f61d6992f00ef6977f833b@linux-foundation.org>
 <20220913071358.1812206-1-liushixin2@huawei.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663599677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iDQ4TbeBXa/svhW7EfZleIQJqRglXyx7TDIqISE6yyM=;
        b=QruWER5KDSb+2K6n6HFs/WUurfTkzp5sMxSVkMVrm3lehOt+UtyXCfIE5QlGQ6AB/pQl2H
        bWA7U17LROAZJt8gYCc6PbCQMojyqbCPedL6IdL4/SbV8YQ9RG2aDhG9+P00umlWIFwU4j
        oOEFwRn36kywPKURtqAA8cYTgrgtKb4=
Content-Disposition: inline
In-Reply-To: <20220913071358.1812206-1-liushixin2@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liu Shixin <liushixin2@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>

On Tue 13-09-22 15:13:58, Liu Shixin wrote:
> Use kstrtobool which is more powerful to handle all kinds of parameters
> like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".

the main usefulness is with the code reusability of library functions
rather than ad-hoc stuff.

> Signed-off-by: Liu Shixin <liushixin2@huawei.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0a1a8a846870..5511c0c120d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7434,10 +7434,10 @@ bool mem_cgroup_swap_full(struct folio *folio)
>  
>  static int __init setup_swap_account(char *s)
>  {
> -	if (!strcmp(s, "1"))
> -		cgroup_memory_noswap = false;
> -	else if (!strcmp(s, "0"))
> -		cgroup_memory_noswap = true;
> +	bool res;
> +
> +	if (!kstrtobool(s, &res))
> +		cgroup_memory_noswap = !res;
>  	return 1;
>  }
>  __setup("swapaccount=", setup_swap_account);
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
