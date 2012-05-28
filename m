From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] account guest time per-cgroup as well.
Date: Mon, 28 May 2012 17:26:25 +0400
Message-ID: <4FC37D01.7080704@parallels.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com> <1334010315-4453-3-git-send-email-glommer@parallels.com> <CAPM31RLwY4d-Ng3-T+-1eLxuZxr8wbdC_+sDQbJQXuqEfe9tfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------050909060109020409000805"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RLwY4d-Ng3-T+-1eLxuZxr8wbdC_+sDQbJQXuqEfe9tfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

--------------050909060109020409000805
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 05/26/2012 08:44 AM, Paul Turner wrote:
> On 04/09/2012 03:25 PM, Glauber Costa wrote:
>> In the interest of providing a per-cgroup figure of common statistics,
>> this patch adds a nr_switches counter to each group runqueue (both cfs
>> and rt).
>>
>> To avoid impact on schedule(), we don't walk the tree at stat gather
>> time. This is because schedule() is called much more frequently than
>> the tick functions, in which we do walk the tree.
>>
>> When this figure needs to be read (different patch), we will
>> aggregate them at read time.
>>
>>

Paul,

How about the following patch instead?

It is still using the cfs_rq and rt_rq's structures, (this code actually 
only touches fair.c as a PoC, rt would be similar).

Tasks in the root cgroup (without an se->parent), will do a branch and 
exit. For the others, we accumulate here, and simplify the reader.

My reasoning for this, is based on the fact that all the se->parent 
relations should be cached by our recent call to put_prev_task (well, 
unless of course we have a really big chain)

This would incur a slightly higher context switch time for tasks inside 
a cgroup.

The reader (in a different patch) would then be the same as the others:

+static u64 tg_nr_switches(struct task_group *tg, int cpu)
+{
+	if (tg != &root_task_group)
+		return rt_rq(rt_nr_switches, tg, cpu)
                        +fair_rq(nr_switches, tg, cpu);
+
+	return cpu_rq(cpu)->nr_switches;
+}

I plan to measure this today, but an extra branch cost for the common 
case of a task in the root cgroup + O(depth) for tasks inside cgroups 
may be acceptable, given the simplification it brings.

Let me know what you think.





--------------050909060109020409000805
Content-Type: text/x-patch; name="alternative.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="alternative.patch"

Index: linux/kernel/sched/fair.c
===================================================================
--- linux.orig/kernel/sched/fair.c
+++ linux/kernel/sched/fair.c
@@ -2990,6 +2990,22 @@ static struct task_struct *pick_next_tas
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (!se->parent)
+		goto out;
+	cfs_rq = group_cfs_rq(se->parent);
+	if (cfs_rq->prev == se)
+		goto out;
+	cfs_rq->prev = se;
+
+	while (se->parent) {
+		se = se->parent;
+		cfs_rq = group_cfs_rq(se);
+		cfs_rq->nr_switches++;
+	}
+out:
+#endif
+
 	return p;
 }
 
Index: linux/kernel/sched/sched.h
===================================================================
--- linux.orig/kernel/sched/sched.h
+++ linux/kernel/sched/sched.h
@@ -237,6 +237,8 @@ struct cfs_rq {
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
+	u64 nr_switches;
+	struct sched_entity *prev;
 #ifdef CONFIG_SMP
 	/*
 	 *   h_load = weight * f(tg)
@@ -307,6 +309,9 @@ struct rt_rq {
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
+
+	u64 rt_nr_switches;
+	struct sched_rt_entity *prev;
 #endif
 };
 

--------------050909060109020409000805--
