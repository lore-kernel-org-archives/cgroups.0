From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 0/5] Use obj_cgroup APIs to change kmem pages
Date: Mon, 1 Mar 2021 17:12:06 -0800
Message-ID: <YD2Q5q2HfKXPnDte@carbon.dhcp.thefacebook.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ThN+ehv/zMIPsztTY0/Oc35AMeSc5RecSzsa87omAco=;
 b=M9alM8+oJnTILnBZEDHmMVLdcDVxYxKxIsH66hkzDvuGNWqJdDq/d3iV02dIOO+jzMDg
 1qO40mIyK7ExrEtjNrFinafblX9J8NCiBeR3dwHsqMOZdXGSod/LFJQi0mdU4S2vfgrU
 jGw62O8DOJL68s3WumjI2qLRW1wh6VA9sAc= 
Content-Disposition: inline
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com, chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz, mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com, iamjo

Hi Muchun!

On Mon, Mar 01, 2021 at 02:22:22PM +0800, Muchun Song wrote:
> Since Roman series "The new cgroup slab memory controller" applied. All
> slab objects are changed via the new APIs of obj_cgroup. This new APIs
> introduce a struct obj_cgroup instead of using struct mem_cgroup directly
> to charge slab objects. It prevents long-living objects from pinning the
> original memory cgroup in the memory. But there are still some corner
> objects (e.g. allocations larger than order-1 page on SLUB) which are
> not charged via the API of obj_cgroup. Those objects (include the pages
> which are allocated from buddy allocator directly) are charged as kmem
> pages which still hold a reference to the memory cgroup.

Yes, this is a good idea, large kmallocs should be treated the same
way as small ones.

> 
> E.g. We know that the kernel stack is charged as kmem pages because the
> size of the kernel stack can be greater than 2 pages (e.g. 16KB on x86_64
> or arm64). If we create a thread (suppose the thread stack is charged to
> memory cgroup A) and then move it from memory cgroup A to memory cgroup
> B. Because the kernel stack of the thread hold a reference to the memory
> cgroup A. The thread can pin the memory cgroup A in the memory even if
> we remove the cgroup A. If we want to see this scenario by using the
> following script. We can see that the system has added 500 dying cgroups.
> 
> 	#!/bin/bash
> 
> 	cat /proc/cgroups | grep memory
> 
> 	cd /sys/fs/cgroup/memory
> 	echo 1 > memory.move_charge_at_immigrate
> 
> 	for i in range{1..500}
> 	do
> 		mkdir kmem_test
> 		echo $$ > kmem_test/cgroup.procs
> 		sleep 3600 &
> 		echo $$ > cgroup.procs
> 		echo `cat kmem_test/cgroup.procs` > cgroup.procs
> 		rmdir kmem_test
> 	done
> 
> 	cat /proc/cgroups | grep memory

Well, moving processes between cgroups always created a lot of issues
and corner cases and this one is definitely not the worst. So this problem
looks a bit artificial, unless I'm missing something. But if it doesn't
introduce any new performance costs and doesn't make the code more complex,
I have nothing against.

Btw, can you, please, run the spell-checker on commit logs? There are many
typos (starting from the title of the series, I guess), which make the patchset
look less appealing.

Thank you!

> 
> This patchset aims to make those kmem pages drop the reference to memory
> cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> of the dying cgroups will not increase if we run the above test script.
> 
> Patch 1-3 are using obj_cgroup APIs to charge kmem pages. The remote
> memory cgroup charing APIs is a mechanism to charge kernel memory to a
> given memory cgroup. So I also make it use the APIs of obj_cgroup.
> Patch 4-5 are doing this.
> 
> Muchun Song (5):
>   mm: memcontrol: introduce obj_cgroup_{un}charge_page
>   mm: memcontrol: make page_memcg{_rcu} only applicable for non-kmem
>     page
>   mm: memcontrol: reparent the kmem pages on cgroup removal
>   mm: memcontrol: move remote memcg charging APIs to CONFIG_MEMCG_KMEM
>   mm: memcontrol: use object cgroup for remote memory cgroup charging
> 
>  fs/buffer.c                          |  10 +-
>  fs/notify/fanotify/fanotify.c        |   6 +-
>  fs/notify/fanotify/fanotify_user.c   |   2 +-
>  fs/notify/group.c                    |   3 +-
>  fs/notify/inotify/inotify_fsnotify.c |   8 +-
>  fs/notify/inotify/inotify_user.c     |   2 +-
>  include/linux/bpf.h                  |   2 +-
>  include/linux/fsnotify_backend.h     |   2 +-
>  include/linux/memcontrol.h           | 109 +++++++++++---
>  include/linux/sched.h                |   6 +-
>  include/linux/sched/mm.h             |  30 ++--
>  kernel/bpf/syscall.c                 |  35 ++---
>  kernel/fork.c                        |   4 +-
>  mm/memcontrol.c                      | 276 ++++++++++++++++++++++-------------
>  mm/page_alloc.c                      |   4 +-
>  15 files changed, 324 insertions(+), 175 deletions(-)
> 
> -- 
> 2.11.0
> 
