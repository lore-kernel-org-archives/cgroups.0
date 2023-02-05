From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup/cpuset: Don't update tasks' cpumasks for
 cpu offline events
Date: Sat, 4 Feb 2023 23:40:31 -0500
Message-ID: <68d7c246-a678-df0c-6f54-d69725a085cc@redhat.com>
References: <20230202143200.128753-1-longman@redhat.com>
 <20230202143200.128753-3-longman@redhat.com>
 <Y94oDD/8PDGqNLTH@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675572036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JW2YRqDb7Gl6nvlc0G6hG8NSEgmWXKugZCw7U0hwVUo=;
        b=QiUpUYqeYrCEIrBbgmLoaDfFUmBHVphb2rjP9e6tgQE9PiZOnWlOPntP2pKVBi/P0qZr1g
        MKg+ThDNElgKaUOeZuEdwIM6ix7ChqFFxWzCqr5MMDCuPhO0S48UtBcaQIiNCQXIZTx7oZ
        qKqsXPvx1OtWWCRPOlFKBKl5LYQiE1c=
Content-Language: en-US
In-Reply-To: <Y94oDD/8PDGqNLTH-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org


On 2/4/23 04:40, Peter Zijlstra wrote:
> On Thu, Feb 02, 2023 at 09:32:00AM -0500, Waiman Long wrote:
>> It is a known issue that when a task is in a non-root v1 cpuset, a cpu
>> offline event will cause that cpu to be lost from the task's cpumask
>> permanently as the cpuset's cpus_allowed mask won't get back that cpu
>> when it becomes online again. A possible workaround for this type of
>> cpu offline/online sequence is to leave the offline cpu in the task's
>> cpumask and do the update only if new cpus are added. It also has the
>> benefit of reducing the overhead of a cpu offline event.
>>
>> Note that the scheduler is able to ignore the offline cpus and so
>> leaving offline cpus in the cpumask won't do any harm.
>>
>> Now with v2, only the cpu online events will cause a call to
>> hotplug_update_tasks() to update the tasks' cpumasks. For tasks
>> in a non-root v1 cpuset, the situation is a bit different. The cpu
>> offline event will not cause change to a task's cpumask. Neither does a
>> subsequent cpu online event because "cpuset.cpus" had that offline cpu
>> removed and its subsequent onlining won't be registered as a change
>> to the cpuset. An exception is when all the cpus in the original
>> "cpuset.cpus" have gone offline once. In that case, "cpuset.cpus" will
>> become empty which will force task migration to its parent. A task's
>> cpumask will also be changed if set_cpus_allowed_ptr() is somehow called
>> for whatever reason.
>>
>> Of course, this patch can cause a discrepancy between v1's "cpuset.cpus"
>> and and its tasks' cpumasks. Howver, it can also largely work around
>> the offline cpu losing problem with v1 cpuset.
> I don't thikn you can simply not update on offline, even if
> effective_cpus doesn't go empty, because the intersection between
> task_cpu_possible_mask() and effective_cpus might have gone empty.
>
> Very fundamentally, the introduction of task_cpu_possible_mask() means
> that you now *HAVE* to always consider affinity settings per-task, you
> cannot group them anymore.

Right, it makes sense to me. That is why I am thinking that we should 
have an API like may_have_task_cpu_possible_mask() that returns true for 
heterogeneous systems. That will allow us to apply some optimizations in 
systems with homogeneous cpus. So far, this is an arm64 only feature. We 
shouldn't penalize other arches because arm64 needs that. In the future, 
maybe more arches will have that.

Cheers,
Longman


