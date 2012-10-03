From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/15] cfq-iosched: Properly name all references to IO
 class
Date: Wed, 3 Oct 2012 09:54:29 +0900
Message-ID: <20121003005429.GA15806@localhost>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-2-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IF7QkfBzva7taOvdHjsPj2eoCm73H5VFQ5akExOknUA=;
        b=pHP6w2gjbs+n8DkKE04fs6V1ay1Y/dllFOdDAvDJ524MKqjix/0/IDggro1cTIczol
         a3lsYiQU++LD/btQv2ouQl/GXyxyGO8nZLu7wFEyAO5k1cfnvrTWpU8jJtKacuLjpiuN
         eqFmk6NOtneR1eIydv5aAnxI/Zwpj+fYClVSnq7bE60YOOlHIQ045z3rwprxZQ0LWVyY
         UILWmhHy5Vw/s6jNiz+wcaePEbXVdlCLAIZoG6fJzAhMDAOrk1lXdxuwSXPR3PAEheQL
         E0Oa3HB0EJE1OGkjVeUn0mJMDGpj27NO2tk3clmAWtKyKCaRkhkEKlGJgkFtZcsxmIWR
         FuYw==
Content-Disposition: inline
In-Reply-To: <1349119976-26837-2-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 01, 2012 at 03:32:42PM -0400, Vivek Goyal wrote:
> Currently CFQ has three IO classes, RT, BE and IDLE. At many a places we
> are calling workloads belonging to these classes as "prio". This gets
> very confusing as one starts to associate it with ioprio.
> 
> So this patch just does bunch of renaming so that reading code becomes
> easier. All reference to RT, BE and IDLE workload are done using keyword
> "class" and all references to subclass, SYNC, SYNC-IDLE, ASYNC are made
> using keyword "type".
> 
> This makes me feel much better while I am reading the code. There is no
> functionality change due to this patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> @@ -751,16 +751,16 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
>  	return SYNC_WORKLOAD;
>  }
>  
> -static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
> +static inline int cfq_group_busy_queues_wl(enum wl_class_t wl_class,
>  					struct cfq_data *cfqd,
>  					struct cfq_group *cfqg)
>  {
> -	if (wl == IDLE_WORKLOAD)
> +	if (wl_class == IDLE_WORKLOAD)
>  		return cfqg->service_tree_idle.count;
>  
> -	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
> -		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
> -		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
> +	return cfqg->service_trees[wl_class][ASYNC_WORKLOAD].count
> +		+ cfqg->service_trees[wl_class][SYNC_NOIDLE_WORKLOAD].count
> +		+ cfqg->service_trees[wl_class][SYNC_WORKLOAD].count;

While at it, maybe move the operator to the end of the preceding line
like everybody else?

Thanks.

-- 
tejun
