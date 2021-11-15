From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 15 Nov 2021 20:31:22 +0100
Message-ID: <20211115193122.GA16798@blackbody.suse.cz>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637004684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4ZiiwEnz5XGSlWeT8O+jkCefoPIbeg8p3rHgDHkvM8=;
        b=hfo7k3ahAq+4WiayhhOAps8Zu5wAe5DwJIiHDlPpeCzNbkiWPbAOOnNXVL2YcbwxT3z+aT
        8eO9nE9fZ/TfsPOuBb0fxmigq974glS7V22iBaPiyrHPEh5gmiV+m2TBjRM/BtzH8uwgqZ
        IkmYD5pRuYyF6FOldCIXVATt7yLJuiM=
Content-Disposition: inline
In-Reply-To: <20211018143619.205065-6-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Hello.

On Mon, Oct 18, 2021 at 10:36:18AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> +	When set to "isolated", the CPUs in that partition root will
> +	be in an isolated state without any load balancing from the
> +	scheduler.  Tasks in such a partition must be explicitly bound
> +	to each individual CPU.

This sounds reasonable but it seems to have some usability issues as was
raised in another thread [1]. (I could only think of the workaround of
single-cpu cgroup leaves + CLONE_INTO_CGROUP.)

TL;DR Do whatever you find suitable but (re)consider sticking to the
delegation principle (making hotplug and ancestor changes equal).

Now to the constraints and partition setups. I think it's useful to have
a model with which the implementation can be compared with.
I tried to condense some "simple rules" from the descriptions you posted
in v8 plus your response to my remarks in v7 [2]. These should only be
the "validity conditions", not "transition conditions".

## Validity conditions

For simplification, there's a condition called 'degraded' that tells
whether a cpuset can host tasks (with the given config) that expands to
two predicates:

	degraded := cpus.internal_effective == ø && has_tasks
	valid_root := !degraded && cpus_exclusive && parent.valid_root
	(valid_member := !degraded)

with a helping predicate
	cpus_exclusive := cpus not shared by a sibling

The effective CPUs basically combine configured+available CPUs

	cpus.internal_effective := (cpus ∩ parent.cpus ∩ online_cpus) - passed

where
	passed := union of children cpus whose partition is not member

Finally, to handle the degraded cpusets gracefully, we define

	if (!degraded)
		cpus.effective := cpus.internal_effective 
	else
		cpus.effective := parent.cpus.effective

(In cases when there's no parent, we replace its cpus with online_cpus.)

---

I'll try applying these conditions to your description.

> +
> +	"cpuset.cpus" must always be set up first before enabling
> +	partition.

This is just a transition condition.

>       Unlike "member" whose "cpuset.cpus.effective" can
> +	contain CPUs not in "cpuset.cpus", this can never happen with a
> +	valid partition root. In other words, "cpuset.cpus.effective"
> +	is always a subset of "cpuset.cpus" for a valid partition root.

IIUC this refers to the cgroup that is 'degraded'. (The consequences for
a valid partition root follow from valid_root definition above.)

> +
> +	When a parent partition root cannot exclusively grant any of
> +	the CPUs specified in "cpuset.cpus", "cpuset.cpus.effective"
> +	becomes empty.

This sounds too strict to me, perhaps you meant 'cannot grant _all_ of
the CPUs'?

>       If there are tasks in the partition root, the
> +	partition root becomes invalid and "cpuset.cpus.effective"
> +	is reset to that of the nearest non-empty ancestor.

This is captured in the definition of 'degraded'.

> +
> +        Note that a task cannot be moved to a croup with empty
> +        "cpuset.cpus.effective".

A transition condition. (Makes sense.)

[With the validity conditions above, it's possible to have 'valid_root'
with empty cpus (hence also empty cpus.internal_effective) if there are
no tasks in there. The transition conditions so far prevented this
corner case.]

> +	There are additional constraints on where a partition root can
> +	be enabled ("root" or "isolated").  It can only be enabled in
> +	a cgroup if all the following conditions are met.

I think the enablement (aka rewriting cpuset.cpus.partition) could be
always possible but it'd result in "root invalid (...)" if the resulting
config doesn't meet the validity condition.

> +
> +	1) The "cpuset.cpus" is non-empty and exclusive, i.e. they are
> +	   not shared by any of its siblings.

The emptiness here is a judgement call (in my formulation of the
conditions it seemed simpler to allow empty cpus.internal_effective with
no tasks).

> +	2) The parent cgroup is a valid partition root.

Captured in the valid_root definition.

> +	3) The "cpuset.cpus" is a subset of parent's "cpuset.cpus".

This is unnecessary strictness. Allow such config,
cpus.internal_effective still can't be more than parent's cpuset.cpus.
(Or do you have a reason to discard such configs?)

> +	4) There is no child cgroups with cpuset enabled.  This avoids
> +	   cpu migrations of multiple cgroups simultaneously which can
> +	   be problematic.

A transition condition (i.e. not relevant to validity conditions).

> +	Once becoming a partition root, changes to "cpuset.cpus"
> +	is generally allowed as long as the cpu list is exclusive,
> +	non-empty and is a superset of children's cpu lists.

Any changes should be allowed otherwise it denies the delegation
principle of v2 (IOW a parent should be able to preempt CPUs given to
chilren previously and not be denied because of them).

(If the change results in failed validity condition the cgroup of course
cannot be be a valid_root anymore.)

> +        The constraints of a valid partition root are as follows:
> +
> +        1) The parent cgroup is a valid partition root.
> +        2) "cpuset.cpus.effective" is a subset of "cpuset.cpus"
> +        3) "cpuset.cpus.effective" is non-empty when there are tasks
> +           in the partition.

(This seem to miss the sibling exclusivity condition.)
Here I'd simply paste the "Validity conditions" specified above instead.

> +        Changing a partition root to "member" is always allowed.
> +        If there are child partition roots underneath it, however,
> +        they will be forced to be switched back to "member" too and
> +        lose their partitions. So care must be taken to double check
> +        for this condition before disabling a partition root.

(Or is this how delegation is intended?) However, AFAICS, parent still
can't remove cpuset.cpus even when the child is a "member". Otherwise,
I agree with the back-switch.


> +	Setting a cgroup to a valid partition root will take the CPUs
> +	away from the effective CPUs of the parent partition.

Captured in the definition of cpus.internal_effective.

> +	A valid parent partition may distribute out all its CPUs to
> +	its child partitions as long as it is not the root cgroup as
> +	we need some house-keeping CPUs in the root cgroup.

This actually applies to any root partition that's supposed to host
tasks. (IOW, 'valid_root' cannot be 'degraded'.)

> +	An invalid partition is not a real partition even though some
> +	internal states may still be kept.

Tautology? (Or new definition of "real".)

> +
> +	An invalid partition root can be reverted back to a real
> +	partition root if none of the constraints of a valid partition
> +        root are violated.

Yes. (Also tautological.)

Anyway, as I said above, I just tried to formulate the model for clearer
understanding and the implementation may introduce transition
constraints but it'd be good to always have the simple rules to tell
what's a valid root in the tree and what's not.

Regards,
Michal

[1] https://lore.kernel.org/r/AM9PR10MB4869C14EAE01B87C0037BF6A89939-M49tMopaQCDO+/9PLUklKbUAtUbAAahqZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org/
[2] https://lore.kernel.org/lkml/5eacfdcc-148b-b599-3111-4f2971e7ddc0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

