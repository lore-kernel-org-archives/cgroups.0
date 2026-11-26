Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795672352;
	b=AouCPuHX+RAbD4DnJ/ndAHb952yGzmeNYd0WpXRxR1q+CBID3gTHvmf8nWne9tw8tvuB
	 uDCLOk18OGfLp7yDjcnSUzFrYLqcUxqeRfFRz/pSlShPlEJCH+roxoM0Gd4K9GZ3QrtWL
	 byLrY0YNcXz0m6fd64pU/aHWRxVdYLtad443Pvq6NJQ1g6TYv0U9epkXLpJlDLjcOrmR9
	 ZwWJiEoHIwyGbuz19m+UWnjz+WaRCgzA1VDaR4QmsCzbY/JMpVE17LG1inmU31PEOC89v
	 P6abZbTYupLxySqNerZGr+l/ZrENfGGkr5RRb8SbaF32qlGmy7FGBXUqcZoH1/IQXpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795672352;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zVuXwTyscVbFZi1wkQQAp7eD1hXL+dltypOcVIhVGZk=;
	b=jCd3y8NDB8hQPOFvO0XHzRuLkF86emZNoKMIGl0r8rYk2yg6XC7qBEJf4ZRDXHYGSMuh
	 bM6fPc4UZPtVAe0Y0cQf74/aB6NRXiitcw2UAYA2OuewimpxOXpYsHyoJr4tVyB436E8n
	 syb9zrd4zNuen4JRPPeWCxHu2bFZEFixAtm5CJbk4TvbeAcyeHQ8VuG3l0ynnS1KJCvYi
	 /ROW5Zdi7CzFbPhYl+wVwfZK+1/pVyCd68HBHaa+xHTu8Hxrl0uAkwha8kPvxZoqKmjV5
	 ZjUWtJR0dQF0A5VXvUH/NOnpUHAmKOQPiacdpFLPN5g29sbZERSZa8Q77+WyNhYZ+zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ONqKK8bn;
	arc=none smtp.remote-ip=91.218.175.54
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353AE606A326
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 05:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 353AE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ONqKK8bn
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=baszU1mgchieKqc/JGnZXd/YJ5gRMUsdHJjPpVJvFZQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795672350; v=1; x=1796277150;
 b=ONqKK8bnNeEeOmHKGj56U3mdVSBU+8GghiKcwoXAxpubEhdYvizLQmfoNer1jkFMlSWRzT78
 gDCBhHwRkpWuxwLZHYoWpnT7j9nv9rrqVRr/gfiEPUohm/WS9F1GFJk90IAmXTuxIxrtlDzjClL
 JI2DYGnPFlpxSgB+HoZVYTYc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b5932c74b5b5b20e;
	Thu, 26 Nov 2026 05:52:30 +0000
X-Mizu-Trace-ID: b5932c74b5b5b20e
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	tj@kernel.org,
	corbet@lwn.net
Cc: ridong.chen@linux.dev,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 1/2] docs: cgroup-v1: Fix the isolcpus description
Date: Thu, 26 Nov 2026 13:52:05 +0800
Message-ID: <20261126055206.251724-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126055206.251724-1-guopeng.zhang@linux.dev>
References: <20261126055206.251724-1-guopeng.zhang@linux.dev>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The sched_load_balance section incorrectly includes CPUs isolated
with the domain flag of isolcpus= in the default scheduling domain.
It also refers to a nonexistent cpuset.isolcpus file.

Correct both passages and clarify that domain is the default flag
of isolcpus=. The nohz and managed_irq flags do not by themselves
disable scheduler load balancing.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v1/cpusets.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
index fb3fb6fa88cb..d47f96979988 100644
--- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
+++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -398,10 +398,11 @@ Put simply, it costs less to balance between two smaller sched domains
 than one big one, but doing so means that overloads in one of the
 two domains won't be load balanced to the other one.
 
-By default, there is one sched domain covering all CPUs, including those
-marked isolated using the kernel boot time "isolcpus=" argument. However,
-the isolated CPUs will not participate in load balancing, and will not
-have tasks running on them unless explicitly assigned.
+By default, scheduler load balancing includes all online CPUs except
+those isolated with the "domain" flag of the "isolcpus=" boot option.
+This flag is implied if no flags are specified. The "nohz" and
+"managed_irq" flags do not by themselves disable scheduler load
+balancing.
 
 This default load balancing across all CPUs is not well suited for
 the following two situations:
@@ -474,9 +475,9 @@ such partially load balanced cpusets, as they may be artificially
 constrained to some subset of the CPUs allowed to them, for lack of
 load balancing to the other CPUs.
 
-CPUs in "cpuset.isolcpus" were excluded from load balancing by the
-isolcpus= kernel boot option, and will never be load balanced regardless
-of the value of "cpuset.sched_load_balance" in any cpuset.
+CPUs isolated with the "domain" flag of the "isolcpus=" boot option
+remain excluded from scheduler load balancing regardless of the value
+of "cpuset.sched_load_balance" in any cpuset.
 
 1.7.1 sched_load_balance implementation details.
 ------------------------------------------------
-- 
2.43.0

