From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update cgroup_enable_task_cg_lists()
 to grab siglock
Date: Sat, 15 Feb 2014 11:37:48 +0800
Message-ID: <52FEE10C.7010101@huawei.com>
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
> once-a-year oops during boot.  I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this
> on-demand craziness.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
