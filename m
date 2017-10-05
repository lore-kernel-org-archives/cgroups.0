From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Thu, 5 Oct 2017 13:40:47 +0200
Message-ID: <20171005114047.wbie3b6nhtea4mwt@dhcp22.suse.cz>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171004154638.710-4-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 04-10-17 16:46:35, Roman Gushchin wrote:
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

Thanks for separating the group_oom part. This is getting in the
mergeable state. I will ack it once the suggested fixes are folded in.
There is some clean up potential on top (I find the oc->chosen_memcg
quite ugly and will post a patch on top of yours) but that can be done
later.
 
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
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
