From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on suspend-resume
Date: Tue, 7 Mar 2023 14:17:25 -0800
Message-ID: <CA+khW7jQg6x_j70eARVF0eemP0txU_K9Lc=5kfBmU_KxsfbK2w@mail.gmail.com>
References: <20230206221428.2125324-1-qyousef@layalina.io> <CA+khW7i_Sc0M4FXzojmQ5PSfkPwk6AdcbN9j0gDXZ9FsOMQAwA@mail.gmail.com>
 <f3a99500-e51c-032f-a0c6-01763f0a5be6@redhat.com> <CA+khW7iWAn6bbXdkJX1Lt4dWUsN6o4KqVQ8OFTs0B+VTtVjBkw@mail.gmail.com>
 <1f2cf8ea-a9d7-5245-0f69-eb8be9f64afc@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678227457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZPDIXIYKXniSn7Cewj9Ohui8u8k77FZgGbBf+MYE2I=;
        b=H564rYcr021ZaO8vXlD0OPJNwRxXvsmm/vqUrqRtpwiFQvN40keui/j6Bp3KmULdu0
         ivF+sTy4V6jvb6d37Mz5mve8tFjbJKLWl5yMUyEVgpSK1EcV63guC/PFNzt+wwIT798o
         WqdQoR3xShV1oG19aLBwWl/pXw4vKAwK9izs0QOL6MyM6i2SEA9H6wcRRCDyVzSNu6tI
         HBPukjF+XFb10s4toX3I8sppLqirPA5S7hSYGqsWOioAHyTdu1xTh7tiFAfi2YImRMms
         V74ZL12YdBf/AQet8JvGIrBeausWDblgLUn0+XRaTe5HAGxvBBcQqG8kXpTe00SfoBWk
         582g==
In-Reply-To: <1f2cf8ea-a9d7-5245-0f69-eb8be9f64afc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Mar 7, 2023 at 1:13=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>
> On 3/7/23 16:06, Hao Luo wrote:
> > On Tue, Mar 7, 2023 at 12:09=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
> wrote:
> >> On 3/7/23 14:56, Hao Luo wrote:
> >>> On Mon, Feb 6, 2023 at 2:15=E2=80=AFPM Qais Yousef <qyousef@layalina.=
io> wrote:
> >>>> Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounti=
ng information")
> >>>> enabled rebuilding root domain on cpuset and hotplug operations to
> >>>> correct deadline accounting.
> >>>>
> >>>> Rebuilding root domain is a slow operation and we see 10+ of ms dela=
ys
> >>>> on suspend-resume because of that (worst case captures 20ms which
> >>>> happens often).
> >>>>
> >>>> Since nothing is expected to change on suspend-resume operation; ski=
p
> >>>> rebuilding the root domains to regain the some of the time lost.
> >>>>
> >>>> Achieve this by refactoring the code to pass whether dl accoutning n=
eeds
> >>>> an update to rebuild_sched_domains(). And while at it, rename
> >>>> rebuild_root_domains() to update_dl_rd_accounting() which I believe =
is
> >>>> a more representative name since we are not really rebuilding the ro=
ot
> >>>> domains, but rather updating dl accounting at the root domain.
> >>>>
> >>>> Some users of rebuild_sched_domains() will skip dl accounting update
> >>>> now:
> >>>>
> >>>>           * Update sched domains when relaxing the domain level in c=
puset
> >>>>             which only impacts searching level in load balance
> >>>>           * update sched domains when cpufreq governor changes and w=
e need
> >>>>             to create the perf domains
> >>>>
> >>>> Users in arch/x86 and arch/s390 are left with the old behavior.
> >>>>
> >>>> Debugged-by: Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>>> Signed-off-by: Qais Yousef (Google) <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> >>>> ---
> >>> Hi Qais,
> >>>
> >>> Thank you for reporting this. We observed the same issue in our
> >>> production environment. Rebuild_root_domains() is also called under
> >>> cpuset_write_resmask, which handles writing to cpuset.cpus. Under
> >>> production workloads, on a 4.15 kernel, we observed the median latenc=
y
> >>> of writing cpuset.cpus at 3ms, p99 at 7ms. Now the median becomes
> >>> 60ms, p99 at >100ms. Writing cpuset.cpus is a fairly frequent and
> >>> critical path in production, but blindly traversing every task in the
> >>> system is not scalable. And its cost is really unnecessary for users
> >>> who don't use deadline tasks at all.
> >> The rebuild_root_domains() function shouldn't be called when updating
> >> cpuset.cpus unless it is a partition root. Is it?
> >>
> > I think it's because we were using the legacy hierarchy. I'm not
> > familiar with cpuset partition though.
>
> In legacy hierarchy, changing cpuset.cpus shouldn't lead to the calling
> of rebuild_root_domains() unless you play with cpuset.sched_load_balance
> file by changing it to 0 in the right cpusets. If you are touching
> cpuset.sched_load_balance, you shouldn't change cpuset.cpus that often.
>

Actually, I think it's the opposite. If I understand the code
correctly[1], it looks like rebuild_root_domains is called when
LOAD_BALANCE _is_ set and sched_load_balance is 1 by default. Is that
condition a bug?

I don't think we updated cpuset.sched_load_balance.

[1] https://github.com/torvalds/linux/blob/master/kernel/cgroup/cpuset.c#L1=
677
