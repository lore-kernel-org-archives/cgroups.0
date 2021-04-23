From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Fri, 23 Apr 2021 12:01:38 -0700
Message-ID: <YIMZkjzNFypjZao9@carbon.dhcp.thefacebook.com>
References: <20210423171351.3614430-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BVKv2y1CwMySf+78zGdHb71OEY0pzqxWthwxNaZ677w=;
 b=enATvBR0yaM1w8STLScUtXBFAXWNQtg/pr+oPSEzMHrVJndGDkLARMQJbsFLbBc74Fhb
 A2mYpM56omqMHlariIFVulCw4wSGV5peog4tmTeUpPGjolAZbWrF1TGLiQ6LSqi1slLX
 Tn8rdFsFZ5pveBLXZ7ihjtsecKt2T6OSDxY= 
Content-Disposition: inline
In-Reply-To: <20210423171351.3614430-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 23, 2021 at 07:13:51PM +0200, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Introduce a new cgroup.signal file which is available in non-root
> cgroups and allows to send signals to cgroups. As with all new cgroup
> features this is recursive by default. This first implementation is
> restricted to sending SIGKILL with the possibility to be extended to
> other signals in the future which I think is very likely.
> 
> There are various use-cases of this interface. In container-land
> assuming a conservative layout where a container is treated as a
> separate machine each container usually has a delegated cgroup.
> 
> This means there is a 1:1 mapping between container and cgroup. If the
> container in addition uses a separate pid namespace then killing a
> container becomes a simple kill -9 <container-init-pid> from an ancestor
> pid namespace.
> 
> However, there are quite a few scenarios where that isn't true. For
> example, there are containers that share the cgroup with other processes
> on purpose that are supposed to be bound to the lifetime of the
> container but are not in the same pidns of the container. Containers
> that are in a delegated cgroup but share the pid namespace with the host
> or other containers.
> 
> Other use-cases arise for service management in systemd and potentially
> userspace oom implementations.
> 
> I'm honestly a bit worried because this patch feels way to
> straightforward right now and I've been holding it back because I fear I
> keep missing obvious problems. In any case, here are the semantics and
> the corner-cases that came to my mind and how I reasoned about them:
> - Signals are specified by writing the signal number into cgroup.signal.
>   An alternative would be to allow writing the signal name but I don't
>   think that's worth it. Callers like systemd can easily do a snprintf()
>   with the signal's define/enum.
> - Since signaling is a one-time event and we're holding cgroup_mutex()
>   as we do for freezer we don't need to worry about tasks joining the
>   cgroup while we're signaling the cgroup. Freezer needed to care about
>   this because a task could join or leave frozen/non-frozen cgroups.
>   Since we only support SIGKILL currently and SIGKILL works for frozen
>   tasks there's also not significant interaction with frozen cgroups.

Hello Christian!

I'm worried that we might miss a fork'ing task. If a task started fork'ing,
holding a tasklist_lock will not prevent it from joining the cgroup after
we'll release it. So I guess the task could escape from being killed, which
will obviously break user's expectations. Something to check here.


> - Since signaling leads to an event and not a state change the
>   cgroup.signal file is write-only.
> - Since we currently only support SIGKILL we don't need to generate a
>   separate notification and can rely on the unpopulated notification
>   meachnism. If we support more signals we can introduce a separate
>   notification in cgroup.events.

An alternative interface is to have echo "1" > cgroup.kill .
I'm not sure what's better long-term.
Given that it's unlikely that new signals will appear, maybe it's better
to decide right now if we're going to support anything beyond SIGKILL and
implement it all together. Otherwise applications would need to handle
-EINVAL on some signals on some kernel versions...

> - We skip signaling kthreads this also means a cgroup that has a kthread
>   but receives a SIGKILL signal will not become empty and consequently
>   no populated event will be generated. This could potentially be
>   handled if we were to generate an event whenever we are finished
>   sending a signal. I'm not sure that's worth it.

I think this is fine. Generally it's expected that all kthreads are in
the root cgroup (at least on cgroup v2). If it's not the case, a user should
be prepared for various side-effects. The freezer has them too. There is no
way to treat kthreads as normal processes without bad consequences.

> - Freezer doesn't care about tasks in different pid namespaces, i.e. if
>   you have two tasks in different pid namespaces the cgroup would still
>   be frozen.
>   The cgroup.signal mechanism should consequently behave the same way,
>   i.e.  signal all processes and ignore in which pid namespace they
>   exist. This would obviously mean that if you e.g. had a task from an
>   ancestor pid namespace join a delegated cgroup of a container in a
>   child pid namespace the container can kill that task. But I think this
>   is fine and actually the semantics we want since the cgroup has been
>   delegated.
> - It is currently not possible to signal tasks in ancestor or sibling
>   pid namespaces with regular singal APIs. This is not even possible
>   with pidfds right now as I've added a check access_pidfd_pidns() which
>   verifies that the task to be signaled is in the same or a descendant
>   pid namespace as the caller. However, with cgroup.signal this would be
>   possible whenever a task lives in a cgroup that is delegated to a
>   caller in an ancestor or sibling pid namespace.

I agree.

> - SIGKILLing a task that is PID 1 in a pid namespace which is
>   located in a delegated cgroup but which has children in non-delegated
>   cgroups (further up the hierarchy for example) would necessarily cause
>   those children to die too.
> - We skip signaling tasks that already have pending fatal signals.
> - If we are located in a cgroup that is going to get SIGKILLed we'll be
>   SIGKILLed as well which is fine and doesn't require us to do anything
>   special.
> - We're holding the read-side of tasklist lock while we're signaling
>   tasks. That seems fine since kill(-1, SIGKILL) holds the read-side
>   of tasklist lock walking all processes and is a way for unprivileged
>   users to trigger tasklist lock being held for a long time. In contrast
>   it would require a delegated cgroup with lots of processes and a deep
>   hierarchy to allow for something similar with this interface.
> 
> Fwiw, in addition to the system manager and container use-cases I think
> this has the potential to be picked up by the "kill" tool. In the future
> I'd hope we can do: kill -9 --cgroup /sys/fs/cgroup/delegated
> 
> Once we see this is a feasible direction and I haven't missed a bunch of
> obvious problems I'll add proper tests and send out a non-RFC version of
> this patch. Manual testing indicates it works as expected.

Overall it sounds very reasonable and makes total sense to me. Many userspace
applications can use the new interface instead of reading cgroup.procs in
a cycle and killing all processes or using the freezer and kill a frozen
list of tasks. It will simplify the code and make it more reliable.

Thanks!
