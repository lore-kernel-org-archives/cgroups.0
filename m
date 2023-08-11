From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Fri, 11 Aug 2023 15:35:25 -0700
Message-ID: <CABWYdi0CXy2GZax_s6O-Xc0gvH+TGJzKwv_v6QqMty9P-ATJug@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com> <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
 <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com> <CABWYdi2iWYT0sHpK74W6=Oz6HA_3bAqKQd4h+amK0n3T3nge6g@mail.gmail.com>
 <CABWYdi3YNwtPDwwJWmCO-ER50iP7CfbXkCep5TKb-9QzY-a40A@mail.gmail.com>
 <CABWYdi0+0gxr7PB4R8rh6hXO=H7ZaCzfk8bmOSeQMuZR7s7Pjg@mail.gmail.com> <a052dffe-ed5e-6d22-8af8-0861e618f327@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1691793336; x=1692398136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8LF9AZyTjnQ02IC5rFGZjKpNEux79/i6FeKaru0zgQ=;
        b=dflohdncr3ytwTRzfIzKjnRGNGpaczVE0J/aFDcIK/Ne9KYPHVFRvuBcrQYbVm0HHB
         JdvAcrUFKtYXPFgvlOFtDpeEyw5Ro9GbfaPHzV2rOfL6XmOJCRlhKzwbKQaWrZLSLzfs
         TwwcIgyKy5GN7CVWekeF8j7XAxDopRi9Y/ANs=
In-Reply-To: <a052dffe-ed5e-6d22-8af8-0861e618f327-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Aug 11, 2023 at 3:27=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> On 8/11/23 18:03, Ivan Babrou wrote:
> > On Fri, Jul 14, 2023 at 5:30=E2=80=AFPM Ivan Babrou <ivan-lDpJ742SOEuslyEXuUq45g@public.gmane.org=
m> wrote:
> >> On Thu, Jul 13, 2023 at 4:25=E2=80=AFPM Ivan Babrou <ivan@cloudflare.c=
om> wrote:
> >>>> My understanding of mem-stat and cpu-stat is that they are independe=
nt
> >>>> of each other. In theory, reading one shouldn't affect the performan=
ce
> >>>> of reading the others. Since you are doing mem-stat and cpu-stat rea=
ding
> >>>> repetitively in a loop, it is likely that all the data are in the ca=
che
> >>>> most of the time resulting in very fast processing time. If it happe=
ns
> >>>> that the specific memory location of mem-stat and cpu-stat data are =
such
> >>>> that reading one will cause the other data to be flushed out of the
> >>>> cache and have to be re-read from memory again, you could see
> >>>> significant performance regression.
> >>>>
> >>>> It is one of the possible causes, but I may be wrong.
> >>> Do you think it's somewhat similar to how iterating a matrix in rows
> >>> is faster than in columns due to sequential vs random memory reads?
> >>>
> >>> * https://stackoverflow.com/q/9936132
> >>> * https://en.wikipedia.org/wiki/Row-_and_column-major_order
> >>> * https://en.wikipedia.org/wiki/Loop_interchange
> >>>
> >>> I've had a similar suspicion and it would be good to confirm whether
> >>> it's that or something else. I can probably collect perf counters for
> >>> different runs, but I'm not sure which ones I'll need.
> >>>
> >>> In a similar vein, if we could come up with a tracepoint that would
> >>> tell us the amount of work done (or any other relevant metric that
> >>> would help) during rstat flushing, I can certainly collect that
> >>> information as well for every reading combination.
> >> Since cgroup_rstat_flush_locked appears in flamegraphs for both fast
> >> (discrete) and slow (combined) cases, I grabbed some stats for it:
> >>
> >> * Slow:
> >>
> >> completed: 19.43s [manual / mem-stat + cpu-stat]
> >>
> >> $ sudo /usr/share/bcc/tools/funclatency -uT cgroup_rstat_flush_locked
> >> Tracing 1 functions for "cgroup_rstat_flush_locked"... Hit Ctrl-C to e=
nd.
> >> ^C
> >> 00:12:55
> >>       usecs               : count     distribution
> >>           0 -> 1          : 0        |                                =
        |
> >>           2 -> 3          : 0        |                                =
        |
> >>           4 -> 7          : 0        |                                =
        |
> >>           8 -> 15         : 0        |                                =
        |
> >>          16 -> 31         : 0        |                                =
        |
> >>          32 -> 63         : 0        |                                =
        |
> >>          64 -> 127        : 1        |                                =
        |
> >>         128 -> 255        : 191      |************                    =
        |
> >>         256 -> 511        : 590      |********************************=
********|
> >>         512 -> 1023       : 186      |************                    =
        |
> >>        1024 -> 2047       : 2        |                                =
        |
> >>        2048 -> 4095       : 0        |                                =
        |
> >>        4096 -> 8191       : 0        |                                =
        |
> >>        8192 -> 16383      : 504      |********************************=
**      |
> >>       16384 -> 32767      : 514      |********************************=
**      |
> >>       32768 -> 65535      : 3        |                                =
        |
> >>       65536 -> 131071     : 1        |                                =
        |
> >>
> >> avg =3D 8852 usecs, total: 17633268 usecs, count: 1992
> >>
> >> * Fast:
> >>
> >> completed:  0.95s [manual / mem-stat]
> >> completed:  0.05s [manual / cpu-stat]
> >>
> >> $ sudo /usr/share/bcc/tools/funclatency -uT cgroup_rstat_flush_locked
> >> Tracing 1 functions for "cgroup_rstat_flush_locked"... Hit Ctrl-C to e=
nd.
> >> ^C
> >> 00:13:27
> >>       usecs               : count     distribution
> >>           0 -> 1          : 0        |                                =
        |
> >>           2 -> 3          : 0        |                                =
        |
> >>           4 -> 7          : 499      |********************************=
********|
> >>           8 -> 15         : 253      |********************            =
        |
> >>          16 -> 31         : 191      |***************                 =
        |
> >>          32 -> 63         : 41       |***                             =
        |
> >>          64 -> 127        : 12       |                                =
        |
> >>         128 -> 255        : 2        |                                =
        |
> >>         256 -> 511        : 2        |                                =
        |
> >>         512 -> 1023       : 0        |                                =
        |
> >>        1024 -> 2047       : 0        |                                =
        |
> >>        2048 -> 4095       : 0        |                                =
        |
> >>        4096 -> 8191       : 0        |                                =
        |
> >>        8192 -> 16383      : 34       |**                              =
        |
> >>       16384 -> 32767      : 21       |*                               =
        |
> >>
> >> avg =3D 857 usecs, total: 904762 usecs, count: 1055
> >>
> >> There's a different number of calls into cgroup_rstat_flush_locked and
> >> they are much slower in the slow case. There are also two bands in the
> >> slow case, with 8ms..32ms having the half of the calls.
> >>
> >> For mem_cgroup_css_rstat_flush:
> >>
> >> * Slow:
> >>
> >> completed: 32.77s [manual / mem-stat + cpu-stat]
> >>
> >> $ sudo /usr/share/bcc/tools/funclatency -uT mem_cgroup_css_rstat_flush
> >> Tracing 1 functions for "mem_cgroup_css_rstat_flush"... Hit Ctrl-C to =
end.
> >> ^C
> >> 00:21:25
> >>       usecs               : count     distribution
> >>           0 -> 1          : 93078    |*                               =
        |
> >>           2 -> 3          : 3397714  |********************************=
********|
> >>           4 -> 7          : 1009440  |***********                     =
        |
> >>           8 -> 15         : 168013   |*                               =
        |
> >>          16 -> 31         : 93       |                                =
        |
> >>
> >> avg =3D 3 usecs, total: 17189289 usecs, count: 4668338
> >>
> >> * Fast:
> >>
> >> completed:  0.16s [manual / mem-stat]
> >> completed:  0.04s [manual / cpu-stat]
> >>
> >> $ sudo /usr/share/bcc/tools/funclatency -uT mem_cgroup_css_rstat_flush
> >> Tracing 1 functions for "mem_cgroup_css_rstat_flush"... Hit Ctrl-C to =
end.
> >> ^C
> >> 00:21:57
> >>       usecs               : count     distribution
> >>           0 -> 1          : 1441     |***                             =
        |
> >>           2 -> 3          : 18780    |********************************=
********|
> >>           4 -> 7          : 4826     |**********                      =
        |
> >>           8 -> 15         : 732      |*                               =
        |
> >>          16 -> 31         : 1        |                                =
        |
> >>
> >> avg =3D 3 usecs, total: 89174 usecs, count: 25780
> >>
> >> There's an 181x difference in the number of calls into
> >> mem_cgroup_css_rstat_flush.
> >>
> >> Does this provide a clue? Perhaps cgroup_rstat_cpu_pop_updated is
> >> yielding a ton more iterations for some reason here?
> >>
> >> * https://elixir.bootlin.com/linux/v6.1/source/kernel/cgroup/rstat.c#L=
196
> >>
> >> It's inlined, but I can place a probe into the loop:
> >>
> >>        7         for_each_possible_cpu(cpu) {
> >>        8                 raw_spinlock_t *cpu_lock =3D
> >> per_cpu_ptr(&cgroup_rstat_cpu_lock,
> >>                                                                 cpu);
> >>       10                 struct cgroup *pos =3D NULL;
> >>                          unsigned long flags;
> >>
> >>                          /*
> >>                           * The _irqsave() is needed because cgroup_rs=
tat_lock is
> >>                           * spinlock_t which is a sleeping lock on
> >> PREEMPT_RT. Acquiring
> >>                           * this lock with the _irq() suffix only
> >> disables interrupts on
> >>                           * a non-PREEMPT_RT kernel. The raw_spinlock_=
t
> >> below disables
> >>                           * interrupts on both configurations. The
> >> _irqsave() ensures
> >>                           * that interrupts are always disabled and
> >> later restored.
> >>                           */
> >>                          raw_spin_lock_irqsave(cpu_lock, flags);
> >>                          while ((pos =3D
> >> cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu))) {
> >>                                  struct cgroup_subsys_state *css;
> >>
> >>                                  cgroup_base_stat_flush(pos, cpu);
> >>       26                         bpf_rstat_flush(pos, cgroup_parent(po=
s), cpu);
> >>
> >>       28                         rcu_read_lock();
> >>       29                         list_for_each_entry_rcu(css,
> >> &pos->rstat_css_list,
> >>                                                          rstat_css_nod=
e)
> >>       31                                 css->ss->css_rstat_flush(css,=
 cpu);
> >>       32                         rcu_read_unlock();
> >>                          }
> >>       34                 raw_spin_unlock_irqrestore(cpu_lock, flags);
> >>
> >> I added probes on both line 26 and line 31 to catch the middle and inn=
er loops.
> >>
> >> * Slow:
> >>
> >> completed: 32.97s [manual / mem-stat + cpu-stat]
> >>
> >>   Performance counter stats for '/tmp/derp':
> >>
> >>           4,702,570      probe:cgroup_rstat_flush_locked_L26
> >>           9,301,436      probe:cgroup_rstat_flush_locked_L31
> >>
> >> * Fast:
> >>
> >> completed:  0.17s [manual / mem-stat]
> >> completed:  0.34s [manual / cpu-stat]
> >>
> >>   Performance counter stats for '/tmp/derp':
> >>
> >>              31,769      probe:cgroup_rstat_flush_locked_L26
> >>              62,849      probe:cgroup_rstat_flush_locked_L31
> >>
> >> It definitely looks like cgroup_rstat_cpu_pop_updated is yielding a
> >> lot more positions.
> >>
> >> I'm going to sign off for the week, but let me know if I should place
> >> any more probes to nail this down.
> > I spent some time looking into this and I think I landed on a fix:
> >
> > * https://github.com/bobrik/linux/commit/50b627811d54
> >
> > I'm not 100% sure if it's the right fix for the issue, but it reduces
> > the runtime significantly.
>
> It looks like the overhead of mem_cgroup_flush_stats() may be the cause
> of the performance regression. So what version of the Linux kernel are
> you using? From the patch listed in the URL above, it doesn't seem like
> you are using the latest kernel.
>
> The latest upstream kernel already have patches that reduce rstat
> flushing overhead like commit 11192d9c124 ("memcg: flush stats only if
> updated"). Have you try to reproduce it with the latest kernel?

We're on v6.1, which is the latest LTS (I mentioned it in the first
message). It has this patch included and my commit mentions it in the
very first line of the description.

I should've also mentioned commit fd25a9e0e23b ("memcg: unify memcg
stat flushing") from the same series, which my patch is partially
reverting.
