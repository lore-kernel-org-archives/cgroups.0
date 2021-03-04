From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm: Fix dropped memcg from mem cgroup soft limit
 tree
Date: Thu, 4 Mar 2021 09:35:08 -0800
Message-ID: <72cb8618-73af-ce08-d5d5-30cab30755a3@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen@linux.intel.com>
 <YC68Xo9+R2msn/ul@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YC68Xo9+R2msn/ul-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/18/21 11:13 AM, Michal Hocko wrote:

> 
> Fixes: 4e41695356fb ("memory controller: soft limit reclaim on contention")
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> Thanks!
>> ---
>>  mm/memcontrol.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index ed5cc78a8dbf..a51bf90732cb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3505,8 +3505,12 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>>  			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
>>  			break;
>>  	} while (!nr_reclaimed);
>> -	if (next_mz)
>> +	if (next_mz) {
>> +		spin_lock_irq(&mctz->lock);
>> +		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
>> +		spin_unlock_irq(&mctz->lock);
>>  		css_put(&next_mz->memcg->css);
>> +	}
>>  	return nr_reclaimed;
>>  }
>>  
>> -- 
>> 2.20.1
> 

Mel,

Reviewing this patch a bit more, I realize that there is a chance that the removed
next_mz could be inserted back to the tree from a memcg_check_events
that happen in between.  So we need to make sure that the next_mz
is indeed off the tree and update the excess value before adding it
back.  Update the patch to the patch below.

Thanks.

Tim
---

From 412764d1fad219b04c77bcb1cc8161067c8424f2 Mon Sep 17 00:00:00 2001
From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date: Tue, 2 Feb 2021 15:53:21 -0800
Subject: [PATCH v3] mm: Fix dropped memcg from mem cgroup soft limit tree
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>,Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

During soft limit memory reclaim, we will temporarily remove the target
mem cgroup from the cgroup soft limit tree.  We then perform memory
reclaim, update the memory usage excess count and re-insert the mem
cgroup back into the mem cgroup soft limit tree according to the new
memory usage excess count.

However, when memory reclaim failed for a maximum number of attempts
and we bail out of the reclaim loop, we forgot to put the target mem
cgroup chosen for next reclaim back to the soft limit tree. This prevented
pages in the mem cgroup from being reclaimed in the future even though
the mem cgroup exceeded its soft limit.  Fix the logic and put the mem
cgroup back on the tree when page reclaim failed for the mem cgroup.

Fixes: 4e41695356fb ("memory controller: soft limit reclaim on contention")
---
 mm/memcontrol.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ed5cc78a8dbf..bc9cc73ff66b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3505,8 +3505,18 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
-	if (next_mz)
+	if (next_mz) {
+		/*
+		 * next_mz was removed in __mem_cgroup_largest_soft_limit_node.
+		 * Put it back in tree with latest excess value.
+		 */
+		spin_lock_irq(&mctz->lock);
+		__mem_cgroup_remove_exceeded(next_mz, mctz);
+		excess = soft_limit_excess(next_mz->memcg);
+		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
+		spin_unlock_irq(&mctz->lock);
 		css_put(&next_mz->memcg->css);
+	}
 	return nr_reclaimed;
 }
 
-- 
2.20.1

