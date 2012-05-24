From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] per-cgroup /proc/stat statistics
Date: Thu, 24 May 2012 13:10:26 +0400
Message-ID: <4FBDFB02.4090502@parallels.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334010315-4453-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

On 04/10/2012 02:25 AM, Glauber Costa wrote:
> Hi,
>
> This patch aims at allowing userspace to recreate the most important
> contents of /proc/stat per-cgroup. It exports the data needed for it
> from the guts of the scheduler, and then anyone can parse it and
> present it to a container in a meaningful way. Again, the kernel won't
> get involved in this directly.
>
> Part of it will come from the cpu cgroup. Another part, from the cpuacct
> cgroup. Data is exported in cgroup files stat_percpu. They are just like
> the normal stat files, but with a cpuXXX value before the actual data
> field. As so, they are also extensible. So if anyone wants to give a
> shot at values I am currently ignoring (as iowait) in the future, we
> at least won't have a format problem.
>
> Let me know what you think.
>
> Glauber Costa (5):
>    measure exec_clock for rt sched entities
>    account guest time per-cgroup as well.
>    record nr_switches per task_group
>    expose fine-grained per-cpu data for cpuacct stats
>    expose per-taskgroup schedstats in cgroup
>
>   kernel/sched/core.c  |  214 ++++++++++++++++++++++++++++++++++++++++++++++++--
>   kernel/sched/fair.c  |   27 ++++++-
>   kernel/sched/rt.c    |    5 +
>   kernel/sched/sched.h |    6 ++
>   4 files changed, 245 insertions(+), 7 deletions(-)
>
Paul and the other scheduler folks:

Do you have a saying on this?

Thanks
