From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Date: Fri, 22 Jun 2012 08:27:25 +0900
Message-ID: <4FE3ADDD.9060908@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com> <20120621202043.GD4642@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120621202043.GD4642-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>




(2012/06/22 5:20), Tejun Heo wrote:
> On Fri, May 11, 2012 at 06:41:36PM +0900, KAMEZAWA Hiroyuki wrote:
>> Hi, here is v3 based on memcg-devel tree.
>> git://github.com/mstsxfx/memcg-devel.git
>>
>> This patch series is for avoiding -ENOMEM at calling pre_destroy()
>> which is called at rmdir(). After this patch, charges will be moved
>> to root (if use_hierarchy==0) or parent (if use_hierarchy==1), and
>> we'll not see -ENOMEM in rmdir() of cgroup.
>>
>> v2 included some other patches than ones for handling -ENOMEM problem,
>> but I divided it. I'd like to post others in different series, later.
>> No logical changes in general, maybe v3 is cleaner than v2.
>>
>> 0001 ....fix error code in memcg-hugetlb
>> 0002 ....add res_counter_uncharge_until
>> 0003 ....use res_counter_uncharge_until in memcg
>> 0004 ....move charges to root is use_hierarchy==0
>> 0005 ....cleanup for mem_cgroup_move_account()
>> 0006 ....remove warning of res_counter_uncharge_nofail (from Costa's slub accounting series).
>
> KAME, how is this progressing?  Is it stuck on anything?
>

I think I finished 80% of works and patches are in -mm stack now.
They'll be visible in -next, soon.

Remaining 20% of work is based on a modification to cgroup layer

How do you think this patch ? (This patch is not tested yet...so
may have troubles...) I think callers of pre_destory() is not so many...

==
 From a28db946f91f3509d25779e8c5db249506cc4b07 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Fri, 22 Jun 2012 08:38:38 +0900
Subject: [PATCH] cgroup: keep cgroup_mutex() while calling ->pre_destroy()

In past, memcg's pre_destroy() was verrry slow because of the possibility
of page reclaiming in it. So, cgroup_mutex() was released before calling
pre_destroy() callbacks. Now, it's enough fast. memcg just scans the list
and move pages to other cgroup, no memory reclaim happens.
Then, we can keep cgroup_mutex() there.

By holding looks, we can avoid following cases
    1. new task is attached while rmdir().
    2. new child cgroup is created while rmdir()
    3. new task is attached to cgroup and removed from cgroup before
       checking css's count. So, ->destroy() will be called even if
       some trashes by the task remains

(3. is terrible case...even if I think it will not happen in real world..)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
  kernel/cgroup.c |    3 +--
  1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index caff6a1..a5b6df1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4171,7 +4171,6 @@ again:
  		mutex_unlock(&cgroup_mutex);
  		return -EBUSY;
  	}
-	mutex_unlock(&cgroup_mutex);
  
  	/*
  	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4190,11 +4189,11 @@ again:
  	 */
  	ret = cgroup_call_pre_destroy(cgrp);
  	if (ret) {
+		mutex_unlock(&cgroup_mutex);
  		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
  		return ret;
  	}
  
-	mutex_lock(&cgroup_mutex);
  	parent = cgrp->parent;
  	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
  		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
-- 
1.7.4.1












