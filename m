From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] swap: cond_resched in swap_cgroup_prepare()
Date: Sat, 3 Jun 2017 17:58:26 +0300
Message-ID: <20170603145826.GA15130@esperanza>
References: <20170601195635.20744-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UUsyf5QzAXgojmxUabJo1wwb4NpXBXMuYTVdQkVKoUc=;
        b=Cy9SkEKrcjhTmd4Frx/lR9bjjuRZH/vNpF10UH3XZLpY7sgc4eHeHr3eO+je7r5DwZ
         JDsntAJqeS/bIQIuKJREW5+11DplE2dQWxT5W89YnmO4CxGtBRl73W6IkPPK9+rPg0kW
         y6LpIm6YpgRiSDveyASBN2nAhbgbwYFsUQccuj9vX1vPrXaJdauU/GgeFoyKxyuxhL4w
         8DAoDEHzvxUHl7hm9N3rf0nMxtFn+syMXKv6bKfb3+8xiaCvIdqQfxeOJmwZNM0cBP5N
         OGBVtygS7UoAA5ViD1j0Y57C0r136aWEq5rIUUVYjz7RJhdX/6H3Mrva+eweqMqP1HHt
         N9bA==
Content-Disposition: inline
In-Reply-To: <20170601195635.20744-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 01, 2017 at 12:56:35PM -0700, Yu Zhao wrote:
> Saw need_resched() warnings when swapping on large swapfile (TBs)
> because page allocation in swap_cgroup_prepare() took too long.
> 
> We already cond_resched when freeing page in swap_cgroup_swapoff().
> Do the same for the page allocation.
> 
> Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> ---
>  mm/swap_cgroup.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> index ac6318a064d3..3405b4ee1757 100644
> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -48,6 +48,9 @@ static int swap_cgroup_prepare(int type)
>  		if (!page)
>  			goto not_enough_page;
>  		ctrl->map[idx] = page;
> +
> +		if (!(idx % SWAP_CLUSTER_MAX))
> +			cond_resched();
>  	}
>  	return 0;
>  not_enough_page:

We should probably do the same on the error path.
