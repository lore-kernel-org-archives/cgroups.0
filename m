Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75504A1DFB
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946700; cv=none; b=Nz4jrV1k2sGojm9Lj5CsqA/V2LLtb87y4+uMQbBJPUldqzDlu8xiQ92q78doksdZwXoKUh/Xb2LCxJIEBBDicJDq+8yUevT6xf3jDjcqrigrQkwSCkFzTxGjbbx0ijm5EmzCK0jPr7txgq9W//uhf4MDRZZcBwY7fpAmAske1F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946700; c=relaxed/simple;
	bh=9LKpz3kS0U/O+ogCzpthVS7zLgh0K4YTIMJPzUCU0Uo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UxF7hLPIy2ccNu8yBKMwSjhKaNyFnySA6xJ4NgSbiEMuPuZZnlUOld8uaMrEJv/WjVyUKkmdg6rr3iKDwpY/yoRi+XD7FkQ88orC0zjuecwFGHHCbENqzlcJLOSlEkl7+z5+kvMgsWflJDvCnixKmogw9iV5k4ZbaMs6+p9cFSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0qrgyUM; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0qrgyUM"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34b223602d7so3159069eec.2
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946691; x=1791551491; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXW18KF21LCiFNVNAVkygqJCkvk1Ia+QDkwORzpp+Bk=;
        b=F0qrgyUMn/DtHRvDp1I6VmWz2lgKRF1LdP1Q65wTl5qJxotATi3jFXgZZ5268knBCy
         XtbwNg6fIRuNUr0PbpGFE5mkHHftEAxGmV1gnkcv/sub2VqC1yGLSIlrzpVM1qz409Un
         Wt8V6JEbo0QNXvKGDMeP7onepELRSotQ5sHGpLfwUXMElOUKVZxH5J+UnuYL8RTuv9lx
         F7tvP8O1QkMeoIoA0BwAfsnz1G2nRjbu97PwFYrHY9tMz71ueZNKrYodReNqAApuC6ur
         4BLdanOPS27O9yhYToZTJJCgc4lclkFS+iKvrKsjp+udb9j4oLdo6OQAIJlX0L3bzTDe
         oNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946691; x=1791551491;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AXW18KF21LCiFNVNAVkygqJCkvk1Ia+QDkwORzpp+Bk=;
        b=1S3umZRZVj8Gp1a2glOXyqEoH7FhuBu3lpPfdmH0irFIVmcfOG/FAxDhJ4nUJ165FG
         10pconfi5sBpSIGOEo9aCVmK1nRDGn7RpVHxcBZBt8HTsla5sdFLlXKOxrvxGa79ZWQ7
         SLhGXBThhPJlQxmpa9ZhXphh5yxg+eiG6BOn7V56u5owfJXF/XmyNwNphCkQY9e76ICl
         MBJgMlRXcUwMEiWdGQRnXN1dwZkoNxkoKZcC06H1KVzg3KYEhqxi9S9Byc0Uev/z+mSC
         WXAavo5IyGjYxVnJSfWhPbVr09jxfPobgItz+4ou9puzo5Sy6P06dsJtrOPYeEGFE8sE
         YTig==
X-Forwarded-Encrypted: i=1; AKwUvBxCdggBxMjJs4yCfF/yoTzoWc2x6dF8Cww5t/4DkgkH6PArHQv00WLur9aaolZNpCg66oZ/oFKi@vger.kernel.org
X-Gm-Message-State: AFq9FYKTiEqTn4KP1r6RmxdMU36LHnNrnM4fgUnN4szowXsHDDAelWoS
	z1mWGOUU/TqTRSIR0FiVuOyk/Z39LTND/iUKweCUKQVsGdlIqCfRndih
X-Gm-Gg: AYBFou2k6cy+suOGj49xScpX2vQOE5yX+vdj8pOE7TtGZee/iR6jZzzwd7XxnKw7dqR
	iOuqhWOVNw7lF7IdfRKiXpbclbcNur6dp21ThEEmWvE4EWcEGvZZhWRHZXzLfWmG9HGSVnO7TWL
	UDO2783noFV+rqoNuFdKf0Fzbxp+E6u2xzf56eajjK5CCPnN9dc7rgrDvbWIF/k3N2sWxrQdTlk
	brbv82OWEBNeL7dvt8dt3nesMLy/EQ1SRur7Lr+M+EwMrwTdWukUxQJyROWRkXnmz5643AtCdNS
	Rxe+t1JJQh0J4DB5jEZSFMpk8DyUw3d2xTPvA1BWHp+0J8lwGJh4EXp+8rCZ9Y3G9Z/rHdgrzZK
	I/I3mC0lrpZUhp5CeAmvb8nNY3f0GADPNDRnTl1nsQnF0mdJo7ZNHS0oNdqaR7Y7c1QzWOB70+u
	4xNDUcvi7MEF7hHzgjCxgLJYe3vP+NXyKGqeMIqOq0n17BjoI0A9Q5Ki0TaHdGVWo9LLzMy+5qW
	bmP
X-Received: by 2002:a05:7300:b905:b0:343:6622:ee15 with SMTP id 5a478bee46e88-34f150a014bmr4182712eec.11.1790946690523;
        Fri, 02 Oct 2026 06:11:30 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:11:29 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:27 +0800
Subject: [PATCH v5 07/12] watchdog: Sync watchdog_cpumask with
 HK_TYPE_KERNEL_NOISE on isolation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-7-78a6996d87ad@gmail.com>
References: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
In-Reply-To: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
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

The watchdog is initialized at boot to run on all housekeeping CPUs
(HK_TYPE_KERNEL_NOISE). When a cpuset isolated partition removes CPUs
from that mask at runtime, watchdog continues running on those CPUs
because nothing updates watchdog_cpumask.

Save the boot-time watchdog_cpumask as watchdog_cpumask_boot, which
captures the user's intended coverage (possibly narrowed via kernel
parameter or sysctl) before any runtime isolation. Introduce
lockup_detector_hk_update() which intersects this boot snapshot with
the current HK_TYPE_KERNEL_NOISE mask and reconfigures the detector.
This ensures that isolated CPUs are excluded while honoring any
manual narrowing the admin applied at or after boot.

lockup_detector_hk_update() snapshots the RCU-protected housekeeping
mask under rcu_read_lock(), then updates watchdog_cpumask and calls
__lockup_detector_reconfigure() under watchdog_mutex, matching the
same locking discipline used by proc_watchdog_cpumask().

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 include/linux/nmi.h |  2 ++
 kernel/watchdog.c   | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index af69712df5f48..409af7884d939 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -37,6 +37,7 @@ extern int sysctl_hardlockup_all_cpu_backtrace;
 static inline void lockup_detector_init(void) { }
 static inline void lockup_detector_retry_init(void) { }
 static inline void lockup_detector_soft_poweroff(void) { }
+static inline void lockup_detector_hk_update(void) { }
 #endif /* !CONFIG_LOCKUP_DETECTOR */
 
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
@@ -120,6 +121,7 @@ void watchdog_hardlockup_enable(unsigned int cpu);
 void watchdog_hardlockup_disable(unsigned int cpu);
 
 void lockup_detector_reconfigure(void);
+void lockup_detector_hk_update(void);
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR_BUDDY
 void watchdog_buddy_check_hardlockup(int hrtimer_interrupts);
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e567fbb0d4692..d4eccb8e337f1 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -53,6 +53,8 @@ static int __read_mostly watchdog_hardlockup_available;
 
 struct cpumask watchdog_cpumask __read_mostly;
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
+/* Boot snapshot: user's intended watchdog mask before any runtime isolation. */
+static struct cpumask watchdog_cpumask_boot __ro_after_init;
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 
@@ -1348,6 +1350,27 @@ static void __init lockup_detector_delay_init(struct work_struct *work)
 	lockup_detector_setup();
 }
 
+void lockup_detector_hk_update(void)
+{
+	cpumask_var_t new_mask;
+
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return;
+
+	rcu_read_lock();
+	cpumask_and(new_mask, &watchdog_cpumask_boot,
+		    housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE));
+	rcu_read_unlock();
+
+	mutex_lock(&watchdog_mutex);
+	cpumask_copy(&watchdog_cpumask, new_mask);
+	__lockup_detector_reconfigure(false);
+	mutex_unlock(&watchdog_mutex);
+
+	free_cpumask_var(new_mask);
+}
+EXPORT_SYMBOL_GPL(lockup_detector_hk_update);
+
 /*
  * lockup_detector_retry_init - retry init lockup detector if possible.
  *
@@ -1390,6 +1413,7 @@ void __init lockup_detector_init(void)
 
 	cpumask_copy(&watchdog_cpumask,
 		     housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
+	cpumask_copy(&watchdog_cpumask_boot, &watchdog_cpumask);
 
 	if (!watchdog_hardlockup_probe())
 		watchdog_hardlockup_available = true;

-- 
2.43.0

