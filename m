From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Mon, 17 Jul 2017 16:56:32 -0400
Message-ID: <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com AE2367A162
In-Reply-To: <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/17/2017 10:14 AM, Peter Zijlstra wrote:
> On Sun, Jul 16, 2017 at 10:07:20PM -0400, Tejun Heo wrote:
>> v4: - Updated to marking each cgroup threaded as suggested by PeterZ.
>>
>> +On creation, a cgroup is always a domain cgroup and can be made
>> +threaded by writing "threaded" to the "cgroup.type" file.  The
>> +operation is single direction::
>> +
>> +  # echo threaded > cgroup.type
>> +
>> +Once threaded, the cgroup can't be made a domain again.  To enable the
>> +thread mode, the following conditions must be met.
>> +
>> +- As the cgroup will join the parent's resource domain.  The parent
>> +  must either be a valid (threaded) domain or a threaded cgroup.
>> +
>> +- The cgroup must be empty.  No enabled controllers, child cgroups or
>> +  processes.
>> +
>> +Topology-wise, a cgroup can be in an invalid state.  Please consider
>> +the following toplogy::
>> +
>> +  A (threaded domain) - B (threaded) - C (domain, just created)
>> +
>> +C is created as a domain but isn't connected to a parent which can
>> +host child domains.  C can't be used until it is turned into a
>> +threaded cgroup.  "cgroup.type" file will report "domain (invalid)" in
>> +these cases.  Operations which fail due to invalid topology use
>> +EOPNOTSUPP as the errno.
>> +
>> +A domain cgroup is turned into a threaded domain when one of its child
>> +cgroup becomes threaded or threaded controllers are enabled in the
>> +"cgroup.subtree_control" file while there are processes in the cgroup.
>> +A threaded domain reverts to a normal domain when the conditions
>> +clear.
> AFAICT this is not in fact what I suggested... :/
>
> My proposal did not have that invalid state. It would simply refuse to
> change the type from thread to domain in the case where the parent is
> not a domain.
>
> Also, my proposal maintained the normal property inheritance rules. A
> child cgroup's creation 'type' would be that of its parent and not
> always be 'domain'.

I agree with Peter on this. A new cgroup created under a threaded cgroup
should always be threaded. I don't see a need for an intermediate
invalid domain.

Cheers,
Longman

