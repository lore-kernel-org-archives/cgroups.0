From: David Rientjes <rientjes@google.com>
Subject: Re: [v10 2/6] mm: implement mem_cgroup_scan_tasks() for the root
 memory cgroup
Date: Wed, 4 Oct 2017 13:10:44 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710041308510.67374@chino.kir.corp.google.com>
References: <20171004154638.710-1-guro@fb.com> <20171004154638.710-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=q/ZlA66j3uAgXC0fyqZZS+Pk14cZQpG2Aqvp5VOuLYk=;
        b=gUAysxRosDH+GhGCQEvgjPNvJg/HxukybflErChQp3JsJwUN7yZwWcQUlDF7hnz8rK
         xPOhqWC50UvNiol08wRqb9tWLVf6mE9wBngC7eA8Dnm4/2v/5wfbzj01MhUfqcpTz7QE
         xlIyzWU3bcqcik13U5SdGzVav46S4GxQBZKt30UpZZSvfMH0nCdPgkW7nd7Lu+JbWLaU
         QckSWdjQ5Dq2WgnzNV/itB+fw9hgD0Xi0aGv9EK2YvGL3QctGHfG0IRm26CwZdMK+qy/
         /nsfk2L+hytnM8nv/b0/MpRVKyez3ETuKt7OqTTzILb6VEj76HgMCIYTWjKRoD9y81XM
         162w==
In-Reply-To: <20171004154638.710-3-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 4 Oct 2017, Roman Gushchin wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d5f3a62887cf..b4de17a78dc1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -917,7 +917,8 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
>   * value, the function breaks the iteration loop and returns the value.
>   * Otherwise, it will iterate over all tasks and return 0.
>   *
> - * This function must not be called for the root memory cgroup.
> + * If memcg is the root memory cgroup, this function will iterate only
> + * over tasks belonging directly to the root memory cgroup.
>   */
>  int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  			  int (*fn)(struct task_struct *, void *), void *arg)
> @@ -925,8 +926,6 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  	struct mem_cgroup *iter;
>  	int ret = 0;
>  
> -	BUG_ON(memcg == root_mem_cgroup);
> -
>  	for_each_mem_cgroup_tree(iter, memcg) {
>  		struct css_task_iter it;
>  		struct task_struct *task;
> @@ -935,7 +934,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		while (!ret && (task = css_task_iter_next(&it)))
>  			ret = fn(task, arg);
>  		css_task_iter_end(&it);
> -		if (ret) {
> +		if (ret || memcg == root_mem_cgroup) {
>  			mem_cgroup_iter_break(memcg, iter);
>  			break;
>  		}

I think this is fine, but a little strange to start an iteration that 
never loops :)  No objection to the patch but it could also be extracted 
into a new mem_cgroup_scan_tasks() which actually scans the tasks in that 
mem cgroup and then a wrapper that does the iteration that calls into it, 
say, mem_cgroup_scan_tasks_tree().

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
