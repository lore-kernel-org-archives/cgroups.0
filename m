Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692858;
	b=LNyqDiEze/j4KZDwWBpC3kjGJOSA4a1wJuOFzhOs/PNPI1EJdSgAShUtu7xVHA04mR4B
	 B1EapBuIhKgbI0C8Oa5Zp7DqD5RKaw9CYPXuN4xyn0JWKCRyZGQHm41k/axOrrn37MWwy
	 S07U5wD4uTPkztkP8UghMjlXmXSxHYGwbA94uXLmfBQaqr8Y/svIZZbC+/CVwUv6Gm+ke
	 PYRMUio4Yu8j2M8ozmGs/Tc7CFeW7otyMga+QUsO36plgGD5TN8zAyz6ufKCnL4ptVWbR
	 Zddv1hrNrIxAt43UXyCF8i7EPjZeLK7gD7uf166DeEITEb81MbPi6GlVjYhiuzuvoWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692858;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jaPQ34I/G6MMT2pb+dBcgiPAsdHes/QH+s/hJq1mQjw=;
	b=nOOHUOL2vVdIOqq22dLx1765O7R1HjGgzXv33N6PlTZ+UVxa7lm7p5xox1QfLjSMd18q
	 RMoVev42mOR8ogq0XUOL4AKbWfG1TzXeLbusyOoKCWyzFti4BdrEHeBnuK+HbbRqjOxMs
	 YY6+Q3oKmnrLUdIergjnM7Zm9SU6YPrA5byFSsOfF4OTGm5O6Tkba6VA5xeaMHVL1x8Qs
	 zTRTGoRB4cHBczQNIB0t27Cn+PG9gctl7q672f3MGQqAIKY2+48rB98qPnKH2LblKF5Fm
	 uwpg6g4N9qgLUNy6NMXAfQrAWI6giS+Psd5b5AJC7eJgYt2nxxr7jVlRjvio8pBoZ+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aBXWkUP9;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F94606A329
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39F94606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aBXWkUP9
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A72C13F520
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692855;
	bh=jaPQ34I/G6MMT2pb+dBcgiPAsdHes/QH+s/hJq1mQjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=aBXWkUP9q41s8F4rawwetX2HntceBR69rrDT+JIkZEmMbpRGvFQVMJsjQcH0JIgEX
	 J5cRmXjo0XzXJGbQAwqLzwewAIS4mHk+K+17oC4Fptsk7bQDlZwlpxbV3MLNByAHCb
	 8aTlqyP5Vd/BUHFsOU97+tb6PJJzyFZ4CBZwsNa/qZwBFm76YC7ytpc0opscAtRWzM
	 KMVONE3pyqAn1iN/Wuix7mNrr23NlNYuLUuPUdPNABjEY4GiGVdna7SRLlojx2hotA
	 a/3o9SNfwcjfyneXLgb01y5DjcCCB8mGzxFYBjMSwXE2xJH5dNQH5LgYguOJNrp44D
	 zPsR35En38yAFkykjizzT4U8yIacJvLUTylIRAk1C41NFOGMX9jkCPrS0qM4IkQNR5
	 rePvv4C8/oU7kiqCj2/KEJ5MHVMiVjED02lKtYpucF4Ram8siEvmCKPO+KTY3vmNKJ
	 gUeCganuYdEhVo7AHv4R8NobPJLRwFlOBCJa6OeZ+JeIq+HL9EgWJYl/X5L7O2pMhA
	 GCOUoHgchPTK9UVBlC/gbT1FgPM5yRFf08dAub7vDTZMfQBaK/w12CYN5MiY2Tfy2i
	 EdjL60VCz5LTrd8JjBHMYkIrQiG2zbkI/ZxpII7j8Xq7xHbwtwWyRYlV6FSb9qZ+qL
	 7x7kOUOXtbOdZu2zVwtIEghA=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so8807891eec.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692854; x=1794297654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jaPQ34I/G6MMT2pb+dBcgiPAsdHes/QH+s/hJq1mQjw=;
        b=zM+iJzFzCgf9BbnO/eqzFL/mcuQ5TyZhozmO3zjAdpwLDo5z1Yf3HXeiF698DYcZ+I
         Mh636TdEZ3pFjwiCB04rk5U0V1uxgFm2zT66V/oNODQe4oDln9Z9z/jp1ViNNp7XILI2
         WnK4X+rZugIX17rrR1dcZ4aDTtBNK34fGfds+oAUMXhUmfdYczGy3lJVLzZrXVfknv3a
         l5rnu1HuV6nEhneMEkv0/YuEsObtasTZ8aMoxARPB4wZZAXCjOp5Uqfa0KgOpZpZVkHs
         syVZR0oQbTF0enqoMBYVCLP3j03r4c4YzS2wQGCg9hqeDUil116HMFc8EPSFCYMwY02H
         VVKA==
X-Forwarded-Encrypted: i=1; AKwUvBw9os5P1EDcZuDCeaOZjZtxgINOVaMpywOyOOnLjUmhykRQ/Pw7Pr8tNYizpUEToLh/B0nO4Up/@vger.kernel.org
X-Gm-Message-State: APuU4Z/ETNMUtHmLh0iCOjMbQE3oK2FniIQkczYkl1EQBgoxO7+9plF0
	Ud0s8OywH4mY/B5Nw+b1cyUPwIofeUsdM1DGst/lSGNApxoD1UFs1o8RfCIPOsT8Bls4+4Y7/Dv
	u3XKntIkASrIIMjGkYh1h+2Xdv2fuax8R+Q400W1fvHFoXFJtyV58Ij+Yv0qlTS2U2O2DhsQQzJ
	A=
X-Gm-Gg: AYBFou21imtX5itB2Wfzzm7SdPZnFgimBDH5gk2paMLM8hQ1cD7OnRqyesWTXbuthzm
	LHivHs/BNjEMHGEN3KVXTHdTniCH92Xe21NZpeqqsSu8QZncg842QBYcJCG+occMW/gHmSmFawm
	XvQk/l+0XcxhmteB7FAO/ezJ0LFw8SH1Wx3H8MuqabeNPIPlU4MSnc2EZVFUPGLoaCmshqzUcRk
	fj6QMxwxz28V8iAgqFjWD/peCAbUPpGyW4GdhnypBQrhglgM8RYbb4iZFRdsd8f8/TGRMb+aeXB
	FyDtArkXz8M3zKP5rsiJrjE5mg3kRvw1G+yTUa0DkPPoe5W8y96ML1eOe7/daQ7bwmiHG6+yD0C
	W47hAcNOvP5e/KAUX3y0uxYC+OeiFqoI+sdTQHnKa015wJsjBqOwtaKIFRr4AnN89PbK0fwvBo/
	KQfwd5GS3HSykeoivukg==
X-Received: by 2002:a05:7300:5988:b0:369:ef92:bd7b with SMTP id 5a478bee46e88-36a42426236mr18638152eec.41.1793692853888;
        Tue, 03 Nov 2026 00:00:53 -0800 (PST)
X-Received: by 2002:a05:7300:5988:b0:369:ef92:bd7b with SMTP id 5a478bee46e88-36a42426236mr18638097eec.41.1793692853176;
        Tue, 03 Nov 2026 00:00:53 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:52 -0800 (PST)
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
Subject: [PATCH 4/6] sched/isolation: Drain per-CPU LRU batches when CPUs become isolated
Date: Tue,  3 Nov 2026 20:59:38 +1300
Message-ID: <20261103075940.110308-5-matthew.ruffell@canonical.com>
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

Isolated CPUs no longer batch folios in their per-CPU LRU caches, so
that __lru_add_drain_all() never has to queue work on them. Boot time
isolation (isolcpus=, nohz_full=) takes effect before any folio is
batched, but a cpuset isolated partition can be created at runtime and
the affected CPUs may still hold folios in their batches from before.
Those would linger until the CPU happens to drain locally, and the next
lru_add_drain_all() would fall back to queueing work on the now isolated
CPU, which is exactly what must be avoided.

Drain all batches once from housekeeping_update(), right after the
HK_TYPE_DOMAIN mask has been updated and next to the vmstat and memcg
workqueue flushes that exist for the same reason, so that newly isolated
CPUs start out with empty batches.

Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/sched/isolation.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b7..17d8171fe97b 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/llist.h>
 #include <linux/pci.h>
+#include <linux/swap.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -149,6 +150,13 @@ int housekeeping_update(struct cpumask *isol_mask)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+	/*
+	 * Folios batched on the newly isolated CPUs before the update would
+	 * otherwise linger in their per-CPU LRU batches, since isolated CPUs
+	 * stop batching from now on (see lru_batching_bypassed()) and remote
+	 * draining is exactly what must be avoided on them.
+	 */
+	lru_add_drain_all();
 
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(HK_TYPE_DOMAIN));
 	WARN_ON_ONCE(err < 0);
-- 
2.55.0

