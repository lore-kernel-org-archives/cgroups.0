From: Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] sched/cpuset: Bring back cpuset_mutex
Date: Thu, 27 Apr 2023 10:58:03 +0800
Message-ID: <CAB8ipk-ns=d+jNkKi1sjkSQmQidziCj34COkHZt6ZkRiG47HHA@mail.gmail.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-3-juri.lelli@redhat.com> <fa585497-5c6d-f0ed-bdda-c71a81d315ad@redhat.com>
 <ZEkRq9iGkYP/8T5w@localhost.localdomain> <d53a8af3-46e7-fe6e-5cdd-0421796f80d2@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682564294; x=1685156294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dt12pza0kSqr2v/SyPGEEMbF6AGPcE5T8sVhWjoTuNo=;
        b=PXbRbj/hqLIMG7XcL+7o/0g5pwQ8mX2GCONQE8Hy8VMJndcsn9gZRBM9OvNcwcFNDg
         bIHFxJQ3oY21rCZ8ujcOTmXrVDEVPWwQQTHbm/E9TI+we0j0zv79E+DPqka570z+F8Gn
         7+M7ZvrlpdQH+vMOSbOKYM/gsp5VEsCcPlHMn+1a0rywWHcxljl2yUOVIbWHFdRIUcW+
         dMg2UP09vjd4UuknFAytWQO22a3R+OnjrY3WjcU+vkwoRf/qLXE10hv9TaAEt9yuAOXb
         xSkAdzV6qAQbqXYxYuu8iniGAhXWlw4XwYWWx5l8zyTsoK5dddzJTLPsA4X0Ayt632Tl
         Qsuw==
In-Reply-To: <d53a8af3-46e7-fe6e-5cdd-0421796f80d2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

HI Juri,

Would this patch be merged tobe stable-rc? In kernel5.15, we also find
that the rwsem would be blocked for a long  time, when we change the
task's cpuset cgroup.
And when we revert to the mutex, the delay would disappear.

BR
Thanks!

On Wed, Apr 26, 2023 at 10:50=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>
> On 4/26/23 07:57, Juri Lelli wrote:
> > On 04/04/23 13:31, Waiman Long wrote:
> >> On 3/29/23 08:55, Juri Lelli wrote:
> >>> Turns out percpu_cpuset_rwsem - commit 1243dc518c9d ("cgroup/cpuset:
> >>> Convert cpuset_mutex to percpu_rwsem") - wasn't such a brilliant idea=
,
> >>> as it has been reported to cause slowdowns in workloads that need to
> >>> change cpuset configuration frequently and it is also not implementin=
g
> >>> priority inheritance (which causes troubles with realtime workloads).
> >>>
> >>> Convert percpu_cpuset_rwsem back to regular cpuset_mutex. Also grab i=
t
> >>> only for SCHED_DEADLINE tasks (other policies don't care about stable
> >>> cpusets anyway).
> >>>
> >>> Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> I am thinking that maybe we should switch the percpu rwsem to a regula=
r
> >> rwsem as there are cases where a read lock is sufficient. This will al=
so
> >> avoid the potential PREEMPT_RT problem with PI and reduce the time it =
needs
> >> to take a write lock.
> > I'm not a big fan of rwsems for reasons like
> > https://lore.kernel.org/lkml/20230321161140.HMcQEhHb-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org/, so
> > I'd vote for a standard mutex unless we have a strong argument and/or
> > numbers.
>
> That is fine for me too.
>
> Cheers,
> Longman
>
