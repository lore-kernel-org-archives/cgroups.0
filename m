From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [patch] mm, memcg: do not retry precharge charges
Date: Thu, 12 Jan 2017 11:17:12 +0100
Message-ID: <20170112101712.GH2264@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed 11-01-17 20:32:12, David Rientjes wrote:
[...]
> This also restructures mem_cgroup_wait_acct_move() since it is not
> possible for mc.moving_task to be current.

thinking about this some more, I do not think this is the right way to
go. It is true that we will not reach mem_cgroup_wait_acct_move if all
the charges from the task moving code path are __GFP_NORETRY but that
is quite subtle requirement IMHO.

> Fixes: 0029e19ebf84 ("mm: memcontrol: remove explicit OOM parameter in charge path")
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/memcontrol.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1125,18 +1125,19 @@ static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
>  
>  static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
>  {
> -	if (mc.moving_task && current != mc.moving_task) {
> -		if (mem_cgroup_under_move(memcg)) {
> -			DEFINE_WAIT(wait);
> -			prepare_to_wait(&mc.waitq, &wait, TASK_INTERRUPTIBLE);
> -			/* moving charge context might have finished. */
> -			if (mc.moving_task)
> -				schedule();
> -			finish_wait(&mc.waitq, &wait);
> -			return true;
> -		}
> +	DEFINE_WAIT(wait);
> +
> +	if (likely(!mem_cgroup_under_move(memcg)))
> +		return false;
> +
> +	prepare_to_wait(&mc.waitq, &wait, TASK_INTERRUPTIBLE);
> +	/* moving charge context might have finished. */
> +	if (mc.moving_task) {
> +		WARN_ON_ONCE(mc.moving_task == current);
> +		schedule();
>  	}
> -	return false;
> +	finish_wait(&mc.waitq, &wait);
> +	return true;
>  }
>  
>  #define K(x) ((x) << (PAGE_SHIFT-10))
-- 
Michal Hocko
SUSE Labs
