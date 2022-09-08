From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: use kstrtobool for swapaccount param
 parsing
Date: Thu, 8 Sep 2022 15:02:48 -0700
Message-ID: <20220908150248.85fff32bf275844f0927a856@linux-foundation.org>
References: <20220908083452.2844125-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662674569;
        bh=8sy1ATs3JDer4J6KBpLpL/36vh5+x6IuTH2whh/yMVE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x1eZtPss8z2xDuQ68b7Q5wAXvxzGWI3qEDMWP24UxzJLRN0Ko2W1T66YWttxzQSug
         fl4/D5KUwLVvlUF4thcLin9nf2YLrJqrxEww2eV1LvdGqPuFVeNXBhmHAFqIVnbKnm
         uoyYf/5C6LmYn6auMZsETC++A5gpXT7EgxuY4U8w=
In-Reply-To: <20220908083452.2844125-1-liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, 8 Sep 2022 16:34:52 +0800 Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -194,7 +194,7 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
>  	return 0;
>  nomem:
>  	pr_info("couldn't allocate enough memory for swap_cgroup\n");
> -	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
> +	pr_info("swap_cgroup can be disabled by swapaccount=[oO][Ff]/N/n/0 boot option\n");

I'm not sure this really needed changing.  "=0" was OK and the message
now looks rather silly.  But whatever.
