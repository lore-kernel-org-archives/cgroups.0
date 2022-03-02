From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] cgroup: Add a comment to cgroup_rstat_flush_locked().
Date: Wed, 2 Mar 2022 15:46:16 +0100
Message-ID: <Yh+DOK73hfVV5ThX@linutronix.de>
References: <[PATCH0/2]CorrectlockingassumptiononPREEMPT_RT>
 <20220301122143.1521823-1-bigeasy@linutronix.de>
 <20220301122143.1521823-2-bigeasy@linutronix.de>
 <Yh8Q+wjgk6dkDphR@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646232378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PpxvpaW7wGw/ZOsSQfgwEFQcmBDCMW9CjHzv6C/1/8s=;
        b=VAqsDfA05L/UKHxCLqWaMOIvNQh4FjZfmAqtPhVH65b1wOk4T3tV4WAmK7XY+1gAdk4qJg
        hr64GyLFSRmleqCMpjurxIdzY5xmsZRCF0iGlB/bXhM+xyJKU/R3AJk4M04DGsCWtu/b5V
        RqHDY0xXJkbe6I9f6/BAvqaQFqb/fKjnm+0DIT0hKsgfCBi+mQ9Mfw0ynrFC8EBevtWk2o
        /a/E8s6ozK7O8kK4ifEWpNx8w0Z7BFj7CrTZzVJp6FJZddvmrjLQ9CZUbcg28UbvqKKBOj
        Fq16Dq0ptToFuHv2KtH1F/C3vfU2FoYdX6ytpkL28y1Zmu2XeM4aqV/cdxz5Lw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646232378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PpxvpaW7wGw/ZOsSQfgwEFQcmBDCMW9CjHzv6C/1/8s=;
        b=4fKvI7QRhukl8Z2nIjFhR4UnkZXhUnIctHZf2n93YEcuHLFPDrGOejNEwmnME6IaTinIND
        UhA5AooQA+/4iJCg==
Content-Disposition: inline
In-Reply-To: <Yh8Q+wjgk6dkDphR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Add a comment why spin_lock_irq() -> raw_spin_lock_irqsave() is needed.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
On 2022-03-01 20:38:51 [-1000], Tejun Heo wrote:
> Hello,

Hello Tejun,

> Can you please add a comment explaining why irqsave is being used? As it
> stands, it just looks spurious.

Something like this?

 kernel/cgroup/rstat.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 53b771c20ee50..ba7a660184e41 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -155,6 +155,14 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 		struct cgroup *pos = NULL;
 		unsigned long flags;
 
+		/*
+		 * The _irqsave() is needed because cgroup_rstat_lock is
+		 * spinlock_t which is a sleeping lock on PREEMPT_RT. Acquiring
+		 * this lock with the _irq() suffix only disables interrupts on
+		 * a non-PREEMPT_RT kernel. The raw_spinlock_t below disables
+		 * interrupts on both configurations. The _irqsave() ensures
+		 * that interrupts are always disabled and later restored.
+		 */
 		raw_spin_lock_irqsave(cpu_lock, flags);
 		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu))) {
 			struct cgroup_subsys_state *css;
-- 
2.35.1
