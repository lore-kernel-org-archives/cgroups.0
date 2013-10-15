From: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroup_attach_task && while_each_thread (Was: cgroup attach task
 - slogging cpu)
Date: Tue, 15 Oct 2013 10:34:04 +0530
Message-ID: <CALPf4Ty_xmred_Mf=tyzKDLu+rqStYUxTazZpYDOCKN_nm-5vQ@mail.gmail.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com>
	<20131004130207.GA9338@redhat.com>
	<20131007184507.GD27396@htj.dyndns.org>
	<20131008145833.GA15600@redhat.com>
	<5254EB2A.7090803@huawei.com>
	<20131009133047.GA12414@redhat.com>
	<20131009140551.GA15849@redhat.com>
	<20131009165448.GA22437@redhat.com>
	<5257F9E3.5030708@huawei.com>
	<20131011160004.GA26416@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=C06AIXzbAzAOYJx791kPVURZeoB0JPRuxs570QKJkgs=;
        b=tn11ndocjOXspAk7k+fYJx9mF8ryeJS2hOcOUVs7VmuA4aEY4AYv3oTxuUdSD+foxi
         QBBLlvTZOMuSjl3w+6ce7JckTi4w07aEOl0tcx80Go2IE4mxBUuhD77qPGMQA9TggLvd
         FWLBB6gBrcvxqp/CqTUDvivwG/tkti0H8RCncJLDNEi2YmMNxTqLHcPn7ROarh3OUfjW
         hFVLqHQztTcO2JEOhqNf9q1fXH9imM6WrR0HnX318h2HLTK8YaBVrFahoGdN1nMQ2K+Y
         yrAqEDibYwefx/O5EjGa9PEsuXNtprViIDAy44FPcldYlyQ17B8DHpfWS2Scj3e6jMqX
         ewkA==
In-Reply-To: <20131011160004.GA26416-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

Hi All,

Thankyou for your suggestions.
I have made the modifications as suggested.

Please find the patch below.

From fd85f093f912a160c0896ea2784dfbdd64f142ca Mon Sep 17 00:00:00 2001
From: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 9 Oct 2013 16:49:22 +0530
Subject: [PATCH] Single thread break missing in cgroup_attach_task

Problem:
Issue when attaching a single thread to a cgroup if the thread was alredy in the
cgroup. The check if the thread is already in cgroup in the above case,
continues to the next thread instead of exciting.

Solution:
Add a check if it is a single thread or a threadgroup and
take decision accordingly. If it is a single thread break out of the do-while
loop, and if it is a threadgroup goto the next thread.

Change-Id: If6bbdef12ca5992823ac2a7bc15eaeb3dddb461a
Signed-off-by: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2418b6e..13eafdc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2039,7 +2039,7 @@ static int cgroup_attach_task(struct cgroup
*cgrp, struct task_struct *tsk,

 		/* @tsk either already exited or can't exit until the end */
 		if (tsk->flags & PF_EXITING)
-			continue;
+			goto next_thread;

 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
@@ -2047,7 +2047,7 @@ static int cgroup_attach_task(struct cgroup
*cgrp, struct task_struct *tsk,
 		ent.cgrp = task_cgroup_from_root(tsk, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
-			continue;
+			goto next_thread;
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2055,7 +2055,7 @@ static int cgroup_attach_task(struct cgroup
*cgrp, struct task_struct *tsk,
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-
+next_thread:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, tsk);
-- 
1.7.6



On 10/11/13, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/11, Li Zefan wrote:
>>
>> On 2013/10/10 0:54, Oleg Nesterov wrote:
>>
>> > And I am starting to think that this change should also fix the
>> > while_each_thread() problems in this particular case.
>
> Please see below,
>
>> > In generak the code like
>> >
>> > 	rcu_read_lock();
>> > 	task = find_get_task(...);
>> > 	rcu_read_unlock();
>> >
>> > 	rcu_read_lock();
>> > 	t = task;
>> > 	do {
>> > 		...
>> > 	} while_each_thread (task, t);
>> > 	rcu_read_unlock();
>> >
>> > is wrong even if while_each_thread() was correct (and we have a lot
>> > of examples of this pattern). A GP can pass before the 2nd rcu-lock,
>> > and we simply can't trust ->thread_group.next.
>> >
>> > But I didn't notice that cgroup_attach_task(tsk, threadgroup) can only
>> > be called with threadgroup == T when a) tsk is ->group_leader and b)
>> > we hold threadgroup_lock() which blocks de_thread(). IOW, in this case
>> > "tsk" can't be removed from ->thread_group list before other threads.
>> >
>> > If next_thread() sees thread_group.next != leader, we know that the
>> > that .next thread didn't do __unhash_process() yet, and since we
>> > know that in this case "leader" didn't do this too we are safe.
>> >
>> > In short: __unhash_process(leader) (in this) case can never change
>> > ->thread_group.next of another thread, because leader->thread_group
>> > should be already list_empty().
>> >
>>
>> If threadgroup == false, and if the tsk is existing or is already in
>> the targeted cgroup, we won't break the loop due to the bug but do
>> this:
>>
>>   while_each_thread(task, t)
>>
>> If @task isn't the leader, we might got stuck in the loop?
>
> Yes, yes, sure. We need to fix the wrong "continue" logic, hopefully
>
> I tried to say (see above) that after we do this while_each_thread()
> should be fine in this particular case.
>
> Oleg.
>
>
