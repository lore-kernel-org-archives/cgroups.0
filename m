From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1] vmpressure: wake up work only when there is
 registration event
Date: Mon, 13 Sep 2021 18:03:24 +0200
Message-ID: <YT92TBIMAakm9s33@dhcp22.suse.cz>
References: <1631548441-2784-1-git-send-email-wang.yong12@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631549005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JBqyG3a4suDnnnaA3ac7IWCsPb+90G8GQiU5+rkKCIk=;
        b=Ar3weKnx1+I8P1sh4HMmXS1uBLW+4wBr79SZPuSNdxNbWyG6TrhJTYLZEnSJgq0NqujFjS
        UpTXLMx5gTJoyaZ6AmGW3tIHIVRtAHPWclKKhf/RrIpw2jV/W6gPULbm3loP8H8BG8r5ub
        sLeI775kCQa2bjboI/pOrxkYgvd/jqs=
Content-Disposition: inline
In-Reply-To: <1631548441-2784-1-git-send-email-wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

On Mon 13-09-21 08:54:01, yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> Use the global variable num_events to record the number of vmpressure
> events registered by the system, and wake up work only when there is
> registration event.
> Usually, the vmpressure event is not registered in the system, this patch
> can avoid waking up work and doing nothing.

How much of an improvement does this bring?

> Refer to Michal Hocko's suggestion:
> https://lore.kernel.org/linux-mm/YR%2FNRJEhPKRQ1r22-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/

let me also point out that we do have means to implement conditional
branches with a zero overhead. Have a look at static branches.

> Tested-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  mm/vmpressure.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index 76518e4..dfac76b 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -67,6 +67,11 @@ static const unsigned int vmpressure_level_critical = 95;
>   */
>  static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
>  
> +/*
> + * Count the number of vmpressure events registered in the system.
> + */
> +static atomic_t num_events = ATOMIC_INIT(0);
> +
>  static struct vmpressure *work_to_vmpressure(struct work_struct *work)
>  {
>  	return container_of(work, struct vmpressure, work);
> @@ -277,7 +282,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>  		vmpr->tree_reclaimed += reclaimed;
>  		spin_unlock(&vmpr->sr_lock);
>  
> -		if (scanned < vmpressure_win)
> +		if (scanned < vmpressure_win || atomic_read(&num_events) == 0)
>  			return;
>  		schedule_work(&vmpr->work);
>  	} else {

This is a very odd place to put the check on. It is past locks being
held and schedule_work on it's own is unlikely to provide a big
overhead. I would have expected to implement the check at the very
beginning of vmpressure()

-- 
Michal Hocko
SUSE Labs
