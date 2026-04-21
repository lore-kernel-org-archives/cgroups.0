Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE2375ABD
	for <cgroups@vger.kernel.org>; Tue, 21 Apr 2026 03:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776740831; cv=none; b=Y2gKXvLuFdB9wqQDVniFWNMZd3yMNVAIPDespo/2DCsFwBkFxGeBNelCGpxTUifqWkUT3EvB6f4TMtt0kGVHpbDkNn794KfwCRgY4o6mHRMFKoUr+AdidgCh69shgmDFzaMHXnZ5TfObAUcSuuDN3isx8gTpD046rSpNOOH0s4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776740831; c=relaxed/simple;
	bh=0bGGT6V5Q/frPq9S5iAZsTcMRt+nPcX7PGfKt6HDhdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRw5tp2sIBFE1+jmkciG3uDRTfh+Fr1+Y1+l7cVYTDNqyLZdwPwEYIkyWZAoJxBoaY8EVxTUjwTr95Clz8FNXbvIrpBnU8H1POCW0n12Tuec99mCeOmnm2WTSdL2SzHSlbn060iRjqD7x1sfkYhEdetGodLVajU1SAKnJh6mblU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SLFWFWJT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SLFWFWJT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776740829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjKKGFReES6fBmLSbBk8lBaxQLaUKd2+7TGo9rl4EsY=;
	b=SLFWFWJTkxoObL4bcXvwuxRlTBHj8hSb4FDxaKUTelWyEErwGY2uur0m8VSlF+G+H+hTn+
	bBY7AlrpXtGebObRSvI50Pe7VjhsZfdC6lYmCF7M1nI6YKZSvjWtx+8s55wEmqC1tEfNsR
	YtyLwlFe67/C+aUpNQVudVPFAjkvokc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-NeFIKFsmNKaVw44PsfsFGA-1; Mon,
 20 Apr 2026 23:07:04 -0400
X-MC-Unique: NeFIKFsmNKaVw44PsfsFGA-1
X-Mimecast-MFC-AGG-ID: NeFIKFsmNKaVw44PsfsFGA_1776740819
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 995781956095;
	Tue, 21 Apr 2026 03:06:59 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.81])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 897CB19560AB;
	Tue, 21 Apr 2026 03:06:52 +0000 (UTC)
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
Subject: [PATCH 17/23] sched/isolation: Extend housekeeping_dereference_check() to cover changes in nohz_full or manged_irqs cpumasks
Date: Mon, 20 Apr 2026 23:03:45 -0400
Message-ID: <20260421030351.281436-18-longman@redhat.com>
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

As we are going to make HK_TYPE_KERNEL_NOISE and
HK_TYPE_MANAGED_IRQ housekeeping cpumasks run time changeable, extend
housekeeping_dereference_check() to cover changes to those cpumasks
as well.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/sched/isolation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 1f3f1c83dd12..1647e7b08bac 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -38,7 +38,8 @@ EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
 static bool housekeeping_dereference_check(enum hk_type type)
 {
-	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) &&
+	   (BIT(type) & (HK_FLAG_DOMAIN | HK_FLAG_KERNEL_NOISE | HK_FLAG_MANAGED_IRQ))) {
 		/* Cpuset isn't even writable yet? */
 		if (system_state <= SYSTEM_SCHEDULING)
 			return true;
-- 
2.53.0

