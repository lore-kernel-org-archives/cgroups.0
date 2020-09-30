From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcontrol: reword obsolete comment of
 mem_cgroup_unmark_under_oom()
Date: Wed, 30 Sep 2020 12:48:19 +0200
Message-ID: <20200930104819.GS2277@dhcp22.suse.cz>
References: <20200930095336.21323-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601462900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7IFfx3OZnBqgehUu2cMHgsqKwAUzAFD3b+C2ju1XQ1M=;
        b=kSGXheRNDCMV2H2V8U5XRM1cHAIxtJscvMNLblFLwwRrfidDvPGlPhMlrG3r6uyWFZ9oXY
        YanXrUHiJfGiwjrjUrUcNNMenjR/RUHxXRfHFR1/6VlLiweKCqlQY9y3xFchtwGGU8Aw9I
        3+hP1Y9IMTAAk2cLWQSeH7GPviQsPlM=
Content-Disposition: inline
In-Reply-To: <20200930095336.21323-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 30-09-20 05:53:36, Miaohe Lin wrote:
> Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
> counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
> the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
> here because mem_cgroup_oom_lock() does not operate on under_oom field. So
> we reword the comment as this would be helpful.
> [Thanks Michal Hocko for rewording this comment.]
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6877c765b8d0..4f0c14cb8690 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1817,8 +1817,8 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
>  	struct mem_cgroup *iter;
>  
>  	/*
> -	 * When a new child is created while the hierarchy is under oom,
> -	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
> +	 * Be careful about under_oom underflows becase a child memcg
> +	 * could have been added after mem_cgroup_mark_under_oom.
>  	 */
>  	spin_lock(&memcg_oom_lock);
>  	for_each_mem_cgroup_tree(iter, memcg)
> -- 
> 2.19.1

-- 
Michal Hocko
SUSE Labs
