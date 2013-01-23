From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Date: Wed, 23 Jan 2013 10:34:53 +0800
Message-ID: <50FF4C4D.4020405@huawei.com>
References: <50F7B040.2020906@huawei.com> <20130123002754.GB5359@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130123002754.GB5359-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2013/1/23 8:27, Tejun Heo wrote:
> (cc'ing Andrew as scheduler folks are difficult to get response from
>  these days and I can't think of anyone else to bother :)
> 
> Hello, Li.
> 
> The cgroup part looks good to me but it would be great if the
> descriptions are more detailed, especially, about why the change is
> beneficial or what it's aiming at.  I take it that the shed changes
> are necessary to facilitate the later cgroup changes?  Can you please
> elaborate how?
> 

Scheduler changes made in patch #2 are preparation for #3 and #4.

- for #3:

After ss->css_alloc(), there's a small window that tg->css.cgroup is NULL.
With the change, tg won't be seen before ss->css_online(), so the scheduler
won't see NULL tg->css.cgroup.

- for #4:

If tg is unregistered and removed from global list in css_free(), and if
we kfree cgroup right after ss->css_free(), the scheduler can access
invalid tg->css.cgroup, because tg is also protected by RCU.

Without patch #2:

cgroup_rmdir()
  no ss->css_offline()
diput()
  syncronize_rcu()
  ss->css_free()    <-- remove tg from global list,
			and free tg via call_rcu()
  kfree_rcu(cgroup) <-- wait rcu read section

With the change:

cgroup_rmdir()
  ss->css_offline() <-- remove tg from global list
diput()
  synchronize_rcu() <-- wait rcu read section
  ss->css_free();   <-- free tg
  kfree(cgroup);

> The scheduler part of changes are mostly mechanical, so it would be
> great if we can get ack from scheduler people and route these together.
> 
> Thanks.
> 
