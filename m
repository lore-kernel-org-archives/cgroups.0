From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Tue, 6 Nov 2018 09:06:01 -0500
Message-ID: <8c386375-b801-8adb-602e-40c73a7efedc@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
 <20181106115335.GQ22431@hirez.programming.kicks-ass.net>
 <20181106115558.GB22485@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181106115558.GB22485@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 11/06/2018 06:55 AM, Peter Zijlstra wrote:
> On Tue, Nov 06, 2018 at 12:53:35PM +0100, Peter Zijlstra wrote:
>> On Mon, Nov 05, 2018 at 08:36:56AM -0800, Tejun Heo wrote:
>>> Hello,
>>>
>>> So, this looks good to me.  Peter, I'm gonna roll the series into
>>> cgroup/for-4.21-cpuset.  Please holler if you have any objections /
>>> comments.
>> Mostly nits, except I think the interface for cpuset.sched.partition
>> needs to find another term for "not a parition", "normal" really doesn't
>> work for me.
> cpuset.sched.partition: "true", "false", "error"
>
> makes more sense to me.

The terms "true", "false", "error" look good to me. I can change the
patchset to use those if Tejun has no objection. I will fix the other
nits you have as well.

Cheers,
Longman

