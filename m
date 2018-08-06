From: Michal Hocko <mhocko@kernel.org>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 20:39:54 +0200
Message-ID: <20180806183954.GF10003@dhcp22.suse.cz>
References: <fc6e173e-8bda-269f-d44f-1c5f5215beac@I-love.SAKURA.ne.jp>
 <0000000000006350880572c61e62@google.com>
 <20180806174410.GB10003@dhcp22.suse.cz>
 <20180806175627.GC10003@dhcp22.suse.cz>
 <20180806181339.GD10003@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806181339.GD10003@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, penguin-kernel@I-love.SAKURA.ne.jp, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On Mon 06-08-18 20:13:39, Michal Hocko wrote:
> I simply do not see how this is possible. Let's try with the following
> extended debugging patch.
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git 116b181bb646afedd770985de20a68721bdb2648
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4603ad75c9a9..e2dfdf4361ba 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1388,6 +1388,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool ret;
>  
>  	mutex_lock(&oom_lock);
> +	pr_info("task=%s pid=%d invoked memcg oom killer. oom_victim=%d\n",
> +			current->comm, current->pid, tsk_is_oom_victim(current));
>  	ret = out_of_memory(&oc);
>  	mutex_unlock(&oom_lock);
>  	return ret;
> @@ -2108,6 +2110,9 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
>  	if (mem_cgroup_is_root(memcg))
>  		return 0;
> +	if (tsk_is_oom_victim(current))
> +		pr_info("task=%s pid=%d charge for nr_pages=%d\n",
> +			current->comm, current->pid, nr_pages);
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
> @@ -2137,8 +2142,11 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 */
>  	if (unlikely(tsk_is_oom_victim(current) ||
>  		     fatal_signal_pending(current) ||
> -		     current->flags & PF_EXITING))
> +		     current->flags & PF_EXITING)) {
> +		pr_info("task=%s pid=%d charge bypass\n",
> +			current->comm, current->pid);
>  		goto force;
> +	}
>  
>  	/*
>  	 * Prevent unbounded recursion when reclaim operations need to
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 104ef4a01a55..7d9adcde8cf6 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -692,6 +692,8 @@ static void mark_oom_victim(struct task_struct *tsk)
>  	__thaw_task(tsk);
>  	atomic_inc(&oom_victims);
>  	trace_mark_victim(tsk->pid);
> +	pr_info("task=%s pid=%d is oom victim now\n",
> +			current->comm, current->pid);
>  }

Ble this should be s@current@tsk@g. But it didn't really help. I will
have to think about this more.

-- 
Michal Hocko
SUSE Labs
