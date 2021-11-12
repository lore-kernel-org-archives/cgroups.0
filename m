From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Questions about replacing isolcpus by cgroup-v2
Date: Fri, 12 Nov 2021 17:37:07 +0100
Message-ID: <20211112163707.GA315388@lothringen>
References: <AM9PR10MB48692A964E3106D11AC0FDEE898D9@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
 <20211112153656.qkwyvdmb42ze25iw@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636735030;
        bh=GS153duIpf6p5uzAwTDe6we3+dolhCi2DZKA7ujmHls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGZ37Kgc90dL7lAVMZ2FJ1aXipF8gl6tNM0FuBn7Gm2U2kMosmvrrHAAyNMgYTehJ
         EWFjhbbiEFWP+TqHuaudpGkZhX39Wm6M4XiBLoDsjRf2egC46nuvNUke+QVJeSLQN6
         EPKosuM1LxY2H37hDEibXqGGOnEZLxOFWcbC8Oj5vZdT/hLnv6dI/y9w1qabXswwaR
         hRj0eiDx8GlpnYeSj/HcLHVQApH/Yh1f0eykcdnx6tyC8MxukGzJtvzWqUkVNo1lNt
         DyoI0FYq9mXvDAM8lKCnNlPQiK8MZ65DHaOseFdM9W35JqVa6iFDAiGbjnHTek07q+
         bs5/3ws04MoXA==
Content-Disposition: inline
In-Reply-To: <20211112153656.qkwyvdmb42ze25iw-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "Schmidt, Adriaan" <adriaan.schmidt-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Nov 12, 2021 at 04:36:56PM +0100, Sebastian Andrzej Siewior wrote:
> On 2021-11-04 17:29:08 [+0000], Moessbauer, Felix wrote:
> > Dear subscribers,
> Hi,
> 
> I Cced cgroups@vger since thus question fits there better.
> I Cced Frederic in case he has come clues regarding isolcpus and
> cgroups.
> 
> > we are currently evaluating how to rework realtime tuning to use cgroup-v2 cpusets instead of the isolcpus kernel parameter.
> > Our use-case are realtime applications with rt and non-rt threads. Hereby, the non-rt thread might create additional non-rt threads:
> > 
> > Example (RT CPU=1, 4 CPUs):
> > - Non-RT Thread (A) with default affinity 0xD (1101b)
> > - RT Thread (B) with Affinity 0x2 (0010b, via set_affinity)
> > 
> > When using pure isolcpus and cgroup-v1, just setting isolcpus=1 perfectly works:
> > Thread A gets affinity 0xD, Thread B gets 0x2 and additional threads get a default affinity of 0xD.
> > By that, independent of the threads' priorities, we can ensure that nothing is scheduled on our RT cpu (except from kernel threads, etc...).
> > 
> > During this journey, we discovered the following:
> > 
> > Using cgroup-v2 cpusets and isolcpus together seems to be incompatible:
> > When activating the cpuset controller on a cgroup (for the first time), all default CPU affinities are reset.
> > By that, also the default affinity is set to 0xFFFF..., while with isolcpus we expect it to be (0xFFFF - isolcpus).
> > This breaks the example from above, as now the non-RT thread can also be
> > scheduled on the RT CPU.

That sounds buggy from the cpuset-v2 side (adding the maintainers in Cc).

Also please have a look into "[PATCH v8 0/6] cgroup/cpuset: Add new cpuset
partition type & empty effecitve cpus":

	  https://lore.kernel.org/lkml/20211018143619.205065-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

This stuff adds support for a new "isolated" partition type on cpuset/cgroup-v2
which should behave just like isolcpus.

> > 
> > When only using cgroup-v2, we can isolate our RT process by placing it in a cgroup with CPUs=0,1 and remove CPU=1 from all other cgroups.
> > However, we do not know of a strategy to set a default affinity:
> > Given the example above, we have no way to ensure that newly created threads are born with an affinity of just 0x2 (without changing the application).
> > 
> > Finally, isolcpus itself is deprecated since kernel 5.4.
> 
> Where is this the deprecation of isolcpus announced/ written?

We tried to deprecate it but too many people are still using it. Better pick an
interface that allows you to change the isolated set at runtime like
cpuset.sched_load_balance on cpuset/cgroup-v1 or the above patchset on v2.

Thanks.
