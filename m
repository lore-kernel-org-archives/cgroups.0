From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v10 4/6] mm, oom: introduce memory.oom_group
Date: Wed, 4 Oct 2017 15:37:00 -0400
Message-ID: <20171004193700.GD1501@cmpxchg.org>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mG8gmZeK5PwcbcrNeewNTwKlCrHBt5j5YQdMvR475tg=; b=iBY8y3CsYxF6Jb9lUoJ/N1JXtG
	a0FSqJOnRMWygItVCagHVRRx0tblyFS2RfWcluzOPnp+HUPEXlDAEzvYY7GnsCTdun6hPYr65Q42B
	XeBIi6GwRUqVlgo2lr0pLPyWQth0U+gWDFQytywKKJBUAexKfBSMnv+nbKmyLxClJdPE=;
Content-Disposition: inline
In-Reply-To: <20171004154638.710-5-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 04:46:36PM +0100, Roman Gushchin wrote:
> The cgroup-aware OOM killer treats leaf memory cgroups as memory
> consumption entities and performs the victim selection by comparing
> them based on their memory footprint. Then it kills the biggest task
> inside the selected memory cgroup.
> 
> But there are workloads, which are not tolerant to a such behavior.
> Killing a random task may leave the workload in a broken state.
> 
> To solve this problem, memory.oom_group knob is introduced.
> It will define, whether a memory group should be treated as an
> indivisible memory consumer, compared by total memory consumption
> with other memory consumers (leaf memory cgroups and other memory
> cgroups with memory.oom_group set), and whether all belonging tasks
> should be killed if the cgroup is selected.
> 
> If set on memcg A, it means that in case of system-wide OOM or
> memcg-wide OOM scoped to A or any ancestor cgroup, all tasks,
> belonging to the sub-tree of A will be killed. If OOM event is
> scoped to a descendant cgroup (A/B, for example), only tasks in
> that cgroup can be affected. OOM killer will never touch any tasks
> outside of the scope of the OOM event.
> 
> Also, tasks with oom_score_adj set to -1000 will not be killed.
> 
> The default value is 0.
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

Those semantics make sense to me and the code looks good.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
