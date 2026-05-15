Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D0040759B;
	Fri, 15 May 2026 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.198.250.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778848656; cv=none; b=Y8hWyW+uf6kHnsIbxmwERme4t+wN4PF7zEbA9PWx2zNyzhQDUytiv8YMX5Q2jQRi7SWIW4P8Lll8Hfwkjkk160JKWSUKO6/BQTgSm7zNAt3+lswJR5p+sMVQmQTwFy7c7u0iYo6J4i02HUxh8gKWPNE++6h3HuXdjHe18HQRPwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778848656; c=relaxed/simple;
	bh=v6ptNs8E2DM2gJTqLa+MtCsCzJtzpVu1kbUO0k9fpks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tdDrEfKfdWn1lkxNbQ2q8zHsKLdiIKS1kyPKrulqliMUyFPrX8Fb3NrXh9/xyGPi/H2Vt3XWC02vqe7unc/QeYMmUNvbkck6wkmEsufoZoeRDuTUC6SRgRn16uLiWija6Io3ZB1Zr801EALLpElyeCo+QeT8WXFRMyFt9+3Qfbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=bD5At0bR; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=UahecYSk; arc=none smtp.client-ip=91.198.250.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="bD5At0bR";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="UahecYSk"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gH63V0jzVzB1CM;
	Fri, 15 May 2026 14:30:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1778848214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7NWDlTQaOo7IiwNKl0GG4fj27FJy+PDmnfri/o5z8H0=;
	b=bD5At0bR5Jg0JWof7LzSK4ORDhNyyEesEyk8oHcsIbvqqiWbld/GsJvZAOIkYGhm5UtY6Q
	cbdI+b3EmuHku1xHuvjaZpc6WsGns9pTo2GyX7kk7fdxZPfOQzy0GMvEFxLRShn0Ip/Hi/
	Hzh1YnTn8jE/2WsCWDNY8gMK1Vgs8FzztTrtWdkpiduaApNxqxhRCnFZxBX9iC5m5RGBlJ
	MaV+R8Sr1rKTM22AmAIX1f9RpLlPdnSa1PAttC/+55MgEJ8KRK/ew2klCVEvBelCbHw7t0
	2NPTxZFHPa+VRxykZWD2woSqgckNxsFoJ5pIoK53HW7AZ04Kjp56J/OkYXA93g==
From: Qing Ming <a0yami@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1778848213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7NWDlTQaOo7IiwNKl0GG4fj27FJy+PDmnfri/o5z8H0=;
	b=UahecYSk8nnvQGyyqodvVB6F0/VKbsnV53NEdKKWO9grVGIf4lxYkRLept06aOEBNixlrl
	p9qIiGSEbwS8PAvPmxvLKhYr1CfJcma8QPuv6aL5wAL3lToGJwDbYQmF4iq1wxkvUnNE8a
	SnO2Xk1fx+RiMHGIGDV4iws8ZMLrlmH2Y7zpxHL7SBgrhkeYl70r1BwcjV3KkFnV1rlt+1
	M1Iol2Bbnxz43YSvpShH0oZncBRD0SswzpOh3rsih9PGUTp7I4CjxAYdK+0i3O3VChExQL
	L7rPWG36dsmSze3AI1tibcbehiWtCDh0ZoFGB5Z+6Z2GRWOPfdYXfJwoeHKTdQ==
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qing Ming <a0yami@mailbox.org>
Subject: [PATCH] cgroup/rstat: validate cpu before css_rstat_cpu() access
Date: Fri, 15 May 2026 20:29:52 +0800
Message-ID: <20260515122952.59209-1-a0yami@mailbox.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: napwcxwa8qci3tfzheyabyxb5yjcnppn
X-MBO-RS-ID: 9450986fa3a4b6431c2

css_rstat_updated() is exposed as a BPF kfunc and accepts a
caller-provided cpu argument. The function uses cpu for per-cpu rstat
lookups without checking whether it refers to a valid possible CPU.

A BPF iter/cgroup program with CAP_BPF and CAP_PERFMON can pass an
invalid cpu value. On an unfixed UBSCAN_BOUNDS test kernel, cpu ==
0x7fffffff triggers:

  UBSAN: array-index-out-of-bounds in kernel/cgroup/rstat.c:31:9
  index 2147483647 is out of range for type 'long unsigned int [64]'
  Call Trace:
    css_rstat_updated
    bpf_iter_run_prog
    cgroup_iter_seq_show
    bpf_seq_read

Reject invalid cpu values before css_rstat_cpu() access.

Fixes: a319185be9f5 ("cgroup: bpf: enable bpf programs to integrate with rstat")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
---
 kernel/cgroup/rstat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 150e5871e66f..b70b57b9345b 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "cgroup-internal.h"
 
+#include <linux/cpumask.h>
 #include <linux/sched/cputime.h>
 
 #include <linux/bpf.h>
@@ -90,6 +91,9 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	     !IS_ENABLED(CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS)) && in_nmi())
 		return;
 
+	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
+		return;
+
 	rstatc = css_rstat_cpu(css, cpu);
 	/*
 	 * If already on list return. This check is racy and smp_mb() is needed
-- 
2.53.0

