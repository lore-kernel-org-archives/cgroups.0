From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 4/4] cpuacct.stat: re-use scheduler statistics for the
 root cgroup
Date: Fri, 25 Nov 2011 11:37:20 +0900
Message-ID: <20111125113720.e57a7cc9.kamezawa.hiroyu@jp.fujitsu.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com>
	<1322184806-20421-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322184806-20421-5-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, 24 Nov 2011 23:33:26 -0200
Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> Right now, after we collect tick statistics for user and system and store them
> in a well known location, we keep the same statistics again for cpuacct.
> Since cpuacct is hierarchical, the numbers for the root cgroup should be
> absolutely equal to the system-wide numbers.
> 
> So it would be better to just use it: this patch changes cpuacct accounting
> in a way that the cpustat statistics are kept in a struct kernel_cpustat percpu
> array. In the root cgroup case, we just point it to the main array. The rest of
> the hierarchy walk can be totally disabled later with a static branch - but I am
> not doing it here.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Paul Tuner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

seems reasonable to me.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
