From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] do not abuse ->cred_guard_mutex in threadgroup_lock()
Date: Thu, 21 Mar 2013 15:06:26 -0700
Message-ID: <20130321150626.a7934d989fb80d835fa92255@linux-foundation.org>
References: <20130306223657.GA7392@redhat.com>
	<20130307172545.GA10353@redhat.com>
	<20130307180139.GD29601@htj.dyndns.org>
	<20130307180332.GE29601@htj.dyndns.org>
	<20130307191242.GA18265@redhat.com>
	<20130307193820.GB3209@htj.dyndns.org>
	<513A9A67.60909@huawei.com>
	<20130309032936.GT14556@mtj.dyndns.org>
	<513AE918.7020704@huawei.com>
	<20130309200046.GA8149@redhat.com>
	<20130321162138.GA21859@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321162138.GA21859-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, 21 Mar 2013 17:21:38 +0100 Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> threadgroup_lock() takes signal->cred_guard_mutex to ensure that
> thread_group_leader() is stable. This doesn't look nice, the scope
> of this lock in do_execve() is huge.
> 
> And as Dave pointed out this can lead to deadlock, we have the
> following dependencies:
> 
> 	do_execve:		cred_guard_mutex -> i_mutex
> 	cgroup_mount:		i_mutex -> cgroup_mutex
> 	attach_task_by_pid:	cgroup_mutex -> cred_guard_mutex
> 
> Change de_thread() to take threadgroup_change_begin() around the
> switch-the-leader code and change threadgroup_lock() to avoid
> ->cred_guard_mutex.
> 
> Note that de_thread() can't sleep with ->group_rwsem held, this
> can obviously deadlock with the exiting leader if the writer is
> active, so it does threadgroup_change_end() before schedule().

<formletter>
When writing a changelog, please describe the end-user-visible effects
of the bug, so that others can more easily decide which kernel
version(s) should be fixed, and so that downstream kernel maintainers
can more easily work out whether this patch will fix a problem which
they or their customers are observing.
</formletter>

> Reported-by: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Perhaps Dave's report provides the needed info?  trinity went titsup?

