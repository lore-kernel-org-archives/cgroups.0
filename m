From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: use kstrtobool for swapaccount param
 parsing
Date: Fri, 9 Sep 2022 14:53:08 -0700
Message-ID: <20220909145308.f2f61d6992f00ef6977f833b@linux-foundation.org>
References: <20220909084647.3598299-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760389;
        bh=0JcE0DLdNzQm3AF+ZqlE39XNCX4d5bRLfNDfq0UT/g4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MBWJF+Ae7WdYf68cBxuz+A7rZmgFkpzsf5z3e0zEWKuLYcSLhPtI2YV1SGKHOY3oC
         Luy2cPNFoakNi7qC+zQaeo5I81q7yZDg3ogVrDFGH9CAIvXo278uOnjET+AEwkAjdl
         j/pOtTVmax8W40oStXD8ZsmUhesodTnlrMEBtlAM=
In-Reply-To: <20220909084647.3598299-1-liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Fri, 9 Sep 2022 16:46:47 +0800 Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

> Use kstrtobool which is more powerful to handle all kinds of parameters
> like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".
> 
> ...
>
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6037,10 +6037,11 @@
>  			Execution Facility on pSeries.
>  
>  	swapaccount=	[KNL]
> -			Format: [0|1]
> +			Format: { [oO][Nn]/Y/y/1 | [oO][Ff]/N/n/0 }
>  			Enable accounting of swap in memory resource
> -			controller if no parameter or 1 is given or disable
> -			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
> +			controller if no parameter or [oO][Nn]/Y/y/1 is given
> +			or disable it if [oO][Ff]/N/n/0 is given
> +			(See Documentation/admin-guide/cgroup-v1/memory.rst)
>  
>  	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
>  			Format: { <int> [,<int>] | force | noforce }

mhocko suggested dropping this change as well.

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

And I agree.  See, the risk with this patch is that someone will
develop userspace code which relies upon the new behaviour.  Then when
someone tries to use that code on an older kernel, whoops, it doesn't
work.  In other words, we're encouraging development of
non-backward-compatible userspace code.

Leaving the documentation as it was (just "0|1") will help to prevent
that situation.
