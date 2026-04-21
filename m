Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B92373C1D
	for <cgroups@vger.kernel.org>; Tue, 21 Apr 2026 03:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776740766; cv=none; b=aFaS1JPR4WO1FLJKihLmrkWynDqb0U4hMhmk9uCxdMSKllPGYGT78sNfrjknTphjfcNEdCUvO7u5xnuqlApM7HMyKzKT8XdAeXTgQRed2oZvhEM+vhfPJCG5FuQZRmqEYpA1ZLJ5pMFo8wA6Dqb52sewt0YLFHR0TRFSmzPnehA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776740766; c=relaxed/simple;
	bh=TxL29QnTwq/820ZjxDXVDgXLQ2KjHnCopRJMsMKEbOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft7YTWRSmbHmrx7Pidch84cRI9yEF5KS5XCFbS4EU/rzFOg966LS8m0SO9rhCBvbMHL9GjiLQ20fG1cv1qVzNkGE5RGZAxtnbZhWniHB0UQXV/phvbe5oYMszxCA5IungOUGqRE0OsYVVqlQUk1gq+qL4BXwS2B2/ETTgGodmF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPaDRmJC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPaDRmJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776740763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLt3YbZO8LaJ7i/PL30alZF/tGSXpd8N0J3i5JY/BrE=;
	b=NPaDRmJCpHDIkw1ac01Dfbi8Pl/jqLl9PjjWiW8duRqpYHYuBd20b5JbeGS85CxCo900o2
	XlQ29Yjx59YfOOeHL+B6pPWVoylBLGWCu+oq9GRp22TfsbUgG/mopsCIexZim8fecIkR5Q
	eLRDzz+S+xrlL17WIpgi5yVv4uLRJc0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-OH2KDsxlO5S_BO4AkuvH1A-1; Mon,
 20 Apr 2026 23:05:59 -0400
X-MC-Unique: OH2KDsxlO5S_BO4AkuvH1A-1
X-Mimecast-MFC-AGG-ID: OH2KDsxlO5S_BO4AkuvH1A_1776740754
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 091971800663;
	Tue, 21 Apr 2026 03:05:54 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.81])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B279A19560AB;
	Tue, 21 Apr 2026 03:05:46 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hyperv@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	rcu@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Costa Shulyupin <cshulyup@redhat.com>,
	Qiliang Yuan <realwujing@gmail.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 08/23] arm64: topology: Use RCU to protect access to HK_TYPE_TICK cpumask
Date: Mon, 20 Apr 2026 23:03:36 -0400
Message-ID: <20260421030351.281436-9-longman@redhat.com>
In-Reply-To: <20260421030351.281436-1-longman@redhat.com>
References: <20260421030351.281436-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

As the HK_TYPE_TICK cpumask is going to be changeable at run time, we
need to use RCU to protect access to the cpumask to prevent it from
going away in the middle of the operation.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 arch/arm64/kernel/topology.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index b32f13358fbb..48f150801689 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -173,6 +173,7 @@ void arch_cpu_idle_enter(void)
 	if (!amu_fie_cpu_supported(cpu))
 		return;
 
+	guard(rcu)();
 	/* Kick in AMU update but only if one has not happened already */
 	if (housekeeping_cpu(cpu, HK_TYPE_TICK) &&
 	    time_is_before_jiffies(per_cpu(cpu_amu_samples.last_scale_update, cpu)))
@@ -187,11 +188,16 @@ int arch_freq_get_on_cpu(int cpu)
 	unsigned int start_cpu = cpu;
 	unsigned long last_update;
 	unsigned int freq = 0;
+	bool hk_cpu;
 	u64 scale;
 
 	if (!amu_fie_cpu_supported(cpu) || !arch_scale_freq_ref(cpu))
 		return -EOPNOTSUPP;
 
+	scoped_guard(rcu) {
+		hk_cpu = housekeeping_cpu(cpu, HK_TYPE_TICK);
+	}
+
 	while (1) {
 
 		amu_sample = per_cpu_ptr(&cpu_amu_samples, cpu);
@@ -204,16 +210,21 @@ int arch_freq_get_on_cpu(int cpu)
 		 * (and thus freq scale), if available, for given policy: this boils
 		 * down to identifying an active cpu within the same freq domain, if any.
 		 */
-		if (!housekeeping_cpu(cpu, HK_TYPE_TICK) ||
+		if (!hk_cpu ||
 		    time_is_before_jiffies(last_update + msecs_to_jiffies(AMU_SAMPLE_EXP_MS))) {
 			struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+			bool hk_intersects;
 			int ref_cpu;
 
 			if (!policy)
 				return -EINVAL;
 
-			if (!cpumask_intersects(policy->related_cpus,
-						housekeeping_cpumask(HK_TYPE_TICK))) {
+			scoped_guard(rcu) {
+				hk_intersects = cpumask_intersects(policy->related_cpus,
+							housekeeping_cpumask(HK_TYPE_TICK));
+			}
+
+			if (!hk_intersects) {
 				cpufreq_cpu_put(policy);
 				return -EOPNOTSUPP;
 			}
-- 
2.53.0

