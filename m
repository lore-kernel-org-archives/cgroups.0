From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/9 v2] cgroup: add cgroup_subsys->post_create()
Date: Thu, 08 Nov 2012 11:59:41 +0900
Message-ID: <509B201D.3060909@jp.fujitsu.com>
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org> <20121107171508.GF2660@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121107171508.GF2660-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

(2012/11/08 2:15), Tejun Heo wrote:
> Currently, there's no way for a controller to find out whether a new
> cgroup finished all ->create() allocatinos successfully and is
> considered "live" by cgroup.
>
> This becomes a problem later when we add generic descendants walking
> to cgroup which can be used by controllers as controllers don't have a
> synchronization point where it can synchronize against new cgroups
> appearing in such walks.
>
> This patch adds ->post_create().  It's called after all ->create()
> succeeded and the cgroup is linked into the generic cgroup hierarchy.
> This plays the counterpart of ->pre_destroy().
>
> When used in combination with the to-be-added generic descendant
> iterators, ->post_create() can be used to implement reliable state
> inheritance.  It will be explained with the descendant iterators.
>
> v2: Added a paragraph about its future use w/ descendant iterators per
>      Michal.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

