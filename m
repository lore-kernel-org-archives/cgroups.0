From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.19 3/3] cgroup: fix the async css offline
 wait logic in cgroup_subtree_control_write()
Date: Tue, 18 Nov 2014 14:30:44 +0800
Message-ID: <546AE794.5070902@huawei.com>
References: <20141113215813.GA2598@htj.dyndns.org> <20141113215848.GB2598@htj.dyndns.org> <20141113215921.GC2598@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141113215921.GC2598-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/11/14 5:59, Tejun Heo wrote:
> When a subsystem is offlined, its entry on @cgrp->subsys[] is cleared
> asynchronously.  If cgroup_subtree_control_write() is requested to
> enable the subsystem again before the entry is cleared, it has to wait
> for the previous offlining to finish and clear the @cgrp->subsys[]
> entry before trying to enable the subsystem again.
> 
> This is currently done while verifying the input enable / disable
> parameters.  This used to be correct but f63070d350e3 ("cgroup: make
> interface files visible iff enabled on cgroup->subtree_control")
> breaks it.  The commit is one of the commits implementing subsystem
> dependency.
> 
> Through subsystem dependency, some subsystems may be enabled and
> disabled implicitly in addition to the explicitly requested ones.  The
> actual subsystems to be enabled and disabled are determined during
> @css_enable/disable calculation.  The current offline wait logic skips
> the ones which are already implicitly enabled and then waits for
> subsystems in @enable; however, this misses the subsystems which may
> be implicitly enabled through dependency from @enable.  If such
> implicitly subsystem hasn't yet finished offlining yet, the function
> ends up trying to create a css when its @cgrp->subsys[] slot is
> already occupied triggering BUG_ON() in init_and_link_css().
> 
> Fix it by moving the wait logic after @css_enable is calculated and
> waiting for all the subsystems in @css_enable.  This fixes the above
> bug as the mask contains all subsystems which are to be enabled
> including the ones enabled through dependencies.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: f63070d350e3 ("cgroup: make interface files visible iff enabled on cgroup->subtree_control")

For all 3 patches:

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
