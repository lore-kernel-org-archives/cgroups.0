From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Tue, 7 Mar 2023 21:29:56 -0500
Message-ID: <315efe55-abaf-c199-673b-95ef76a1e442@redhat.com>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <CA+khW7i_Sc0M4FXzojmQ5PSfkPwk6AdcbN9j0gDXZ9FsOMQAwA@mail.gmail.com>
 <f3a99500-e51c-032f-a0c6-01763f0a5be6@redhat.com>
 <CA+khW7iWAn6bbXdkJX1Lt4dWUsN6o4KqVQ8OFTs0B+VTtVjBkw@mail.gmail.com>
 <1f2cf8ea-a9d7-5245-0f69-eb8be9f64afc@redhat.com>
 <CA+khW7jQg6x_j70eARVF0eemP0txU_K9Lc=5kfBmU_KxsfbK2w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678242603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbv/Z0+2e9KA+90ir0NQlNBV1OxH+DFm151G8CV2Alw=;
        b=JsaAXjGsqfI9JwHovsaGHDa4mI89N8/ULuBTvX7MhaLLIQqQCr8H1GxjReYW/cR9xm7+Ff
        kSBMPZduNAa3l5J8D0PB5zvm5xEVeZxgdGDSCvxDsTImi0x14MZcFjnNi499QLRRWdCGjM
        N9mKx+2Gu+lnjC2nGvpqngpYeSF7Zu4=
Content-Language: en-US
In-Reply-To: <CA+khW7jQg6x_j70eARVF0eemP0txU_K9Lc=5kfBmU_KxsfbK2w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Hao Luo <haoluo@google.com>
Cc: Qais Yousef <qyousef@layalina.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, Dietmar Eggemann <dietmar.eggemann@arm.com>, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Sudeep Holla <sudeep.holla@arm.com>, Zefan Li <lizefan.x@bytedance.com>

On 3/7/23 17:17, Hao Luo wrote:
> On Tue, Mar 7, 2023 at 1:13 PM Waiman Long <longman@redhat.com> wrote:
>> On 3/7/23 16:06, Hao Luo wrote:
>>> On Tue, Mar 7, 2023 at 12:09 PM Waiman Long <longman@redhat.com> wrote:
>>>> On 3/7/23 14:56, Hao Luo wrote:
>>>>> On Mon, Feb 6, 2023 at 2:15 PM Qais Yousef <qyousef@layalina.io> wrote:
>>>>>> Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
>>>>>> enabled rebuilding root domain on cpuset and hotplug operations to
>>>>>> correct deadline accounting.
>>>>>>
>>>>>> Rebuilding root domain is a slow operation and we see 10+ of ms delays
>>>>>> on suspend-resume because of that (worst case captures 20ms which
>>>>>> happens often).
>>>>>>
>>>>>> Since nothing is expected to change on suspend-resume operation; skip
>>>>>> rebuilding the root domains to regain the some of the time lost.
>>>>>>
>>>>>> Achieve this by refactoring the code to pass whether dl accoutning needs
>>>>>> an update to rebuild_sched_domains(). And while at it, rename
>>>>>> rebuild_root_domains() to update_dl_rd_accounting() which I believe is
>>>>>> a more representative name since we are not really rebuilding the root
>>>>>> domains, but rather updating dl accounting at the root domain.
>>>>>>
>>>>>> Some users of rebuild_sched_domains() will skip dl accounting update
>>>>>> now:
>>>>>>
>>>>>>            * Update sched domains when relaxing the domain level in cpuset
>>>>>>              which only impacts searching level in load balance
>>>>>>            * update sched domains when cpufreq governor changes and we need
>>>>>>              to create the perf domains
>>>>>>
>>>>>> Users in arch/x86 and arch/s390 are left with the old behavior.
>>>>>>
>>>>>> Debugged-by: Rick Yiu <rickyiu@google.com>
>>>>>> Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
>>>>>> ---
>>>>> Hi Qais,
>>>>>
>>>>> Thank you for reporting this. We observed the same issue in our
>>>>> production environment. Rebuild_root_domains() is also called under
>>>>> cpuset_write_resmask, which handles writing to cpuset.cpus. Under
>>>>> production workloads, on a 4.15 kernel, we observed the median latency
>>>>> of writing cpuset.cpus at 3ms, p99 at 7ms. Now the median becomes
>>>>> 60ms, p99 at >100ms. Writing cpuset.cpus is a fairly frequent and
>>>>> critical path in production, but blindly traversing every task in the
>>>>> system is not scalable. And its cost is really unnecessary for users
>>>>> who don't use deadline tasks at all.
>>>> The rebuild_root_domains() function shouldn't be called when updating
>>>> cpuset.cpus unless it is a partition root. Is it?
>>>>
>>> I think it's because we were using the legacy hierarchy. I'm not
>>> familiar with cpuset partition though.
>> In legacy hierarchy, changing cpuset.cpus shouldn't lead to the calling
>> of rebuild_root_domains() unless you play with cpuset.sched_load_balance
>> file by changing it to 0 in the right cpusets. If you are touching
>> cpuset.sched_load_balance, you shouldn't change cpuset.cpus that often.
>>
> Actually, I think it's the opposite. If I understand the code
> correctly[1], it looks like rebuild_root_domains is called when
> LOAD_BALANCE _is_ set and sched_load_balance is 1 by default. Is that
> condition a bug?
>
> I don't think we updated cpuset.sched_load_balance.
>
> [1] https://github.com/torvalds/linux/blob/master/kernel/cgroup/cpuset.c#L1677

The only reason rebuild_root_domains() is called is because the the 
scheduling domains were changed. The cpuset.sched_load_balance control 
file is 1 by default. If no one touch it, there is just one global 
scheduling domain that covers all the active CPUs. However, by setting 
cpuset.sched_load_balance to 0 in the right cpusets, you can create 
multiple scheduling domains or disabling load balancing on some CPUs. 
With that setup, changing cpuset.cpus in the right place can cause 
rebuild_root_domains() to be called because the set of scheduling 
domains are changed.

Cheers,
Longman

