From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Wed, 20 Jul 2022 17:31:51 +0530
Message-ID: <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
 <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=PounAutb3kLS4hWLQOwWstVt1Gn/0IZTeXgbAgcBKLU=;
 b=OhZNbju618cRfiZf7Eyko8mruqAG2W2TCSBDQiXAkINfmhpxzeQliRmkQyV/kZIjmWLG
 LzLAUrEVAgn8NK5k826QKAFr7spN01LkN9eCPlejYs+qRldvQFjqtHu4lPCmXhfc1Cep
 857O1djV0+Xj13rnAjGYUG0kG5E4vvT1wjyv+dwpAmj3V1Rv8Lwf4jHZ2nUhB7eQ9Ivy
 CrgLdIEtEU/AUiUlg/U1NlqP577UGnOCMlBRKm9WkAaEhq9JlwvnD7y3myufxuLaAmcX
 Ra9SYA0ssy+T5KYZXHLA1VwHUGBJ7+dj14aO6mzhNS0Jhe6okjRgxhaSJPTYGmt5Fz4M Yg== 
Content-Language: en-US
In-Reply-To: <ba48eac5-8ef7-251b-11fe-8163bb7a2d54-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Looks like these patches are the fixes.

https://lore.kernel.org/all/YtDvN0wJ6CKaEPN8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/#r

Would let Tejun confirm this .

-Mukesh

On 7/20/2022 4:36 PM, Mukesh Ojha wrote:
> Hi,
> 
> On 7/20/2022 8:57 AM, Imran Khan wrote:
>> Hello everyone,
>>
>> I am seeing a deadlock between cgroup_threadgroup_rwsem and 
>> cpu_hotplug_lock in
>> 5.4 kernel.
>>
>> Due to some missing drivers I don't have this test setup for latest 
>> upstream
>> kernel but looking at the code the issue seems to be present in the 
>> latest
>> kernel as well. If needed I can provide stack traces and other 
>> relevant info
>> from the vmcore that I have got from 5.4 setup.
>>
>> The description of the problem is as follows (I am using 5.19-rc7 as 
>> reference
>> below):
>>
>> __cgroup_procs_write acquires cgroup_threadgroup_rwsem via
>> cgroup_procs_write_start and then invokes cgroup_attach_task. Now
>> cgroup_attach_task can invoke following call chain:
>>
>> cgroup_attach_task --> cgroup_migrate --> cgroup_migrate_execute --> 
>> cpuset_attach
>>
>> Here cpuset_attach tries to take cpu_hotplug_lock.
>>
>> But by this time if some other context
>>
>> 1. is already in the middle of cpu hotplug and has acquired 
>> cpu_hotplug_lock in
>> _cpu_up but
>> 2. has not yet reached CPUHP_ONLINE state and
>> 3. one of the intermediate hotplug states (in my case 
>> CPUHP_AP_ONLINE_DYN ) has
>> a callback which involves creation of a thread (or invocation of 
>> copy_process
>> via some other path) the invoked copy_process will get blocked on
>> cgroup_threadgroup_rwsem in following call chain:
>>
>>     copy_process --> cgroup_can_fork --> cgroup_css_set_fork -->
>> cgroup_threadgroup_change_begin
> 
> Similar discussion is at [1], not sure on the conclusion.
> 
> [1]
> https://lore.kernel.org/lkml/20220705123705.764-1-xuewen.yan-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org/
> 
> -Mukesh
> 
>>
>>
>> I am looking for suggestions to fix this deadlock.
>>
>> Or if I am missing something in the above analysis and the above mention
>> scenario can't happen in latest upstream kernel, then please let me 
>> know as that
>> would help me in back porting relevant changes to 5.4 kernel because 
>> the issue
>> definitely exists in 5.4 kernel.
>>
>> Thanks,
>> -- Imran
