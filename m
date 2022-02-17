From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v3 0/5] mm/memcg: Address PREEMPT_RT problems instead of disabling it.
Date: Thu, 17 Feb 2022 10:47:57 +0100
Message-ID: <20220217094802.3644569-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645091287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=A4ypfDSqGMLg9km1dl2WOJwJsS8OW8SkL6eTIxLtYuc=;
        b=elTaWLiRGCv72mzSp9Bn5+xIhnnOLk02quK11HhQEiDGoAHa0bQtAn3sNjtHsc3Co7fCPn
        UYkVRXcupS33LVJlDqLQ60Sv3edMm9HWVcPL5mCvS4oolAAtMTphXJ5UE9Hf6xItugrE6e
        Kb2ksXizy4WoqynEpl8MPiW7Ds1eOaFGmGJ6MOmTp06Js+K2oY08/5xpQBpQ6o4/+MFrh7
        HwKhJ6KqvkPckqPdz5XPKx/ns8vxfhDzACx8/2ueyIoVvXHKlf7z4XOiXqeso10Tt7Z0z9
        dz1sL3Q7fjs/wGPrNdzMQJPMGp+AkFwYXgd6jMSjhu5MxvbUfCKXv6Rv4gDV1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645091287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=A4ypfDSqGMLg9km1dl2WOJwJsS8OW8SkL6eTIxLtYuc=;
        b=W7kqkBljW4f1rmnUnTl4a9BsY3Hz7ECJSUiEAiFfHNnHHa8U9x2NdU53pOkTCFTvy/Yvmq
        xwFn+kjKzH8kSZBA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

this series aims to address the memcg related problem on PREEMPT_RT.

I tested them on CONFIG_PREEMPT and CONFIG_PREEMPT_RT with the
tools/testing/selftests/cgroup/* tests and I haven't observed any
regressions (other than the lockdep report that is already there).

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


