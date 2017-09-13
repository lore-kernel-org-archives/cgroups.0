From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 2/4] mm, oom: cgroup-aware OOM killer
Date: Wed, 13 Sep 2017 13:46:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709131346200.146292@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <20170911131742.16482-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=krSGNniU52uR4qbpf1FzZsR4k44wAKvGJKAOMyFUHDs=;
        b=oiCwFhblthcmD3ceFwvwuPklF0gLyMaMNEEsFi+JrnHTNhMczDCSuCx5G+EkVBO8yS
         fw5dDIJDuM03pVvFOpoJYUiOaIrfbvfV5kbZYKDyR9y/IviKgeqf5TVyiaRChNwLdSV+
         geX0bIjK3Yw3NRWp3/adGhsaQ0vltuUjYgI/Ie+B50bvEJyWFXVMwivmQ7YMAbeydAaj
         1qbOn65PFYQ9bP/HYNAL/18cSB/T/Z+fMw6UU3c2Jlkx2PZHntS8Y2px94LvIgaHtfMR
         LyvyTcFZ6FXHx/PE5UQ+tnS4FInOEqqcfgxC8L4ZksGo65lhpI9+INf3RZSNLqwDZkzm
         SMQQ==
In-Reply-To: <20170911131742.16482-3-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 11 Sep 2017, Roman Gushchin wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 15af3da5af02..da2b12ea4667 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2661,6 +2661,231 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
>  	return ret;
>  }
>  
> +static long memcg_oom_badness(struct mem_cgroup *memcg,
> +			      const nodemask_t *nodemask,
> +			      unsigned long totalpages)
> +{
> +	long points = 0;
> +	int nid;
> +	pg_data_t *pgdat;
> +
> +	/*
> +	 * We don't have necessary stats for the root memcg,
> +	 * so we define it's oom_score as the maximum oom_score
> +	 * of the belonging tasks.
> +	 */
> +	if (memcg == root_mem_cgroup) {
> +		struct css_task_iter it;
> +		struct task_struct *task;
> +		long score, max_score = 0;
> +
> +		css_task_iter_start(&memcg->css, 0, &it);
> +		while ((task = css_task_iter_next(&it))) {
> +			score = oom_badness(task, memcg, nodemask,
> +					    totalpages);
> +			if (max_score > score)

score > max_score

> +				max_score = score;
> +		}
> +		css_task_iter_end(&it);
> +
> +		return max_score;
> +	}
> +
> +	for_each_node_state(nid, N_MEMORY) {
> +		if (nodemask && !node_isset(nid, *nodemask))
> +			continue;
> +
> +		points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> +				LRU_ALL_ANON | BIT(LRU_UNEVICTABLE));
> +
> +		pgdat = NODE_DATA(nid);
> +		points += lruvec_page_state(mem_cgroup_lruvec(pgdat, memcg),
> +					    NR_SLAB_UNRECLAIMABLE);
> +	}
> +
> +	points += memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) /
> +		(PAGE_SIZE / 1024);
> +	points += memcg_page_state(memcg, MEMCG_SOCK);
> +	points += memcg_page_state(memcg, MEMCG_SWAP);
> +
> +	return points;
> +}
