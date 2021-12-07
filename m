From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Tue, 7 Dec 2021 16:52:08 +0100
Message-ID: <20211207155208.eyre5svucpg7krxe@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638892329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VS6roNBiwUEM5X9fxDy5HZGLySBmQhwrowKmxwnMeKo=;
        b=BcczSFN8CKvWRlXBGO8eJz8aSgoUZFPDl3yXZwMqcRiniKvyEO5H1I4FD8smWeB72tPE7W
        4FhHfvENUhH9Oo6smxiNulqEiCddctZcH8HzErDwFV5cQVwltMyZTjvCpZA16+BMABd+nu
        URprFReGV/dMjZsMN9iyCoeY+dLhb/Sv22rM9pdB88rvFY2yO2deqrjbrcgru9sePRnXs+
        Zu5n9d5/Jpy2MuFGa1z+CABNUK9eZbcyQVF+WyhjJaF2c8dQU9/Z8fRwNc7F6XZRQAzXpr
        LgdIAHZGeTPJuYa+DoJdCJ6Vn8/T5VSKZagkg/tQUH0Rcb5lLWAMFha7knUaPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638892329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VS6roNBiwUEM5X9fxDy5HZGLySBmQhwrowKmxwnMeKo=;
        b=w1JyOzTzNREXfaHDN1SVgPUu3ulwLcDKPcxYzaU9oZ+cen1LSNAG8b7kwCvPe4RsoqnOQS
        pEpFizCPgDi0ANAg==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

MEMCG has a few constructs which are not compatible with PREEMPT_RT's
requirements. This includes:
- relying on disabled interrupts from spin_lock_irqsave() locking for
  something not related to lock itself (like the per-CPU counter).

- explicitly disabling interrupts and acquiring a spinlock_t based lock
  like in memcg_check_events() -> eventfd_signal().

- explicitly disabling interrupts and freeing memory like in
  drain_obj_stock() -> obj_cgroup_put() -> obj_cgroup_release() ->
  percpu_ref_exit().

Commit 559271146efc ("mm/memcg: optimize user context object stock
access") continued to optimize for the CPU local access which
complicates the PREEMPT_RT locking requirements further.

Disable MEMCG on PREEMPT_RT until the whole situation can be evaluated
again.

[ bigeasy: commit description. ]

Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -943,6 +943,7 @@ config PAGE_COUNTER
 
 config MEMCG
 	bool "Memory controller"
+	depends on !PREEMPT_RT
 	select PAGE_COUNTER
 	select EVENTFD
 	help
