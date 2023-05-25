From: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: Bug report: Unable to handle kernel paging request at virtual
 address 00000000c0000010
Date: Thu, 25 May 2023 20:21:11 +0800
Message-ID: <acc00c94-8590-15d0-7903-7e5040d24ddc@huaweicloud.com>
References: <c0a63cf1-7487-5670-771b-5077a73be4c7@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <c0a63cf1-7487-5670-771b-5077a73be4c7-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cuigaosheng <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, wangweiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

How about this solution? we stop task iteration when moving css_set to a
new list in rebind_subsystems(), patch is as bellow:


diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 567c547cf371..3f1557cb5758 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -47,6 +47,7 @@ struct kernel_clone_args;

 /* internal flags */
 #define CSS_TASK_ITER_SKIPPED		(1U << 16)
+#define CSS_TASK_ITER_STOPPED		(1U << 17)

 /* a css_task_iter should be treated as an opaque object */
 struct css_task_iter {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f10cef511ffa..091c9a38d0c7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -240,6 +240,8 @@ static int cgroup_apply_control(struct cgroup *cgrp);
 static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
 static void css_task_iter_skip(struct css_task_iter *it,
 			       struct task_struct *task);
+static void css_task_iter_stop(struct css_task_iter *it,
+			       struct css_set *cset);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss);
@@ -889,6 +891,19 @@ static void css_set_skip_task_iters(struct css_set
*cset,
 		css_task_iter_skip(it, task);
 }

+/*
+ * @cset is moving to other list, it's not safe to continue the iterator,
+ * because the cset_head and css_pos of css_task_iter does not make sense
+ * for the new list.
+ */
+static void css_set_stop_iters(struct css_set *cset)
+{
+	struct css_task_iter *it, *pos;
+
+	list_for_each_entry_safe(it, pos, &cset->task_iters, iters_node)
+		css_task_iter_stop(it, cset);
+}
+
 /**
  * css_set_move_task - move a task from one css_set to another
  * @task: task being moved
@@ -1861,9 +1876,11 @@ int rebind_subsystems(struct cgroup_root
*dst_root, u16 ss_mask)
 		css->cgroup = dcgrp;

 		spin_lock_irq(&css_set_lock);
-		hash_for_each(css_set_table, i, cset, hlist)
+		hash_for_each(css_set_table, i, cset, hlist) {
+			css_set_stop_iters(cset);
 			list_move_tail(&cset->e_cset_node[ss->id],
 				       &dcgrp->e_csets[ss->id]);
+		}
 		spin_unlock_irq(&css_set_lock);

 		if (ss->css_rstat_flush) {
@@ -4866,6 +4883,15 @@ static void css_task_iter_skip(struct
css_task_iter *it,
 	}
 }

+static void css_task_iter_stop(struct css_task_iter *it,
+			       struct css_set *cset)
+{
+	lockdep_assert_held(&css_set_lock);
+
+	WARN_ONCE(it->cur_cset != cset, "invalid cur_set\n");
+	it->flags |= CSS_TASK_ITER_STOPPED;
+}
+
 static void css_task_iter_advance(struct css_task_iter *it)
 {
 	struct task_struct *task;
@@ -4969,6 +4995,9 @@ struct task_struct *css_task_iter_next(struct
css_task_iter *it)

 	spin_lock_irq(&css_set_lock);

+	if (it->flags & CSS_TASK_ITER_STOPPED)
+		goto unlock;
+
 	/* @it may be half-advanced by skips, finish advancing */
 	if (it->flags & CSS_TASK_ITER_SKIPPED)
 		css_task_iter_advance(it);
@@ -4980,6 +5009,7 @@ struct task_struct *css_task_iter_next(struct
css_task_iter *it)
 		css_task_iter_advance(it);
 	}

+unlock:
 	spin_unlock_irq(&css_set_lock);

 	return it->cur_task;



On 2023/5/24 20:13, cuigaosheng wrote:
> 
> Hi,everybody
> 
> There is a bug in the mainline
> code(https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux.git -b master).
> 
> The bug's call trace as follows:
>> refcount_t: addition on 0; use-after-free.
>>   WARNING: CPU: 1 PID: 342 at lib/refcount.c:25
>> refcount_warn_saturate+0xa0/0x148
>>   Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.79 12/28/2022
>>   Workqueue: events cpuset_hotplug_workfn
>>   Call trace:
>>    refcount_warn_saturate+0xa0/0x148
>>    __refcount_add.constprop.0+0x5c/0x80
>>    css_task_iter_advance_css_set+0xd8/0x210
>>    css_task_iter_advance+0xa8/0x120
>>    css_task_iter_next+0x94/0x158
>>    update_tasks_root_domain+0x58/0x98
>>    rebuild_root_domains+0xa0/0x1b0
>>    rebuild_sched_domains_locked+0x144/0x188
>>    cpuset_hotplug_workfn+0x138/0x5a0
>>    process_one_work+0x1e8/0x448
>>    worker_thread+0x228/0x3e0
>>    kthread+0xe0/0xf0
>>    ret_from_fork+0x10/0x20
>>   ---[ end trace 0000000000000000 ]---
>>   ------------[ cut here ]------------
>>   refcount_t: underflow; use-after-free.
>>   WARNING: CPU: 1 PID: 342 at lib/refcount.c:28
>> refcount_warn_saturate+0xf4/0x148
>>   Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.79 12/28/2022
>>   Workqueue: events cpuset_hotplug_workfn
>>   Call trace:
>>    refcount_warn_saturate+0xf4/0x148
>>    put_css_set_locked+0x80/0x98
>>    css_task_iter_end+0x70/0x160
>>    update_tasks_root_domain+0x68/0x98
>>    rebuild_root_domains+0xa0/0x1b0
>>    rebuild_sched_domains_locked+0x144/0x188
>>    cpuset_hotplug_workfn+0x138/0x5a0
>>    process_one_work+0x1e8/0x448
>>    worker_thread+0x228/0x3e0
>>    kthread+0xe0/0xf0
>>    ret_from_fork+0x10/0x20
>>   ---[ end trace 0000000000000000 ]---
>>   process 10324 (cpuhotplug_do_s) no longer affine to cpu1
>>   psci: CPU1 killed (polled 0 ms)
>>   Unable to handle kernel paging request at virtual address
>> 00000000c0000010
>>   Internal error: Oops: 0000000096000004 [#1] SMP
>>   Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.79 12/28/2022
>>   Workqueue: cgroup_destroy css_free_rwork_fn
>>   Call trace:
>>    cgroup_apply_control_disable+0xb0/0x1f8
>>    rebind_subsystems+0x20c/0x548
>>    cgroup_destroy_root+0x64/0x240
>>    css_free_rwork_fn+0x18c/0x1a8
>>    process_one_work+0x1e8/0x448
>>    worker_thread+0x178/0x3e0
>>    kthread+0xe0/0xf0
>>    ret_from_fork+0x10/0x20
>>   Code: 91012842 8b020f62 f9400453 b4000293 (f9400a60)
>>   SMP: stopping secondary CPUs
>>   Starting crashdump kernel...
> This bug occurs in concurrency scenarios, In the hotplug,
> update_tasks_root_domain will
> iterate over all tasks on the cpuset/root domain, the code as follows:
>> static void update_tasks_root_domain(struct cpuset *cs)
>> {
>>          struct css_task_iter it;
>>          struct task_struct *task;
>>
>>          css_task_iter_start(&cs->css, 0, &it); // hold css_set_lock
>> in css_task_iter_start
>>                  ... //nolock time1: don't hold css_set_lock
>>          while ((task = css_task_iter_next(&it))) // hold css_set_lock
>> in css_task_iter_next
>>                  dl_add_task_root_domain(task); //nolock time2: don't
>> hold css_set_lock
>>
>>          css_task_iter_end(&it);
>> }
> The cgroup.e_csets will be traversed through css_task_iter, and
> it->cset_head will record
> the head of the e_cset list that is currently traversed, we will hold
> css_set_lock in
> css_task_iter_start or in css_task_iter_next, but we don't always hold
> the css_set_lock,
> such as "nolock time1" and "nolock time2" in the code comments above.
> 
> During the time without css_set_lock in update_tasks_root_domain, if
> it->cur_cset(current css_set)
> is migrated to another list, such as:
>> int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
>> {
>>      ...
>>       spin_lock_irq(&css_set_lock);
>>       hash_for_each(css_set_table, i, cset, hlist)
>>          list_move_tail(&cset->e_cset_node[ss->id],
>> &dcgrp->e_csets[ss->id]);
>>      spin_unlock_irq(&css_set_lock);
>>      ...
>> }
> The bug will be triggered. As follows:
> 
> #1> in css_task_iter_start(), it->cset_head =
> &css->cgroup->e_csets[css->ss->id]; list A
> #2> in css_task_iter_next(&it), it->cur_cset=nodeA，return task
> #3> move nodeA to listB, for example:
> rebind_subsystems(),list_move_tail(nodeA, listB),then nodeA->next = headB
> #4> next css_task_iter_next, new = nodeA->next == headB
> #5> headB is not a valid css_set, but now new != it->cset_head(nodeA),
> so headB will be referred to as a valid css_set
> #6> get_css_set(headB), refcount warning
> 
> The following changes will increase the probability of this bug being
> triggered:
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index e4ca2dd2b764..120e0c23517f 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -66,6 +66,7 @@
>>   #include <linux/mutex.h>
>>   #include <linux/cgroup.h>
>>   #include <linux/wait.h>
>> +#include <linux/delay.h>
>>
>>   DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
>>   DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
>> @@ -1073,8 +1074,10 @@ static void update_tasks_root_domain(struct
>> cpuset *cs)
>>
>>          css_task_iter_start(&cs->css, 0, &it);
>>
>> -       while ((task = css_task_iter_next(&it)))
>> +       while ((task = css_task_iter_next(&it))) {
>> +               udelay(1000 * 10);
>>                  dl_add_task_root_domain(task);
>> +       }
>>
>>          css_task_iter_end(&it);
>>   }
> 
> We can trigger this bug with ltp test
> cases(https://github.com/linux-test-project/ltp/blob/master/runtest/controllers):
> 
> step 1: create a process to execute the following usecases:
> cpuhotplug02 cpuhotplug02.sh -c 1 -l 1
> cpuhotplug03 cpuhotplug03.sh -c 1 -l 1
> cpuhotplug04 cpuhotplug04.sh -l 1
> cpuhotplug05 cpuhotplug05.sh -c 1 -l 1 -d /tmp
> cpuhotplug06 cpuhotplug06.sh -c 1 -l 1
> cpuhotplug07 cpuhotplug07.sh -c 1 -l 1 -d /usr/src/linux
> 
> step 2: create another process to execute the following usecases:
> cpuset_base_ops cpuset_base_ops_testset.sh
> cpuset_inherit cpuset_inherit_testset.sh
> cpuset_exclusive cpuset_exclusive_test.sh
> cpuset_hierarchy cpuset_hierarchy_test.sh
> cpuset_syscall cpuset_syscall_testset.sh
> cpuset_sched_domains cpuset_sched_domains_test.sh
> cpuset_load_balance cpuset_load_balance_test.sh
> cpuset_hotplug cpuset_hotplug_test.sh
> cpuset_memory cpuset_memory_testset.sh
> 
> Looking forward to your reply.
> 
> Thanks.
> 
> 

