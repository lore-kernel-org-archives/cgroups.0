Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692836;
	b=CDYhkJs/9WMaMj8vYMhoSGXx3azpsApG0P2YU+nscMzMytbpffehwym4PZ/+Exlbl3fy
	 WHH6x7V7T4cw+KiEWssovuAlXHoAlrtUQBjS3aJcTLIYNCfXk9ngHxNsGn1hT5bnFIWJz
	 MZPuoaQTq4CGn3tw/E0Zw729VOWHFWi9fOB9kNQW1iZ69RG2oaaAawVv1M7uB+kMJ/bHS
	 omlM0J4Jf5PRsK4ckROWw7tazPA9YYgmxFzNGwGxSU+b5quDZx591D4IVt94wWwz0IO0N
	 zRvdX19ukU2i3l94J7yvcL2yf7iShFtcjAiZsBIMBAP15Gif59KOcUwIQEU0KSRiJ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692836;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T8zb3wMITIwc0YE32nW2cv2RNb7OiLJ0144r3mIJzPg=;
	b=ocaVuRTQGBqv8TuMCfypcaNr5vEkR2Jgcpixv9MkaprbsmPD9UQRskYkBAAqzpBvmNzI
	 ku3wK+pqvrz8s/RcZzpu1XnSWLwjt/DEPXymSJnChL9EXdTiXA4vJC5+Ot7YIdk80xvUf
	 V6PZkBfohqPQlYaAQdM2Dch/Qoeten28cYF1xdLjlunmOGVlR6IZ3gG0mX7JADj5R9NXp
	 YfdlbCVpyTLjCaFRXLfvz634Zp0+VK7eItN8GJSj0lKnJcF4DRsBMpvfp7V5GwMv6Z6rO
	 jrnueZCw5/ru3UTPCSY/urfTkcB3ETOmbKDtnOdGFUngm3kNqECQKGCdSeo9JXvCUBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=UIZ7nvGJ;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E50606A32C
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59E50606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=UIZ7nvGJ
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7E7FA3F4C1
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692833;
	bh=T8zb3wMITIwc0YE32nW2cv2RNb7OiLJ0144r3mIJzPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=UIZ7nvGJIG+sZFnD5a2PhAo7R+1VRHTTj5tcQ9agWWGqguxjGWfXQxShCVJNqqxjh
	 7+eYGCu2IIr/4IkbD2B9bEvoB5XJVN1oas8l8eE11iA1EddyzowpzfENN0thWISoeP
	 ME230/40+1EYDuQ9NOu5uWce3VCPSKt+qawfobSipY17OHfPqsHIROBvmybfYO8Dyn
	 8H43ByagapbMD5a7Gm6hJdXR/OaB07mxJWj+tiKyMxCQq8F9v4OiCab3ATYauCof3u
	 klIB83wh7QqxArr/oMPbt1TW/UZFf3/fsWQO9eSEroeqme4fWkJV6uH3WIyFQACdIb
	 mND213+P4+V6v9+JAkqxZmsQaDLnjrgEiBg6Bb9qr/mRaVSNMzCsCHQ3hLhyrY8ohM
	 gseKbZ00eBIXVscg1kTDlHTKDRZVRZlvZjcSorFfdZt+tg+jM1ORCu+KJKxwxVb2xx
	 nlIJu1szBd32ZNlo7QfNzVenxGCoHX0gIQx8YocXAAg4urjY4DpQ+nDH60RUn9hMw4
	 k5ehBI/nrghGdKi+An6t3RGG2LearEX+D4F7VbDWacVfBMwrsWzbWyO4o/80iUYCdR
	 KAddM6unYm7VNE67IyYpzzgd8mFdqGsP3kXnsu/0Hn6AC6OOTO+6W4ERi4kA19aCT+
	 llkWm58IhOiis8+Uj1DaThqs=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso8653642eec.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:00:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692832; x=1794297632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T8zb3wMITIwc0YE32nW2cv2RNb7OiLJ0144r3mIJzPg=;
        b=W4/r6tx+FboBBhGNTezW1Wuu4dWINrqTphEyivj/10VbkZPf49IbZzAd1pUP1HAtfB
         0IKwYuHIDltmZ4/NapDbFyHMxKxRMGRMgcggkL5w9IICD0wkuQEuVArdeyYOaFWLdBmO
         v5ZAMWb9BY7cuULBH1mowgm9En7l9iJH8sr3VS3wtj7keDIAdirMAWWJKUGXgUOGSYWp
         GDdo06h4/aV42A2QK9173QpoUExeAAzFfx5KifteBjUQeSOZ3RNld2Qd6K35osGi9MEp
         RM7ECZhszyqAS4cxGqRnZlrJFGeeqq/35/xB8eGShE60byqc0Mokd4159R2gTVzm7NYI
         XtBg==
X-Forwarded-Encrypted: i=1; AKwUvBzyvJ4fNk1BP/4at07mfu91vzCR74Dii8YYen3V2JrpXTDS5uiDTstUOJE24u9/ks6WGLVmG67U@vger.kernel.org
X-Gm-Message-State: APuU4Z+a//WXcdp6WW5SaM5edBqJaW5FH42ydpTGb4DzhufNR3uZ7XGE
	BhvGYhPJjH5adA3dofAvzJFO2ZXeR+QXnADXbyWNZnD7/PJMNME32QheHF/22wj7NOzsMjm+gSJ
	O6uOodM01P9331fJsoQH6cS0Lgg/RP+NV7i56N3BAcsVwuicNd2ODOPbYpJslfZxcoi/SqRtEo3
	Q=
X-Gm-Gg: AYBFou28o79fs+xnSzaSLetwwArUXkGw0fXSnn0zBu64FcWIoy9NKOmWvt1c1gTfDN3
	4Zs3mNkuGnu/t7dwHvyeA866QBAO6aVyqx1UZKZsbDALu0XAh8fpq6GWur2b0nODIy5q1eFF8t6
	p7zzB4QASwTztbA2EGziWb06MN9V3SUeDJERaiMlcF5CL/nkVV754aKMCW40gI7/Fue29LNuplE
	70x3YUjue1sbbyQaDgLWPxcwMTwrkOV2yexo5Lt5cdq3eJD/yk3SZD0YxpQFhqwOBlQj5U1QhXZ
	MlW6BSLEI//FHpnV4KjnjzKhEqnwJ84CUxXuWIanlGS1KLGOSdcSZf9N/oQsFDJp82KV9H/tQJ5
	l48gm5iOhhxAD/NNnnH2Bmg580FmiGapw2DngvdVuIQ/iPhAy3AyZxYKed50hJiUhIQGcui4AP8
	cUoHSxtEcGljbf5PHU8Q==
X-Received: by 2002:a05:693c:20d3:10b0:369:fa21:ba0b with SMTP id 5a478bee46e88-36a42451227mr19269610eec.33.1793692831576;
        Tue, 03 Nov 2026 00:00:31 -0800 (PST)
X-Received: by 2002:a05:693c:20d3:10b0:369:fa21:ba0b with SMTP id 5a478bee46e88-36a42451227mr19269546eec.33.1793692830912;
        Tue, 03 Nov 2026 00:00:30 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:30 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
Date: Tue,  3 Nov 2026 20:59:36 +1300
Message-ID: <20261103075940.110308-3-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Caron Wills <caron.wills@pulsar.com>

Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
preferred affinity management") kthread_fetch_affinity() only removes
domain isolated CPUs from a kthread's affinity, assuming that nohz_full
CPUs are always domain isolated as well. Up to v6.13 every kthread
inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
so nohz_full CPUs were always excluded.

On a system that keeps its nohz_full CPUs in the scheduler domains, e.g.

  isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178

HK_TYPE_DOMAIN covers every CPU, and the RCU expedited grace period
workers rcu_exp_par_gp_kthread_worker/N, the RCU boost kthreads rcub/N
and every NUMA node affine kthread can now land on nohz_full CPUs.
rcu_thread_affine_rnp() prefers the CPUs of the rcu_node, so for a leaf
rcu_node made entirely of nohz_full CPUs the worker is pinned to nothing
but nohz_full CPUs.

Those workers are SCHED_NORMAL (CONFIG_RCU_BOOST=n leaves kthread_prio
at 0), so a SCHED_FIFO userspace busy loop on such a CPU starves them
indefinitely. Every synchronize_rcu_expedited() in the system then
blocks in sync_rcu_exp_select_cpus() -> kthread_flush_work() until the
FIFO task yields. LP: #2165410 captured exactly that on three 7.0
kernels: the cpuset_migrate_mm kworker sits in

  synchronize_rcu_expedited+0x1b2/0x220
  lru_cache_disable+0x15/0x30
  do_migrate_pages+0x4e/0x2b0
  cpuset_migrate_mm_workfn+0x26/0x50

with rcu_exp_gp_kthread_worker in D state in kthread_flush_work(), and
PID 1 waits behind that migration in flush_workqueue() for minutes.

Intersect the affinity with the HK_TYPE_KERNEL_NOISE housekeeping mask
as well and fall back to the CPUs that are housekeeping for both types.
On systems where nohz_full implies domain isolation the two masks are
identical and nothing changes.

HK_TYPE_KERNEL_NOISE is named explicitly rather than HK_TYPE_KTHREAD:
commit 8f78b749f3da ("sched/isolation: Make HK_TYPE_KTHREAD an alias of
HK_TYPE_DOMAIN") (v7.1-rc3) turned the latter into a synonym of the domain
mask, which is precisely the assumption being corrected here, and made a
first version of this patch a no-op on 7.1+ kernels.

Fixes: 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management")
Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/kthread.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index fdb8fb07f40b..b9d8dfe1b6ca 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -327,24 +327,46 @@ void __noreturn kthread_complete_and_exit(struct completion *comp, long code)
 }
 EXPORT_SYMBOL(kthread_complete_and_exit);
 
+/*
+ * Unbound kthreads must run neither on domain isolated CPUs (isolcpus=domain,
+ * cpuset isolated partitions) nor on CPUs isolated from kernel noise
+ * (nohz_full=, isolcpus=nohz). The two sets usually coincide, but the kernel
+ * accepts nohz_full CPUs that remain in the scheduler domains, so both
+ * housekeeping types have to be honoured.
+ */
 static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpumask)
 {
-	const struct cpumask *pref;
+	const struct cpumask *pref, *hk_domain, *hk_kthread;
 
 	guard(rcu)();
 
+	hk_domain = housekeeping_cpumask(HK_TYPE_DOMAIN);
+	/*
+	 * Deliberately not HK_TYPE_KTHREAD: since v7.1 that is an alias of
+	 * HK_TYPE_DOMAIN (commit 8f78b749f3da), which is the very assumption
+	 * being corrected here.
+	 */
+	hk_kthread = housekeeping_cpumask(HK_TYPE_KERNEL_NOISE);
+
 	if (kthread->preferred_affinity) {
 		pref = kthread->preferred_affinity;
 	} else {
 		if (kthread->node == NUMA_NO_NODE)
-			pref = housekeeping_cpumask(HK_TYPE_DOMAIN);
+			pref = hk_domain;
 		else
 			pref = cpumask_of_node(kthread->node);
 	}
 
-	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
+	cpumask_and(cpumask, pref, hk_domain);
+	cpumask_and(cpumask, cpumask, hk_kthread);
+	if (cpumask_empty(cpumask))
+		cpumask_and(cpumask, hk_domain, hk_kthread);
+	/*
+	 * Both the boot parameters and cpuset guarantee that at least one
+	 * CPU stays housekeeping for every type, but don't rely on it.
+	 */
 	if (!cpumask_intersects(cpumask, cpu_online_mask))
-		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+		cpumask_copy(cpumask, hk_domain);
 }
 
 static void kthread_affine_node(void)
-- 
2.55.0

