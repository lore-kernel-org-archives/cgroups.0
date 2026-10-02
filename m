Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6519F43149D;
	Fri,  2 Oct 2026 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790954829; cv=none; b=p5WvM06qw3Fi5C/93x62kRjKwq01phun4e7MYdgc+QbA0G49/4ahI/R/bqgaMctHxXEG1eqj9XykxixDDtzrcPs7+gitcZ9rjB9yBB1qFiMCv+fBW0IO2MoRXjmo1kB2+ZCcTSX/g7sZG+3yVp/2QRo606F/Ics+Et+yz9xptuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790954829; c=relaxed/simple;
	bh=bjpo6tvg1DCVZMJqklvFUuf602rMdzy2YM6oQNc8qeU=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=WjJn0Lljo5Fhu3ddtbxDRhQEfCilmVNpmCiXbgDYJIyBBYnmN/r84umSbgEYqUhKPaqT3jP+bMAAbatzRQpl8BFPCSzr7Lvfjwc+gLbqksUcyr0J6zcD4kE9zOuJHKPgPKB+WXeOLMv3VAqFK4h0yiIRO93TkBpA+arD/lAkA5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=RfpU2o2x; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=X1cI4+Mp; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="RfpU2o2x";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="X1cI4+Mp"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790954789; bh=9T/wUe6RMWDwS3C9Yfgbl5T
	6Qg1ecGSGmKcD5n/LrnU=; b=RfpU2o2xyn006JHL0GmBnYa2vWwB4Xko7Vy9bRggAAkl7vHFwC
	4kOefPYcmDERBqTVYRgbr7k/X/2u3PCL3FZ+D98H48UEgDdCsI8vIxEQZ4u2VBc7lzyquYfm0Ed
	fb9F0V7Y9kYcg/jpenTcSiA0v10DGpcJsaDnqjJDVCMa4WZNGAtHa3EVkILIxMas7gAYnQmkkGx
	oFuQcBsqbWgWQ1UMortM1FzYbI3C3NhsgbBAQMnbKggNJkOvKYGjXZOzs5RO/i4jNLVqxqrB318
	7rSsEjQZI7KDitvttZ2g5KMulqv1a1iwoK/P1RY21P95k4EfslH+GtHUackQs5bnZFg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790954789; bh=9T/wUe6RMWDwS3C9Yfgbl5T
	6Qg1ecGSGmKcD5n/LrnU=; b=X1cI4+Mp3YW++RespDPcwZvJvGcNBOVLY7A98yWDWfQ9IBARfN
	nBmg2QL31ecuawkbil3gqg4Hu9Psn/DWtbAg==;
Date: Fri, 02 Oct 2026 16:26:29 +0100
From: Bradley Morgan <brads@mainlining.org>
To: odys.yuan@gmail.com
CC: anna-maria@linutronix.de, boqun@kernel.org, bsegall@google.com,
 cgroups@vger.kernel.org, corbet@lwn.net, dietmar.eggemann@arm.com,
 frederic@kernel.org, jiangshanlai@gmail.com, joelagnelf@nvidia.com,
 josh@joshtriplett.org, juri.lelli@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 longman@redhat.com, mathieu.desnoyers@efficios.com, mgorman@suse.de,
 mingo@redhat.com, neeraj.upadhyay@kernel.org, paulmck@kernel.org,
 peterz@infradead.org, qiang.zhang@linux.dev, rcu@vger.kernel.org,
 rostedt@goodmis.org, shuah@kernel.org, skhan@linuxfoundation.org,
 tglx@kernel.org, tj@kernel.org, urezki@gmail.com, vincent.guittot@linaro.org,
 vschneid@redhat.com, pmladek@suse.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_07/12=5D_watchdog=3A_Sync_watchdog=5F?=
 =?US-ASCII?Q?cpumask_with_HK=5FTYPE=5FKERNEL=5FNOISE_on_isolation?=
In-Reply-To: <20261002-wujing-dhm-v5-7-78a6996d87ad@gmail.com>
Message-ID: <C21F0A47-2FE9-46F1-867D-E035673F750D@mainlining.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 2 October 2026 14:10:27 BST, Qiliang Yuan <odys.yuan@gmail.com> wrote:
>The watchdog is initialized at boot to run on all housekeeping CPUs
>(HK_TYPE_KERNEL_NOISE). When a cpuset isolated partition removes CPUs
>from that mask at runtime, watchdog continues running on those CPUs
>because nothing updates watchdog_cpumask.
>
>Save the boot-time watchdog_cpumask as watchdog_cpumask_boot, which
>captures the user's intended coverage (possibly narrowed via kernel
>parameter or sysctl) before any runtime isolation. Introduce
>lockup_detector_hk_update() which intersects this boot snapshot with
>the current HK_TYPE_KERNEL_NOISE mask and reconfigures the detector.
>This ensures that isolated CPUs are excluded while honoring any
>manual narrowing the admin applied at or after boot.
>
>lockup_detector_hk_update() snapshots the RCU-protected housekeeping
>mask under rcu_read_lock(), then updates watchdog_cpumask and calls
>__lockup_detector_reconfigure() under watchdog_mutex, matching the
>same locking discipline used by proc_watchdog_cpumask().
>

Added Petr mladek, maybe he may be interested? See comments:

>Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
>---
> include/linux/nmi.h |  2 ++
> kernel/watchdog.c   | 24 ++++++++++++++++++++++++
> 2 files changed, 26 insertions(+)
>
>diff --git a/include/linux/nmi.h b/include/linux/nmi.h
>index af69712df5f48..409af7884d939 100644
>--- a/include/linux/nmi.h
>+++ b/include/linux/nmi.h
>@@ -37,6 +37,7 @@ extern int sysctl_hardlockup_all_cpu_backtrace;
> static inline void lockup_detector_init(void) { }
> static inline void lockup_detector_retry_init(void) { }
> static inline void lockup_detector_soft_poweroff(void) { }
>+static inline void lockup_detector_hk_update(void) { }
> #endif /* !CONFIG_LOCKUP_DETECTOR */
> 
> #ifdef CONFIG_SOFTLOCKUP_DETECTOR
>@@ -120,6 +121,7 @@ void watchdog_hardlockup_enable(unsigned int cpu);
> void watchdog_hardlockup_disable(unsigned int cpu);
> 
> void lockup_detector_reconfigure(void);
>+void lockup_detector_hk_update(void);
> 
> #ifdef CONFIG_HARDLOCKUP_DETECTOR_BUDDY
> void watchdog_buddy_check_hardlockup(int hrtimer_interrupts);
>diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>index e567fbb0d4692..d4eccb8e337f1 100644
>--- a/kernel/watchdog.c
>+++ b/kernel/watchdog.c
>@@ -53,6 +53,8 @@ static int __read_mostly watchdog_hardlockup_available;
> 
> struct cpumask watchdog_cpumask __read_mostly;
> unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
>+/* Boot snapshot: user's intended watchdog mask before any runtime isolation. */
>+static struct cpumask watchdog_cpumask_boot __ro_after_init;
> 
> #ifdef CONFIG_HARDLOCKUP_DETECTOR
> 
>@@ -1348,6 +1350,27 @@ static void __init lockup_detector_delay_init(struct work_struct *work)
> 	lockup_detector_setup();
> }
> 

Why no comment?, other than that,

Looks good to me, cheerss

Reviewed-by: Bradley Morgan <brads@mainlining.org>

>+void lockup_detector_hk_update(void)
>+{
>+	cpumask_var_t new_mask;
>+
>+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
>+		return;
>+
>+	rcu_read_lock();
>+	cpumask_and(new_mask, &watchdog_cpumask_boot,
>+		    housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE));
>+	rcu_read_unlock();
>+
>+	mutex_lock(&watchdog_mutex);
>+	cpumask_copy(&watchdog_cpumask, new_mask);
>+	__lockup_detector_reconfigure(false);
>+	mutex_unlock(&watchdog_mutex);
>+
>+	free_cpumask_var(new_mask);
>+}
>+EXPORT_SYMBOL_GPL(lockup_detector_hk_update);
>+
> /*
>  * lockup_detector_retry_init - retry init lockup detector if possible.
>  *
>@@ -1390,6 +1413,7 @@ void __init lockup_detector_init(void)
> 
> 	cpumask_copy(&watchdog_cpumask,
> 		     housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
>+	cpumask_copy(&watchdog_cpumask_boot, &watchdog_cpumask);
> 
> 	if (!watchdog_hardlockup_probe())
> 		watchdog_hardlockup_available = true;
>
>


--- Thanks!
"I'm not a very positive person" - Linus torvalds
