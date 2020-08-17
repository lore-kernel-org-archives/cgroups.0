From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Mon, 17 Aug 2020 17:26:55 +0200
Message-ID: <20200817152655.GE28270@dhcp22.suse.cz>
References: <20200817140831.30260-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200817140831.30260-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Mon 17-08-20 10:08:23, Waiman Long wrote:
> Memory controller can be used to control and limit the amount of
> physical memory used by a task. When a limit is set in "memory.high" in
> a v2 non-root memory cgroup, the memory controller will try to reclaim
> memory if the limit has been exceeded. Normally, that will be enough
> to keep the physical memory consumption of tasks in the memory cgroup
> to be around or below the "memory.high" limit.
> 
> Sometimes, memory reclaim may not be able to recover memory in a rate
> that can catch up to the physical memory allocation rate. In this case,
> the physical memory consumption will keep on increasing.  When it reaches
> "memory.max" for memory cgroup v2 or when the system is running out of
> free memory, the OOM killer will be invoked to kill some tasks to free
> up additional memory. However, one has little control of which tasks
> are going to be killed by an OOM killer. Killing tasks that hold some
> important resources without freeing them first can create other system
> problems down the road.
> 
> Users who do not want the OOM killer to be invoked to kill random
> tasks in an out-of-memory situation can use the memory control
> facility provided by this new patchset via prctl(2) to better manage
> the mitigation action that needs to be performed to various tasks when
> the specified memory limit is exceeded with memory cgroup v2 being used.
> 
> The currently supported mitigation actions include the followings:
> 
>  1) Return ENOMEM for some syscalls that allocate or handle memory
>  2) Slow down the process for memory reclaim to catch up
>  3) Send a specific signal to the task
>  4) Kill the task
> 
> The users that want better memory control for their applicatons can
> either modify their applications to call the prctl(2) syscall directly
> with the new memory control command code or write the desired action to
> the newly provided memctl procfs files of their applications provided
> that those applications run in a non-root v2 memory cgroup.

prctl is fundamentally about per-process control while cgroup (not only
memcg) is about group of processes interface. How do those two interact
together? In other words what is the semantic when different processes
have a different views on the same underlying memcg event?

Also the above description doesn't really describe any usecase which
struggles with the existing interface. We already do allow slow down and
along with PSI also provide user space control over close to OOM
situation.

-- 
Michal Hocko
SUSE Labs
