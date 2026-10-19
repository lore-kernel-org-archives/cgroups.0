Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB94330F7E8
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 01:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372501; cv=none; b=u4w18R/8aWkJz05CH9j2pMmywphx7Y4RRusiJY+bz3LzIlvFfHnR0MQ2r7JCiaeOuwxZej8ZdbXKwJOcJYCvSDPZXH8ZCHbytmWlntQIqwS4Br4ZQ5FTUajUmg58NeMApJ/153muYoOcrRyGvzpAn32zoyjh0JLBaKypBBI30Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372501; c=relaxed/simple;
	bh=b/d6EMWrCn0T5QVqLEzN9+sowVmf1Ha6Ji1SgmKaaz4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gm/KPVhBuf+o5veHfdyrYCz3zPiW/ntr2jB9P5jbrBnPZalqKvYgcqNgz7Mrv1K9tXhikwlHUsQnv8m5gqsL6tVD6NBRzm0qDvu5WrCSn/y1F80hxXaO9NimJH7yoISt3GopUsOttzLSO522oyOAj19VwKpTKMQmRmr2H3nFng4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=QCpAC4kX; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="QCpAC4kX"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5e930a11148so1115098e0c.2
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 18:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372498; x=1792977298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AG4iCQmCtWMmOqYT8IYP5jpAChTLSZorOObJHVgwpSM=;
        b=QCpAC4kX6onPlv8oJEKXQihNV0//1YQmxuEVtIP7VNFmUVCZIzxXmlHn2IHiTCJYOr
         2UEp0G4C1HZSKpS5pZJlWsSp28lWCTxHliLZf+aYlM4toewhjWAEnnylsZ4iWwyyfnWM
         RANRWmZPp1sYU5Cr8Q9vRswPqnfpt5rrdX2GFeR0HA/tO1SiJAMC0Mc94o+5YNM5bVBT
         UqkjaWP3+X61hoynwuNtd3fyx2tBza8L3JSjNCpcCswwTmtIM4Bhn4zy0f1gVoWlNFfF
         Fjk5dHMb+No3mG7rBr0BExkQFA3W6OLXB3WumpSHkbiA6IkX+i1yGxn1/BnuYtmhGG17
         YTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372498; x=1792977298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AG4iCQmCtWMmOqYT8IYP5jpAChTLSZorOObJHVgwpSM=;
        b=aPyB+q7UCVBlxQMCJkgNaQO6HbZgkKUDnrZ4ak2zvko/sIItiVuiSkDBsFdt03sUKm
         TbayHuZBAysrW1LIJDMwMbbCNB3bm0mvCMUi3eBcL43CGail7EvlYc3kQhwM4qRGNiFk
         nQOxkMr7zoPW7jrjkSJZAOWwBBUs1nhX6L91BQhviKFV5IVD8kruFiEa82FAMTJLoZUV
         /28+sEKwtTEiZJe99RBsRlSkx1ZFLMGvYXwpaG7Ou1TodxEwfxw5BwUU4cW4Tiuq/CsO
         uP5xZpaFwKcVbekFkb9O4A9g5KWDW5DE+zlHOX4cG9DPgEzkML4iLuJDgWuPr5YcNMdQ
         3S0Q==
X-Forwarded-Encrypted: i=1; AKwUvBx1fBk3UOst2yryQmFCxm+dwJcJC+dqE72RXjpMW/B7oJmp1MQC9YXEP90VbtUN/OmCpCrAWqcA@vger.kernel.org
X-Gm-Message-State: AFq9FYL6xhcT+XaQsfL+vR1OebqeBcM0NP+1xhjH140kPqhXE47NcCwH
	HHLSxw6GL2RGcJUVZejHt4fXUiR4U2QZLWc8v5ZzUUGoQ0d1k5Arl6Gij9hjuX129jE=
X-Gm-Gg: AYBFou2drqHxwm4htO/zdCjf30TuIwAk+9jwHPSPt9iQuPYKz095/Cgvh6EkInzju63
	4yRgUuWpPbOOGACwHl+6fsxyn5xA6EH26yVODW0Bs5XkvG9fU9HLtJgo3d6lKzXYTjYlkxYgltA
	AED0CahVOzEeDQrSQNT9vpiEy6tVJC7WM0xKCyZZHcyifbC+4JX47MNm1/yv41jCGIaNoTxVQ58
	T50pYvgLyZ/7HSfZbAxUZjXGlXf8CcmMFaZShkEBC/75B/X+ULC99hn2KzsTwmdnHkurJ7XSDCY
	J4hb+vNslXiUvkIJ5F/eK8YfBZA9toCqBLB5ktUCTXJyXA6no51Hqq0k+5fMN/5tFbBL8yJxi0Z
	kap7FYUg98cSQaaOhxWA+KO/jUWhQUUEWzokg6BFvSytc1recXHcW40+bYtwzhQWUZA/OCltrej
	gAYknD+wykXwTRyuRfYOjzJOF2u2hJdpZstvnHiYxfQFr2cM6KpxW5vMpRp9io60zNNeJVfN/Jz
	kjI5Iu9v7VSpkGFo2lsaoXcqARMvOQOkHqPmnV9FqFR6qpUzun3nFq7TdjlXCuIWt5bNLSoalJr
	wvHAJkiODjHoiTMcGXY=
X-Received: by 2002:a05:6122:d19:b0:5ea:c90d:d1b2 with SMTP id 71dfb90a1353d-5eac90dd9bfmr454444e0c.13.1792372497778;
        Sun, 18 Oct 2026 18:14:57 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:56 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 3/8] x86/mce/intel: Bound cmci_rediscover() to a single topology peer
Date: Sun, 18 Oct 2026 21:14:41 -0400
Message-ID: <20261019011446.834487-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a CPU goes offline, cmci_clear() disables CMCI on any MCA banks
owned by that CPU, and mce_cpu_dead() calls cmci_rediscover(). Currently
cmci_rediscover() invokes on_each_cpu(cmci_rediscover_work_func, NULL, 1),
sending a synchronous broadcast IPI to every online CPU in the system,
all of which contend on the global cmci_discover_lock while reading up
to 32 MSR_IA32_MCx_CTL2 MSRs.

Any bank disabled by cmci_clear() is either thread-private, core-scoped
(shared between SMT threads of the same physical core), L2-cluster-scoped,
die-scoped, or package-scoped:
1. Any bank index that is already owned by the target peer in its own
   mce_banks_owned bitmap is private to a narrower scope than the shared
   level and will be skipped by cmci_skip_bank() on the target anyway.
2. Core- or cluster-shared MCA banks can only be claimed by an online
   SMT sibling or L2 cluster peer.
3. Shared die-scoped or package-scoped uncore banks can be claimed in a
   single pass by one online peer on the same die or package.

Record the bitmap of banks disabled by __cmci_disable_bank() in
cmci_orphaned_banks, select a single online topology peer
cmci_orphaned_target (SMT sibling, L2 cluster peer, die peer, or package
peer) in cmci_clear(), and mask out any bank indices already owned by
that target peer. In cmci_rediscover(), return immediately when
cmci_orphaned_banks is empty; otherwise probe only cmci_orphaned_target
via a single smp_call_function_single() call.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  11.42 s ->  9.63 s (-15.7%)
  Online:   11.08 s -> 11.11 s
  Total:    22.50 s -> 20.74 s (-7.8%)
  cmci_rediscover() (cpu479 offline):
    7,720.6 us -> 0.6 us (-99.99%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/cpu/mce/intel.c | 57 +++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 4655223ba560..f57718b097d9 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -11,6 +11,7 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/topology.h>
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_device_id.h>
@@ -40,6 +41,8 @@
  * owned by the offlined cpu.
  */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
+static mce_banks_t cmci_orphaned_banks;
+static unsigned int cmci_orphaned_target;
 
 /*
  * cmci_discover_lock protects against parallel discovery attempts
@@ -244,6 +247,7 @@ static void cmci_claim_bank(int bank, u64 val, int bios_zero_thresh, int *bios_w
 
 	/* This CPU successfully set the enable bit. */
 	set_bit(bank, (void *)this_cpu_ptr(&mce_banks_owned));
+	__clear_bit(bank, cmci_orphaned_banks);
 
 	if ((val & MCI_CTL2_CMCI_THRESHOLD_MASK) == CMCI_STORM_THRESHOLD) {
 		pr_notice("CPU%d BANK%d CMCI inherited storm\n", smp_processor_id(), bank);
@@ -328,6 +332,7 @@ static void __cmci_disable_bank(int bank)
 	val &= ~MCI_CTL2_CMCI_EN;
 	wrmsrq(MSR_IA32_MCx_CTL2(bank), val);
 	__clear_bit(bank, this_cpu_ptr(mce_banks_owned));
+	__set_bit(bank, cmci_orphaned_banks);
 
 	if ((val & MCI_CTL2_CMCI_THRESHOLD_MASK) == CMCI_STORM_THRESHOLD)
 		cmci_storm_end(bank);
@@ -339,6 +344,8 @@ static void __cmci_disable_bank(int bank)
  */
 void cmci_clear(void)
 {
+	unsigned int cpu = smp_processor_id();
+	unsigned int target;
 	unsigned long flags;
 	int i;
 	int banks;
@@ -346,8 +353,31 @@ void cmci_clear(void)
 	if (!cmci_supported(&banks))
 		return;
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
+	/*
+	 * A bank is shared by the CPUs of one SMT core, L2 cluster, die or
+	 * package, and these scopes nest. The first online peer found from
+	 * the innermost scope outwards is therefore part of every sharing
+	 * scope that still has an online CPU, so it alone can claim every
+	 * orphaned bank that is still claimable. If it already owns an index,
+	 * the instance released here is not shared with it, hence not with
+	 * any online CPU, and that index can be dropped from the rediscovery.
+	 */
+	target = cpumask_any_but(topology_sibling_cpumask(cpu), cpu);
+	if (target >= nr_cpu_ids)
+		target = cpumask_any_but(topology_cluster_cpumask(cpu), cpu);
+	if (target >= nr_cpu_ids)
+		target = cpumask_any_but(topology_die_cpumask(cpu), cpu);
+	if (target >= nr_cpu_ids)
+		target = cpumask_any_but(topology_core_cpumask(cpu), cpu);
+	cmci_orphaned_target = target;
 	for (i = 0; i < banks; i++)
 		__cmci_disable_bank(i);
+	if (target < nr_cpu_ids)
+		bitmap_andnot(cmci_orphaned_banks, cmci_orphaned_banks,
+			      per_cpu(mce_banks_owned, target), MAX_NR_BANKS);
+	else
+		bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
@@ -360,15 +390,38 @@ static void cmci_rediscover_work_func(void *arg)
 		cmci_discover(banks);
 }
 
-/* After a CPU went down cycle through all the others and rediscover */
+/*
+ * After a CPU went down, rediscover orphaned shared banks on a single
+ * topology peer (SMT sibling, L2 cluster peer, die peer, or package peer)
+ * selected in cmci_clear(). Core-private banks whose core is now completely
+ * offline cannot be claimed by any other core, so probing more than one
+ * peer is redundant.
+ */
 void cmci_rediscover(void)
 {
+	unsigned int target;
+	unsigned long flags;
+	bool orphaned;
 	int banks;
 
 	if (!cmci_supported(&banks))
 		return;
 
-	on_each_cpu(cmci_rediscover_work_func, NULL, 1);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	orphaned = !bitmap_empty(cmci_orphaned_banks, MAX_NR_BANKS);
+	target = cmci_orphaned_target;
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+
+	if (!orphaned)
+		return;
+
+	if (target < nr_cpu_ids && cpu_online(target))
+		smp_call_function_single(target, cmci_rediscover_work_func,
+					 NULL, 1);
+
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
-- 
2.56.0.176.g3575e65682-goog

