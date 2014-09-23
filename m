From: Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
Date: Tue, 23 Sep 2014 09:12:53 +0100
Message-ID: <54212B85.7060806@arm.com>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-3-git-send-email-juri.lelli@arm.com> <20140919212547.GG2832@worktop.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140919212547.GG2832-IIpfhp3q70wB9AHHLWeGtNQXobZC6xk2@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "raistlin-k2GhghHVRtY@public.gmane.org" <raistlin-k2GhghHVRtY@public.gmane.org>, "michael-dyjBcgdgk7Pe9wHmmfpqLFaTQe2KTcn/@public.gmane.org" <michael-dyjBcgdgk7Pe9wHmmfpqLFaTQe2KTcn/@public.gmane.org>, "fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org" <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "vincent-9z8vmPu0pS/iB9QmIjCX8w@public.gmane.org" <vincent-9z8vmPu0pS/iB9QmIjCX8w@public.gmane.org>, "luca.abeni-3IIOeSMMxS4@public.gmane.org" <luca.abeni-3IIOeSMMxS4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Peter,

On 19/09/14 22:25, Peter Zijlstra wrote:
> On Fri, Sep 19, 2014 at 10:22:40AM +0100, Juri Lelli wrote:
>> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
>> affinity (performing what is commonly called clustered scheduling).
>> Unfortunately, such thing is currently broken for two reasons:
>>
>>  - No check is performed when the user tries to attach a task to
>>    an exlusive cpuset (recall that exclusive cpusets have an
>>    associated maximum allowed bandwidth).
>>
>>  - Bandwidths of source and destination cpusets are not correctly
>>    updated after a task is migrated between them.
>>
>> This patch fixes both things at once, as they are opposite faces
>> of the same coin.
>>
>> The check is performed in cpuset_can_attach(), as there aren't any
>> points of failure after that function. The updated is split in two
>> halves. We first reserve bandwidth in the destination cpuset, after
>> we pass the check in cpuset_can_attach(). And we then release
>> bandwidth from the source cpuset when the task's affinity is
>> actually changed. Even if there can be time windows when sched_setattr()
>> may erroneously fail in the source cpuset, we are fine with it, as
>> we can't perfom an atomic update of both cpusets at once.
> 
> The thing I cannot find is if we correctly deal with updates to the
> cpuset. Say we first setup 2 (exclusive) sets A:cpu0 B:cpu1-3. Then
> assign tasks and then update the cpu masks like: B:cpu2,3, A:cpu1,2.
> 

Right, next week I should be able to properly test this.

Thanks a lot,

- Juri
