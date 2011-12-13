From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: [PATCH 0/3] sched: some fixes for vruntime calculation related to
 cgroup movement
Date: Tue, 13 Dec 2011 15:57:10 +0900
Message-ID: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

Hi,

These patches fix problems I could see in 3.2-rc2 when testing frequent cgroup movement
under very high load. Without these patches, some processes were not scheduled
(although they were queued into rq)for a very long time(minutes or hours!),
because vruntime of these processes were far bigger than min_vruntime.

Daisuke Nishimura (3):
  sched: fix cgroup movement of newly created process
  sched: fix cgroup movement of forking process
  sched: fix cgroup movement of waking process

 kernel/sched_fair.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)


Thanks,
Daisuke Nishimura.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
