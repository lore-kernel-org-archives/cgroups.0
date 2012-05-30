From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 2/6] account guest time per-cgroup as well.
Date: Wed, 30 May 2012 14:36:27 +0400
Message-ID: <4FC5F82B.6030404@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-3-git-send-email-glommer@parallels.com> <1338373947.26856.240.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338373947.26856.240.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 02:32 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
>> >  We already track multiple tick statistics per-cgroup, using
>> >  the task_group_account_field facility. This patch accounts
>> >  guest_time in that manner as well.
> So this leaves IOWAIT and IDLE the only fields not using
> task_group_account_field(), right?

Yes, because they are essentially global, and their meaning is 
ill-defined from within a cgroup.

If you look further out in the patchset, I intend to export idle from 
cpu, instead of cpuacct, because something that can be used as idle 
value is already computed anyway from the schedstats, so I'm just using it.

iowait will be left blank for now. Me and Paul agreed last time we 
talked that it is not uber important to have iowait values per-cgroup.
