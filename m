From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Wed, 7 Nov 2018 16:52:29 -0500
Message-ID: <9f4c7123-d8ea-fd80-55ea-82b8733aa07a@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
 <20181106115335.GQ22431@hirez.programming.kicks-ass.net>
 <20181106115558.GB22485@hirez.programming.kicks-ass.net>
 <8c386375-b801-8adb-602e-40c73a7efedc@redhat.com>
 <20181107213229.GB2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181107213229.GB2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 11/07/2018 04:32 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Nov 06, 2018 at 09:06:01AM -0500, Waiman Long wrote:
>> On 11/06/2018 06:55 AM, Peter Zijlstra wrote:
>>> On Tue, Nov 06, 2018 at 12:53:35PM +0100, Peter Zijlstra wrote:
>>>> On Mon, Nov 05, 2018 at 08:36:56AM -0800, Tejun Heo wrote:
>>>>> Hello,
>>>>>
>>>>> So, this looks good to me.  Peter, I'm gonna roll the series into
>>>>> cgroup/for-4.21-cpuset.  Please holler if you have any objections /
>>>>> comments.
>>>> Mostly nits, except I think the interface for cpuset.sched.partition
>>>> needs to find another term for "not a parition", "normal" really doesn't
>>>> work for me.
>>> cpuset.sched.partition: "true", "false", "error"
>>>
>>> makes more sense to me.
>> The terms "true", "false", "error" look good to me. I can change the
>> patchset to use those if Tejun has no objection. I will fix the other
>> nits you have as well.
> How about the following?
>
> Interface file is named "cpuset.cpus.partition" as it's a partition of
> cpus.  The writeable keys are "root" and "member" - a partition root
> and a partition member.  When "root" is requested but can't be
> satisfied it shows "root invalid".  This seems pretty consistent with
> cgroup.type and other cpuset files.
>
> Thanks.
>
Yes, that looks good. I will revise my patchset to include those changes
unless Peter has other better idea.

Thanks,
Longman

