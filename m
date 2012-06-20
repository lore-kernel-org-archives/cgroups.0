From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v4 23/25] memcg: propagate kmem limiting information to
 children
Date: Wed, 20 Jun 2012 12:59:46 +0400
Message-ID: <4FE19102.6030704@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-24-git-send-email-glommer@parallels.com> <4FDF20ED.4090401@jp.fujitsu.com> <4FDF227B.3080601@parallels.com> <4FDFC4D4.1030303@jp.fujitsu.com> <4FE039B9.3080809@parallels.com> <4FE03E4B.5020809@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------070307050206010405020807"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4FE03E4B.5020809@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, devel@openvz.org, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Suleiman Souhlal <suleiman@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

--------------070307050206010405020807
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit

On 06/19/2012 12:54 PM, Glauber Costa wrote:
> On 06/19/2012 12:35 PM, Glauber Costa wrote:
>> On 06/19/2012 04:16 AM, Kamezawa Hiroyuki wrote:
>>> (2012/06/18 21:43), Glauber Costa wrote:
>>>> On 06/18/2012 04:37 PM, Kamezawa Hiroyuki wrote:
>>>>> (2012/06/18 19:28), Glauber Costa wrote:
>>>>>> The current memcg slab cache management fails to present satisfatory hierarchical
>>>>>> behavior in the following scenario:
>>>>>>
>>>>>> ->   /cgroups/memory/A/B/C
>>>>>>
>>>>>> * kmem limit set at A
>>>>>> * A and B empty taskwise
>>>>>> * bash in C does find /
>>>>>>
>>>>>> Because kmem_accounted is a boolean that was not set for C, no accounting
>>>>>> would be done. This is, however, not what we expect.
>>>>>>
>>>>>
>>>>> Hmm....do we need this new routines even while we have mem_cgroup_iter() ?
>>>>>
>>>>> Doesn't this work ?
>>>>>
>>>>> 	struct mem_cgroup {
>>>>> 		.....
>>>>> 		bool kmem_accounted_this;
>>>>> 		atomic_t kmem_accounted;
>>>>> 		....
>>>>> 	}
>>>>>
>>>>> at set limit
>>>>>
>>>>> 	....set_limit(memcg) {
>>>>>
>>>>> 		if (newly accounted) {
>>>>> 			mem_cgroup_iter() {
>>>>> 				atomic_inc(&iter->kmem_accounted)
>>>>> 			}
>>>>> 		} else {
>>>>> 			mem_cgroup_iter() {
>>>>> 				atomic_dec(&iter->kmem_accounted);
>>>>> 			}
>>>>> 	}
>>>>>
>>>>>
>>>>> hm ? Then, you can see kmem is accounted or not by atomic_read(&memcg->kmem_accounted);
>>>>>
>>>>
>>>> Accounted by itself / parent is still useful, and I see no reason to use
>>>> an atomic + bool if we can use a pair of bits.
>>>>
>>>> As for the routine, I guess mem_cgroup_iter will work... It does a lot
>>>> more than I need, but for the sake of using what's already in there, I
>>>> can switch to it with no problems.
>>>>
>>>
>>> Hmm. please start from reusing existing routines.
>>> If it's not enough, some enhancement for generic cgroup  will be welcomed
>>> rather than completely new one only for memcg.
>>>
>>
>> And now that I am trying to adapt the code to the new function, I
>> remember clearly why I done this way. Sorry for my failed memory.
>>
>> That has to do with the order of the walk. I need to enforce hierarchy,
>> which means whenever a cgroup has !use_hierarchy, I need to cut out that
>> branch, but continue scanning the tree for other branches.
>>
>> That is a lot easier to do with depth-search tree walks like the one
>> proposed in this patch. for_each_mem_cgroup() seems to walk the tree in
>> css-creation order. Which means we need to keep track of parents that
>> has hierarchy disabled at all times ( can be many ), and always test for
>> ancestorship - which is expensive, but I don't particularly care.
>>
>> But I'll give another shot with this one.
>>
> 
> Humm, silly me. I was believing the hierarchical settings to be more
> flexible than they really are.
> 
> I thought that it could be possible for a children of a parent with
> use_hierarchy = 1 to have use_hierarchy = 0.
> 
> It seems not to be the case. This makes my life a lot easier.
> 

How about the following patch?

It is still expensive in the clear_bit case, because I can't just walk
the whole tree flipping the bit down: I need to stop whenever I see a
branch whose root is itself accounted - and the ordering of iter forces
me to always check the tree up (So we got O(n*h) h being height instead
of O(n)).

for flipping the bit up, it is easy enough.



--------------070307050206010405020807
Content-Type: text/x-patch;
	name="0001-memcg-propagate-kmem-limiting-information-to-childre.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-memcg-propagate-kmem-limiting-information-to-childre.pa";
	filename*1="tch"

From e78b084162cb638129ae491167af14c29c57d52d Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Mon, 21 May 2012 15:18:42 +0400
Subject: [PATCH] memcg: propagate kmem limiting information to children

The current memcg slab cache management fails to present satisfatory hierarchical
behavior in the following scenario:

-> /cgroups/memory/A/B/C

* kmem limit set at A
* A and B empty taskwise
* bash in C does find /

Because kmem_accounted is a boolean that was not set for C, no accounting
would be done. This is, however, not what we expect.

The basic idea, is that when a cgroup is limited, we walk the tree
upwards (something Kame and I already thought about doing for other purposes),
and make sure that we store the information about the parent being limited in
kmem_accounted (that is turned into a bitmap: two booleans would not be space
efficient). The code for that is taken from sched/core.c. My reasons for not
putting it into a common place is to dodge the type issues that would arise
from a common implementation between memcg and the scheduler - but I think
that it should ultimately happen, so if you want me to do it now, let me
know.

We do the reverse operation when a formerly limited cgroup becomes unlimited.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Suleiman Souhlal <suleiman@google.com>
---
 mm/memcontrol.c |   86 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22eaf15..5f02899 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -274,7 +274,11 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	bool kmem_accounted;
+	/*
+	 * bit0: accounted by this cgroup
+	 * bit1: accounted by a parent.
+	 */
+	volatile unsigned long kmem_accounted;
 
 	bool		oom_lock;
 	atomic_t	under_oom;
@@ -332,6 +336,9 @@ struct mem_cgroup {
 #endif
 };
 
+#define KMEM_ACCOUNTED_THIS	0
+#define KMEM_ACCOUNTED_PARENT	1
+
 int memcg_css_id(struct mem_cgroup *memcg)
 {
 	return css_id(&memcg->css);
@@ -474,7 +481,7 @@ void sock_release_memcg(struct sock *sk)
 
 static void disarm_static_keys(struct mem_cgroup *memcg)
 {
-	if (memcg->kmem_accounted)
+	if (test_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted))
 		static_key_slow_dec(&mem_cgroup_kmem_enabled_key);
 	/*
 	 * This check can't live in kmem destruction function,
@@ -4418,6 +4425,66 @@ static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
 	len = scnprintf(str, sizeof(str), "%llu\n", (unsigned long long)val);
 	return simple_read_from_buffer(buf, nbytes, ppos, str, len);
 }
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+static void mem_cgroup_update_kmem_limit(struct mem_cgroup *memcg, u64 val)
+{
+	struct mem_cgroup *iter;
+
+	mutex_lock(&set_limit_mutex);
+	if (!test_and_set_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted) &&
+		val != RESOURCE_MAX) {
+
+		/*
+		 * Once enabled, can't be disabled. We could in theory
+		 * disable it if we haven't yet created any caches, or
+		 * if we can shrink them all to death.
+		 *
+		 * But it is not worth the trouble
+		 */
+		static_key_slow_inc(&mem_cgroup_kmem_enabled_key);
+
+		if (!memcg->use_hierarchy)
+			goto out;
+
+		for_each_mem_cgroup_tree(iter, memcg) {
+			if (iter == memcg)
+				continue;
+			set_bit(KMEM_ACCOUNTED_PARENT, &iter->kmem_accounted);
+		}
+
+	} else if (test_and_clear_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted)
+		&& val == RESOURCE_MAX) {
+
+		if (!memcg->use_hierarchy)
+			goto out;
+
+		for_each_mem_cgroup_tree(iter, memcg) {
+			struct mem_cgroup *parent;
+			if (iter == memcg)
+				continue;
+			/*
+			 * We should only have our parent bit cleared if none of
+			 * ouri parents are accounted. The transversal order of
+			 * our iter function forces us to always look at the
+			 * parents.
+			 */
+			parent = parent_mem_cgroup(iter);
+			while (parent && (parent != memcg)) {
+				if (test_bit(KMEM_ACCOUNTED_THIS, &parent->kmem_accounted))
+					goto noclear;
+					
+				parent = parent_mem_cgroup(parent);
+			}
+			clear_bit(KMEM_ACCOUNTED_PARENT, &iter->kmem_accounted);
+noclear:
+			continue;
+		}
+	}
+out:
+	mutex_unlock(&set_limit_mutex);
+}
+#endif
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -4455,19 +4522,8 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 			ret = res_counter_set_limit(&memcg->kmem, val);
 			if (ret)
 				break;
-			/*
-			 * Once enabled, can't be disabled. We could in theory
-			 * disable it if we haven't yet created any caches, or
-			 * if we can shrink them all to death.
-			 *
-			 * But it is not worth the trouble
-			 */
-			mutex_lock(&set_limit_mutex);
-			if (!memcg->kmem_accounted && val != RESOURCE_MAX) {
-				static_key_slow_inc(&mem_cgroup_kmem_enabled_key);
-				memcg->kmem_accounted = true;
-			}
-			mutex_unlock(&set_limit_mutex);
+			mem_cgroup_update_kmem_limit(memcg, val);
+			break;
 		}
 #endif
 		else
-- 
1.7.10.2


--------------070307050206010405020807--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
