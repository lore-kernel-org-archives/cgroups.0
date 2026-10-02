Received: from mail-dy2-f40.google.com (mail-dy2-f40.google.com [74.125.229.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C5049892A
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946639; cv=none; b=rmAay8vbiesf2I6OabXR/v3vc/QMKq2RVpNjzyS/Z8NPaQAlRgc4x3KDvE7UjPQSSLXVanCHAT5tm552Hwu7dWji0mikMfZqVPTkWma2YKrZq5fA/LXQWEY8NGa7e5qL1Ha0oluv+UjncGCcp0abagJqowKwBYVX5uvEJZWCN2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946639; c=relaxed/simple;
	bh=953Zce3sT7tTW2t7lTLnAiNMrpvoZpC1Sw2HVgtqVVk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=G9G1oEAIUMl2Yv+ZP1Q9xJs5+cZoaP9yGrC4PSGJ1dI/iuBAZ8nAjOF72yb2eq46Yxrb7k8vQh8jHdAmSWBkcjmc/aElNEJH1B6D+OB/yFQu9A3O4ZNuTHld5XRUa/MZqvkPCxxYEoU0j0MM0iiU4IvYBbP/ssfNspTZIa0aRKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dAReCwe+; arc=none smtp.client-ip=74.125.229.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dAReCwe+"
Received: by mail-dy2-f40.google.com with SMTP id 5a478bee46e88-34ea9118159so1948801eec.3
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946631; x=1791551431; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YfYUoXDoquTDHPpxsK7XM5vtynshH2OvSmQaYK2ji9s=;
        b=dAReCwe+NlHwTeR3besaSLUw0I7IPhwJwuD9iwcmOIURiZcsARm+eR7QxDgKFg681m
         tlIHs1HGXXHJbprZmazZigeUGYwXcFPOU9MTUQsqbxFsGI+X6Qv8ne6u5HR8dpbJw7Zn
         MxHDmNpjIKOn8n3giVLjh504YYCNyJcIoNTQI7KlodwfT9RQapH2oAbgrpjUBahJ2kCE
         Bwd5klS0jKWPhG1jx/oe+lFy1VvE6VbR+GoVmy9IAlLZ7zWo1t+46BE+v9vqO8uQ/4dC
         36QTJD2O2oaqSAX4c2vJ6uyNTEmUpFiWlecnuLxseHHnacQlA7hR7aCp91+TLyR3D8Cu
         ZjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946631; x=1791551431;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YfYUoXDoquTDHPpxsK7XM5vtynshH2OvSmQaYK2ji9s=;
        b=gUG4E0oZcOrPS4AI6QMl4CqzafDqlmhS30NY2rAL0AbnOwoRSi7PwoUZ7pdBde/JdH
         pCTyhaK8HFrSs+fgBzqgfBG3N0Szfb/ubox11btjpkeUiQLE9osykJkqfjVvTehAizr3
         sURzY2kHGAiXfSHaBpmy7aQBEqfezF8BGsQs1GctZvegyYSxEYsqdGxOQfZH/2b7sG9r
         SC/7S5fJw5XJtRCKnXy4r3V/qNzP78yf/8S1eu5GWFLYSoZmx1aT/mJpMdIGjmB59qkj
         h/UNNJ5hQ6EyCTaWZFzhQp+0P4inTGo0lFHnD6MXXFn6I6PXQx8lQSkU9KU8udJEw0xm
         DJ3A==
X-Forwarded-Encrypted: i=1; AKwUvBwk+vNC9kXjIYLiEU6UTjZScZrUfcLDPOhm9W3BbW56sEIpbr5pAom/Pn0LNbRQY+yWoi3iEkjx@vger.kernel.org
X-Gm-Message-State: AFq9FYIUGAYAetg++cz8tSnm3pemy9BQR4DyylSpjN4JxGwHdZmKKPuJ
	n6alnIk49V8jOibLU6kstywf0lpaCDK0OfUtn8JBZdK77jiw+xrVTv9i
X-Gm-Gg: AYBFou1SgGHDojx7rul4IK2NZkHPRnUJFdyvO3nrT1Dh6mn7seSvzhoVJFlAtZjGJGS
	3A3Rs7qTIluvioVQFI5mWp+gowa7jSLx8t9gnVJU7uvXuFqrpMvTQbJYKKDvoeA0VDSWI7QKQ7z
	NP+kIS+7wyu61KTsicW2oKemMGeLls3cjxs0XgFiq0Aes4R4RAhCNnqxBG4vlYxb136ZjaQ8Mhl
	VcVXdUnaS4N6KQWIWTnWE6s4v72XXFYcVgZKxbNhTJsoxOSFi3witLSP0r3djm2DXNwfmjOxmZb
	KGtg3Pj9LQTdcEoZqMhyArCfRTtICVwWh8FBaQSgQZvGeqcKROfqZ6AdM4mzIZtY/SC1iJeAgkC
	f6RDb1ZhE94oti3xeNine0uFwlPnnHw4cSqeY11DjTQki0wWIP7wEl07iBGr0isNrnQy2Qagwey
	vpj8gR9P6qWMyYY2hC3/GJPR6ikk4i+LjdC7gyTpJvQKVLB5NoyXCVEWgviAhdimKiyQ==
X-Received: by 2002:a05:693c:3881:b0:34c:1f07:2d5 with SMTP id 5a478bee46e88-34f1508567fmr2912506eec.6.1790946630947;
        Fri, 02 Oct 2026 06:10:30 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:10:30 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v5 00/12] Dynamic Housekeeping Management (DHM) via CPUSets
Date: Fri, 02 Oct 2026 21:10:20 +0800
Message-Id: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAD2tv2oC/13Q3WrDIBTA8VcpXs+hR2PMrvYeYxTjR3JGPoo2b
 qXk3WdKIW3vPAd+fw5eSfIRfSIfhyuJPmPCeSpD9XYgtjdT5ym6MhNgoJhkmv4uPzh11PUj1UE
 KD0421mlSwCn6gH+32Nd3mXtM5zlebu0M2/ae4eIxk4EyypQLwK1pTeU+u9Hg8G7nkWyZzHcqo
 CrGI80caMDJDOVVeMMbaw0Ia1x44THY3QNTNHhzXqKn7jKZEe0R0zzY05KO9/B2DTM1575ltpa
 v14i9pvjTf2RRKOjAjXRatEq/UrnTmrMnKjfqGw6+co2S1SNd1/UfXU/VkagBAAA=
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
 rcu@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

This series introduces Dynamic Housekeeping Management (DHM) to the Linux
kernel, enabling runtime reconfiguration of kernel-noise housekeeping
(nohz_full tick suppression, RCU NOCB offloading, and managed IRQ
migration) through the existing cgroup v2 cpuset isolated partition
mechanism — no new kernel ABI required.

When a cpuset partition is set to isolated mode, DHM cycles each CPU in
that partition offline, reconfigures the housekeeping masks (removing the
CPU from HK_TYPE_KERNEL_NOISE and related types), and brings it back
online.  The subsystems (tick/nohz, RCU NOCB, genirq) pick up the new
masks through their existing CPU hotplug callbacks.  Destroying the
partition reverses the cycle: each CPU is taken offline, restored to all
housekeeping masks, and brought back online.

Housekeeping cpumask pointers are RCU-protected to allow lock-free readers
during updates.  A global dhm_cycling_cpus mask suppresses transient
cpuset partition invalidation while CPUs are being cycled.

This work is related to Waiman Long's [PATCH-next 00/23] series
(20260421030351.281436-1-longman@redhat.com), which also targets runtime
cpuset housekeeping control.  DHM's distinguishing feature is zero-boot-
parameter activation: nohz_full+nocb isolation can be achieved at runtime
without any boot-time nohz_full= or rcu_nocbs= parameters.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V4 -> V5:
- Rebase onto current mainline (was based on a v7.1-era snapshot).
- Gate the HK_TYPE_KERNEL_NOISE/HK_TYPE_MANAGED_IRQ mask update on the
  HK_TYPE_DOMAIN update succeeding, so a CPU can never end up
  tick-suppressed while still part of the normal sched domain.
  Frederic asked for HK_TYPE_KERNEL_NOISE to stay a subset of
  HK_TYPE_DOMAIN.
- Keep cpuset_top_mutex held across dhm_cycle_isolated_cpus() instead
  of releasing it before the hotplug cycle, so dhm_prev_isolated's
  "protected by cpuset_top_mutex" invariant actually holds and a second
  isolated-partition update cannot race with one still in flight.
  Frederic asked whether cpus_read_lock should stay held here.
- Remove tick_nohz_full_mask and tick_nohz_full_running; derive
  tick_nohz_full_enabled()/tick_nohz_full_cpu() from
  housekeeping_enabled(HK_TYPE_KERNEL_NOISE) and
  housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE) instead, removing the
  now-redundant lazy-allocation and locking in
  tick_nohz_cpu_isolate()/deisolate().  Frederic pointed out the
  duplication.
- Publish each CPU's HK_TYPE_KERNEL_NOISE/HK_TYPE_MANAGED_IRQ mask
  update from dhm_cycle_isolated_cpus() itself, strictly between that
  CPU's own remove_cpu() succeeding and add_cpu() bringing it back,
  instead of batching the whole isolation set before or after the
  cycle.  A CPU the cycling loop skips (not hotpluggable, or
  remove_cpu() fails) is then simply never published as isolated,
  with no separate pre-filter or republish-on-failure step needed.
- Install tick_do_timer_cpu's hotplug protection from
  housekeeping_update_types()'s HK_TYPE_KERNEL_NOISE first-enable
  path too, via a new tick_nohz_full_hotplug_init(): tick_nohz_init()
  never runs on DHM's zero-boot-param path, so the current duty
  holder had no protection against being pulled down by remove_cpu().
- Keep tick_nohz_cpu_hotpluggable()'s duty-holder check on the plain
  housekeeping_enabled() flag rather than a mask-aware variant:
  housekeeping_update_types() only publishes a CPU's isolation after
  its own remove_cpu() already succeeded, so a mask-aware check would
  see every single-CPU isolation's own live mask as still empty and
  leave the duty holder unprotected each time, not just the first.
  Use the mask-aware variant only for tick_sched_do_timer()'s
  diagnostic WARN, since HK_TYPE_KERNEL_NOISE can stay enabled with an
  empty mask after a full runtime de-isolation, an ordinary
  NO_HZ_IDLE handover rather than a violation.
- Close a context_tracking_key activation race: a CPU whose
  kernel<->user transition lands in the window before every CPU
  observes static_branch_inc()'s patched code sees
  context_tracking_enabled() as still false and silently drops the
  transition, tripping CT_WARN_ON() on its next kernel entry.  Add
  context_tracking_activating, a plain per-CPU bool with no
  code-patching delay of its own, set via IPI before
  static_branch_inc() and cleared via IPI only after it returns, and
  route user_enter_irqoff()/user_exit_irqoff()/CT_WARN_ON()/ct_state()
  through it alongside the static key.
- Fix the boot-time nohz_full=/isolcpus=domain invariant check
  itself: it ran before static_branch_enable(&housekeeping_overridden),
  so housekeeping_cpumask() always returned cpu_possible_mask for
  both sides of the subset comparison and the check never actually
  rejected anything.  Enable housekeeping_overridden first.
- Fix a cpumask_var_t leak in dhm_cycle_isolated_cpus() on the no-op
  path (a partition update that nets to no CPU delta).
- Let HK_TYPE_MANAGED_IRQ use the same runtime first-enable path as
  HK_TYPE_KERNEL_NOISE; it was unconditionally skipped without a
  boot-time isolcpus=managed_irq, so managed-IRQ migration silently
  never activated on a zero-boot-parameter system.
- Finish converting HK_TYPE_MANAGED_IRQ/HK_TYPE_KERNEL_NOISE readers
  to housekeeping_cpumask_rcu(): vmbus_channel_set_cpu() in
  drivers/hv/vmbus_drv.c, rps_cpumask_housekeeping() in
  net/core/net-sysfs.c, and tmigr_isolated_exclude_cpumask() in
  kernel/time/timer_migration.c were still reading the mask
  without RCU protection.
- Register the CONFIG_RCU_LAZY shrinker from the runtime nocb
  first-enable path too; previously only the boot path did, so a
  system with no rcu_nocbs=/nohz_full= at boot never got lazy-callback
  reclaim once DHM enabled NOCB offload at runtime.
- Add a standalone patch enforcing nohz_full=/isolcpus=nohz as a
  subset of isolcpus=domain at boot: disable nohz_full entirely
  (including when it is passed alone, with no isolcpus=domain at
  all) if the invariant does not hold, checked in housekeeping_init()
  so the outcome does not depend on cmdline argument order.
  Frederic's superset invariant above only covers the cpuset-driven
  runtime path; this closes the same gap for the two boot
  parameters, which he separately said he'd enforce "if he could do
  it again".

V3 -> V4:
- Drop apply() callback architecture entirely (struct housekeeping_cbs,
  pre_validate/apply hooks, housekeeping_update_types() notification).
  Thomas Gleixner identified concurrent in-kernel mask apply as
  fundamentally unsafe ("broken beyond repair") and endorsed CPU-by-CPU
  hotplug cycling as the correct approach.
- Track A prerequisites (housekeeping boot type isolation, RCU reader
  protection, cpuset trigger) submitted upstream separately; v4 builds
  on top of those three committed patches.
- Fix rcu/nocb lazy_init: remove __init from rcu_organize_nocb_kthreads()
  forward declaration (tree.h) to prevent GCC from placing the function in
  .init.text, which caused an NX-protected page fault when
  rcu_nocb_cpu_isolate() was called at runtime.  Add noinline to
  rcu_nocb_lazy_init() to preserve the GCC IPA call chain.
- Fix cpuset remote partition cycling suppression: extend dhm_cycling_cpus
  guard to the remote-partition disable path in cpuset_hotplug_update_tasks(),
  preventing false partition invalidation during hotplug cycling steps.
  Fixes selftest TEST_MATRIX[69] (A2: expected 1-2, got 1-3).

V2 -> V3:
- Replace notifier chain with explicit per-type callback interface
  (struct housekeeping_cbs with .name, .pre_validate, .apply fields).
- RCU-protect all housekeeping cpumask pointers; callers must hold
  rcu_read_lock() or use housekeeping_cpumask_rcu() in apply() callbacks.
- Drop 5 patches from v2: HK_TYPE enum separation (upstream aliases are
  already correct), no-op timer/hrtimer patches, kthread dead code, and
  workqueue double-update.
- Fix deadlock in rcu_hk_workfn(): remove cpus_read_lock() wrapper around
  remove_cpu()/add_cpu() which take cpu_hotplug_lock write side.
- Fix UAF in rcu_hk_apply(): snapshot the housekeeping cpumask inside the
  work function under rcu_read_lock(), not at apply() time where the old
  pointer may be freed by synchronize_rcu() before the work runs.
- Fix tick apply(): snapshot housekeeping_cpumask_rcu() under
  rcu_read_lock() as required by lockdep for runtime-mutable types.
- Activate context_tracking dynamically via ct_cpu_track_user() /
  ct_cpu_untrack_user() in tick apply(), eliminating the dependency on
  CONFIG_CONTEXT_TRACKING_USER_FORCE flagged by tglx.
- Fix genirq apply(): snapshot HK_TYPE_MANAGED_IRQ mask under
  rcu_read_lock() before the IRQ iteration loop.
- Simplify cpuset noise_types to BIT(HK_TYPE_KERNEL_NOISE) |
  BIT(HK_TYPE_MANAGED_IRQ), replacing the redundant per-alias bitmask.
- housekeeping_update_types(): always use cpu_possible_mask as base
  for HK_TYPE_KERNEL_NOISE, so de-isolation restores the mask to all
  possible CPUs rather than leaving it at its last non-trivial value.
- Initialize watchdog_cpumask from HK_TYPE_KERNEL_NOISE (not
  HK_TYPE_TIMER) at boot; keep it in sync at runtime via a new
  housekeeping_cbs callback.
- Add kernel-noise selftest to test_cpuset_prs.sh, including
  cpu_in_cpulist() for correct cpulist range membership detection and
  nohz_full sysfs verification when CONFIG_NO_HZ_FULL is active.
- Add RCU caller fixes: sched/core (HK_TYPE_KERNEL_NOISE) and
  drivers/hv (HK_TYPE_MANAGED_IRQ) are required because those types
  are updated at runtime; hrtimer (HK_TYPE_TIMER) and arm64/topology
  (HK_TYPE_TICK) are defensive fixes.
- Reorder patches so all subsystem callbacks are registered before the
  cpuset patch that triggers housekeeping_update_types().

V1 -> V2:
- Rebrand series from DHEI to DHM (Dynamic Housekeeping Management).
- Drop custom sysfs interface entirely.
- Integrate housekeeping control into cgroup v2 cpuset isolated partition
  mechanism.
- Add SMT-aware isolation constraints to prevent splitting SMT siblings.
- Add comprehensive documentation and cgroup functional selftests.
- Refactor mask transition logic to use RCU-safe handover.

v4: https://lore.kernel.org/r/20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com
v3: https://lore.kernel.org/r/20260618-wujing-dhm-v3-0-28f1a4d83b68@gmail.com
v2: https://lore.kernel.org/r/20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com
v1: https://lore.kernel.org/all/20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com

---
Qiliang Yuan (12):
      sched/isolation: Enforce nohz_full as a subset of isolcpus=domain at boot
      sched/isolation: Add runtime housekeeping mask updates with boot snapshots
      sched/isolation: RCU-protect runtime-mutable housekeeping cpumask readers
      cpuset: Drive kernel-noise housekeeping from isolated partitions
      context_tracking: Allow runtime per-CPU user tracking enable/disable
      rcu/nocb: Support lazy init for runtime CPU isolation
      watchdog: Sync watchdog_cpumask with HK_TYPE_KERNEL_NOISE on isolation
      tick/nohz: Derive full-dynticks state from HK_TYPE_KERNEL_NOISE
      cpuset: Add dhm_cycling_cpus mask to suppress transient invalidation
      cpuset: Drive kernel-noise isolation via per-CPU hotplug cycling
      docs: cgroup-v2: Document kernel-noise isolation via isolated partitions
      selftests/cgroup: Add kernel-noise isolation test to cpuset selftest

 Documentation/admin-guide/cgroup-v2.rst           |  17 +
 Documentation/admin-guide/kernel-parameters.txt   |  12 +
 arch/arm64/kernel/topology.c                      |   9 +-
 drivers/base/cpu.c                                |  42 +-
 drivers/hv/channel_mgmt.c                         |  50 +-
 drivers/hv/vmbus_drv.c                            |  13 +-
 fs/resctrl/internal.h                             |   6 +-
 include/linux/context_tracking.h                  |  16 +-
 include/linux/context_tracking_state.h            |  25 +-
 include/linux/nmi.h                               |   2 +
 include/linux/rcupdate.h                          |   2 +
 include/linux/sched/isolation.h                   |  34 +-
 include/linux/tick.h                              |  40 +-
 kernel/cgroup/cpuset.c                            | 203 +++++++-
 kernel/context_tracking.c                         |  91 +++-
 kernel/rcu/tree.h                                 |   2 +-
 kernel/rcu/tree_nocb.h                            | 105 +++-
 kernel/sched/core.c                               |   7 +-
 kernel/sched/isolation.c                          | 253 +++++++++-
 kernel/sched/sched.h                              |   2 +-
 kernel/time/hrtimer.c                             |   5 +-
 kernel/time/tick-sched.c                          | 158 +++++-
 kernel/time/timer_migration.c                     |   9 +-
 kernel/watchdog.c                                 |  26 +-
 net/core/net-sysfs.c                              |  10 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 578 ++++++++++++++++++++++
 26 files changed, 1558 insertions(+), 159 deletions(-)
---
base-commit: 551c722f40809618230001baccf219193e22fc5a
change-id: 20260408-wujing-dhm-8f43e2d49cd8

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

