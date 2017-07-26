From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v4 1/4] mm, oom: refactor the TIF_MEMDIE usage
Date: Wed, 26 Jul 2017 15:56:22 +0200
Message-ID: <20170726135622.GS2981@dhcp22.suse.cz>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170726132718.14806-2-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 26-07-17 14:27:15, Roman Gushchin wrote:
[...]
> @@ -656,13 +658,24 @@ static void mark_oom_victim(struct task_struct *tsk)
>  	struct mm_struct *mm = tsk->mm;
>  
>  	WARN_ON(oom_killer_disabled);
> -	/* OOM killer might race with memcg OOM */
> -	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
> +
> +	if (!cmpxchg(&tif_memdie_owner, NULL, current)) {
> +		struct task_struct *t;
> +
> +		rcu_read_lock();
> +		for_each_thread(current, t)
> +			set_tsk_thread_flag(t, TIF_MEMDIE);
> +		rcu_read_unlock();
> +	}

I would realy much rather see we limit the amount of memory reserves oom
victims can consume rather than build on top of the current hackish
approach of limiting the number of tasks because the fundamental problem
is still there (a heavy multithreaded process can still deplete the
reserves completely).

Is there really any reason to not go with the existing patch I've
pointed to the last time around? You didn't seem to have any objects
back then.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
