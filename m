From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Fri, 09 Mar 2012 14:26:05 +0800
Message-ID: <4F59A27D.9080705@cn.fujitsu.com>
References: <4F587199.6050404@cn.fujitsu.com> <20120308182622.GC25508@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120308182622.GC25508-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

02:26, Tejun Heo wrote:
> Hello, Li, Frederic.
> 
> On Thu, Mar 08, 2012 at 04:45:13PM +0800, Li Zefan wrote:
>> +static void freezer_post_fork(struct cgroup_subsys *ss,
>> +			      struct task_struct *task)
>> +{
>> +	struct freezer *freezer;
>> +
>> +	cgroup_lock();
>> +
>> +	freezer = task_freezer(task);
>> +	if (!freezer->css.cgroup->parent)
>> +		goto out;
>> +
>> +	spin_lock_irq(&freezer->lock);
>> +	if (freezer->state != CGROUP_THAWED)
>> +		freeze_task(task);
>> +	spin_unlock_irq(&freezer->lock);
>> +out:
>> +	cgroup_unlock();
>> +}
> 
> Urgh... this is requiring policy implementations to synchronize with
> problem caused by cgroup core optimization and it's so very subtle.
> IMHO, this definitely should be contained in cgroup core and in a very
> confined form even inside cgroup core.
> 
> Any other ideas?
> 

The problem is, forks can happen at any time, so there's no way to prevent
forks from happening while iterating tasks in a cgroup, so controllers
have to deal with it. In fact freezer is somewhat aware of this issue,
that's why it provides the ->fork callback, but there's race.

This patch is not too bad (needs a bit modification). cgroup core will detect
(via seqcount) if something's happened to a cgroup and the tasks in it, and
then cgroup will notify controllers to check if newly-forked tasks should
be adjusted accordingly, so they will have consistent status with other tasks
in the same cgroup.
