From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Mon, 3 Jul 2023 10:58:19 +0800
Message-ID: <53486caa-8ca7-78f5-71ac-d5692b482c94@huawei.com>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <9244d968-b25a-066f-2ff3-1281bf03983e@redhat.com>
 <a6c55b82-71eb-ad18-e4b2-d62f1102a0e4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a6c55b82-71eb-ad18-e4b2-d62f1102a0e4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 2023/7/2 7:46, Waiman Long wrote:
> On 7/1/23 19:38, Waiman Long wrote:
>> On 7/1/23 02:50, Miaohe Lin wrote:
>>> update_parent_subparts_cpumask() is called outside RCU read-side critical
>>> section without holding extra css refcnt of cp. In theroy, cp could be
>>> freed at any time. Holding extra css refcnt to ensure cp is valid while
>>> updating parent subparts cpumask.
>>>
>>> Fixes: d7c8142d5a55 ("cgroup/cpuset: Make partition invalid if cpumask change violates exclusivity rule")
>>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   kernel/cgroup/cpuset.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 58e6f18f01c1..632a9986d5de 100644
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
>>>               }
>>>           rcu_read_unlock();
>>>           retval = 0;
>>
>> Thanks for finding that. It looks good to me.
>>
>> Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Though, I will say that an offline cpuset cannot be a valid partition root. So it is not really a problem. For correctness sake and consistency with other similar code, I am in favor of getting it merged.

Yes, cpuset_mutex will prevent cpuset from being offline while update cpumask. And as you mentioned, this patch makes code more consistency at least.
Thanks for your review and comment.



