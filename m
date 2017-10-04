From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 15:27:20 -0400
Message-ID: <20171004192720.GC1501@cmpxchg.org>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pKY0FkTYWdC4fC8nseoSxOx4bsfaxgcII6xBQeTwFqo=; b=ep3dFD/LReNX4N/QlqayMvSj6K
	MRDNeEHHnviys3Pv/JBB/jIF18kH/KuAH58vLK7ygSDEo5B0vmXbX8KLuzcU4Qbcc+0/F5aTR4j9l
	EPzIuxTWcF+WS1cs3/5Vo4u4Bbl7bPB2C22KvMPj9Llz1xEL9ftBW3lcH5Sc2YCHUu1A=;
Content-Disposition: inline
In-Reply-To: <20171004154638.710-4-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 04:46:35PM +0100, Roman Gushchin wrote:
> Traditionally, the OOM killer is operating on a process level.
> Under oom conditions, it finds a process with the highest oom score
> and kills it.
> 
> This behavior doesn't suit well the system with many running
> containers:
> 
> 1) There is no fairness between containers. A small container with
> few large processes will be chosen over a large one with huge
> number of small processes.
> 
> 2) Containers often do not expect that some random process inside
> will be killed. In many cases much safer behavior is to kill
> all tasks in the container. Traditionally, this was implemented
> in userspace, but doing it in the kernel has some advantages,
> especially in a case of a system-wide OOM.
> 
> To address these issues, the cgroup-aware OOM killer is introduced.
> 
> Under OOM conditions, it looks for the biggest leaf memory cgroup
> and kills the biggest task belonging to it. The following patches
> will extend this functionality to consider non-leaf memory cgroups
> as well, and also provide an ability to kill all tasks belonging
> to the victim cgroup.
> 
> The root cgroup is treated as a leaf memory cgroup, so it's score
> is compared with leaf memory cgroups.
> Due to memcg statistics implementation a special algorithm
> is used for estimating it's oom_score: we define it as maximum
> oom_score of the belonging tasks.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

This looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

I just have one question:

> @@ -828,6 +828,12 @@ static void __oom_kill_process(struct task_struct *victim)
>  	struct mm_struct *mm;
>  	bool can_oom_reap = true;
>  
> +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD) ||
> +	    victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
> +		put_task_struct(victim);
> +		return;
> +	}
> +
>  	p = find_lock_task_mm(victim);
>  	if (!p) {
>  		put_task_struct(victim);

Is this necessary? The callers of this function use oom_badness() to
find a victim, and that filters init, kthread, OOM_SCORE_ADJ_MIN.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
