Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABEA4EE842
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861748; cv=none; b=mbogJqwvhCLdyKe1a+mkno32J5ff0zPzCkoP3782BRsaZW816WlOMRl4j1myH11N8VKxLYAGgOIMARN61VxEXuScSTJCuUS3PyIaFKjMNQZI1+6MTgEtvQZvFovjzsCwvs8DSKUWXlZ/jrSRpvC1BLjPnibaKQJH8ZHjs29yzwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861748; c=relaxed/simple;
	bh=3EOpRkGpyjybDuKlEe8Dm2WpL894O+e4syc8+3J+rKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFiWSksyxkJdbaVkSrV4YbUuQhbsJYjs0JtloOoYTDZUPmmDdjRRC0iCut/qWbg2lkWZlW5u0ecAtfdmmG+fbtmrssGkPcqhhU1PnV5akUxj7qWlc72jeClnCKk0LRwUqdyUT9L4Dwovva7GJlpudAfmsPuQ/mQTNK1mCCcK1OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YY864aDQ; arc=none smtp.client-ip=95.215.58.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YY864aDQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3EOpRkGpyjybDuKlEe8Dm2WpL894O+e4syc8+3J+rKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861743; v=1; x=1789466543;
 b=YY864aDQ8ApF0zFToG0dYNGdF4qoOSE+bCJa81VN2QE4H4LehI1OWr48s2PAHSKlJmKz0NnU
 P8mWLZMCaZIVvTG1iDB6zZuT2o0VQXTRlstCw+hRo/C0+OE4Vnn7e1r9YgnYfsiRxXPeacE7PDF
 aXWwiahadRC0HFXxHQeVLeCc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e678ba84bb062b64;
	Tue, 08 Sep 2026 10:02:23 +0000
X-Mizu-Trace-ID: e678ba84bb062b64
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 2/8] blk-iocost: define iocost_model_ops cost model interface
Date: Tue,  8 Sep 2026 18:01:37 +0800
Message-ID: <20260908100143.47598-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Define the interface for pluggable cost models: a struct_ops with a
single calc_cost(op, nbytes, sector, cursor, iocg_id, flags) callback
taking scalar arguments only.  The return value is vtime (2^37 per
second of device time), clamped to 1s per IO by the kernel.  A return
value of 0 delegates the IO back to the builtin formula, so a model
which only handles some IO types cannot make the rest free.

iocg_id is the id of the issuing cgroup, so a model can keep
per-cgroup state, e.g. for multi-stream sequentiality detection.
The id is only valid while the cgroup exists and is recycled after
removal, so models must treat it as a transient key; struct_ops
callback signatures are frozen once merged, so the identifier is
part of the initial interface.

The model is called from the IO submission path under RCU and must
not sleep.  Only the bio-level charging path consults the model; the
request-level sizing path keeps using the builtin formula.

This is a definition-only patch; the registration infrastructure and
dispatch hook follow in subsequent patches.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/Kconfig              |  9 ++++++
 include/linux/blk-iocost.h | 56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 include/linux/blk-iocost.h

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941ff..bf43be21e00bb 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -231,4 +231,13 @@ config BLK_ERROR_INJECTION
 
 source "block/Kconfig.iosched"
 
+config BLK_CGROUP_IOCOST_BPF
+	bool "Enable BPF pluggable cost model support for the cost IO controller"
+	depends on BLK_CGROUP_IOCOST && BPF_SYSCALL && BPF_JIT
+	help
+	 Enabling this option registers the "iocost_model_ops" BPF
+	 struct_ops type, which allows a BPF program to replace the
+	 builtin linear cost model on devices configured with
+	 "ctrl=bpf" through io.cost.model.
+
 endif # BLOCK
diff --git a/include/linux/blk-iocost.h b/include/linux/blk-iocost.h
new file mode 100644
index 0000000000000..7111b5c03dc36
--- /dev/null
+++ b/include/linux/blk-iocost.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BLK_IOCOST_H
+#define _LINUX_BLK_IOCOST_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+
+/*
+ * Pluggable cost model interface for blk-iocost.
+ *
+ * A BPF struct_ops implementation registered against "iocost_model_ops"
+ * replaces the builtin linear cost model on devices configured with
+ * "ctrl=bpf" through io.cost.model.  The model is a pure function of the
+ * arguments below and returns the cost of the IO in device time units,
+ * where 1 second of device time equals 2^37 (VTIME_PER_SEC).  The
+ * returned value is clamped by the kernel.  A cost of 0 delegates the
+ * IO back to the builtin formula, so a model which does not handle a
+ * given IO type cannot make it free.
+ *
+ * The iocg_id argument identifies the issuing cgroup (css id) so the
+ * model can keep per-cgroup state, e.g. for multi-stream sequentiality
+ * detection.  The id is only valid while the cgroup exists: css ids are
+ * recycled once the cgroup is removed, so models must treat it as a
+ * transient key and reset state when they observe it reused.  Whether
+ * the interface needs a release(iocg_id) callback for state cleanup is
+ * an open question.
+ *
+ * The model is called from the IO submission path under RCU and must
+ * not sleep.  Only the bio-level charging path consults the model;
+ * the request-level sizing path (calc_size_vtime_cost()) keeps using
+ * the builtin formula.
+ */
+
+/* flags for calc_cost() */
+#define IOCOST_COST_F_MERGE	(1ULL << 0)	/* called from merge path */
+
+struct iocost_model_ops {
+	/*
+	 * @op:		REQ_OP_* value (uapi blk_opf.h)
+	 * @nbytes:	IO size in bytes
+	 * @sector:	starting sector
+	 * @cursor:	iocg cursor sector, 0 if none (sequentiality hint)
+	 * @iocg_id:	css id of the issuing cgroup
+	 * @flags:	IOCOST_COST_F_*
+	 */
+	u64 (*calc_cost)(u64 op, u64 nbytes, u64 sector, u64 cursor,
+			 u64 iocg_id, u64 flags);
+};
+
+bool iocost_bpf_calc_cost(u64 op, u64 nbytes, u64 sector, u64 cursor,
+			  u64 iocg_id, u64 flags, u64 *costp);
+bool iocost_bpf_model_registered(void);
+
+#endif	/* CONFIG_BLK_CGROUP_IOCOST_BPF */
+#endif	/* _LINUX_BLK_IOCOST_H */
-- 
2.43.0

