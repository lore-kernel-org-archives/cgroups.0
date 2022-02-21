From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v4 0/6] mm/memcg: Address PREEMPT_RT problems instead of disabling it.
Date: Mon, 21 Feb 2022 19:25:34 +0100
Message-ID: <20220221182540.380526-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645467966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jxyd7UXPX5m/2j0TbW7YsD0CbLlXnk2SQHCfRxdbRq8=;
        b=rDqhHBZwWPmrML+3zs+6Mry2+GNEjjA2OB1vXBk6cIwkdYf79tuoYcBtWuGqMUx7pbqKav
        A/11ZQzjIQf7TZ0fZ5Qt12GUJbJ4CEf0+OKdcxPBoWpMPvM9G1p2FbpsPgZXRDx3VXeRRU
        Uq/iEdP/UHrQ4l7y4x65LjBJPhypR3DE+anLYbBxZcQ5HxHzmkG0w0CnJyPiXPQd9VZWk5
        qc7JN+OWjdgOUJr695dH+ENcatXmRCfewsDIjstt8Wt34dqGa81x8iLqUMRq9V8MC01d83
        u/Aj13T3DL3oGVIK9y6vegva0eyCsY+bK5ZhkIpTAXSC2wNc6xXWBiEdhpDDIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645467966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jxyd7UXPX5m/2j0TbW7YsD0CbLlXnk2SQHCfRxdbRq8=;
        b=z0wkmCZRL38ez2aF9RpPLjXxM5m6UAa833zd33BcQNifDcHjsIBWZcqD8bdsNL9+6VRwmU
        LpFHPO8HL8JCCEBw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

this series aims to address the memcg related problem on PREEMPT_RT.

I tested them on CONFIG_PREEMPT and CONFIG_PREEMPT_RT with the
tools/testing/selftests/cgroup/* tests and I haven't observed any
regressions (other than the lockdep report that is already there).

Changes since v3:
- Added __memcg_stats_lock() to __mod_memcg_lruvec_state(). This one
  does not check for disabled interrupts on !RT. The only user
  (__mod_memcg_lruvec_state()) checks if the context is task (neither
  soft nor hard irq) if the two idx are used which are used by rmap.c
  and otherwise it checks for disabled interrupts. Reported by Shakeel
  Butt.

- In drain_all_stock() migration is disabled and drain_local_stock() is
  invoked directly if the request CPU is the local CPU.=20

v3: https://lore.kernel.org/all/20220217094802.3644569-1-bigeasy@linutronix=
.de/

Changes since v2:
- rebased on top of v5.17-rc4-mmots-2022-02-15-20-39.

- Added memcg_stats_lock() in 3/5 so it a little more obvious and
  hopefully easiert to maintain.

- Opencoded obj_cgroup_uncharge_pages() in drain_obj_stock(). The
  __locked suffix was confusing.

v2: https://lore.kernel.org/all/20220211223537.2175879-1-bigeasy@linutronix=
.de/

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


