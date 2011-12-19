From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: Re: [PATCH -tip 0/3] sched: some fixes for vruntime calculation
 related to cgroup movement(v2)
Date: Mon, 19 Dec 2011 11:55:08 +0900
Message-ID: <20111219115508.0d5bc98d.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	<20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111215143506.335e443e.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>

Someone who have comments ?
If there are some problems that prevent these patches from being accepted,
I'll fix them.

Thanks,
Daisuke Nishimura

On Thu, 15 Dec 2011 14:35:06 +0900
Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org> wrote:

> Hi, all.
> 
> This is an updated version based on comments and rebased onto the -tip tree.
> 
> These patches fix problems I could see in 3.2-rc2 when testing frequent cgroup movement
> under very high load. Without these patches, some processes were not scheduled
> (although they were queued into rq)for a very long time(minutes or hours!),
> because vruntime of these processes were far bigger than min_vruntime.
> 
> Daisuke Nishimura (3):
>   sched: fix cgroup movement of newly created process
>   sched: fix cgroup movement of forking process
>   sched: fix cgroup movement of waking process
> 
>  kernel/sched/fair.c |   22 ++++++++++++++++++++--
>  1 files changed, 20 insertions(+), 2 deletions(-)
> 
> Thanks,
> Daisuke Nishimura.
