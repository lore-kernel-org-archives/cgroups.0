From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-3.15] cgroup: make cgroup_enable_task_cg_lists()
 to grab siglock
Date: Sat, 15 Feb 2014 10:11:47 +0800
Message-ID: <52FECCE3.1010707@huawei.com>
References: <20140213182931.GB17608@htj.dyndns.org> <20140214204709.GB2851@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140214204709.GB2851-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/2/15 4:47, Tejun Heo wrote:
> Currently, there's nothing explicitly preventing
> cgroup_enable_task_cg_lists() from missing set PF_EXITING and race
> against cgroup_exit(), and, depending on the timing, cgroup_exit()
> seemingly may finish with the task still linked on css_set leading to
> list corruption because cgroup_enable_task_cg_lists() can end up
> linking it after list_empty(&tsk->cg_list) test in cgroup_exit().
> 
> This can't really happen because exit_mm() grabs and release
> task_lock() between setting of PF_EXITING and cgroup_exit(), and
> cgroup_enable_task_cg_lists() synchronizes against task_lock too;
> however, this is fragile and more of a happy accident.  Let's make the
> synchronization explicit by making cgroup_enable_task_cg_lists() grab
> siglock around PF_EXITING testing.
> 
> This whole on-demand cg_list optimization is extremely fragile and has
> ample possibility to lead to bugs which can cause things like
> once-a-year oops during boot.  I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this dynamic
> optimization craziness.
> 
> v2: Li pointed out that the race condition can't actually happen due
>     to task_lock locking in exit_mm().  Updated the patch description
>     accordingly and dropped -stable cc.
> 

I realise exit_mm() is a no-op for threads... There're quite a few places
task_lock is used between exit_signal() and cgroup_exit(), but they're
all conditional, so I think your original changelog stands!
