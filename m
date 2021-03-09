From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Tue, 9 Mar 2021 15:57:52 +0100
Message-ID: <YEeM8AZczZt/irhR@dhcp22.suse.cz>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615301872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ub+z7UW6G+p7byFeLSBCS3Oq9eOmRCBt+nX5wp22Mg=;
        b=AivRumHZpuQ4WOtIffTFP2IZCPHT1w3Z1VSEUQCS85Si/yS/0LEY0F3M9HsP7VdBx5rf5R
        kprrR1HPRo1G9mKSWEgrfenZA9x6IXOBttbWnCdzMIQIXXIRKI8k9tMN9NhfGEY86DlWWi
        B0xXDtrH4r5dIHEslCslFYtKv69a8us=
Content-Disposition: inline
In-Reply-To: <18a0ae77-89ff-2679-ab19-378e38ce2be2-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 09-03-21 11:03:48, Vasily Averin wrote:
> in_interrupt() check in memcg_kmem_bypass() is incorrect because
> it does not allow to account memory allocation called from task context
> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections

Is there any existing user in the tree? Or is this more of a preparatory
patch for a later one which will need it? In other words, is this a bug
fix or a preparatory work.

> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 845eec0..568f2cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>  		return false;
>  
>  	/* Memcg to charge can't be determined. */
> -	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>  		return true;
>  
>  	return false;
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
