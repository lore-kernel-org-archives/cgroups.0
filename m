From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 2/4] cgroup: Allow bypass mode in subtree_control
Date: Tue, 1 Aug 2017 10:29:44 -0400
Message-ID: <a5f95e93-2708-12a4-b794-99b9cabc7fc3@redhat.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-3-git-send-email-longman@redhat.com>
 <20170722135030.GC3329631@devbig577.frc2.facebook.com>
 <3cf09046-7eac-82fe-8bd2-6aef1125b10c@redhat.com>
 <20170725171343.GB3216015@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725171343.GB3216015@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/25/2017 01:13 PM, Tejun Heo wrote:
>>
>> Bypass mode targets mainly non-domain controllers and controllers that
>> have cost associated with each additional level of hierarchy (e.g. cpu).
>> I believe the end goal of cgroup v2 is to have all controllers migrated
>> to it eventually. Consider the following:
>>
>>     A
>>    / \
>>   B   C
>>  / \ / \
>> D  E F G
>>
>> Controller X may want (A, B, C) to be controlled as one group with one
>> set of control files whereas D, E, F, G will have their own control
>> files. Controller Y may want all of them have their own control files.
>> Bypass mode allows us to do that. With more and more controllers enabled
>> in v2, the chance of this kind of configuration conflicts is going up.
> I think I understand what it wants to do but I think it's still
> lacking justfications given how invasive the change is to the basic
> operation and usage.  We need more than one can think of this and it

I don't think it is as invasive as you have suggested. The latest patch
doesn't change the semantics of the cgroup control operation as long as
the bypass mode isn't used in subtree_control.

A major feature enabled by this mode is that instead of enabling a
controller in all its children, the bypass mode allows us to choose
which children will have the controller enabled. As for the ownership
question, I am going to change the description so that control files in
the children are still going to be owned by the parent to minimize
changes to basic operation.

> can help with certain hypothetical use cases.  ie. along the line of
> what the actual use cases are, what our overhead looks like and why,
> and why the problem can't be solved in a different, hopefully less
> intrusive, way.

A common use case is an application that want to use cpuset, for
example, to bind some worker threads to individual cpus. At the same
time, the application may also want to use cpu controller to limit the
amount of cpu consumed by some other threads. Right now, the only way to
do that with the current v2 control scheme is to create child cgroups
with both cpu and cpuset controllers enabled and put the desired
processes or threads into those child cgroups. The cost of enabling
cpuset on a task that need cpu controller is negligible. However, the
cost of enabling cpu controller on tasks that only need cpuset can be
noticeable. The performance difference may become a concern for users to
move from cgroup v1 to v2. If our goal is to retire cgroup v1
eventually, we need to make cgroup v2 as performant as cgroup v1.

The cpu controller also have a higher memory cost than other cgroup
controller due to the fact that it requires percpu runqueue structure
that is pretty big especially on system with many cpus. As a result,
more memory will be wasted on tasks that only need cpuset.

With bypass mode, you can put tasks that need cpu controller into a
child cgroups with only cpu controller enabled and put tasks that need
cpuset into child cgroups with only cpuset enabled, similar to what
users can now do on cgroup v1.

I think there is enough justification to have the bypass mode feature in
cgroup v2. I would like to know what other concern do you have with this
feature.

Cheers,
Longman




