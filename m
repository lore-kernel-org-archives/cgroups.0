From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Expensive memory.stat + cpu.stat reads
Date: Fri, 30 Jun 2023 16:22:28 -0700
Message-ID: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1688167360; x=1690759360;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VK1/OtAJXK8/kraYa6/U+8C0ZuqhuzcqNzn9O4FJGas=;
        b=JIyBKNtRrCvh1/J0Aia88RunCnBe34DcvcRR/xqkto9DKiP0CoJsMe9AEsMrcocQXa
         KXzU0xeE8Ynn4vsjVq6S/1cSMppdCM5vHTv6cycRYhKMbtS8osvCknVpybopDo8HlGmS
         2aY3f2gRBCcrD1RClb7o73Cvr+nsmVkDEnhIo=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

We're seeing CPU load issues with cgroup stats retrieval. I made a
public gist with all the details, including the repro code (which
unfortunately requires heavily loaded hardware) and some flamegraphs:

* https://gist.github.com/bobrik/5ba58fb75a48620a1965026ad30a0a13

I'll repeat the gist of that gist here. Our repro has the following
output after a warm-up run:

completed:  5.17s [manual / mem-stat + cpu-stat]
completed:  5.59s [manual / cpu-stat + mem-stat]
completed:  0.52s [manual / mem-stat]
completed:  0.04s [manual / cpu-stat]

The first two lines do effectively the following:

for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/memory.stat
/sys/fs/cgroup/system.slice/cpu.stat > /dev/null

The latter two are the same thing, but via two loops:

for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/cpu.stat >
/dev/null; done
for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/memory.stat
> /dev/null; done

As you might've noticed from the output, splitting the loop into two
makes the code run 10x faster. This isn't great, because most
monitoring software likes to get all stats for one service before
reading the stats for the next one, which maps to the slow and
expensive way of doing this.

We're running Linux v6.1 (the output is from v6.1.25) with no patches
that touch the cgroup or mm subsystems, so you can assume vanilla
kernel.

From the flamegraph it just looks like rstat flushing takes longer. I
used the following flags on an AMD EPYC 7642 system (our usual pick
cpu-clock was blaming spinlock irqrestore, which was questionable):

perf -e cycles -g --call-graph fp -F 999 -- /tmp/repro

Naturally, there are two questions that arise:

* Is this expected (I guess not, but good to be sure)?
* What can we do to make this better?

I am happy to try out patches or to do some tracing to help understand
this better.
