From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
Date: Wed, 30 May 2012 12:42:35 +0200
Message-ID: <1338374555.26856.243.camel@twins>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	  <1338371317-5980-2-git-send-email-glommer@parallels.com>
	 <1338373759.26856.238.camel@twins> <4FC5F727.2040804@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC5F727.2040804-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, 2012-05-30 at 14:32 +0400, Glauber Costa wrote:
> >> +    for_each_sched_rt_entity(rt_se) {
> >> +            rt_rq = rt_rq_of_se(rt_se);
> >> +            schedstat_add(rt_rq, exec_clock, delta_exec);
> >> +    }
> >> +
> >>      if (!rt_bandwidth_enabled())
> >>              return;
> >
> > See, this just makes me sad.. you now have a double
> > for_each_sched_rt_entity() loop.
> 
> The way I read the rt.c code, it it is called from enqueue_task_rt only
> once. 

Ah, what I meant was, right after that !rt_bandwidth_enabled() muck we
do another for_each_sched_rt_entity() walk.
