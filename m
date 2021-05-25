From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix kernel-doc
Date: Tue, 25 May 2021 10:34:43 +0200
Message-ID: <YKy2o2WGRcD7vht8@dhcp22.suse.cz>
References: <1621851862-34443-1-git-send-email-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621931684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bjnsL2peeOiwWaK94JCXPWqqFm70yQEu/wWcJgX6mj8=;
        b=Y7rk0GEZ2G5BRETie8/EcGewGFpOb/F+H5mMaKQIz01KT1HN37phtRqsK5uKgMqra2IBtc
        c7RUPp8fYAzoG/lcS4F+KVbnNYp50GLWBtd6+1XHQ66//RWJ+IbkA7I8N2M78qdbMN14yg
        5onv36M08g1DIF7KwxmO4au0Xiqa2UE=
Content-Disposition: inline
In-Reply-To: <1621851862-34443-1-git-send-email-yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 24-05-21 18:24:22, Yang Li wrote:
> Fix function name in mm/memcontrol.c kernel-doc comment
> to remove a warning.
> 
> mm/memcontrol.c:6546: warning: expecting prototype for
> mem_cgroup_protected(). Prototype was for
> mem_cgroup_calculate_protection() instead.
> 
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 64ada9e..030c1dc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6456,7 +6456,7 @@ static unsigned long effective_protection(unsigned long usage,
>  }
>  
>  /**
> - * mem_cgroup_protected - check if memory consumption is in the normal range
> + * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
>   * @root: the top ancestor of the sub-tree being checked
>   * @memcg: the memory cgroup to check
>   *
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
