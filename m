From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: correct the comment of
 mem_cgroup_unmark_under_oom()
Date: Wed, 16 Sep 2020 16:53:36 +0200
Message-ID: <20200916145336.GI18998@dhcp22.suse.cz>
References: <20200916131927.11340-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600268017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XWkcsvUYLuBv2uzcZZ0bcAz6BNNnURdggjQevDJBQMk=;
        b=B4ZfZkQTyh6ucc0CDOCoHrBoEoqEKXhzrWyFLZovTbslQ3qlxl9dwKILWewGtRRgbZ7jGN
        oCspOgcD2NxVF2Uoem6CrWV3rZeIQ/jL0GIJHPid+1dBMZDai76UsFfEyMFdmZh6hP3hek
        u5SxSi1yYLMTJa8Ok4sHOjNvjrDALiyEom14min4kLbKOpiXjiz0q6wWZP3Sl7L2LAQOJK
        TooeaSbvdjdOiHfDIHSO4Y9pzziFgRwbKx3Oce7RH+V+V18TxBd5v16Yhn6CMBrJZFZBM/
        wW8YMf2r4GqiIzDVqE7f+EN/iorB0kzWQEY67MdhIffOxYm1PWAsFZvjS8rLYg==
Content-Disposition: inline
In-Reply-To: <20200916131927.11340-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 16-09-20 09:19:27, Miaohe Lin wrote:
> Since commit fb2a6fc56be6 ("mm: memcg: rework and document OOM waiting and
> wakeup"), we have renamed mem_cgroup_oom_lock to mem_cgroup_oom_trylock. So
> replace mem_cgroup_oom_lock with mem_cgroup_oom_trylock in comment.

While you are right I find the comment more confusing then helpful.
What does it try to tell us actually? Is it still valid? Shouldn't we
rather remove it or make it more clear?
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3d26b4b954e2..702aa4d7ebbc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1846,7 +1846,7 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
>  
>  	/*
>  	 * When a new child is created while the hierarchy is under oom,
> -	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
> +	 * mem_cgroup_oom_trylock() may not be called. Watch for underflow.
>  	 */
>  	spin_lock(&memcg_oom_lock);
>  	for_each_mem_cgroup_tree(iter, memcg)
> -- 
> 2.19.1

-- 
Michal Hocko
SUSE Labs
