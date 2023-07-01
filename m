From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Sat, 1 Jul 2023 19:46:37 -0400
Message-ID: <a6c55b82-71eb-ad18-e4b2-d62f1102a0e4@redhat.com>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <9244d968-b25a-066f-2ff3-1281bf03983e@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688255202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDU61wNE5DfHlHzCDfWw1kbbpWQEnHGkk8TG6nyshaY=;
        b=ODsg2iHVZedkeCMTONW9vuiMxxHwjBM16fUSpv2ZjZgr5qKmDx6lD86GPMO77EsT57H9w4
        TO60UgcW9VmK8/UW30RQ3wMjDCep5R9qSb4+W+s77RDU5bheBhYB5nc0puMB6xwW+1NoRq
        ki6noCGShPrtNW4R4w2Ud98a7UeVys0=
Content-Language: en-US
In-Reply-To: <9244d968-b25a-066f-2ff3-1281bf03983e@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Miaohe Lin <linmiaohe@huawei.com>, tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/1/23 19:38, Waiman Long wrote:
> On 7/1/23 02:50, Miaohe Lin wrote:
>> update_parent_subparts_cpumask() is called outside RCU read-side 
>> critical
>> section without holding extra css refcnt of cp. In theroy, cp could be
>> freed at any time. Holding extra css refcnt to ensure cp is valid while
>> updating parent subparts cpumask.
>>
>> Fixes: d7c8142d5a55 ("cgroup/cpuset: Make partition invalid if 
>> cpumask change violates exclusivity rule")
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>   kernel/cgroup/cpuset.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 58e6f18f01c1..632a9986d5de 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1806,9 +1806,12 @@ static int update_cpumask(struct cpuset *cs, 
>> struct cpuset *trialcs,
>>           cpuset_for_each_child(cp, css, parent)
>>               if (is_partition_valid(cp) &&
>>                   cpumask_intersects(trialcs->cpus_allowed, 
>> cp->cpus_allowed)) {
>> +                if (!css_tryget_online(&cp->css))
>> +                    continue;
>>                   rcu_read_unlock();
>>                   update_parent_subparts_cpumask(cp, 
>> partcmd_invalidate, NULL, &tmp);
>>                   rcu_read_lock();
>> +                css_put(&cp->css);
>>               }
>>           rcu_read_unlock();
>>           retval = 0;
>
> Thanks for finding that. It looks good to me.
>
> Reviewed-by: Waiman Long <longman@redhat.com>

Though, I will say that an offline cpuset cannot be a valid partition 
root. So it is not really a problem. For correctness sake and 
consistency with other similar code, I am in favor of getting it merged.

Cheers,
Longman

