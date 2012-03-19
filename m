From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 01/10] cgroup: move cgroup_clear_directory() call out
 of cgroup_populate_dir()
Date: Mon, 19 Mar 2012 14:25:16 +0400
Message-ID: <4F67098C.4050902@parallels.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331940963-15756-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On 03/17/2012 03:35 AM, Tejun Heo wrote:
> cgroup_populate_dir() currently clears all files and then repopulate
> the directory; however, the clearing part is only useful when it's
> called from cgroup_remount().  Relocate the invocation to
> cgroup_remount().
>
> This is to prepare for further cgroup file handling updates.
>
> Signed-off-by: Tejun Heo<tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
