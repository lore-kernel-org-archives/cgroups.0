From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 2/6] cgroup: Enable bypass mode in cgroup v2
Date: Thu, 22 Jun 2017 16:07:10 -0400
Message-ID: <96422b73-9cda-aebc-5a58-7b8be0eba7c4@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-3-git-send-email-longman@redhat.com>
 <20170621211701.GB14720@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B448565403
In-Reply-To: <20170621211701.GB14720-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 06/21/2017 05:17 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> Let's first talk about and make sense of high level semantics.
>
> On Wed, Jun 14, 2017 at 11:05:33AM -0400, Waiman Long wrote:
>> +In the example below, '+' corresponds to an enabled controller and
>> +corresponds to a bypassed controller.
>> +
>> +   +   #   #   #   +
>> +   A - B - C - D - E
>> +         \ F
>> +	   +
>> +In this case, the effective hiearchy is:
>> +
>> +	A|B|C|D - E
>> +	        \ F
> I think that this definitely has potential.  While different
> controllers may see differently abbreviated versions of the tree, they
> can still be mapped to the same hierarchy and we can implement
> cross-controller operations in a meaningful way, I think; however, it
> does make some things really weird.
>
> In the above example, how would A's resources be distributed.  Let's
> say the resource knob in question is memory.high.  Because from memory
> controller's point of view A|B|C|D are all bunched up and have E and F
> as children, memory.high resource knobs on E and F would control how
> A's memory gets distributed, right?

That is right.

> So, once a parent skips a controller with #, you can only determine
> how its resources are actually distributed by scanning the entire
> subtree to determine the span of '#' on the controller and any sort of
> delegation - whether implicit or explicit - wouldn't be possible in
> the middle, right?

That is right, too.

> Can you please think of / explain how this would work with delegation?
> Making things clear with delegation is really helpful because it can
> serve as the canary for the usual hierarchical operations.

+   #   +
A - B - C
        \ D +

In term of delegation story, I would say that for the above
configuration, the parent A can delegate 5 units of resources to B. B,
upon finding out it has 5 units of resources, may decide to take itself
out of the picture (bypass itself) and delegate, say, 2 units to C and 3
units to D assuming that B has no internal process.

Of course, B can decide to ignore the rules, bypass itself and add
internal process to compete with other children of A. So we can make
"cgroup.controllers" non-writable to B if we don't want any controllers
to be bypassed.

As a side note, I have another delegation story for enabling bypass mode
in subtree_control. A parent can activate a controller in bypass mode to
signal that it has delegated the authority to enable a controller to its
children. A child can then activate a controller by writing '+' to its
cgroup.controllers (not implemented yet). In this scenario, the child
own the control knobs, not the parent. That can be useful for
controllers that deal with ID or membership like devices, freezer,
perf_event or even cpusets. You may not want to have separate IDs for
all the nodes in the hierarchy, but for those who need a different ID,
they can choose to do that. In fact, I am thinking if it may be useful
to define a bypass_on_dfl attribute that work like implicit_on_dfl so
that we don't need to explicitly set those controllers in bypass mode.

Cheers,
Longman




