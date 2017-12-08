From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Fri, 8 Dec 2017 17:15:55 +0530
Message-ID: <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1512733561;
        bh=J0Tcm2GVfKJMsP8Ui99hwH4AJP0Tl3COyGEyVMfRL1s=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=Agpa1+cn2xyAm4YHEu+PJq7RoDTZEhtPf6NfuhbBGg530LC0nfkLk40/FBZv9Aw+8
         9ONbbrMOOyenfSIm8i0AbOaYN3cXpXwKRVMu+qXEvwPdGON9yO/WBE84L7/GC7pNLf
         991oCR9PJa04N5pzCnF5Eg5jDoJbp7AbhjPO/GIA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1512733560;
        bh=J0Tcm2GVfKJMsP8Ui99hwH4AJP0Tl3COyGEyVMfRL1s=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=Wei2UshNSqmUjaMcDGJlXM9hFY70XTm3FnMfg2AtbJQsrs+luDkqo4wl+HSZYFp37
         ukxruHxC1DDkMIYdljigId4EvSvn83HltdMk4GjAWlfSEkFG5EvDicKDKgPo3JtiQf
         VLAe/xJ82Vko6YpzfbABcBobG3fVme9AKBiOOI5M=
In-Reply-To: <4e63b5e9-1696-910f-16ac-4d4d7eb98725-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 12/08/2017 03:10 PM, Prateek Sood wrote:
> On 12/05/2017 04:31 AM, Peter Zijlstra wrote:
>> On Mon, Dec 04, 2017 at 02:58:25PM -0800, Tejun Heo wrote:
>>> Hello, again.
>>>
>>> On Mon, Dec 04, 2017 at 12:22:19PM -0800, Tejun Heo wrote:
>>>> Hello,
>>>>
>>>> On Mon, Dec 04, 2017 at 10:44:49AM +0530, Prateek Sood wrote:
>>>>> Any feedback/suggestion for this patch?
>>>>
>>>> Sorry about the delay.  I'm a bit worried because it feels like we're
>>>> chasing a squirrel.  I'll think through the recent changes and this
>>>> one and get back to you.
>>>
>>> Can you please take a look at the following pending commit?
>>>
>>>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d
>>>
>>> AFAICS, this should remove the circular dependency you originally
>>> reported.  I'll revert the two cpuset commits for now.
>>
>> So I liked his patches in that we would be able to go back to
>> synchronous sched_domain building.
>>
> https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d
> 
> This will fix the original circular locking dependency issue.
> I will let you both (Peter & TJ) to decide on which one to
> pick.
> 
> 
> 

TJ & Peter,

There is one deadlock issue during cgroup migration from cpu
hotplug path when a task T is being moved from source to
destination cgroup.

kworker/0:0
cpuset_hotplug_workfn()
   cpuset_hotplug_update_tasks()
      hotplug_update_tasks_legacy()
        remove_tasks_in_empty_cpuset()
          cgroup_transfer_tasks() // stuck in iterator loop
            cgroup_migrate()
              cgroup_migrate_add_task()

In cgroup_migrate_add_task() it checks for PF_EXITING flag of task T.
Task T will not migrate to destination cgroup. css_task_iter_start()
will keep pointing to task T in loop waiting for task T cg_list node
to be removed.

Task T
do_exit()
  exit_signals() // sets PF_EXITING
  exit_task_namespaces()
    switch_task_namespaces()
      free_nsproxy()
        put_mnt_ns()
          drop_collected_mounts()
            namespace_unlock()
              synchronize_rcu()
                _synchronize_rcu_expedited()
                  schedule_work() // on cpu0 low priority worker pool
                  wait_event() // waiting for work item to execute

Task T inserted a work item in the worklist of cpu0 low priority
worker pool. It is waiting for expedited grace period work item
to execute. This work item will only be executed once kworker/0:0
complete execution of cpuset_hotplug_workfn().

kworker/0:0 ==> Task T ==>kworker/0:0
 
Following suggested patch might not be able to fix the above
mentioned case:
https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d

Combination of following patches fixes above mentioned scenario
as well:
1) Inverting cpuset_mutex and cpu_hotplug_lock locking sequence
2) Making cpuset hotplug work synchronous 



-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
