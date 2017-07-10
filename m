From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Mon, 10 Jul 2017 17:01:19 -0400
Message-ID: <8f9c83d7-cadf-3a41-8e56-5828d5abfa26@redhat.com>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org> <20170627070143.GB4114@worktop>
 <20170630132324.GA18669@htj.duckdns.org>
 <20170710083200.poevcjo7x47hy5ni@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com CE5003D956
In-Reply-To: <20170710083200.poevcjo7x47hy5ni-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 07/10/2017 04:32 AM, Peter Zijlstra wrote:
> On Fri, Jun 30, 2017 at 09:23:24AM -0400, Tejun Heo wrote:
>> On Tue, Jun 27, 2017 at 09:01:43AM +0200, Peter Zijlstra wrote:
>>> On Mon, Jun 12, 2017 at 05:27:53PM -0400, Tejun Heo wrote:
>>> IIRC the problem with the 'threaded' marker is that it doesn't clearly
>>> capture what a resource domain is.
>>>
>>> That is, assuming that a thread root is always a resource domain, we get
>>> the following problem:
>>>
>>> If we set 'threaded' on the root group in order to create a thread
>>> (sub)group. If we then want to create another domain group, we'd have to
>>> clear 'threaded' on that.
>>>
>>> 	R (t=1)
>>>        / \
>>> (t=1) T   D (t=0)
>>>
>>> So far so good. However, now we want to create another thread group
>>> under our domain group D, so we have to set its 'threaded' marker again:
>>>
>>> 	R (t=1)
>>>        / \
>>> (t=1) T   D (t=1)
>>>          /
>>> 	T (t=1)

This configuration is actually not possible with Tejun's latest v3 patch
which took out the "join" operation. Maybe we should keep the "join"
operation if this configuration is likely to happen.

>>> And we can no longer identify D as a resource domain. If OTOH we mark
>>> 'domain' we get:
>>>
>>> 	R (d=1)
>>>        / \
>>> (d=0) T   D (d=1)
>>>          /
>>> 	T (d=0)
>>>
>>> Which clearly identifies the domains and the thread only groups.
>> So, the difference between the two interfaces is that the one I
>> proposed is marking the thread root which makes all its descendants
>> threaded while the above is marking each individual cgroup as being
>> whether a resource domain or threaded.
> You start by marking the thread root, but then continue to mark all
> 'threaded' (including root). This then leads to the problem described
> above where you cannot (easily) (re)discover what the actual root is.

I don't think that is true. Internally, we can always find out if a
cgroup is a thread root. Externally, the presence of resource domain
control knobs in a threaded cgroup will indicate that it is a thread root.

> My proposal differs in that we retain a clear difference between
> resource domain / root and threaded (sub)trees.

For me, I have no preference of using either the threaded or the domain
marker as long as some kind of join operation that allows the
configuration above is present in the thread mode. They both looks good
to me. It is just a matter of which aspect of the cgroup we want to
emphasize. I would suggest we reach a consensus ASAP and move forward to
other more substantial issues in cgroup v2.

Cheers,
Longman
