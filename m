Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE4844CF25
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780481127; cv=none; b=YRhzkMwK8Cn+pdGzN0uSUdfxVPKemzljNVCpC54+pacbHtE+wWGVJ+WQ0Ag5CdFjLLCS6jFyUKsAfAzgVB4bMAK5PTIHTzdb1tUgL86ovOBUf7wXpqLIckDku1HK6TcUbjeXXPP08rEJmsGFBEv7z1O9BaAY22BBvPRZQqa09UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780481127; c=relaxed/simple;
	bh=5VKyKkFGz84zAPIQQLvMW8v7xC3j1mSG8BYLNTBAYDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4162wS2LN1Sn4fMtXdNz0xcTYLPWdGYmWuLBbx/rjtVlYWg9F3MOMco6iI6XqvFe7BekVx3cow2674uFWNvavoSR899Nw2UqoArMh3Sb5auLlvuL1n3vSMa/xwmXRVCOtHHR8KaphNzvLXYzk3F6sWVwc/Ngo97HIdaCTXBbrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fxmf0PrU; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fxmf0PrU"
Message-ID: <4e7f7515-8960-4677-bd42-b83cd5f863ad@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780481122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DD0BK3aWz7e4cWGnJSR2bOOltOzwIU/8X0Yu2qlKJjg=;
	b=Fxmf0PrUHggRtboPNSsToWb8Do1UqvAKc/UXk0HUDZxGSsKSl8jpHjgmjHD4iA6UU+NH+s
	R1S50ycCbalKF4vO8iQWqiVn9tTUvIVSxR7pEVUsnTAvAhCSMTqjvhU6mlMFb0QU6As6L4
	PJ5R9BW2/DXC15zM9aXvh8hKYNLEzcU=
Date: Wed, 3 Jun 2026 18:05:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH cgroup/for-next v2 0/5] cgroup/cpuset: Support multiple
 source/destination cpusets for cpuset_*attach()
To: Waiman Long <longman@redhat.com>, Chen Ridong
 <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Aaron Tomlin <atomlin@atomlin.com>
References: <20260516042448.698216-1-longman@redhat.com>
 <3936b856-cf88-41a9-bb3f-4f48440e2692@linux.dev>
 <b91080da-486c-4df0-9e6b-8eb3364cae45@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <b91080da-486c-4df0-9e6b-8eb3364cae45@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 2026/5/27 4:12, Waiman Long wrote:
> 
> On 5/20/26 4:29 AM, Ridong Chen wrote:
>>
>>
>> On 2026/5/16 12:24, Waiman Long wrote:
>>> Sashiko AI review of another cpuset patch had found that cpuset_attach()
>>> and cpuset_can_attach() can be passed a cgroup_taskset with tasks
>>> migrating from one source cpuset to multiple destination cpusets and
>>> vice versa.  Further testing of the cpuset code indicates that this is
>>> indeed the case when the v2 cpuset controller is enabled or disabled.
>>>
>>> Unfortunately, cpuset_attach() and cpuset_can_attach() still assume that
>>> there will be one source and one destinaton cpuset which may result in
>>> inocrrect behavior.
>>>
>>
>> Hi Longman,
>>
>> I am thinking whether we can use the pids subsystem's approach to
>> solve this issue, which I think could be much simpler.
>>
>> For the DL task accounting, we can handle it the same way
>> pids_can_attach() does - just call task_cs(task) for each task
>> individually inside the can_attach() loop and do the nr_deadline_tasks
>> adjustment right there. This eliminates the need to pass per-task
>> source cpuset information to the attach() callback entirely for DL
>> accounting purposes.
> DL task accounting doesn't use the new oldcs stored in the task
> structure which is only used for mm migration. BTW, I believe
> task_cs(task) doesn't return the old cs in cpuset_attach().

Sorry for the late response.

If I understand correctly, for DL task accounting, we need to know the
destination cpuset to allocate bandwidth. The destination cpuset can be
obtained in cpuset_can_attach.

You are right that task_cs(task) does not return the old cpuset in
cpuset_attach(). But do we really need the old cpuset in cpuset_attach?
Is cpuset_attach_old_cs sufficient for mm migration?

>>
>> For cpuset_migrate_mm(), I don't think we need per-task oldcs storage
>> in task_struct either. The scenarios where multiple source cpusets are
>> involved are:
>>
>> enable cpuset controller: child cpusets inherit parent's
>> effective_mems, so attach_mems_updated is false and
>> cpuset_migrate_mm() is never called.
>>
>> disable cpuset controller: tasks move from children to parent. Since
>> children's effective_mems is always a subset of parent's
>> effective_mems, even if cpuset_migrate_mm() is triggered, it's
>> effectively a noop (no pages need to move from a subset to its superset).
>>
>> cgroup.procs write with threads in different cpusets: this is a
>> many-to-one migration with a single process, so there is only one
>> group_leader and one mm. We only need to record the leader's oldcs,
>> which a single static variable can handle.
>>
>> So in all cases, the migration path only needs one oldcs for the
>> leader. We don't need to add a field to task_struct.
>>
>> What do you think?
> 
> Yes, that makes sense. I will rework the patch series.
> 
> Thanks,
> Longman
> 
>>
>>
>>
>>> This patch series is created to fix this issue. The first 2 patches are
>>> just preparatory patches to make the remaining patches easier to review.
>>>
>>> Patch 3 adds a new attach_old_cs field into task_struct to track the
>>> old cpuset to be used in case when cpuset_migrate_mm() needs to be
>>> called in cpuset_attach().
>>>
>>> Patch 4 moves mpol_rebind_mm() and cpuset_migrate_mm() inside
>>> cpuset_attach_task() to make CLONE_INTO_CGROUP flag of clone(2) works
>>> more like moving task from one cpuset to another one, while also make
>>> supporting multiple source and destination cpusets easier.
>>>
>>> Patch 5 makes the necessary changes to enable the support of multiple
>>> source and destination cpusets by keeping all the source and destination
>>> cpusets found during task iterations in two singly linked lists for
>>> source and destination cpusets respectively.
>>>
>>> Waiman Long (5):
>>>    cgroup/cpuset: Add a cpuset_reserve_dl_bw() helper
>>>    cgroup/cpuset: Expand the scope of cpuset_can_attach_check()
>>>    cgroup/cpuset: Replace cpuset_attach_old_cs by a new attach_old_cs
>>>      field in task_struct
>>>    cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside
>>>      cpuset_attach_task()
>>>    cgroup/cpuset: Support multiple source/destination cpusets for
>>>      cpuset_*attach()
>>>
>>>   include/linux/sched.h           |   3 +
>>>   kernel/cgroup/cpuset-internal.h |   6 +
>>>   kernel/cgroup/cpuset.c          | 358 +++++++++++++++++++++-----------
>>>   3 files changed, 249 insertions(+), 118 deletions(-)
>>>
>>
> 
> 

-- 
Best regards,
Ridong
