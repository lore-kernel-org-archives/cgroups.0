From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Fri, 14 Jul 2023 17:00:50 -0700
Message-ID: <CABWYdi2mBWsaEJXDEKeYaSCuikNbjBBU1yo+Yai+vM=rf2=LVQ@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com> <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
 <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com> <CABWYdi2iWYT0sHpK74W6=Oz6HA_3bAqKQd4h+amK0n3T3nge6g@mail.gmail.com>
 <fea3587a-ca6a-6930-bd3d-c4f7f330be67@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1689379261; x=1691971261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qCsYq5AfQu15dBgFcUhM5i+Y9hdaw4Di+rchoqRa1A=;
        b=w1so6/uRCSkF2JfOE4Lp7UEUm7H2/SnJOrUe5GP0/6Hoc5lu/q59ef2oEAIUdNGlPu
         1oBomtwOZE28hBXuVf9l6r3h/U7PyWOeBibY6Emk7xzVuyXK6RJfTioxx73MA4Ej67Ft
         gK1kNyPKvTTQneIkrmuHgWBjmDfq96bq6Y21Q=
In-Reply-To: <fea3587a-ca6a-6930-bd3d-c4f7f330be67-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jul 14, 2023 at 10:23=E2=80=AFAM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>
> On 7/13/23 19:25, Ivan Babrou wrote:
> > On Mon, Jul 10, 2023 at 5:44=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
> wrote:
> >> On 7/10/23 19:21, Ivan Babrou wrote:
> >>> On Wed, Jul 5, 2023 at 11:20=E2=80=AFPM Shakeel Butt <shakeelb@google=
.com> wrote:
> >>>> On Fri, Jun 30, 2023 at 04:22:28PM -0700, Ivan Babrou wrote:
> >>>>> Hello,
> >>>>>
> >>>>> We're seeing CPU load issues with cgroup stats retrieval. I made a
> >>>>> public gist with all the details, including the repro code (which
> >>>>> unfortunately requires heavily loaded hardware) and some flamegraph=
s:
> >>>>>
> >>>>> * https://gist.github.com/bobrik/5ba58fb75a48620a1965026ad30a0a13
> >>>>>
> >>>>> I'll repeat the gist of that gist here. Our repro has the following
> >>>>> output after a warm-up run:
> >>>>>
> >>>>> completed:  5.17s [manual / mem-stat + cpu-stat]
> >>>>> completed:  5.59s [manual / cpu-stat + mem-stat]
> >>>>> completed:  0.52s [manual / mem-stat]
> >>>>> completed:  0.04s [manual / cpu-stat]
> >>>>>
> >>>>> The first two lines do effectively the following:
> >>>>>
> >>>>> for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/memory.s=
tat
> >>>>> /sys/fs/cgroup/system.slice/cpu.stat > /dev/null
> >>>>>
> >>>>> The latter two are the same thing, but via two loops:
> >>>>>
> >>>>> for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/cpu.stat=
 >
> >>>>> /dev/null; done
> >>>>> for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/memory.s=
tat
> >>>>>> /dev/null; done
> >>>>> As you might've noticed from the output, splitting the loop into tw=
o
> >>>>> makes the code run 10x faster. This isn't great, because most
> >>>>> monitoring software likes to get all stats for one service before
> >>>>> reading the stats for the next one, which maps to the slow and
> >>>>> expensive way of doing this.
> >>>>>
> >>>>> We're running Linux v6.1 (the output is from v6.1.25) with no patch=
es
> >>>>> that touch the cgroup or mm subsystems, so you can assume vanilla
> >>>>> kernel.
> >>>>>
> >>>>>   From the flamegraph it just looks like rstat flushing takes longe=
r. I
> >>>>> used the following flags on an AMD EPYC 7642 system (our usual pick
> >>>>> cpu-clock was blaming spinlock irqrestore, which was questionable):
> >>>>>
> >>>>> perf -e cycles -g --call-graph fp -F 999 -- /tmp/repro
> >>>>>
> >>>>> Naturally, there are two questions that arise:
> >>>>>
> >>>>> * Is this expected (I guess not, but good to be sure)?
> >>>>> * What can we do to make this better?
> >>>>>
> >>>>> I am happy to try out patches or to do some tracing to help underst=
and
> >>>>> this better.
> >>>> Hi Ivan,
> >>>>
> >>>> Thanks a lot, as always, for reporting this. This is not expected an=
d
> >>>> should be fixed. Is the issue easy to repro or some specific workloa=
d or
> >>>> high load/traffic is required? Can you repro this with the latest li=
nus
> >>>> tree? Also do you see any difference of root's cgroup.stat where thi=
s
> >>>> issue happens vs good state?
> >>> I'm afraid there's no easy way to reproduce. We see it from time to
> >>> time in different locations. The one that I was looking at for the
> >>> initial email does not reproduce it anymore:
> >> My understanding of mem-stat and cpu-stat is that they are independent
> >> of each other. In theory, reading one shouldn't affect the performance
> >> of reading the others. Since you are doing mem-stat and cpu-stat readi=
ng
> >> repetitively in a loop, it is likely that all the data are in the cach=
e
> >> most of the time resulting in very fast processing time. If it happens
> >> that the specific memory location of mem-stat and cpu-stat data are su=
ch
> >> that reading one will cause the other data to be flushed out of the
> >> cache and have to be re-read from memory again, you could see
> >> significant performance regression.
> >>
> >> It is one of the possible causes, but I may be wrong.
> > Do you think it's somewhat similar to how iterating a matrix in rows
> > is faster than in columns due to sequential vs random memory reads?
> >
> > * https://stackoverflow.com/q/9936132
> > * https://en.wikipedia.org/wiki/Row-_and_column-major_order
> > * https://en.wikipedia.org/wiki/Loop_interchange
>
> Yes, it is similar to what is being described in those articles.
>
>
> >
> > I've had a similar suspicion and it would be good to confirm whether
> > it's that or something else. I can probably collect perf counters for
> > different runs, but I'm not sure which ones I'll need.
> >
> > In a similar vein, if we could come up with a tracepoint that would
> > tell us the amount of work done (or any other relevant metric that
> > would help) during rstat flushing, I can certainly collect that
> > information as well for every reading combination.
>
> The perf-c2c tool may be able to help. The data to look for is how often
> the data is from caches vs direct memory load/store.

It looks like c2c only works for the whole system, not individual
treads. There's a lot of noise from the rest of the system.
