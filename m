From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 0/5] per-cpu/cpuacct cgroup scheduler statistics
Date: Tue, 14 Feb 2012 16:31:40 -0600
Message-ID: <20120214223140.GA7923@sergelap>
References: <1328192372-9551-1-git-send-email-glommer@parallels.com>
 <4F3A428B.9010009@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F3A428B.9010009-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Quoting Glauber Costa (glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
> On 02/02/2012 06:19 PM, Glauber Costa wrote:
> >Hi,
> >
> >Here is my new attempt to get a per-container version of some
> >/proc data such as /proc/stat and /proc/uptime.
> >
> >In this series I solved the visibility problem, which is,
> >the problem of how and when to show /proc/stat data per-cgroup,
> >by declaring it not a problem.
> >
> >This can probably be done in userspace with other aids, like mounting
> >a fuse overlay that simulates /proc from outside a container, to a
> >container location.
> >
> >Here, we should have most of the data needed to do that. They are drawn
> >from both the cpu cgroup, and cpuacct. Each cgroup exports the data it
> >knows better, and I am not really worried here about bindings between them.
> >
> >In this first version, I am using clock_t units, being quite proc-centric.
> >It made my testing easier, but I am happy to show any units you guys would
> >prefer.
> >
> >Besides that, it still has some other minor issues to be sorted out.
> >But I verified the general direction to be working, and would like to know
> >what you think.
> >
> 
> Hi,
> 
> Did someone had any chance to take a look at this already?
> 
> Thanks

Hi,

By declaring proc visibility not a problem and sticking to io stats,
you sort of left me where I don't know what I'm talking about :)  So
let me just say, on patch 2, "store number of iowait events in a task_group",
my initial reaction is "boy that's a lot more work.  What is the performance
impact?"

It'd be possible to move the extra processing out of the hot-path by
only changing the # for the deepest cgroup, and pulling it into
ancestor cgroups only when someone is viewing the stats or the child
cgroup goes away.  But if you have #s showing statistically negligable
performance impact anyway then that wouldn't be worth it.

-serge
