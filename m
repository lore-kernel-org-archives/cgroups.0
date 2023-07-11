From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Tue, 11 Jul 2023 10:52:02 +0800
Message-ID: <30b1f809-a11b-efe8-289c-04a801f20207@huawei.com>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
 <74f1906e-fe58-c745-a851-b160374f7acf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <74f1906e-fe58-c745-a851-b160374f7acf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/10 23:40, Waiman Long wrote:
> On 7/10/23 11:11, Michal Koutný wrote:
>> Hello.
>>
>> On Sat, Jul 01, 2023 at 02:50:49PM +0800, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1806,9 +1806,12 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>>>           cpuset_for_each_child(cp, css, parent)
>>>               if (is_partition_valid(cp) &&
>>>                   cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
>>> +                if (!css_tryget_online(&cp->css))
>>> +                    continue;
>>>                   rcu_read_unlock();
>>>                   update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
>>>                   rcu_read_lock();
>>> +                css_put(&cp->css);
>> Apologies for a possibly noob question -- why is RCU read lock
>> temporarily dropped within the loop?
>> (Is it only because of callback_lock or cgroup_file_kn_lock (via
>> notify_partition_change()) on PREEMPT_RT?)
>>
>>
>>
>> [
>> OT question:
>>     cpuset_for_each_child(cp, css, parent)                (1)
>>         if (is_partition_valid(cp) &&
>>             cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
>>             if (!css_tryget_online(&cp->css))
>>                 continue;
>>             rcu_read_unlock();
>>             update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
>>               ...
>>               update_tasks_cpumask(cp->parent)
>>                 ...
>>                 css_task_iter_start(&cp->parent->css, 0, &it);    (2)
>>                   ...
>>             rcu_read_lock();
>>             css_put(&cp->css);
>>         }
>>
>> May this touch each task same number of times as its depth within
>> herarchy?
> 
> I believe the primary reason is because update_parent_subparts_cpumask() can potential run for quite a while. So we don't want to hold the rcu_read_lock for too long. There may also be a potential that schedule() may be called.

IMHO, the reason should be as same as the below commit:

commit 2bdfd2825c9662463371e6691b1a794e97fa36b4
Author: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Feb 2 22:31:03 2022 -0500

    cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

    It was found that a "suspicious RCU usage" lockdep warning was issued
    with the rcu_read_lock() call in update_sibling_cpumasks().  It is
    because the update_cpumasks_hier() function may sleep. So we have
    to release the RCU lock, call update_cpumasks_hier() and reacquire
    it afterward.

    Also add a percpu_rwsem_assert_held() in update_sibling_cpumasks()
    instead of stating that in the comment.

Thanks both.

