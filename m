Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441249DBA8
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946715; cv=none; b=iipI08oUnEO6ZyuvJsKbNErrXZSWfUH/0Xlfq4QnsX+Teu17mg0eur/a+Ee7DGSeTUa0gQ6BbXXrB5/CehWi9sB0lSplH7BMsuZmXqWQre+SjKiKiYGFierRZrgRe0U200SYINQ2GEK8dPH2D77bpzC2LKqR2xXRzssHt3rgr3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946715; c=relaxed/simple;
	bh=ioHFspw6dBzml20bQjh5wqXld+9sMKkrChXphGvT8j8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nj9+EVesHoB8v2b7yC3PFjaPP8JVAvdLVuOB5u3S7FC2tNTmqKPBHhqJ2M7uVB/2l7zmLETVeqU/+xSbsvw4Z+fJlp2n0q3UIabbGY+Na12ksLC7zzloHfnx6bPUPuJBRpjEqnMSEuVw2Sh1ywwPYbipG5fcL4j/nr+K0tPcrM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6xo5Vcf; arc=none smtp.client-ip=74.125.229.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6xo5Vcf"
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd04f7f2so5977818c88.0
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946707; x=1791551507; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LZG5fAQ0FiH64NGyRXubKr6Xz8RTMEKx2x1RgTKTW7s=;
        b=K6xo5VcfNZoeivzQxs3LR+sbDQwKIxZogzBCOgqHkneIVAXVAV3rmxD342nWtdlsdy
         BOEKtlhyLi8zGMfxv3kk1abWaQUm9NOcWoCFvbiWauYxDliCYbFoY3g3FSblTbd+THc0
         P722ylgCWkf76DWE8OrT8FFOjYnDT+Jmnh7/qz0cTCPbDuCnXT8eYl2yQ6ChVSqOYZRY
         KFOCgGz4oQYzEMelUPBcZDyyBO1X93jUNbfs8KDblK+8wEFTJwxmaZPI0ube+zuGOg2z
         /bt+y4LBahF3jrKVfQ8XBTBJfp33mbGjzOeOUnYjyVw+E+lhRIC616yhU6MoZP0240eO
         1uFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946707; x=1791551507;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZG5fAQ0FiH64NGyRXubKr6Xz8RTMEKx2x1RgTKTW7s=;
        b=ixS9BojQodMf5OsLetvkgTwN4mzuGUImSBXiH7rYnmH4SZuPhUYFwcT8L8Yic1CprF
         cDFw0RYeV/cOzbv7UW99oYlEPPubsKQeKDS/KVOylI3NARQjR4Gf7uF2U/k+3+xsoQ5m
         mQiVJsbYdRjkn3bnI4wsPRGnmPX7dCFFm5ek6HP/DOzJKka0RPKFW3Ip51Kt+xNEeyvs
         mYqTqQiGo7VPEUIRbv1RQfWHzDl2Dz2x2qsTRm/x3c4IQEbxHcQ17FdWvXoH9LsXRT5L
         I1VEs8MKLf2sgB0svkH8P7P2KZ3uZgm2O1+5ast9y7fr6BJ+lRu8msU0nF27ug20bA4u
         lSVg==
X-Forwarded-Encrypted: i=1; AKwUvBxYDmixLqbbr4MI7V9EmBCRdqeuFNB+NT6CuQrZcInpv10oLvBZvNB7zLk3EjiFLUOaNaub+gg2@vger.kernel.org
X-Gm-Message-State: AFuF++m32h/BlmzObRhW5IsGbzv3uWwX8/HDLLtO+hmR6fr1D83m1oBg
	MsZ4E1stPFmQ1LubU2k/9m1Wqfq6RJ8crRkOgsiIxcpLsoGV34L8QJTe
X-Gm-Gg: AYBFou3QsGR8E/o8Hj7Mn60u94vUXyl+hM3UGZg9r00HLEOMuhv+Qu7IRdxwQbZGLdJ
	UCUZ0/rkFnHLmmvCvcBeha3eJB8rWYM61R61wxeTe+yHAihv57N9a3hasIrL8svTadp1FZROqh8
	6srJfOvYMKJY8jZk23igkEzqkbiyvd1NJ/YXU/t/nQYCgou4OtA8zRzltDk48wax3ElWP7YMyUy
	AoXQxZaeYmFB2QtLCJgAoDNocSwFfQYMIuqvHvC80wPFeyWcRip7mlb1oWmRo9PmGWFsfEaYEVf
	mRBj1IE0HPyVZVuibDl2C9+w/WS2MFJ050UHjfHWsYW6kpF8zSEKzssjJX26ZgNBBw32nghVsqQ
	LJcTzclEiyGSST9CL2Aoi0rEfxBG/sNIwUHzRqfzLgZcSVCmN28sb/5yAhKKaEt1KWLoRYOuo2Z
	Ctv4CjDiudfmJrq9pUTaa93jqbh2x3jdxJBriGjTIku5tjpJwDC6pMkZ1H/esTIUV4zw==
X-Received: by 2002:a05:701b:2512:b0:13d:974:a2c6 with SMTP id a92af1059eb24-14f5b9fbb86mr2985232c88.7.1790946706628;
        Fri, 02 Oct 2026 06:11:46 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:11:46 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:29 +0800
Subject: [PATCH v5 09/12] cpuset: Add dhm_cycling_cpus mask to suppress
 transient invalidation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-9-78a6996d87ad@gmail.com>
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

When the cpuset code cycles a CPU through hotplug to apply kernel-noise
isolation (remove_cpu followed by add_cpu), the CPU disappears from
cpu_active_mask temporarily. cpuset_hotplug_update_tasks() sees an
empty effective CPU set on the isolated partition and issues
partcmd_invalidate, tearing down the partition. The subsequent add_cpu
brings the CPU back online, but the partition has already been marked
invalid and requires manual user intervention to restore.

Add a global dhm_cycling_cpus cpumask protected by dhm_cycling_lock.
The isolation cycling path sets the bits for CPUs being cycled before
calling remove_cpu(), clears them after add_cpu() completes.
cpuset_hotplug_update_tasks() checks whether any of the cpuset's
effective exclusive CPUs are in dhm_cycling_cpus and skips the
invalidation command when they are, treating the transient empty-CPU
state as expected rather than an error.

A global cpumask avoids the need to walk the cpuset tree to find the
owning cpuset during the cycling loop which runs without cpuset locks.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 kernel/cgroup/cpuset.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8b3bb034adf62..6213e63cf348d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -157,6 +157,14 @@ static bool		update_housekeeping;	/* RWCS */
  */
 static cpumask_var_t	isolated_hk_cpus;	/* T */
 
+/*
+ * CPUs currently being cycled through hotplug for kernel-noise isolation.
+ * Protected by dhm_cycling_lock; read in cpuset_hotplug_update_tasks() to
+ * suppress transient partition invalidation during the offline step.
+ */
+static DEFINE_SPINLOCK(dhm_cycling_lock);
+static cpumask_var_t	dhm_cycling_cpus;
+
 /*
  * A flag to force sched domain rebuild at the end of an operation.
  * It can be set in
@@ -3906,6 +3914,7 @@ int __init cpuset_init(void)
 	BUG_ON(!zalloc_cpumask_var(&subpartitions_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&isolated_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&isolated_hk_cpus, GFP_KERNEL));
+	BUG_ON(!zalloc_cpumask_var(&dhm_cycling_cpus, GFP_KERNEL));
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
@@ -3991,6 +4000,20 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (remote && (cpumask_empty(subpartitions_cpus) ||
 			(cpumask_empty(&new_cpus) &&
 			 partition_is_populated(cs, NULL)))) {
+		bool cycling;
+
+		/*
+		 * Suppress transient invalidation when the offline is part
+		 * of a hotplug cycling step for kernel-noise isolation.
+		 */
+		spin_lock(&dhm_cycling_lock);
+		cycling = cpumask_available(dhm_cycling_cpus) &&
+			  cpumask_intersects(cs->effective_xcpus,
+					     dhm_cycling_cpus);
+		spin_unlock(&dhm_cycling_lock);
+		if (cycling)
+			goto unlock;
+
 		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
@@ -4008,8 +4031,21 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (is_local_partition(cs) &&
 	    (!is_partition_valid(parent) ||
 	     tasks_nocpu_error(parent, cs, &new_cpus) ||
-	     cpumask_empty(subpartitions_cpus)))
-		partcmd = partcmd_invalidate;
+	     cpumask_empty(subpartitions_cpus))) {
+		bool cycling;
+
+		/*
+		 * Suppress transient invalidation when the offline is part
+		 * of a hotplug cycling step for kernel-noise isolation.
+		 */
+		spin_lock(&dhm_cycling_lock);
+		cycling = cpumask_available(dhm_cycling_cpus) &&
+			  cpumask_intersects(cs->effective_xcpus,
+					     dhm_cycling_cpus);
+		spin_unlock(&dhm_cycling_lock);
+		if (!cycling)
+			partcmd = partcmd_invalidate;
+	}
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
 	 * back to a regular one with a non-empty effective xcpus.

-- 
2.43.0

