From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] fork, memcg: fix cached_stacks case
Date: Wed, 2 Jan 2019 21:23:48 +0100
Message-ID: <20190102202348.GE24572@dhcp22.suse.cz>
References: <20190102180145.57406-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190102180145.57406-1-shakeelb@google.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Rik van Riel <riel@surriel.com>, Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org

On Wed 02-01-19 10:01:45, Shakeel Butt wrote:
> Commit 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on
> memcg charge fail") fixes a crash caused due to failed memcg charge of
> the kernel stack. However the fix misses the cached_stacks case which
> this patch fixes. So, the same crash can happen if the memcg charge of
> a cached stack is failed.
> 
> Fixes: 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on memcg charge fail")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@vger.kernel.org>

Ups, I have overlook that. Thanks for catching that.
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  kernel/fork.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e4a51124661a..593cd1577dff 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -216,6 +216,7 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		memset(s->addr, 0, THREAD_SIZE);
>  
>  		tsk->stack_vm_area = s;
> +		tsk->stack = s->addr;
>  		return s->addr;
>  	}
>  
> -- 
> 2.20.1.415.g653613c723-goog
> 

-- 
Michal Hocko
SUSE Labs
