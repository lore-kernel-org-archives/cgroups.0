From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on suspend-resume
Date: Tue, 7 Mar 2023 13:06:57 -0800
Message-ID: <CA+khW7iWAn6bbXdkJX1Lt4dWUsN6o4KqVQ8OFTs0B+VTtVjBkw@mail.gmail.com>
References: <20230206221428.2125324-1-qyousef@layalina.io> <CA+khW7i_Sc0M4FXzojmQ5PSfkPwk6AdcbN9j0gDXZ9FsOMQAwA@mail.gmail.com>
 <f3a99500-e51c-032f-a0c6-01763f0a5be6@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678223229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht5LN05corsofYoRRZ6LtuPGm1HccZj2Qv4agF8zMXE=;
        b=j56rWVMq8AcAbG91+IFHoGnDYEKdEhPpWXttHuOCR9ZdEgqreHqaCEhELwykgJTclB
         rgqtjUgRgeI58Y7JhFG2bz3LQdOGRetfU31lRgyq+dl8CucVnMQp/oOSQsC48IB9K6+g
         hFehKk3LYl6xHfwqzf6XGkDsnIsz037HXGHbRuvtt3Z8IhyD121NivSzU/m9hA2H6rxh
         Lf0aJetdsL8le7mzSvfLD4j0dul5xrEvBKyw6tsGDAkeKa8Ci8OV3CZwni72Y+CJF3o+
         3dE9D7q4P2O+b5YsJbbC4vJwi+9NXDGYIBnpJnF2VnD+fENEF7Guz3Oh4otbyF+ZnIlA
         W8pg==
In-Reply-To: <f3a99500-e51c-032f-a0c6-01763f0a5be6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Mar 7, 2023 at 12:09=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> On 3/7/23 14:56, Hao Luo wrote:
> > On Mon, Feb 6, 2023 at 2:15=E2=80=AFPM Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org=
> wrote:
> >> Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting=
 information")
> >> enabled rebuilding root domain on cpuset and hotplug operations to
> >> correct deadline accounting.
> >>
> >> Rebuilding root domain is a slow operation and we see 10+ of ms delays
> >> on suspend-resume because of that (worst case captures 20ms which
> >> happens often).
> >>
> >> Since nothing is expected to change on suspend-resume operation; skip
> >> rebuilding the root domains to regain the some of the time lost.
> >>
> >> Achieve this by refactoring the code to pass whether dl accoutning nee=
ds
> >> an update to rebuild_sched_domains(). And while at it, rename
> >> rebuild_root_domains() to update_dl_rd_accounting() which I believe is
> >> a more representative name since we are not really rebuilding the root
> >> domains, but rather updating dl accounting at the root domain.
> >>
> >> Some users of rebuild_sched_domains() will skip dl accounting update
> >> now:
> >>
> >>          * Update sched domains when relaxing the domain level in cpus=
et
> >>            which only impacts searching level in load balance
> >>          * update sched domains when cpufreq governor changes and we n=
eed
> >>            to create the perf domains
> >>
> >> Users in arch/x86 and arch/s390 are left with the old behavior.
> >>
> >> Debugged-by: Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Qais Yousef (Google) <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> >> ---
> > Hi Qais,
> >
> > Thank you for reporting this. We observed the same issue in our
> > production environment. Rebuild_root_domains() is also called under
> > cpuset_write_resmask, which handles writing to cpuset.cpus. Under
> > production workloads, on a 4.15 kernel, we observed the median latency
> > of writing cpuset.cpus at 3ms, p99 at 7ms. Now the median becomes
> > 60ms, p99 at >100ms. Writing cpuset.cpus is a fairly frequent and
> > critical path in production, but blindly traversing every task in the
> > system is not scalable. And its cost is really unnecessary for users
> > who don't use deadline tasks at all.
>
> The rebuild_root_domains() function shouldn't be called when updating
> cpuset.cpus unless it is a partition root. Is it?
>

I think it's because we were using the legacy hierarchy. I'm not
familiar with cpuset partition though.

Hao
