From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v2 0/4] mm/memcg: Address PREEMPT_RT problems instead of disabling it.
Date: Fri, 11 Feb 2022 23:35:33 +0100
Message-ID: <20220211223537.2175879-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644618945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2jFa60m1adjhL+4fflkSQgNee+J2OI1P+D0ydxQNeSM=;
        b=PY+tx1P/mAMJnjwiGOq8e0x1SapvGN6YbEqZaTEbMW2zWB0RjTDrvIb6ROp0H8V02fkC18
        VMSHJ69jRzMfXnFB6K80K5V1OabCPyXzqitZdwCtgC06n/VTeVk/i+I1j1JXdsULrnXeQe
        JzeDCNY2nbc8So97FKQmAn6Q+JtOnEZeTuZU1XkPvPUPbBBN+dYopC+zcptCSOc56qYfhT
        U8+mQd2WJEgQnzJRNdIsPONysf5VTR9KPCIF/s4H8X8GdAUlCY+cFL7emEO3NNEElbhYE7
        0ZATNH/bUreS/33JZmnH83dZrO8RuDMKDmNQF4lNUgWQereiUO1p21BRe1aYrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644618945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2jFa60m1adjhL+4fflkSQgNee+J2OI1P+D0ydxQNeSM=;
        b=MOCraIlS0/LMJ+LLb0Si15mJMZtVSnjhrMJYsm25gGy9c0+ObvcxsdrF7SxqppFmMTgVLu
        PjGlxx5xmHuA49Aw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

this series aims to address the memcg related problem on PREEMPT_RT.

I tested them on CONFIG_PREEMPT and CONFIG_PREEMPT_RT with the
tools/testing/selftests/cgroup/* tests and I haven't observed any
regressions (other than the lockdep report that is already there).

Changes since v1:
- Made a full patch from Michal Hocko's diff to disable the from-IRQ vs
  from-task optimisation

- Disabling threshold event handlers is using now IS_ENABLED(PREEMPT_RT)
  instead of #ifdef. The outcome is the same but there is no need to
  shuffle the code around.

v1: https://lore.kernel.org/all/20220125164337.2071854-1-bigeasy@linutronix=
.de/

Changes since the RFC:
- cgroup.event_control / memory.soft_limit_in_bytes is disabled on
  PREEMPT_RT. It is a deprecated v1 feature. Fixing the signal path is
  not worth it.

- The updates to per-CPU counters are usually synchronised by disabling
  interrupts. There are a few spots where assumption about disabled
  interrupts are not true on PREEMPT_RT and therefore preemption is
  disabled. This is okay since the counter are never written from
  in_irq() context.

RFC: https://lore.kernel.org/all/20211222114111.2206248-1-bigeasy@linutroni=
x.de/

Sebastian


