From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 3/3] cgroup/cpuset: Allow only one active attach operation
 per cpuset
Date: Fri, 7 Apr 2023 11:30:14 -0400
Message-ID: <89853ab9-7759-11bf-f751-28ce81a4f02e@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-4-longman@redhat.com>
 <20230406-haselnuss-baumhaus-83dc05f869df@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680881420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5eE8zuLKcMzLpL2FtuAWtdIO+Pdjkebtgu24Aa6llV4=;
        b=iK2cqat/1HxdjEPmCY/4Iz8jN3u9tMlB34biFOIjmeYkhesgel5aDWszvfvh7FAaW1kgFi
        OMem8TpMlRtk1EsfikgTIiCS944ZxkM2MGqlMFHS0hb5o5cct7hLKrZbB1wvvqG+KIz+1x
        Rro8E4+bpVsH8GOcLhhBqQz2IRjKRIA=
Content-Language: en-US
In-Reply-To: <20230406-haselnuss-baumhaus-83dc05f869df@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christian Brauner <brauner@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, gscrivan@redhat.com

On 4/6/23 05:44, Christian Brauner wrote:
> On Fri, Mar 31, 2023 at 10:50:45AM -0400, Waiman Long wrote:
>> The current cpuset code uses the global cpuset_attach_old_cs variable
>> to store the old cpuset value between consecutive cpuset_can_attach()
>> and cpuset_attach() calls. Since a caller of cpuset_can_attach() may
>> not need to hold the global cgroup_threadgroup_rwsem, parallel cpuset
>> attach operations are possible.
>>
>> When there are concurrent cpuset attach operations in progress,
>> cpuset_attach() may fetch the wrong value from cpuset_attach_old_cs
>> causing incorrect result.  To avoid this problem while still allowing
>> certain level of parallelism, drop cpuset_attach_old_cs and use a
>> per-cpuset attach_old_cs value. Also restrict to at most one active
>> attach operation per cpuset to avoid corrupting the value of the
>> per-cpuset attach_old_cs value.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 19 ++++++++++++++-----
>>   1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 2367de611c42..3f925c261513 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -198,6 +198,8 @@ struct cpuset {
>>   
>>   	/* Handle for cpuset.cpus.partition */
>>   	struct cgroup_file partition_file;
>> +
>> +	struct cpuset *attach_old_cs;
>>   };
>>   
>>   /*
>> @@ -2456,22 +2458,27 @@ static int fmeter_getrate(struct fmeter *fmp)
>>   	return val;
>>   }
>>   
>> -static struct cpuset *cpuset_attach_old_cs;
>> -
>>   /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
>>   static int cpuset_can_attach(struct cgroup_taskset *tset)
>>   {
>>   	struct cgroup_subsys_state *css;
>> -	struct cpuset *cs;
>> +	struct cpuset *cs, *oldcs;
>>   	struct task_struct *task;
>>   	int ret;
>>   
>>   	/* used later by cpuset_attach() */
>> -	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
>> +	oldcs = task_cs(cgroup_taskset_first(tset, &css));
>>   	cs = css_cs(css);
>>   
>>   	percpu_down_write(&cpuset_rwsem);
>>   
>> +	/*
>> +	 * Only one cpuset attach operation is allowed for each cpuset.
>> +	 */
>> +	ret = -EBUSY;
>> +	if (cs->attach_in_progress)
>> +		goto out_unlock;
> That'll mean CLONE_INTO_CGROUP becomes even more interestig because it
> isn't subject to this restriction in contrast to fork()+migrate, right?

This patch is not related to the CLONE_INTO_CGROUP. In fact, I have 
dropped that in latter version.

Cheers,
Longman

