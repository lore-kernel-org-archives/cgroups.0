From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v3 5/6] Also record sleep start for a task group
Date: Wed, 30 May 2012 14:44:37 +0200
Message-ID: <1338381877.26856.272.camel@twins>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-6-git-send-email-glommer@parallels.com>
	 <CAPM31R+VXsffUOSOtMPG=g+G9OdzWMKQvx9usTFa3KBbrqPe6A@mail.gmail.com>
	 <4FC61188.8000908@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC61188.8000908-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, 2012-05-30 at 16:24 +0400, Glauber Costa wrote:
> sleep_start is not for iowait. This is for idle. And I know no other way 
> to collect idle time per cgroup, other than the time during which it was 
> out of the runqueue.
> 
> Now what you say about the sleepers don't make that much sense for idle 
> because this information is per-cpu as well.
> 
> When the se is being dequeued, it means none of its children is running 
> on that runqueue. That's idle. 

But does that mean the cgroup is idle? Its impossible to re-construct
the machine state from this per-cpu data if your definition of
cgroup-idle is the time when _all_ cpus are idle.

