From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH -tip 0/3] sched: some fixes for vruntime calculation related
 to cgroup movement(v2)
Date: Thu, 15 Dec 2011 14:35:06 +0900
Message-ID: <20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Hi, all.

This is an updated version based on comments and rebased onto the -tip tree.

These patches fix problems I could see in 3.2-rc2 when testing frequent cgroup movement
under very high load. Without these patches, some processes were not scheduled
(although they were queued into rq)for a very long time(minutes or hours!),
because vruntime of these processes were far bigger than min_vruntime.

Daisuke Nishimura (3):
  sched: fix cgroup movement of newly created process
  sched: fix cgroup movement of forking process
  sched: fix cgroup movement of waking process

 kernel/sched/fair.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

Thanks,
Daisuke Nishimura.
