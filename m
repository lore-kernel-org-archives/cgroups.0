From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] patch
Date: Fri, 6 Apr 2012 17:43:54 +0200
Message-ID: <CAFTL4hw6JpEAXaJE+8f--F=zo6habHRMS8UxpLyfrfVe=16QEQ@mail.gmail.com>
References: <4F7928BE.8000502@samsung.com>
	<4F792976.4090503@samsung.com>
	<20120402102931.GA5885@shutemov.name>
	<4F7D13AD.3030309@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=Do6KcLKpiDDYey5AH4veC8YIPN/5ViaOmsEgkwl7GRU=;
        b=VZ42lj0u724Gfi41W+MKH29hShZkFozjDLKLJ9NVZL8UZt6nqfphDC5fk8ikJFgmNc
         w72Zc5mLNAPxYFHNiK+5ga1KGHefVOQWh2v/UWF9XSaIT4lJFvublA0SB3+D/qkB86+v
         1h50fr00N0s+7bFDxljwwnYewdaPl57CBZHmDjSlIXMOknVYkr4m+IIbI78j3P5oWFVh
         fU2axBJsl8WmR6qQRuJaBhXEZwFQmNfLoE1ovc0WkwAKSwzuH6fhKhMDT4zUEH8Epjlc
         EVVdHZ8XlFocjNQKBgD1Rz4/W93lWRqyyIesR59gWj411bRh+UITaZqq7RM8OR/XIWes
         beFA==
In-Reply-To: <4F7D13AD.3030309-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

2012/4/5 Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>:
> Hi guys, I investigate
>
> http://lwn.net/Articles/453642/
>
> seems that this really fit my proposal and I can make move this
> functionality from core to this css. But, unfortunately, Frederic git=
 is not
> available on kernel.org and current Linux kernel doesn't have this pa=
tches.
> Could you be so kind to provide link to the kernel with this patches.

Hi,

Last version was https://lkml.org/lkml/2012/1/31/489

I'm going to repost a new version around next week because I expect a
few conflicts
with the latest selftests changes after the last merge window.

Will Cc you!

Thanks.

>
>
> On 04/02/2012 02:29 PM, Kirill A. Shutemov wrote:
>>
>> On Mon, Apr 02, 2012 at 08:22:14AM +0400, Alexander Nikiforov wrote:
>>
>> I think it should be part of task counter css, not core.
>> CC list updated.
>>
>>> @@ -4558,6 +4594,22 @@ void cgroup_fork(struct task_struct *child)
>>> =A0 =A0 =A0 =A0child->cgroups =3D current->cgroups;
>>> =A0 =A0 =A0 =A0get_css_set(child->cgroups);
>>> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&child->cg_list);
>>> +
>>> + =A0 =A0 =A0 struct cgroupfs_root *root;
>>> +
>>> + =A0 =A0 =A0 /* send event to the userspace */
>>> + =A0 =A0 =A0 mutex_lock(&cgroup_mutex);
>>> + =A0 =A0 =A0 for_each_active_root(root) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cgroup *cgrp;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct fe_eventfd_list *ev;
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cgrp =3D task_cgroup_from_root(child,=
 root);
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(ev,&cgrp->fe_noti=
fy, list) {
>>>
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 eventfd_signal(ev->ev=
entfd, 1);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 =A0 }
>>> + =A0 =A0 =A0 mutex_unlock(&cgroup_mutex);
>>> =A0}
>>
>> How does it affect performance?
>>
>>>
>>> =A0/**
>>> @@ -4653,6 +4705,7 @@ void cgroup_exit(struct task_struct *tsk, int
>>> run_callbacks)
>>> =A0{
>>> =A0 =A0 =A0 =A0struct css_set *cg;
>>> =A0 =A0 =A0 =A0int i;
>>> + =A0 =A0 =A0 struct cgroupfs_root *root;
>>>
>>> =A0 =A0 =A0 =A0/*
>>> =A0 =A0 =A0 =A0 * Unlink from the css_set task list if necessary.
>>> @@ -4666,6 +4719,20 @@ void cgroup_exit(struct task_struct *tsk, in=
t
>>> run_callbacks)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_unlock(&css_set_lock);
>>> =A0 =A0 =A0 =A0}
>>>
>>> + =A0 =A0 =A0 /* send event to the userspace */
>>> + =A0 =A0 =A0 mutex_lock(&cgroup_mutex);
>>> + =A0 =A0 =A0 for_each_active_root(root) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cgroup *cgrp;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct fe_eventfd_list *ev;
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cgrp =3D task_cgroup_from_root(tsk, r=
oot);
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(ev,&cgrp->fe_noti=
fy, list) {
>>>
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 eventfd_signal(ev->ev=
entfd, 1);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 =A0 }
>>> + =A0 =A0 =A0 mutex_unlock(&cgroup_mutex);
>>> +
>>
>> I think it's racy. You need to notify userspace after reassigning th=
e
>> task, not before.
>>
>>> =A0 =A0 =A0 =A0/* Reassign the task to the init_css_set. */
>>> =A0 =A0 =A0 =A0task_lock(tsk);
>>> =A0 =A0 =A0 =A0cg =3D tsk->cgroups;
>>
>>
>
>
> --
> Best regards,
> =A0 =A0 Alex Nikiforov,
> =A0 =A0 Mobile SW, Advanced Software Group,
> =A0 =A0 Moscow R&D center, Samsung Electronics
>
