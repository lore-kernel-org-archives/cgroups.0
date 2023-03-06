From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2, 4/4] mm, memcg: Prevent memory.soft_limit_in_bytes
 load/store tearing
Date: Mon, 6 Mar 2023 18:55:11 +0100
Message-ID: <ZAYo/ztYBgY0Tx9I@dhcp22.suse.cz>
References: <20230306154138.3775-1-findns94@gmail.com>
 <20230306154138.3775-5-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678125312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Aqp8n+ynFi9vKD6/elu4xNwffzRLPo64QpS6Aa5j97A=;
        b=TiNZbQ/PxLX68w8zNSn4wPJDgq8upb8V6Tt94jaRKTf0BYZNGSyPXKcFFpJ6QtTbcJdKga
        7SLRqkL+wTzLjA7qEW6sJMYohde4FYtAEzSD0djEAKp1z7kPp9ySONPRSrCmJoZcnB6Baz
        +A2dH+HFDYlEDKHDbuEm7Hmx/a0Xlzg=
Content-Disposition: inline
In-Reply-To: <20230306154138.3775-5-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon 06-03-23 23:41:38, Yue Zhao wrote:
> The knob for cgroup v1 memory controller: memory.soft_limit_in_bytes
> is not protected by any locking so it can be modified while it is used.
> This is not an actual problem because races are unlikely.
> But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
> doing anything funky.
> 
> The access of memcg->soft_limit is lockless,
> so it can be concurrently set at the same time as we are
> trying to read it.

Similar here. mem_cgroup_css_reset and mem_cgroup_css_alloc are not
covered.
> 
> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 26605b2f51b1..20566f59bbcb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3728,7 +3728,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>  	case RES_FAILCNT:
>  		return counter->failcnt;
>  	case RES_SOFT_LIMIT:
> -		return (u64)memcg->soft_limit * PAGE_SIZE;
> +		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
>  	default:
>  		BUG();
>  	}
> @@ -3870,7 +3870,7 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>  		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
>  			ret = -EOPNOTSUPP;
>  		} else {
> -			memcg->soft_limit = nr_pages;
> +			WRITE_ONCE(memcg->soft_limit, nr_pages);
>  			ret = 0;
>  		}
>  		break;
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
