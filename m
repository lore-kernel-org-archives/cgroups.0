Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3608485CE8
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 21:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260694; cv=none; b=nt3A/2rC7FzjZVhIoMm4NLzF9dZ/0bPpB5h4FFji8zE72OkLaDfkLsTLL8F0kc5H4dgsI4Uk27Nhtc8cU0WlMMoqgvLjXV7pHvWjvbM02Hb8UxrtJSHcajAv+N5pxgPF9qfoAN/o6JVGaCac7NJcZslg2/vBAfaGnQ9FbO6xySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260694; c=relaxed/simple;
	bh=TDKffd9Fkjz0NiAHzS4kTGbp08DKmog+dRzwJOqZg8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paVW3n5Uot1wcUMkIK/vCOIHLtkK7hUmRwu0p0vwK6/mQnuQWcxSsOT3vzgh0RgtYOApYYU/8C/UFrFo+us5T5fOolSGNJ4bG9d9uG4D1ktgL87ap+XqxtBMFUNskFCN48e5VCPzNN9D64cr2KKrcKQLuRuMGxRDBviy2PebPcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDxkV+Yi; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDxkV+Yi"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d5335cf904so2491125ad.2
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 14:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787260686; x=1787865486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=usT9UbJbbjXSkfskstVIX1ccjxiE/NzHiKaVTFkNt1M=;
        b=EDxkV+YiM+3P8ZsBGZDQBhg34IhQD3pdLX01CwkZRuHWiqwV6uUhmTaR5c074TqfF/
         wh2eypQ4eZHNMUbJWR6QIESpaU0ftq+n7JwoVVPjMWLFNjFE9jQj05qmLMm21K48PjmC
         LRD8R1LFRLSQ6ddKD0fbuh9Otx4U4mgF89PX92i6A8HtHZgBqnYxRV2k5GynMDJ8OrVL
         u4astMIfbANf0oNNWuod6lk/iBwsGKirSxQCEHBNEf9jOBWk57ncuGk9iSHdQIJRbauD
         iut0DDwSuayt6koBJQFZkeiGSW96wXBQ9BTdo65+MKPMo4IJ26MBfyIKC1eedNS7EMxU
         sfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260686; x=1787865486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=usT9UbJbbjXSkfskstVIX1ccjxiE/NzHiKaVTFkNt1M=;
        b=jGZ0OzyAMCCs84CswcNZjUZq3EEE0o5NU38Oq3H41/kf/k1JtcBGz4f6v0g6YRpHI7
         yTK+vX1AJIqne1tE6g8PGd9MDhmWT4T8oiZzSR7mBCTGarUaI+SeZMGbcVbqP1tBKHur
         mL5wKvJWYpLCgdZWf51lB2CmNAMLd3q6E7XjXVxaFGnjB27NT7J9pHB/dPu6Sin2kz3q
         QvySediFmFa1xvs27fiitFvA9ogdzopUEXL7whhsQTHlizmTY9zRHo633icjYGWAPfeJ
         X6EuglnxSkm9sARAk6rYxmY6bRb1FJRUdyhEAg1y32M6mWxsFNPkG2vi/z+tglBFqSPd
         zfEw==
X-Forwarded-Encrypted: i=1; AHgh+RrGE2BL3OoUIB79ZdyFq9s7L9oQaYJLMzNpEJHZ5N6VQ1/u0bcd5HwIkMrWiUO1oy3Xp8hk/Axd@vger.kernel.org
X-Gm-Message-State: AOJu0YwjXrwuNwcd/rrq1aYeXnQgQpgcBC/RKH298b7iPbaFgbYReg2S
	p5IcGqJJ3dK7dBH31hPSBOkxnow1CGA/tPvoEscfCH1OGsMgcJ8/7fsk
X-Gm-Gg: AR+sD11ClCFXwGTNFr3B5mQzohbO+ot+lrIJEMr7BvcCGNd3cMufTaU56eTZRz68i7P
	r+yBgcuzNlsRawd1kBCBs+4T+38mDfI1xMUX+5/j8jpnDo1oDZ4lg3CTshoq+X75zipxzVAk0/5
	FlnOm2xn4yXH5vGS3vZnhffGiRy3FUyT3r10iHyp+LdXn9khduBshzmmRCAkf0bmQHQhNZXWDn3
	0rug1rgkvav88gHu8+Wf8JdQrlZQFvCrSzbypevNO+DjLRi9Yd6ymRhzvj84Iefj0YcN4crR1oU
	rko1/fFS9LI6b/sslKwxkJFTXoJ6oaa2cXoqU+M9K+55XdRiPZU8QU/rUBKUgVF8eIdJLzjs72b
	Peh5XB9O55z33HjBNBpDgm1rTQNIvIAb8InZmu+/Azt1+I6RF71dt/XGuDpdC/kIaBkTrx2l4rd
	s4Sv3b9cbM8N0puEqFb2cdpplCwDlLwCWAwQTSUTIwhX2GPfBJH4fMo0U=
X-Received: by 2002:a17:903:b07:b0:2d0:cc92:f7a3 with SMTP id d9443c01a7336-2d64ada8eb8mr29906555ad.2.1787260686112;
        Thu, 20 Aug 2026 14:18:06 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:66::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327d01ff056sm11599824eec.19.2026.08.20.14.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 14:18:05 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: kernel-team@meta.com,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Ziyang Men <ziyang.meme@gmail.com>,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] block: add BPF kfuncs to read blkcg io.stat
Date: Thu, 20 Aug 2026 14:17:57 -0700
Message-ID: <20260820211758.3393984-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820211758.3393984-1-ziyang.meme@gmail.com>
References: <20260820211758.3393984-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Collecting cgroup statistics is expensive because the existing method
opens and parses a cgroup file for every cgroup. memcg already provides
an efficient BPF interface; extend that model to the block controller.

Add bpf_cgroup_css() and bpf_css_release() to acquire a controller's
css from a cgroup. The reference keeps the css alive across the
sleepable css_rstat_flush().

Add bpf_css_to_blkcg() as a checked RCU-protected css-to-blkcg
conversion and an open-coded iterator for the per-device blkgs.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 MAINTAINERS                |   1 +
 block/Makefile             |   3 +
 block/bpf_blkcg.c          | 138 +++++++++++++++++++++++++++++++++++++
 kernel/cgroup/bpf_cgroup.c |  62 ++++++++++++++---
 4 files changed, 194 insertions(+), 10 deletions(-)
 create mode 100644 block/bpf_blkcg.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f9472c1a090..87c56e955577 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6617,6 +6617,7 @@ F:	block/blk-cgroup.c
 F:	block/blk-iocost.c
 F:	block/blk-iolatency.c
 F:	block/blk-throttle.c
+F:	block/bpf_blkcg.c
 F:	include/linux/blk-cgroup.h
 
 CONTROL GROUP - CPUSET
diff --git a/block/Makefile b/block/Makefile
index e7bd320e3d69..572e49988c8e 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -17,6 +17,9 @@ obj-$(CONFIG_BLK_ERROR_INJECTION) += error-injection.o
 obj-$(CONFIG_BLK_DEV_BSG_COMMON) += bsg.o
 obj-$(CONFIG_BLK_DEV_BSGLIB)	+= bsg-lib.o
 obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
+ifdef CONFIG_BPF_SYSCALL
+obj-$(CONFIG_BLK_CGROUP)	+= bpf_blkcg.o
+endif
 obj-$(CONFIG_BLK_CGROUP_RWSTAT)	+= blk-cgroup-rwstat.o
 obj-$(CONFIG_BLK_CGROUP_FC_APPID) += blk-cgroup-fc-appid.o
 obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o
diff --git a/block/bpf_blkcg.c b/block/bpf_blkcg.c
new file mode 100644
index 000000000000..d8ab8006bc57
--- /dev/null
+++ b/block/bpf_blkcg.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Block I/O Controller-related BPF kfuncs and auxiliary code
+ */
+
+#include "blk-cgroup.h"
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/rculist.h>
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_css_to_blkcg - Cast an io controller css to its block cgroup
+ * @css: io controller css
+ *
+ * Must be called under RCU.
+ *
+ * Return: The block cgroup, or NULL if @css belongs to another controller.
+ */
+__bpf_kfunc struct blkcg *
+bpf_css_to_blkcg(struct cgroup_subsys_state *css)
+{
+	if (unlikely(css->ss != &io_cgrp_subsys))
+		return NULL;
+
+	return css_to_blkcg(css);
+}
+
+struct bpf_iter_blkg {
+	__u64 __opaque[2];
+} __aligned(8);
+
+struct bpf_iter_blkg_kern {
+	struct blkcg *blkcg;
+	struct blkcg_gq *pos;
+} __aligned(8);
+
+/**
+ * bpf_iter_blkg_new - Start iterating a block cgroup's per-device blkgs
+ * @it: iterator to initialize
+ * @blkcg: block cgroup to iterate
+ *
+ * Each blkg holds one device's io.stat counters. Offline blkgs are skipped.
+ * A blkg without a disk can be returned. Root blkgs do not contain the
+ * system-wide statistics shown by root io.stat. Must run under RCU.
+ *
+ * Return: 0 on success.
+ */
+__bpf_kfunc int bpf_iter_blkg_new(struct bpf_iter_blkg *it,
+				  struct blkcg *blkcg)
+{
+	struct bpf_iter_blkg_kern *kit = (void *)it;
+
+	BUILD_BUG_ON(sizeof(struct bpf_iter_blkg_kern) > sizeof(struct bpf_iter_blkg));
+	BUILD_BUG_ON(__alignof__(struct bpf_iter_blkg_kern) !=
+		     __alignof__(struct bpf_iter_blkg));
+
+	kit->pos = NULL;
+	kit->blkcg = blkcg;
+	return 0;
+}
+
+/**
+ * bpf_iter_blkg_next - Return the next online blkg of the iterated block cgroup
+ * @it: iterator
+ *
+ * Return: the next online blkg, or NULL when the walk is done.
+ */
+__bpf_kfunc struct blkcg_gq *bpf_iter_blkg_next(struct bpf_iter_blkg *it)
+{
+	struct bpf_iter_blkg_kern *kit = (void *)it;
+	struct blkcg_gq *blkg = kit->pos;
+	struct hlist_node *node;
+
+	if (!kit->blkcg)
+		return NULL;
+
+	if (!blkg)
+		node = rcu_dereference(hlist_first_rcu(&kit->blkcg->blkg_list));
+	else
+		node = rcu_dereference(hlist_next_rcu(&blkg->blkcg_node));
+
+	/* Skip offline blkgs, matching io.stat. */
+	while (node) {
+		blkg = hlist_entry(node, struct blkcg_gq, blkcg_node);
+		/* A race only changes whether this blkg is returned. */
+		if (data_race(blkg->online)) {
+			kit->pos = blkg;
+			return blkg;
+		}
+		node = rcu_dereference(hlist_next_rcu(&blkg->blkcg_node));
+	}
+
+	/* The iterator must keep returning NULL after completion. */
+	kit->pos = NULL;
+	kit->blkcg = NULL;
+	return NULL;
+}
+
+/**
+ * bpf_iter_blkg_destroy - Tear down a blkg iterator
+ * @it: iterator
+ */
+__bpf_kfunc void bpf_iter_blkg_destroy(struct bpf_iter_blkg *it)
+{
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_blkcg_kfuncs)
+BTF_ID_FLAGS(func, bpf_css_to_blkcg,
+	     KF_RCU | KF_RCU_PROTECTED | KF_RET_NULL)
+
+BTF_ID_FLAGS(func, bpf_iter_blkg_new,
+	     KF_ITER_NEW | KF_RCU | KF_RCU_PROTECTED)
+BTF_ID_FLAGS(func, bpf_iter_blkg_next, KF_ITER_NEXT | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_iter_blkg_destroy, KF_ITER_DESTROY)
+BTF_KFUNCS_END(bpf_blkcg_kfuncs)
+
+static const struct btf_kfunc_id_set bpf_blkcg_kfunc_set = {
+	.owner		= THIS_MODULE,
+	.set		= &bpf_blkcg_kfuncs,
+};
+
+static int __init bpf_blkcg_init(void)
+{
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
+					&bpf_blkcg_kfunc_set);
+	if (err)
+		pr_warn("error while registering bpf blkcg kfuncs: %d\n", err);
+
+	return err;
+}
+late_initcall(bpf_blkcg_init);
diff --git a/kernel/cgroup/bpf_cgroup.c b/kernel/cgroup/bpf_cgroup.c
index cd28c838dc7b..e253633e8278 100644
--- a/kernel/cgroup/bpf_cgroup.c
+++ b/kernel/cgroup/bpf_cgroup.c
@@ -8,12 +8,50 @@
 #include <linux/bpf.h>
 #include <linux/btf_ids.h>
 #include <linux/cgroup.h>
+#include <linux/rcupdate.h>
 
+#ifdef CONFIG_CGROUP_SCHED
 #include "../sched/sched.h"
+#endif
 
-#ifdef CONFIG_CGROUP_SCHED
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_cgroup_css - Get a reference to one controller's css
+ * @cgrp: cgroup to look in
+ * @ssid: controller ID
+ *
+ * The returned css must be released with bpf_css_release().
+ *
+ * Return: The referenced css, or NULL.
+ */
+__bpf_kfunc struct cgroup_subsys_state *
+bpf_cgroup_css(struct cgroup *cgrp, int ssid)
+{
+	struct cgroup_subsys_state *css;
+
+	if (unlikely(ssid < 0 || ssid >= CGROUP_SUBSYS_COUNT))
+		return NULL;
+
+	rcu_read_lock();
+	css = rcu_dereference(cgrp->subsys[ssid]);
+	if (css && !css_tryget(css))
+		css = NULL;
+	rcu_read_unlock();
+
+	return css;
+}
+
+/**
+ * bpf_css_release - Release a css reference
+ * @css: css to release
+ */
+__bpf_kfunc void bpf_css_release(struct cgroup_subsys_state *css)
+{
+	css_put(css);
+}
+
+#ifdef CONFIG_CGROUP_SCHED
 /**
  * bpf_css_to_task_group - Cast a CPU controller css to its task group
  * @css: CPU controller css
@@ -30,29 +68,33 @@ bpf_css_to_task_group(struct cgroup_subsys_state *css)
 
 	return container_of(css, struct task_group, css);
 }
+#endif /* CONFIG_CGROUP_SCHED */
 
 __bpf_kfunc_end_defs();
 
-BTF_KFUNCS_START(bpf_cpu_cgroup_kfunc_ids)
+BTF_KFUNCS_START(bpf_cgroup_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_cgroup_css, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_css_release, KF_RELEASE)
+#ifdef CONFIG_CGROUP_SCHED
 BTF_ID_FLAGS(func, bpf_css_to_task_group,
 	     KF_RCU | KF_RCU_PROTECTED | KF_RET_NULL)
-BTF_KFUNCS_END(bpf_cpu_cgroup_kfunc_ids)
+#endif
+BTF_KFUNCS_END(bpf_cgroup_kfunc_ids)
 
-static const struct btf_kfunc_id_set bpf_cpu_cgroup_kfunc_set = {
+static const struct btf_kfunc_id_set bpf_cgroup_kfunc_set = {
 	.owner		= THIS_MODULE,
-	.set		= &bpf_cpu_cgroup_kfunc_ids,
+	.set		= &bpf_cgroup_kfunc_ids,
 };
 
-static int __init bpf_cpu_cgroup_kfunc_init(void)
+static int __init bpf_cgroup_kfunc_init(void)
 {
 	int err;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
-					&bpf_cpu_cgroup_kfunc_set);
+					&bpf_cgroup_kfunc_set);
 	if (err)
-		pr_warn("error while registering cpu cgroup kfuncs: %d\n", err);
+		pr_warn("error while registering cgroup kfuncs: %d\n", err);
 
 	return err;
 }
-late_initcall(bpf_cpu_cgroup_kfunc_init);
-#endif /* CONFIG_CGROUP_SCHED */
+late_initcall(bpf_cgroup_kfunc_init);
-- 
2.53.0-Meta

