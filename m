From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 2/2] cpuset: Add cpuset.flags control knob to v2
Date: Tue, 20 Mar 2018 16:43:44 -0400
Message-ID: <066acb95-3140-904d-f599-84c1f94ad27c@redhat.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-3-git-send-email-longman@redhat.com>
 <20180319162654.GR2943022@devbig577.frc2.facebook.com>
 <8e553b7e-cab6-1b5d-9110-cc5770ae16c4@redhat.com>
 <cbe9b852-80b6-8341-b51c-4d754d00ce53@redhat.com>
 <20180320202247.GQ519464@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180320202247.GQ519464@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/20/2018 04:22 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, Mar 20, 2018 at 04:12:25PM -0400, Waiman Long wrote:
>> After some thought, I am planning to impose the following additional
>> constraints on how sched_load_balance works in v2.
>>
>> 1) sched_load_balance will be made hierarchical, the child will inherit
>> the flag from its parent.
>> 2) cpu_exclusive will be implicitly associated with sched_load_balance.
>> IOW, sched_load_balance => !cpu_exclusive, and !sched_load_balance =>
>> cpu_exclusive.
>> 3) sched_load_balance cannot be 1 on a child if it is 0 on the parent.
>>
>> With these changes, sched_load_balance will have to be set by the parent
>> and so will not be delegatable. Please let me know your thought on that.
> So, for configurations, we usually don't let them interact across
> hierarchy because that can lead to configurations surprise-changing
> and delegated children locking the parent into the current config.
>
> This case could be different and as long as we always guarantee that
> an ancestor isn't limited by its descendants in what it can configure,
> it should be okay (e.g. an ancestor should always be able to turn on
> sched_load_balance regardless of how the descendants are configured).

Yes, I will do some testing to make sure that a descendant won't be able
to affect how the ancestors can behave.

> Hmmm... can you explain why sched_load_balance needs to behave this
> way?

It boils down to the fact that it doesn't make sense to have a CPU in an
isolated cpuset to participate in load balancing in another cpuset as
Mike has said before. It is especially true in a parent-child
relationship where a delegatee can escape CPU isolation by re-enabling
sched_load_balance in a child cpuset.

Cheers,
Longman

