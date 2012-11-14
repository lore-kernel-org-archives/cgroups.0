From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()
Date: Wed, 14 Nov 2012 17:20:21 +0100
Message-ID: <50A3C4C5.10004@parallels.com>
References: <20121113202714.GA21185@mtj.dyndns.org> <20121113202745.GB21185@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121113202745.GB21185-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/13/2012 09:27 PM, Tejun Heo wrote:
> From bbf2566f9f4fc79ff3320e83cafb69533efc9ea0 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 13 Nov 2012 12:21:50 -0800
> 
> Currently CGRP_CPUSET_CLONE_CHILDREN triggers ->post_clone().  Now
> that clone_children is cpuset specific, there's no reason to have this
> rather odd option activation mechanism in cgroup core.  cpuset can
> check the flag from its ->css_allocate() and take the necessary
> action.
> 
> Move cpuset_post_clone() logic to the end of cpuset_css_alloc() and
> remove cgroup_subsys->post_clone().
> 
> Loosely based on Glauber's "generalize post_clone into post_create"
> patch.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Original-patch-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Original-patch: <1351686554-22592-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

I don't have any preference one way or the other. This patch seems to do
the job.


