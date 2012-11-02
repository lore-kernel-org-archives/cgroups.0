From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Fri, 02 Nov 2012 18:23:10 +0900
Message-ID: <509390FE.1010304@jp.fujitsu.com>
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351657365-25055-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/10/31 13:22), Tejun Heo wrote:
> 2ef37d3fe4 ("memcg: Simplify mem_cgroup_force_empty_list error
> handling") removed the last user of __DEPRECATED_clear_css_refs.  This
> patch removes __DEPRECATED_clear_css_refs and mechanisms to support
> it.
> 
> * Conditionals dependent on __DEPRECATED_clear_css_refs removed.
> 
> * ->pre_destroy() now can only fail if a new task is attached or child
>    cgroup is created while ->pre_destroy()s are being called.  As the
>    condition is checked again after re-acquiring cgroup_mutex
>    afterwards, we don't need to take any immediate action on
>    ->pre_destroy() failures.  This reduces cgroup_call_pre_destroy() to
>    a simple loop surrounding ->pre_destory().  Remove
>    cgroup_call_pre_destroy() and open-code the loop into
>    cgroup_rmdir().
> 
> * cgroup_clear_css_refs() can no longer fail.  All that needs to be
>    done are deactivating refcnts, setting CSS_REMOVED and putting the
>    base reference on each css.  Remove cgroup_clear_css_refs() and the
>    failure path, and open-code the loops into cgroup_rmdir().
> 
> Note that cgroup_rmdir() will see more cleanup soon.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I thank you and Michal for this work.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-c2VE3kR2zFovtab9mdV7tw@public.gmane.org>



