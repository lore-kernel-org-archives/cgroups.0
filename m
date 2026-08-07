Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D833A6B8A
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 19:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786131459; cv=none; b=H9x34eGCgztZp/4NnHZsTgmRuxCfxH+aAFvS4+3xNgjj+FRE3omnU3/MEeLN/Q2iZlWoSwkuKzlBsKv/QvIHPuN9fTUAA7xBZlKsCdwFgrLtuCjcNcHtiAi177xBNY0EW3lEZqauVzgeOf+8HOib03OSTYZnGCwYTgwmA2oiJ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786131459; c=relaxed/simple;
	bh=LY1zudeQGpKe93Wm1RjYLV4w4I6hRdLzm8Tu6l8oMRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHDBEx8VsfQfZgS/UjtG7gBwIh1WuRb2wiHz0aQnvhBbLafCkcNOZlziEbpapGqjf7U3ZNm11YhURcprf4L3fkt4M2zP0+1WA0e6z19rT+2Z0qt6MNgpuWtwkaHtBQu/rZ+opaGVLkGMiIjdJ0YBqSeZK+M+rbADCLgj2YGmtxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOoEnoKB; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOoEnoKB"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c999f162c9aso2731022a12.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 12:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786131456; x=1786736256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oyaDPzZxAYZ6dkJ1RtbEqn7iDEULJIHV8/+9+Tra4y8=;
        b=bOoEnoKB+sUbVvsTr/PHFYuU2ucycPs6Xse04sWmn42rdI6T6ORcpgPO1XQTCw0v/I
         eyEnfdiVsvf2gcQ2NR5r2OAm2rS6Je34MlzNFGYXNsmEKtBN5skgQsd5JKh2bmOEHMSO
         fwdUhggBadPEIIyEAjFbTkwHzbFRvrQJre7IwmeZwyGK7/vc0zDM2PszMoxrFtD4Rtft
         OA3YlddsEb+nDOIHV1i7rJUo8m2S3L0cV/5Oa2qLX6i4x2BU51OIS64y0vSWHJEHumoE
         EURFTVy9UXc13eS6pWE8nj1WYHFWGjYje/88JROJbocrUcyL+uQHCL7UAhdyTmbbFFAq
         Q7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786131456; x=1786736256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oyaDPzZxAYZ6dkJ1RtbEqn7iDEULJIHV8/+9+Tra4y8=;
        b=hUPTlRibwoMAmeLI3qjIgaWO/RLDxbrixmsp72XrVo+pFLsoqHs6I5PRD4i9enIyjy
         dtg57FUvx1wGmhsvw/wS/d4lcajv97w858rsKVcVhHJpLd3wS0fDC5a3FgrUFs2WUYNn
         MAEiVTRuWfFISeYFPbCq0sKECSrnNM5DdFU4AOcwZcQ1Vs8Ik/f7vLW0lNYddpwuzqVP
         NEUsCFOOOcwx4iLXoi43CNNzhlhqAO8wgKSGsHdZ+i8UfkLGujVxwkIw46csnmv5R+Wb
         mxBAlYACPn22hMHZkw9bJUYGcVmhpefIB0zNvdhyPdjuMin7VuR6J2p84ACOru+LsRQ8
         uQSw==
X-Forwarded-Encrypted: i=1; AHgh+RpdNDNbhBRq89aJarZCzATI9bY1J8OISKtF23wyiw2XwX5Gy7OzD/4y2dT/Op9y+gUX19nPoc/f@vger.kernel.org
X-Gm-Message-State: AOJu0YzVewL7Gcz3k4pKK7co8BOAZpzlpiF+1mArXPNQVe5c57MF+6yM
	GcfP+aws8L5lDWeTTzT0u7MC6ZzhFyBhaJYhNVZfuKd24GLyRGJ0JvFW
X-Gm-Gg: AR+sD10OQSmjEi37o424fqvVC7LEZ8OkgLWyX8G6QYU8P5Fwxz2zTmEH/Qp+jCqDK5V
	ZtjEvX1ZgfqTFsKxPj/CA9raZdGmaS5kYxGtt3SDx8YIuPgNzmO0abiMmHi7QDsK9wxiVmUcObY
	Z0+656ciP/pBWkM0ml8WFhD/EfV5M0JW36Q8Z94lORku7fjkWXSYpet7jlpHsBPHaHtmc76/HE8
	+b1TPrqSZdOb0y0XpXaKugceKgV9+DKAVWfbV3MaBodABEHVx2laUTqd0TEdL1uKar8W4JEMd9/
	KaucsI10jmX863kGyKs+imDCWYCQV+SjXTgMSUw9W5LScLIxE6YNYngn72Mp6MSFvMpcGNqD4T9
	VvbcPxVKARriIApyW8P+ATx7GSsAwrEkfxDY2XxwZXg88oHnWxIKS8ztw2w2VNbsgy3PSEp6gaz
	YmaNGfAhoEs0G2cbzKZN2Ao3wuo6388TLJ6YRKOFLruqViJbrhKPOTKhM=
X-Received: by 2002:a05:6a20:6f02:b0:3c4:511e:26ab with SMTP id adf61e73a8af0-3cb85ded984mr34425035637.3.1786131456465;
        Fri, 07 Aug 2026 12:37:36 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:43::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1410199bfd8sm9547703c88.2.2026.08.07.12.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 12:37:36 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	kernel-team@meta.com,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH 1/2] block: add BPF kfuncs to read blkcg io.stat
Date: Fri,  7 Aug 2026 12:37:31 -0700
Message-ID: <20260807193732.4073299-2-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807193732.4073299-1-ziyang.meme@gmail.com>
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the block I/O controller's per-device statistics to BPF,
mirroring the memory controller kfuncs in mm/bpf_memcontrol.c.

A BPF program gets a blkcg from a cgroup's css with bpf_get_blkcg()
(or bpf_get_root_blkcg() for the root), flushes the stats with
bpf_blkcg_flush_stats(), then walks the cgroup's per-device blkgs with
the bpf_iter_blkg open-coded iterator and reads each device's counters
with bpf_blkg_iostat_bytes() and bpf_blkg_iostat_ios().  bpf_blkg_dev()
returns the device id for labelling.  The reference is released with
bpf_put_blkcg().

Unlike the memory controller, blkcg keeps one blkg (and one io.stat
line) per block device, so the reader kfuncs take a blkg and the
iterator yields them under RCU.  The counters are read under the same
u64_stats seqlock the io.stat file uses, so the kfuncs add no fast-path
cost: accounting stays in the per-cpu blkg iostat and is only folded on
flush.

bpf_blkcg_flush_stats() branches the way blkcg_print_stat() does.  A
non-root cgroup is flushed through rstat.  The root cgroup is not
accounted through rstat at all - blkcg_rstat_flush() returns early for
it and __blkcg_rstat_flush() stops propagating one level short - so its
per-device aggregates are refilled from the disks' own statistics
instead, by blkcg_fill_root_iostats(), which is no longer static for
that reason.  Without this a program reading the root cgroup would see
zeroes.  Those numbers cover every cgroup's I/O, exactly as the root
io.stat file reports them.

Two details are worth calling out:

bpf_iter_blkg_next() forgets the list head once the walk ends, not just
the position.  process_iter_next_call() in the verifier requires an
iterator to keep returning NULL once it has returned it, and stops
checking the loop for termination at that point; restarting the walk
would let such a loop spin forever.

The counter readers give up instead of retrying when called from NMI on
32-bit.  There the u64_stats read is a real seqcount loop, every writer
of blkg->iostat keeps interrupts off, and a perf event program can call
these kfuncs from NMI, where the loop would never end.  On 64-bit the
loop compiles away.

Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 MAINTAINERS        |   1 +
 block/Makefile     |   3 +
 block/blk-cgroup.c |   2 +-
 block/blk-cgroup.h |   1 +
 block/bpf_blkcg.c  | 315 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 321 insertions(+), 1 deletion(-)
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
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d9676126c5b5..8d538ad4e861 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1086,7 +1086,7 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
  * flushing the root cgroup's stats by explicitly filling in the iostat
  * with disk level statistics.
  */
-static void blkcg_fill_root_iostats(void)
+void blkcg_fill_root_iostats(void)
 {
 	struct class_dev_iter iter;
 	struct device *dev;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 615390f751aa..8c9c2a1adfaa 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -205,6 +205,7 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 			     const struct blkcg_policy *pol);
 
 const char *blkg_dev_name(struct blkcg_gq *blkg);
+void blkcg_fill_root_iostats(void);
 void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 		       u64 (*prfill)(struct seq_file *,
 				     struct blkg_policy_data *, int),
diff --git a/block/bpf_blkcg.c b/block/bpf_blkcg.c
new file mode 100644
index 000000000000..48a86f07e198
--- /dev/null
+++ b/block/bpf_blkcg.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Block I/O Controller-related BPF kfuncs and auxiliary code.
+ *
+ * These let a BPF program read a cgroup's io.stat counters. A program turns a
+ * cgroup's css into a struct blkcg with bpf_get_blkcg(), flushes the stats with
+ * bpf_blkcg_flush_stats(), then walks the cgroup's per-device blkgs with the
+ * bpf_iter_blkg open-coded iterator, reading each device's counters with
+ * bpf_blkg_iostat_bytes()/bpf_blkg_iostat_ios(). It mirrors the memory
+ * controller kfuncs in mm/bpf_memcontrol.c, but adds a per-device dimension:
+ * unlike memcg, blkcg keeps one blkg (and one io.stat line) per block device.
+ *
+ * This file lives in block/ because the blkcg/blkg struct layouts are private
+ * to block/blk-cgroup.h.
+ */
+
+#include "blk-cgroup.h"
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/preempt.h>
+#include <linux/rculist.h>
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_get_root_blkcg - Returns a pointer to the root block cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root block cgroup is
+ * never destroyed and doesn't require reference counting. It's safe to pass it
+ * to bpf_put_blkcg().
+ *
+ * Note that the root cgroup is special: its counters are the disks' own
+ * statistics, so they cover every cgroup's I/O rather than only the root's.
+ * This matches what the root io.stat file prints.
+ *
+ * Return: A pointer to the root block cgroup.
+ */
+__bpf_kfunc struct blkcg *bpf_get_root_blkcg(void)
+{
+	/* css_get() is not needed */
+	return &blkcg_root;
+}
+
+/**
+ * bpf_get_blkcg - Get a reference to a block cgroup
+ * @css: pointer to the css structure
+ *
+ * It's fine to pass a css which belongs to any cgroup controller,
+ * e.g. unified hierarchy's main css.
+ *
+ * Implements KF_ACQUIRE semantics.
+ *
+ * Return: A pointer to a blkcg structure after bumping the corresponding css's
+ * reference counter, or NULL if the io controller is not enabled on the cgroup.
+ */
+__bpf_kfunc struct blkcg *bpf_get_blkcg(struct cgroup_subsys_state *css)
+{
+	struct blkcg *blkcg = NULL;
+
+	if (css->ss == &io_cgrp_subsys)
+		return css_tryget(css) ? css_to_blkcg(css) : NULL;
+
+	/*
+	 * Some other controller's css, or the cgroup's own one. Look up the io
+	 * controller's css; rcu keeps it alive between the load and the tryget.
+	 * Acquire and release rcu on one straight path, so that block/'s lock
+	 * context analysis can follow it.
+	 */
+	rcu_read_lock();
+	css = rcu_dereference_raw(css->cgroup->subsys[io_cgrp_id]);
+	if (css && css_tryget(css))
+		blkcg = css_to_blkcg(css);
+	rcu_read_unlock();
+
+	return blkcg;
+}
+
+/**
+ * bpf_put_blkcg - Put a reference to a block cgroup
+ * @blkcg: block cgroup to release
+ *
+ * Releases a previously acquired blkcg reference.
+ * Implements KF_RELEASE semantics.
+ */
+__bpf_kfunc void bpf_put_blkcg(struct blkcg *blkcg)
+{
+	css_put(&blkcg->css);
+}
+
+/**
+ * bpf_blkcg_flush_stats - Flush a block cgroup's io statistics
+ * @blkcg: block cgroup
+ *
+ * Call this before reading counters for up-to-date values. Sleepable.
+ *
+ * It does what reading the io.stat file does, which differs by cgroup. For a
+ * non-root cgroup it folds the per-cpu deltas into the per-device aggregates
+ * and up the cgroup tree. The root cgroup is not accounted through rstat at
+ * all, so for it the per-device aggregates are refilled from the disks'
+ * own statistics, which count every cgroup's I/O.
+ *
+ * The root branch is not self-limiting the way the rstat one is: it rereads
+ * every disk on every call, while a second rstat flush finds nothing left to
+ * fold. The numbers it produces are the same for every cgroup, so read them
+ * once rather than once per cgroup of a walk.
+ */
+__bpf_kfunc void bpf_blkcg_flush_stats(struct blkcg *blkcg)
+{
+	if (!blkcg->css.parent)
+		blkcg_fill_root_iostats();
+	else
+		css_rstat_flush(&blkcg->css);
+}
+
+struct bpf_iter_blkg {
+	__u64 __opaque[2];
+} __attribute__((aligned(8)));
+
+struct bpf_iter_blkg_kern {
+	struct blkcg *blkcg;
+	struct blkcg_gq *pos;
+} __attribute__((aligned(8)));
+
+/**
+ * bpf_iter_blkg_new - Start iterating a block cgroup's per-device blkgs
+ * @it: iterator to initialize
+ * @blkcg: block cgroup whose devices to walk
+ *
+ * Each yielded blkg holds one block device's counters, the same ones behind a
+ * per-device line of the io.stat file. Offline blkgs are skipped, as the file
+ * skips them. One case differs: the file prints no line for a blkg whose disk
+ * is gone, while the walk still yields it, and bpf_blkg_dev() returns 0 for
+ * it. Must be used inside an RCU read section.
+ *
+ * Return: 0 on success.
+ */
+__bpf_kfunc int bpf_iter_blkg_new(struct bpf_iter_blkg *it, struct blkcg *blkcg)
+{
+	struct bpf_iter_blkg_kern *kit = (void *)it;
+
+	BUILD_BUG_ON(sizeof(struct bpf_iter_blkg_kern) > sizeof(struct bpf_iter_blkg));
+	BUILD_BUG_ON(__alignof__(struct bpf_iter_blkg_kern) !=
+		     __alignof__(struct bpf_iter_blkg));
+
+	kit->blkcg = blkcg;
+	kit->pos = NULL;
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
+	/* Cleared once the walk is done, see below. */
+	if (!kit->blkcg)
+		return NULL;
+
+	if (!blkg)
+		node = rcu_dereference(hlist_first_rcu(&kit->blkcg->blkg_list));
+	else
+		node = rcu_dereference(hlist_next_rcu(&blkg->blkcg_node));
+
+	/* Skip offline blkgs, matching the io.stat file. */
+	while (node) {
+		blkg = hlist_entry(node, struct blkcg_gq, blkcg_node);
+		if (blkg->online) {
+			kit->pos = blkg;
+			return blkg;
+		}
+		node = rcu_dereference(hlist_next_rcu(&blkg->blkcg_node));
+	}
+
+	/*
+	 * Forget the list head as well. The verifier assumes that an iterator
+	 * which returned NULL keeps returning NULL, and stops checking the
+	 * loop for termination once it has; starting the walk over would let
+	 * such a loop spin forever.
+	 */
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
+/*
+ * Read one counter out of @blkg's flushed io.stat aggregate. @counters is one
+ * of the two arrays in blkg->iostat.cur; both are guarded by that struct's
+ * seqlock, the one the io.stat file uses. Returns (u64)-1 if the counter
+ * cannot be read.
+ */
+static u64 blkg_iostat_read(struct blkcg_gq *blkg, const u64 *counters,
+			    enum blkg_iostat_type rw)
+{
+	struct blkg_iostat_set *bis = &blkg->iostat;
+	unsigned int seq;
+	u64 val;
+
+	if ((unsigned int)rw >= BLKG_IOSTAT_NR)
+		return (u64)-1;
+
+	/*
+	 * On 32-bit the loop below really is a seqcount retry loop. Every
+	 * writer of blkg->iostat keeps interrupts off, so only an NMI can land
+	 * inside an update, and then the loop would never end. These kfuncs
+	 * are reachable from a perf event program, which does run in NMI, so
+	 * give up rather than spin. On 64-bit the loop compiles away.
+	 */
+	if (BITS_PER_LONG == 32 && in_nmi())
+		return (u64)-1;
+
+	do {
+		seq = u64_stats_fetch_begin(&bis->sync);
+		val = counters[rw];
+	} while (u64_stats_fetch_retry(&bis->sync, seq));
+
+	return val;
+}
+
+/**
+ * bpf_blkg_iostat_bytes - Read a device's io.stat byte counter
+ * @blkg: block group (one device of a block cgroup)
+ * @rw: which counter (BLKG_IOSTAT_READ / _WRITE / _DISCARD)
+ *
+ * Reads the flushed aggregate, so call bpf_blkcg_flush_stats() first for
+ * up-to-date values. The read uses the u64_stats seqlock, like the io.stat
+ * file.
+ *
+ * Return: the number of bytes, or (u64)-1 if @rw is out of range or the
+ * counter cannot be read.
+ */
+__bpf_kfunc u64 bpf_blkg_iostat_bytes(struct blkcg_gq *blkg,
+				      enum blkg_iostat_type rw)
+{
+	return blkg_iostat_read(blkg, blkg->iostat.cur.bytes, rw);
+}
+
+/**
+ * bpf_blkg_iostat_ios - Read a device's io.stat I/O count
+ * @blkg: block group (one device of a block cgroup)
+ * @rw: which counter (BLKG_IOSTAT_READ / _WRITE / _DISCARD)
+ *
+ * Return: the number of I/Os, or (u64)-1 if @rw is out of range or the
+ * counter cannot be read.
+ */
+__bpf_kfunc u64 bpf_blkg_iostat_ios(struct blkcg_gq *blkg,
+				    enum blkg_iostat_type rw)
+{
+	return blkg_iostat_read(blkg, blkg->iostat.cur.ios, rw);
+}
+
+/**
+ * bpf_blkg_dev - Return a blkg's device id
+ * @blkg: block group
+ *
+ * Return: the device's dev_t (use MAJOR()/MINOR() to split), or 0 if the blkg
+ * has no disk.
+ */
+__bpf_kfunc u64 bpf_blkg_dev(struct blkcg_gq *blkg)
+{
+	if (!blkg->q || !blkg->q->disk)
+		return 0;
+
+	return blkg->q->disk->part0->bd_dev;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_blkcg_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_blkcg, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_get_blkcg, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
+BTF_ID_FLAGS(func, bpf_put_blkcg, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_blkcg_flush_stats, KF_SLEEPABLE)
+
+BTF_ID_FLAGS(func, bpf_iter_blkg_new, KF_ITER_NEW | KF_RCU_PROTECTED)
+BTF_ID_FLAGS(func, bpf_iter_blkg_next, KF_ITER_NEXT | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_iter_blkg_destroy, KF_ITER_DESTROY)
+
+BTF_ID_FLAGS(func, bpf_blkg_iostat_bytes, KF_RCU)
+BTF_ID_FLAGS(func, bpf_blkg_iostat_ios, KF_RCU)
+BTF_ID_FLAGS(func, bpf_blkg_dev, KF_RCU)
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
-- 
2.53.0-Meta

