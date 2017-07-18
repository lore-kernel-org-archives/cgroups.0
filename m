From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 10:37:41 -0400
Message-ID: <5fa00590-551f-85d2-511b-ef4033781228@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 04D9D80480
In-Reply-To: <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/17/2017 04:56 PM, Waiman Long wrote:
> On 07/17/2017 10:14 AM, Peter Zijlstra wrote:
>> On Sun, Jul 16, 2017 at 10:07:20PM -0400, Tejun Heo wrote:
>>> v4: - Updated to marking each cgroup threaded as suggested by PeterZ.
>>>
>>> +On creation, a cgroup is always a domain cgroup and can be made
>>> +threaded by writing "threaded" to the "cgroup.type" file.  The
>>> +operation is single direction::
>>> +
>>> +  # echo threaded > cgroup.type
>>> +
>>> +Once threaded, the cgroup can't be made a domain again.  To enable the
>>> +thread mode, the following conditions must be met.
>>> +
>>> +- As the cgroup will join the parent's resource domain.  The parent
>>> +  must either be a valid (threaded) domain or a threaded cgroup.
>>> +
>>> +- The cgroup must be empty.  No enabled controllers, child cgroups or
>>> +  processes.
>>> +
>>> +Topology-wise, a cgroup can be in an invalid state.  Please consider
>>> +the following toplogy::
>>> +
>>> +  A (threaded domain) - B (threaded) - C (domain, just created)
>>> +

Thinking about it some more. There is a place for invalid domain. It is
not the child of a threaded cgroup. It is the siblings of a threaded
cgroup whose parent is not root.

       Root - A (domain) - B (domain)
                         \ C (domain)

With "echo threaded > B/cgroup.type":

       Root - A (threaded domain) - B (threaded)
                                  \ C (domain, invalid)

Any children of a threaded cgroup should be threaded.

Cheers,
Longman

