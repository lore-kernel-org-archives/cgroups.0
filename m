From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update cgroup_enable_task_cg_lists()
 to grab siglock
Date: Fri, 14 Feb 2014 11:49:42 +0800
Message-ID: <52FD9256.1080801@huawei.com>
References: <20140213182931.GB17608@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140213182931.GB17608-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/2/14 2:29, Tejun Heo wrote:
> Currently, there's nothing preventing cgroup_enable_task_cg_lists()
> from missing set PF_EXITING and race against cgroup_exit().  Depending
> on the timing, cgroup_exit() may finish with the task still linked on
> css_set leading to list corruption.  Fix it by grabbing siglock in
> cgroup_enable_task_cg_lists() so that PF_EXITING is guaranteed to be
> visible.
> 
> This whole on-demand cg_list optimization is extremely fragile and has
> ample possibility to lead to bugs which can cause things like
> once-a-year oops during boot.

I added the PF_EXITING check years ago:

commit 0e04388f0189fa1f6812a8e1cb6172136eada87e
Author: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Date:   Thu Apr 17 11:37:15 2008 +0800

    cgroup: fix a race condition in manipulating tsk->cg_list

Now the only race I see is caused by checking tsk->cg_list without locking
in cgroup_exit():

cgroup_enable_task_cg_lists()
  ...
  if (!p->flags & PF_EXITING) && list_empty(p->cg_list))
								exit_signal(tsk)  <-- set PF_EXTING;
								...
								if (!list_empty(&tsk->cg_list)) {
								        down_write(&css_set_rwsem);
								        if (!list_empty(&tsk->cg_list))
								                list_del_init(&tsk->cg_list);
								        up_write(&css_set_rwsem);
								}
  	list_add(p->cg_list, ...);

Your patch can fix this race, but after diving into the code I don't think
the race exists, because exit_mm() locks&unlocks task_lock, and exit_mm()
is called after exit_signal() and before cgroup_exit(), and task_lock is
also taken by cgroup_enable_task_cg_lists().

I totally agree the code is fragile and we should take your patch. I just
want to make it clear if the bug exists in real life or not, and then we
can write better changelog and decide to queue the patch for 3.14 or 3.15
and decide to mark it for stable or not.

> I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this
> on-demand craziness.
> 

:)

> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  kernel/cgroup.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 68d8710..105f273 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2905,9 +2905,14 @@ static void cgroup_enable_task_cg_lists(void)
>  		 * We should check if the process is exiting, otherwise
>  		 * it will race with cgroup_exit() in that the list
>  		 * entry won't be deleted though the process has exited.
> +		 * Do it while holding siglock so that we don't end up
> +		 * racing against cgroup_exit().
>  		 */
> +		spin_lock_irq(&p->sighand->siglock);
>  		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
>  			list_add(&p->cg_list, &task_css_set(p)->tasks);
> +		spin_unlock_irq(&p->sighand->siglock);
> +
>  		task_unlock(p);
>  	} while_each_thread(g, p);
>  	read_unlock(&tasklist_lock);
> 
