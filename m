From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 05/12] cpuset: Add an error state to
 cpuset.sched.partition
Date: Tue, 6 Nov 2018 09:17:29 -0500
Message-ID: <98a0b581-584b-ef6e-e38b-20ab601b7c05@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-6-git-send-email-longman@redhat.com>
 <20181106113712.GL22431@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181106113712.GL22431@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 11/06/2018 06:37 AM, Peter Zijlstra wrote:
> On Mon, Oct 15, 2018 at 04:29:30PM -0400, Waiman Long wrote:
>> Handling error returned by update_parent_subparts_cpumask() in
>> update_cpumasks_hier() is problematic as the states may become
>> inconsistent. To avoid that and increase flexibility in handling other
>> error cases, a new error state (-1) is added to the partition_root_state
>> flag. This new error state is set internally and user cannot write this
>> value to "cpuset.sched.partition".
>>
>> In this error state, the partition root becomes an erroneous one. It is
>> no longer a real partition root, but the CS_CPU_EXCLUSIVE flag will
>> still be set as it can be changed back to a real one if appropriate
>> change happens later on.
> I feel this Changelog should be much more explicit about the reasons
> this -1 state can happen. As is, I've got no clue.

OK, I will elaborate more on this changelog.

Cheers,
Longman

