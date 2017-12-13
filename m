From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Wed, 13 Dec 2017 19:58:24 +0530
Message-ID: <c54d904e-13bc-8e2b-c9c1-8bf9cb8a33a3@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
 <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
 <20171211153258.GI2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513175310;
        bh=VtWnSsXs5gMjM8XNCES1sSBBucwBTT7SLAJ1q6aSidk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HdaJtETrLtG3uM+nikOZ18E6JOUVBPiSfqQgJg1m5n+XBLA0jnBXA30eWdkS7efOI
         IG6rcZsZUMm0mRdSekw/RLFlmBGXK018LqvhS5K0/zhKELkWuVFkvhiNjSPBbtsCp4
         2V+cSm77PAFjDzfa9+LR1HxF6jj72RqM3kMibMSE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513175309;
        bh=VtWnSsXs5gMjM8XNCES1sSBBucwBTT7SLAJ1q6aSidk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SCrralH+Rt3FoCdr4RdB9EwwFkx65XeFvrmxKWDWh5Aw7TtB2ZnwxT1UJrxUUrkEe
         0ypH9hfQpml/Ur2fEb7IaW1Yqu0pPi4+xzk+ZDuT74qBg6waBuFSXaFR6OZ0Br2myY
         N8oxYIJAKqP5gQwx0Z5iLhnO5N2wLSX6I6yjJgQ0=
In-Reply-To: <20171211153258.GI2421075@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On 12/11/2017 09:02 PM, Tejun Heo wrote:
> Hello, Prateek.
> 
> On Fri, Dec 08, 2017 at 05:15:55PM +0530, Prateek Sood wrote:
>> There is one deadlock issue during cgroup migration from cpu
>> hotplug path when a task T is being moved from source to
>> destination cgroup.
>>
>> kworker/0:0
>> cpuset_hotplug_workfn()
>>    cpuset_hotplug_update_tasks()
>>       hotplug_update_tasks_legacy()
>>         remove_tasks_in_empty_cpuset()
>>           cgroup_transfer_tasks() // stuck in iterator loop
>>             cgroup_migrate()
>>               cgroup_migrate_add_task()
>>
>> In cgroup_migrate_add_task() it checks for PF_EXITING flag of task T.
>> Task T will not migrate to destination cgroup. css_task_iter_start()
>> will keep pointing to task T in loop waiting for task T cg_list node
>> to be removed.
> 
> Heh, that's a bug in cgroup_transfer_tasks() which happened because I
> forgot to update when we changed how we handle exiting tasks.  The
> right thing to do here is making cgroup_transfer_tasks() repeat iff
> there were a valid migration target which didn't get transferred.
> 
> Thanks.
> 

Hi TJ,

Did you mean something like below. If not then could you
please share a patch for this problem in
cgroup_transfer_tasks().

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 473e0c0..41de618 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -143,6 +143,8 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,

 void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
                         struct css_task_iter *it);
+void css_task_migrate_iter_start(struct cgroup_subsys_state *css,
+                                unsigned int flags, struct css_task_iter *it);
 struct task_struct *css_task_iter_next(struct css_task_iter *it);
 void css_task_iter_end(struct css_task_iter *it);

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 024085d..12279ae 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -122,7 +122,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
         * ->can_attach() fails.
         */
        do {
-               css_task_iter_start(&from->self, 0, &it);
+               css_task_migrate_iter_start(&from->self, 0, &it);
                task = css_task_iter_next(&it);
                if (task)
                        get_task_struct(task);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe1..3c1d2d2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4189,6 +4189,42 @@ void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
        spin_unlock_irq(&css_set_lock);
 }

+void css_task_migrate_iter_start(struct cgroup_subsys_state *css,
+                                unsigned int flags, struct css_task_iter *it)
+{
+       struct task_struct *task = NULL;
+       /* no one should try to iterate before mounting cgroups */
+       WARN_ON_ONCE(!use_task_css_set_links);
+
+       memset(it, 0, sizeof(*it));
+
+       spin_lock_irq(&css_set_lock);
+
+       it->ss = css->ss;
+       it->flags = flags;
+
+       if (it->ss)
+               it->cset_pos = &css->cgroup->e_csets[css->ss->id];
+       else
+               it->cset_pos = &css->cgroup->cset_links;
+
+       it->cset_head = it->cset_pos;
+
+       css_task_iter_advance_css_set(it);
+
+       while (it->task_pos) {
+               task = list_entry(it->task_pos, struct task_struct,
+                       cg_list);
+
+               if (likely(!(task->flags & PF_EXITING)))
+                       break;
+
+               css_task_iter_advance(it);
+       }
+
+       spin_unlock_irq(&css_set_lock);
+}
+
 /**
  * css_task_iter_next - return the next task for the iterator
  * @it: the task iterator being iterated




Thanks

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
