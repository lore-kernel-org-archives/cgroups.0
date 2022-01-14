From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] set_cpus_allowed_ptr() call failed at cpuset_attach()
Date: Fri, 14 Jan 2022 15:33:34 -0500
Message-ID: <8bda2a8d-7faf-621d-c3c0-6351a49219ea@redhat.com>
References: <09ce5796-798e-83d0-f1a6-ba38a787bfc5@huawei.com>
 <4415cd09-6de3-bb2d-386d-8beb4927fb46@huawei.com>
 <YeGi2yjRi/uZIF/2@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642192422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JSMWn4K5l2lYnB0cb+D9eToBHXluoZS4fKlQdOWiSk=;
        b=EdrYShyqeowt+5L/jnQw0MRxF11d89aFiND9bpiipnhelmL8LtZuLSapF5/xveSQAIUQOa
        4yVFcgomP5/GMj5ODA5c9TEECyNwmEVgDe+KXjDRpg4bN8otohMQkA9NpVA0mI+lXCpZFn
        uamfLDIXsdSLxHdX+Vh6VmKsgZn/hrc=
Content-Language: en-US
In-Reply-To: <YeGi2yjRi/uZIF/2@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 1/14/22 11:20, Tejun Heo wrote:
> (cc'ing Waiman and Michal and quoting whole body)
>
> Seems sane to me but let's hear what Waiman and Michal think.
>
> On Fri, Jan 14, 2022 at 09:15:06AM +0800, Zhang Qiao wrote:
>> Hello everyone
>>
>> 	I found the following warning log on qemu. I migrated a task from one cpuset cgroup to
>> another, while I also performed the cpu hotplug operation, and got following calltrace.
>>
>> 	This may lead to a inconsistency between the affinity of the task and cpuset.cpus of the
>> dest cpuset, but this task can be successfully migrated to the dest cpuset cgroup.
>>
>> 	Can we use cpus_read_lock()/cpus_read_unlock() to guarantee that set_cpus_allowed_ptr()
>> doesn't fail, as follows:
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index d0e163a02099..2535d23d2c51 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2265,6 +2265,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>>          guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
>>
>>          cgroup_taskset_for_each(task, css, tset) {
>> +               cpus_read_lock();
>>                  if (cs != &top_cpuset)
>>                          guarantee_online_cpus(task, cpus_attach);
>>                  else
>> @@ -2274,6 +2275,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>>                   * fail.  TODO: have a better way to handle failure here
>>                   */
>>                  WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
>> +               cpus_read_unlock();
>>
>>
>> 	Is there a better solution?
>>
>> 	Thanks

The change looks OK to me. However, we may need to run the full set of 
regression test to make sure that lockdep won't complain about potential 
deadlock.

Cheers,
Longman

