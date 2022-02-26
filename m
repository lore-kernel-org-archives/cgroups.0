From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v5 0/6]  mm/memcg: Address PREEMPT_RT problems instead of disabling it.
Date: Sat, 26 Feb 2022 21:41:38 +0100
Message-ID: <20220226204144.1008339-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645908109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SqdsGvA5XeY6PhfXzb3Fr1EyB14Ft2+PMkzy4AmRIn4=;
        b=2NaqpCidvSVf+88nSX8VSQNVk3Si8mImBA5EHfCoM4lIs7LfsmD+KBlq/MGKt86xC4oXoq
        8EWgEu493FqRB5MDmeVAUT1G32mSvM1WQF/HJKg2e4Ct2JSaMqbSHBITiakO3lAyY+HbJa
        SRVU9w0Y5wF/xB3TuUeNfFA81jTuhsdqgHcTl33NQgPeQuQOYa+XmAvCwuuYUrjFzcGKun
        h/4lEFR3BpJtUCUQaBaS0O5A2qiyAIMtEwbx7puHV8ep0Xn8zWhTnJgoW9PQjZKhoTYzXJ
        A7u6tZKzJt2/yOgkUv+3r60NSVktizaq147UgJ3o+w/7+uJx/ocHFA0KPQsSNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645908109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SqdsGvA5XeY6PhfXzb3Fr1EyB14Ft2+PMkzy4AmRIn4=;
        b=jvZQ8XhTfJ0uhYjhex/5SW2SjipGrWDJ2wYe5UCJWXgE0OV7mSPE/5THKDACixj1nzJn6H
        KrUHr9k6SqNnDmDQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

this series aims to address the memcg related problem on PREEMPT_RT.

I tested them on CONFIG_PREEMPT and CONFIG_PREEMPT_RT with the
tools/testing/selftests/cgroup/* tests and I haven't observed any
regressions (other than the lockdep report that is already there).

Changes since v4:
- Added additional counter index to __mod_memcg_lruvec_state() which are
  updated with enabled interrupts but with disabled interrupts. Also
  disable these checks on PREEMPT_RT. Reported by Shakeel Butt.

- Add additional comment regarding `obj' in drain_obj_stock().

- Disable migration in drain_all_stock() and drain the local stock
  instead of scheduling a worker.

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

