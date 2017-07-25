From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/4] cgroup: Allow bypass mode in subtree_control
Date: Tue, 25 Jul 2017 15:10:04 -0400
Message-ID: <7bdced01-c186-dc33-f68f-e66bee97b865@redhat.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-3-git-send-email-longman@redhat.com>
 <20170722135030.GC3329631@devbig577.frc2.facebook.com>
 <3cf09046-7eac-82fe-8bd2-6aef1125b10c@redhat.com>
 <20170725171343.GB3216015@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725171343.GB3216015-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 07/25/2017 01:13 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Jul 24, 2017 at 02:20:59PM -0400, Waiman Long wrote:
>> As said in patch 3, enabling bypass mode at subtree_control delegate the
>> authority of enabling controllers to the children. The children own the
>> resource control files directly. It will be more straight forward to
> But that doesn't work at all because such child would end up
> controlling the distribution of an ancestor's resources.  It breaks a
> fundamental property of the hierarchy.
>
>> explain if bypass mode can only be used consistently from the root down.
>> Having a mix of regular enable and bypass down the tree will be more
>> tricky to talk about.
> Hmmm... it isn't just being tricky.  As proposed, it is in direct
> conflict with the basic semantics of the resource hierarchy.
>
>>> * While the idea is interesting, I think we need more concrete
>>>   usecases to justify the addition and make sure that we aren't doing
>>>   something misguided.  Can you please illustrate / give examples of
>>>   how this would be useful?
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
> can help with certain hypothetical use cases.  ie. along the line of
> what the actual use cases are, what our overhead looks like and why,
> and why the problem can't be solved in a different, hopefully less
> intrusive, way.

As I said above that bypass mode can be useful for non-domain
controllers. For example, controllers like net_cls, net_prio just
provides an ID for classification. There is no resource for the parent
to control or distribute. We can, of course, make them implicit like
perf_event and activate them in all the cgroups. Alternatively, we can
use bypass and what let whatever cgroups that need it activate one for
themselves to avoid proliferation of unused IDs.

Another use case is the cpu controller. As discussed a while before,
scheduler intensive workload wills suffer with each additional level of
hierarchy even if nothing is running at the same time. Image the
following hierarchy:

    R
   / \
  A   B
 / \ / \
X  Y W Z

Supoose that memory consumption is the bottleneck and we use memory
controller to distribute memory resources to tasks in X, Y, W, Z. Also
suppose we have sufficient CPU resources available that we don't care
much about how much CPU they uses. Now, if tasks in cgroup X want to use
cpu controller to restrict the amount of CPU available to a subgroup of
tasks. Currently, the only way to do that is to have cpu controller
enabled all the way down from the root. Now all the tasks in Y, W & Z
will have to suffer the additional performance overhead of this extra
levels of cpu controller hierarchy. We also need to figure out how much
CPU resource will need to be partitioned among cgroups.

With bypass mode, you only need to activate the CPU controllers where it
is needed. The tasks in the other cgroups can just compete directly with
each other without worrying about resource partition and hierarchical
overhead. This is one example of the conflict of hierarchy problem I
mentioned before.

Even though I wrote that the children own the control files in their
cgroup in bypass mode, it is mainly a conceptual framework for
discussion purpose from my perspective. In reality, it is a matter of
who has the permission to write to cgroup.controller to re-enable a
bypassed controller and the corresponding controller files. So we can
define it either ways (by parent or by child) to  best fit the narrative
that we want to convey to the cgroup users. I don't care much about the
narrative. I care more about what capability and flexibility that can be
made available to the cgroup users.

In your nsdelegate mount option patch, only cgroup.procs and
cgroup.subtree_control are to be written by delegatees. So unless we
extend it to other control files, those other files are still
practically owned by the parent.

Cheers,
Longman



