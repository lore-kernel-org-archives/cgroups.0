From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/1] sched/fair: Fix unfairness caused by missing load decay
Date: Tue, 27 Apr 2021 12:55:44 +0200
Message-ID: <CAKfTPtCdJC2-jxJn82Z4GSsHu0e49pKL4DT0GWk5vKXnyn1Gog@mail.gmail.com>
References: <20210425080902.11854-1-odin@uged.al> <CAKfTPtBHm+CjBTA614P9F2Vx3Bj7vv9Pt0CGFsiwqcrTFmKzjg@mail.gmail.com>
 <CAFpoUr1FgZhuBmor2vCFqC9z7wao+XSybPxJZKFfK-wvZOagCA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S82r8jx5k9d+bfs4UuyuPxKItqibi9UQtep8XqfhYv4=;
        b=itJy1ugZD6GY7AOr/xYufPZq/gR/mFIsdnZCRMF2UuJWl3j1THE6ki08H1rvM3F8k8
         kICTmi5ZBp2qejTvXlH0E1JXk2Iq/cfq2gxxNpi+z5wJv5921gi9KOW76tTdRtAEPvF1
         rn4oA7GFo0V35hCDqX7kJAOmoCZFm2MFhLsd4wrRVEGgzOlecF949Ra0KBCu1H7t5mOj
         wB4u2jFf+IK0PfUus2BmkY19uLh1692l35TpMOoUpfjpPmemUXgOXORzVyA+zxVTxP0u
         isvH4NXN0vwrLbiosZ8dkd7cU5oekLBc+U44FXf9TuK57DxT/lGI3SMif0vke0zMzrYz
         WB9Q==
In-Reply-To: <CAFpoUr1FgZhuBmor2vCFqC9z7wao+XSybPxJZKFfK-wvZOagCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 26 Apr 2021 at 18:33, Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org> wrote:
>
> Hi,
>
>
> > Have you been able to reproduce this on mainline ?
>
> Yes. I have been debugging and testing with v5.12-rc8. After I found
> the suspected
> commit in ~v4.8, I compiled both the v4.4.267 and v4.9.267, and was able to
> successfully reproduce it on v4.9.267 and not on v4.4.267. It is also
> reproducible
> on 5.11.16-arch1-1 that my distro ships, and it is reproducible on all
> the machines
> I have tested.
>
> > When running the script below on v5.12, I'm not able to reproduce your problem
>
> v5.12 is pretty fresh, so I have not tested on anything before v5.12-rc8. I did
> compile v5.12.0 now, and I am able to reproduce it there as well.

I wanted to say one v5.12-rcX version to make sure this is still a
valid problem on latest version

>
> Which version did you try (the one for cgroup v1 or v2)? And/or did you try
> to run the inspection bpftrace script? If you tested the cg v1
> version, it will often
> end up at 50/50, 51/49 etc., and sometimes 60/40+-, making it hard to
> verify without inspection.

I tried cgroup v1 and v2 but not the bpf script

>
> I have attached a version of the "sub cgroup" example for cgroup v1,
> that also force
> the process to start on cpu 1 (CPU_ME), and sends it over to cpu 0
> (CPU) after attaching
> to the new cgroup. That will make it evident each time. This example should also
> always end up with 50/50 per stress process, but "always" ends up more
> like 99/1.
>
> Can you confirm if you are able to reproduce with this version?

I confirm that I can see a ratio of 4ms vs 204ms running time with the
patch below. But when I look more deeply in my trace (I have
instrumented the code), it seems that the 2 stress-ng don't belong to
the same cgroup but remained in cg-1 and cg-2 which explains such
running time difference. So your script doesn't reproduce the bug you
want to highlight. That being said, I can also see a diff between the
contrib of the cpu0 in the tg_load. I'm going to look further

>
> --- bash start
> CGROUP_CPU=/sys/fs/cgroup/cpu/slice
> CGROUP_CPUSET=/sys/fs/cgroup/cpuset/slice
> CGROUP_CPUSET_ME=/sys/fs/cgroup/cpuset/me
> CPU=0
> CPU_ME=1
>
> function run_sandbox {
>   local CG_CPUSET="$1"
>   local CG_CPU="$2"
>   local INNER_SHARES="$3"
>   local CMD="$4"
>
>   local PIPE="$(mktemp -u)"
>   mkfifo "$PIPE"
>   sh -c "read < $PIPE ; exec $CMD" &
>   local TASK="$!"
>   sleep .1
>   mkdir -p "$CG_CPUSET"
>   mkdir -p "$CG_CPU"/sub
>   tee "$CG_CPU"/sub/cgroup.procs <<< "$TASK"
>   tee "$CG_CPU"/sub/cpu.shares <<< "$INNER_SHARES"
>
>   tee "$CG_CPUSET"/cgroup.procs <<< "$TASK"
>
>   tee "$PIPE" <<< sandox_done
>   rm "$PIPE"
> }
>
> mkdir -p "$CGROUP_CPU"
> mkdir -p "$CGROUP_CPUSET"
> mkdir -p "$CGROUP_CPUSET_ME"
>
> tee "$CGROUP_CPUSET"/cpuset.cpus <<< "$CPU"
> tee "$CGROUP_CPUSET"/cpuset.mems <<< "$CPU"
>
> tee "$CGROUP_CPUSET_ME"/cpuset.cpus <<< "$CPU_ME"
> echo $$ | tee "$CGROUP_CPUSET_ME"/cgroup.procs
>
> run_sandbox "$CGROUP_CPUSET" "$CGROUP_CPU/cg-1" 50000 "stress --cpu 1"
> run_sandbox "$CGROUP_CPUSET" "$CGROUP_CPU/cg-2" 2     "stress --cpu 1"
>
> read # click enter to cleanup and stop all stress procs
> killall stress
> sleep .2
> rmdir /sys/fs/cgroup/cpuset/slice/
> rmdir /sys/fs/cgroup/cpu/slice/{cg-{1,2}{/sub,},}
> --- bash end
>
>
> Thanks
> Odin
