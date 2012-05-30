From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
Date: Wed, 30 May 2012 16:09:54 +0400
Message-ID: <4FC60E12.4010201@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-2-git-send-email-glommer@parallels.com> <1338373759.26856.238.camel@twins> <4FC5F727.2040804@parallels.com> <1338374555.26856.243.camel@twins> <4FC5F99B.2060109@parallels.com> <CAPM31RL-X2GYju-opjUumPq_cfGiRzGowXEOx9Tq4kVEG-z3SA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RL-X2GYju-opjUumPq_cfGiRzGowXEOx9Tq4kVEG-z3SA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 03:00 PM, Paul Turner wrote:
> Does this even need to be hierarchical?  While it's natural for it to
> be in the CFS case, it feels forced here.
>
> You could instead make this rt_rq->local_exec_clock  charging only to
> the parenting rt_rq and post-aggregate when you want to report.  The
> only thing you'd need to be careful of is also accounting children
> somewhere on the parent on destruction (reaped_exec_clock?).
>
> Harking back to symmetry, local_exec_clock is also a potentially
> useful stat on the CFS side of things since it allows you to usefully
> disambiguate versus your children (common case where this is useful is
> calculating usage of threads in the root cgroup); so it wouldn't need
> to be unique to rt_rq.

I can try this approach.
