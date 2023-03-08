From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on suspend-resume
Date: Wed, 8 Mar 2023 10:11:07 -0800
Message-ID: <CA+khW7hdE=j58R3S8R1iARL9Pd4L_dOVyGLGeDTCukxRiuytBQ@mail.gmail.com>
References: <20230206221428.2125324-1-qyousef@layalina.io> <CA+khW7i_Sc0M4FXzojmQ5PSfkPwk6AdcbN9j0gDXZ9FsOMQAwA@mail.gmail.com>
 <f3a99500-e51c-032f-a0c6-01763f0a5be6@redhat.com> <CA+khW7iWAn6bbXdkJX1Lt4dWUsN6o4KqVQ8OFTs0B+VTtVjBkw@mail.gmail.com>
 <1f2cf8ea-a9d7-5245-0f69-eb8be9f64afc@redhat.com> <CA+khW7jQg6x_j70eARVF0eemP0txU_K9Lc=5kfBmU_KxsfbK2w@mail.gmail.com>
 <315efe55-abaf-c199-673b-95ef76a1e442@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678299081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUxEuYTDDFPmIiQ52Uj0fWRRHS1cj4kLqmUnBlO9hic=;
        b=k5RClTV1ehgzeGkeqnum3NnxKO1H/40BDWqZdBjT9gFG3JYjQLUI9wg53Qj+4kDgIw
         VDlOpXXx4XW5naIbWEb9Yc3URh87cxpLPeFtVdNCmXMCLSSD13jzdvitgCoaXBmPERgY
         Q+OfEZp4M6/57zNrbtJsnCzc0/NzzcAeq7MR7lB7HtEm4SBTOzWOlOXI6sKzTYhs9Ubt
         aXwsmP9yhamCOVVZAxJmubaI1LRrAiSfQXOZOoLQLJRRYCaq45t3fQOj+onBbFYgbWNf
         A7RGLYUp8dC9BL0td+/hKH/SmLLztGUz0UWebstWtd73kFVJIDGsXSioZw1cI8SoQqNx
         vMCA==
In-Reply-To: <315efe55-abaf-c199-673b-95ef76a1e442-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Mar 7, 2023 at 6:30=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>
> On 3/7/23 17:17, Hao Luo wrote:
> > On Tue, Mar 7, 2023 at 1:13=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
> >> On 3/7/23 16:06, Hao Luo wrote:
> >>> On Tue, Mar 7, 2023 at 12:09=E2=80=AFPM Waiman Long <longman@redhat.c=
om> wrote:
> >>>> On 3/7/23 14:56, Hao Luo wrote:
<...>
> >>>>> Hi Qais,
> >>>>>
> >>>>> Thank you for reporting this. We observed the same issue in our
> >>>>> production environment. Rebuild_root_domains() is also called under
> >>>>> cpuset_write_resmask, which handles writing to cpuset.cpus. Under
> >>>>> production workloads, on a 4.15 kernel, we observed the median late=
ncy
> >>>>> of writing cpuset.cpus at 3ms, p99 at 7ms. Now the median becomes
> >>>>> 60ms, p99 at >100ms. Writing cpuset.cpus is a fairly frequent and
> >>>>> critical path in production, but blindly traversing every task in t=
he
> >>>>> system is not scalable. And its cost is really unnecessary for user=
s
> >>>>> who don't use deadline tasks at all.
> >>>> The rebuild_root_domains() function shouldn't be called when updatin=
g
> >>>> cpuset.cpus unless it is a partition root. Is it?
> >>>>
> >>> I think it's because we were using the legacy hierarchy. I'm not
> >>> familiar with cpuset partition though.
> >> In legacy hierarchy, changing cpuset.cpus shouldn't lead to the callin=
g
> >> of rebuild_root_domains() unless you play with cpuset.sched_load_balan=
ce
> >> file by changing it to 0 in the right cpusets. If you are touching
> >> cpuset.sched_load_balance, you shouldn't change cpuset.cpus that often=
.
> >>
> > Actually, I think it's the opposite. If I understand the code
> > correctly[1], it looks like rebuild_root_domains is called when
> > LOAD_BALANCE _is_ set and sched_load_balance is 1 by default. Is that
> > condition a bug?
> >
> > I don't think we updated cpuset.sched_load_balance.
> >
> > [1] https://github.com/torvalds/linux/blob/master/kernel/cgroup/cpuset.=
c#L1677
>
> The only reason rebuild_root_domains() is called is because the the
> scheduling domains were changed. The cpuset.sched_load_balance control
> file is 1 by default. If no one touch it, there is just one global
> scheduling domain that covers all the active CPUs. However, by setting
> cpuset.sched_load_balance to 0 in the right cpusets, you can create
> multiple scheduling domains or disabling load balancing on some CPUs.
> With that setup, changing cpuset.cpus in the right place can cause
> rebuild_root_domains() to be called because the set of scheduling
> domains are changed.
>

Thanks Longman for the explanation.

I believe we don't touch cpuset.sched_load_balance, so I don't know
what's wrong for now. But I've taken note and will go back to debug
further and see if there is any setup that needs to be fixed in our
system.

Hao
