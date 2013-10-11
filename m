From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup_attach_task && while_each_thread (Was: cgroup attach
	task - slogging cpu)
Date: Fri, 11 Oct 2013 18:00:04 +0200
Message-ID: <20131011160004.GA26416@redhat.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com> <20131009133047.GA12414@redhat.com> <20131009140551.GA15849@redhat.com> <20131009165448.GA22437@redhat.com> <5257F9E3.5030708@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5257F9E3.5030708-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On 10/11, Li Zefan wrote:
>
> On 2013/10/10 0:54, Oleg Nesterov wrote:
>
> > And I am starting to think that this change should also fix the
> > while_each_thread() problems in this particular case.

Please see below,

> > In generak the code like
> >
> > 	rcu_read_lock();
> > 	task = find_get_task(...);
> > 	rcu_read_unlock();
> >
> > 	rcu_read_lock();
> > 	t = task;
> > 	do {
> > 		...
> > 	} while_each_thread (task, t);
> > 	rcu_read_unlock();
> >
> > is wrong even if while_each_thread() was correct (and we have a lot
> > of examples of this pattern). A GP can pass before the 2nd rcu-lock,
> > and we simply can't trust ->thread_group.next.
> >
> > But I didn't notice that cgroup_attach_task(tsk, threadgroup) can only
> > be called with threadgroup == T when a) tsk is ->group_leader and b)
> > we hold threadgroup_lock() which blocks de_thread(). IOW, in this case
> > "tsk" can't be removed from ->thread_group list before other threads.
> >
> > If next_thread() sees thread_group.next != leader, we know that the
> > that .next thread didn't do __unhash_process() yet, and since we
> > know that in this case "leader" didn't do this too we are safe.
> >
> > In short: __unhash_process(leader) (in this) case can never change
> > ->thread_group.next of another thread, because leader->thread_group
> > should be already list_empty().
> >
>
> If threadgroup == false, and if the tsk is existing or is already in
> the targeted cgroup, we won't break the loop due to the bug but do
> this:
>
>   while_each_thread(task, t)
>
> If @task isn't the leader, we might got stuck in the loop?

Yes, yes, sure. We need to fix the wrong "continue" logic, hopefully

I tried to say (see above) that after we do this while_each_thread()
should be fine in this particular case.

Oleg.
