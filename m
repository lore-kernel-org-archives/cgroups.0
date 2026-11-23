Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795411644;
	b=SyBwaoz2B7qdMS6rprBdgJGPhrSxPEdkaxPNFVK69j+cGmixPP3//39xiy4V6BjR2hAS
	 aRr7EouVht7jIYxJuANAbQ9Z7hsHy25mWl90GXrg8WbeV0g/FT4mUML9vOtsTuPD/CpKf
	 mWkGcpFvpZRt8z+2xWC40rApXCDIXz4K/D3g+z3sibyWfUXm6gKwlIeyCWIifkihg3Zp8
	 bMscuNUqCJozXKPvNBM9BgFXgv+g8NTFbbQQEunzpxIS/RdKDBSA11ziqXohp78TpkwUR
	 UX9hPbJpaATooZeoavxQItmS1NS300ZIRN9Lx+T+HXlzwPOp0Qe3TEGwf6h6L5pczdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795411644;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=7DjN14704yiowaIqyEGYRNsbumCAuKtOz7zG7vlkpsk=;
	b=isouheqRryIs2Ryu55d9gjXD3M2MsqQ40oMhI0O59AU71GVW9NB+U99BDhIYGp3uKaSY
	 lcxt3jR8DhelYKYuXbK340iCFik1YWbGBXgE6uNlRht9QqeCC5H4fnYLjfKKrx1fVK2nV
	 Q1ze/92WNMBD0rpC24UIxLvBUnHohZnZntXt+Lt2HPvMRHEYFVB7EAjTqJSlCFNo1zchx
	 x2QDgEgHB2MReBimd6nU7JepqoV4HzwsL4QUEM965kfvGylSGvY1hQ7XLaB6mnnIKegXx
	 k1OE0PnnTDdMX0MJXbCWJbmZRbrV5rRecy9wtu9LPFUIcYDxC3ARPECp7dp29s1zOZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=apVk5raI;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAC5606A31F
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 05:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BAC5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=apVk5raI
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261123052721epoutp0149a23b3ec139c220de05694d6ed4379f~qlWAEXw3h0768207682epoutp01j
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 05:27:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261123052721epoutp0149a23b3ec139c220de05694d6ed4379f~qlWAEXw3h0768207682epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795411641;
	bh=7DjN14704yiowaIqyEGYRNsbumCAuKtOz7zG7vlkpsk=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=apVk5raIaiAkm+DpRE0NO73GwWy4uBC9qJUv1OT1bPTThKIzjD3wpqEJB7LLbNKXk
	 b8+AhhZK1lQgGQzHIOjkFL/ycOtuCw2rnYxCZyCPFVA6zSN95bHEepeBp/Sk3NUkBG
	 SJy5IEpK9ZkPgNDVctfo2UXATo1uYgzX3XgzODp8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261123052720epcas2p3c28e60beda29b106799ffbf512a18ae8~qlV-frHuI2883428834epcas2p3x;
	Mon, 23 Nov 2026 05:27:20 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.212]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jXvZw0dPtz3hhTD; Mon, 23 Nov
	2026 05:27:20 +0000 (GMT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: [RFC PATCH RESEND 3/3] blk-cgroup: add cgroup-based write stream
 placement
Reply-To: suho.son@samsung.com
Sender: Suho Son <suho.son@samsung.com>
From: Suho Son <suho.son@samsung.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
CC: "tj@kernel.org" <tj@kernel.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "rdunlap@infradead.org"
	<rdunlap@infradead.org>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "ngeol564@gmail.com" <ngeol564@gmail.com>,
	KiYoung Lee <kiyoung77.lee@samsung.com>, JinHeon Kim
	<jinheon09.kim@samsung.com>, Suho Son <suho.son@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261123052718epcms2p7a27038aca05d1af19c7c26c4a60b4176@epcms2p7>
Date: Mon, 23 Nov 2026 14:27:18 +0900
X-CMS-MailID: 20261123052718epcms2p7a27038aca05d1af19c7c26c4a60b4176
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e
References: <20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
	<CGME20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p7>

From: Suho Son <suho.son=40samsung.com>

NVMe Flexible Data Placement (FDP) allows writes with similar
lifetimes to be placed in separate reclaim units, reducing write
amplification.  However, existing write stream interfaces require
applications to explicitly assign streams, leaving unmodified
buffered-I/O workloads without an operator-controlled placement
mechanism.

Introduce io.stream, a cgroup v2 I/O controller interface that allows
operators to assign write streams on a per-device basis.  Write I/O
attributed to the cgroup carries the tag via bio->bi_write_stream:
direct writes issued by tasks in the cgroup, and buffered writeback
owned by the cgroup (wbc_init_bio() re-associates writeback bios with
the writeback owner's blkcg_css; requires CONFIG_CGROUP_WRITEBACK).
Devices that support write streams (e.g. NVMe FDP) translate the tag
into a placement identifier so similarly-aged data ends up in the
same reclaim unit.

Key properties:

- Per-device entries are upserts; =22MAJ:MIN inherit=22 restores the
  default state, which adopts the parent's effective stream for the
  device.  An explicit stream 0 is a real entry which pins the cgroup
  to the device default and stops the inheritance walk.
- Configured streams are validated against the device queue limits;
  devices without write streams are rejected with -EOPNOTSUPP, and
  the reserved sentinel (255) is not selectable.
- Only bios still carrying the WRITE_STREAM_NONE sentinel are
  filled: explicit application placement (an io_uring per-I/O stream,
  and filesystem-internal assignments such as f2fs) always wins.
- The policy state is a single word read with READ_ONCE() on the
  submission path; writers are serialized by the queue lock held
  across blkg_conf_prep()/blkg_conf_unprep().  Policy data is freed
  via kfree_rcu() so lockless readers are safe against policy
  deactivation, and the policy activates lazily on first use per
  disk, mirroring blk-throttle.

Link: https://doi.org/10.1145/3837053.3837343

Signed-off-by: Suho Son <suho.son=40samsung.com>
---
 Documentation/admin-guide/cgroup-v2.rst =7C  58 ++++-
 block/Kconfig                           =7C  16 ++
 block/Makefile                          =7C   1 +
 block/blk-core.c                        =7C   2 +
 block/blk-iostream.c                    =7C 315 ++++++++++++++++++++++++
 block/blk-iostream.h                    =7C  18 ++
 6 files changed, 408 insertions(+), 2 deletions(-)
 create mode 100644 block/blk-iostream.c
 create mode 100644 block/blk-iostream.h

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-=
guide/cgroup-v2.rst
index 9e3c67b02ae2e..b0fd93f86027f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
=40=40 -2020,8 +2020,9 =40=40 blk-throttle and apply to all devices, while =
weight based proportional
 distribution is provided by the iocost cost model controller
 (CONFIG_BLK_CGROUP_IOCOST) and, when the BFQ I/O scheduler is in use
 for a device, by BFQ's own cgroup support.  Latency-based protection
-(CONFIG_BLK_CGROUP_IOLATENCY) and I/O priority assignment
-(CONFIG_BLK_CGROUP_IOPRIO) are also available.
+(CONFIG_BLK_CGROUP_IOLATENCY), I/O priority assignment
+(CONFIG_BLK_CGROUP_IOPRIO), and per-device write stream placement
+(CONFIG_BLK_CGROUP_IOSTREAM) are also available.
=20
=20
 IO Interface Files
=40=40 -2443,6 +2444,59 =40=40 The algorithm to set the I/O priority class =
for a request is as follows:
   into the maximum of the I/O priority class policy number and the numeric=
al
   I/O priority class.
=20
+IO Stream Placement
+=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E=7E
+
+The stream placement cgroup policy (CONFIG_BLK_CGROUP_IOSTREAM) allows
+an operator to assign write streams on a per-device basis for write
+I/O attributed to a cgroup.  Write streams are a block-layer hint
+(bio->bi_write_stream) that devices which support write placement
+directives, such as NVMe Flexible Data Placement (FDP), translate into
+placement identifiers, so that data with similar lifetimes is grouped
+into the same reclaim unit.  Write I/O is attributed to the cgroup as
+follows: direct writes issued by tasks in the cgroup, and buffered
+writeback owned by the cgroup; the writeback case requires
+CONFIG_CGROUP_WRITEBACK.
+
+Only bios that do not already carry a stream are affected: a stream
+explicitly assigned by an application or by a file system always
+wins, and a write that expresses no stream at all is placed in the
+device-default stream.
+
+  io.stream
+	A read-write flat-keyed file which exists on non-root
+	cgroups.  Lines are keyed by =24MAJ:=24MIN device numbers.
+
+	Writing =22MAJ:MIN <stream>=22 assigns the write stream to use on
+	that device.  Valid stream numbers are 0 up to the device's
+	maximum write stream count: 0 explicitly selects the
+	device-default stream, larger values select the corresponding
+	device stream.  Writing the same device twice replaces the
+	previous value.  Writing =22MAJ:MIN inherit=22 restores the
+	default state, and a cgroup in the default state adopts the
+	effective stream of the closest ancestor with an entry for
+	that device; an explicit 0 is a real entry which stops this
+	inheritance walk.
+
+	Stream numbers above the device's maximum, and the reserved
+	value 255, are rejected with -EINVAL.  Configuring a device
+	which does not support write streams is rejected with
+	-EOPNOTSUPP.
+
+	Reading returns only the explicit entries; a cgroup in the
+	inherit state has no line for the device.  For example::
+
+	  8:16 3
+
+	To place the writes of a cgroup in stream 3 of a device
+	currently exposed as 8:16, write::
+
+	  echo =228:16 3=22 > io.stream
+
+On direct I/O to a raw block device, the file's write lifetime hint
+(F_SET_RW_HINT) takes precedence over the cgroup value; the cgroup
+value only applies to writes that express no stream.
+
 PID
 ---
=20
diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941ff..558d1251c4343 100644
--- a/block/Kconfig
+++ b/block/Kconfig
=40=40 -170,6 +170,22 =40=40 config BLK_CGROUP_IOPRIO
 	scheduler and block devices process requests. Only some I/O schedulers
 	and some block devices support I/O priorities.
=20
+config BLK_CGROUP_IOSTREAM
+	bool =22Cgroup I/O controller for assigning a per-device write stream=22
+	depends on BLK_CGROUP
+	help
+	Enable the io.stream interface that lets a cgroup associate a
+	block-layer write stream tag with a specific block device. Writes
+	attributed to the cgroup then carry that tag via
+	bio->bi_write_stream. This covers direct I/O issued by tasks in
+	the cgroup as well as buffered writeback owned by the cgroup
+	(which requires CONFIG_CGROUP_WRITEBACK), so devices that support
+	write streams (e.g. NVMe FDP) can group similarly-aged data into
+	the same reclaim unit, reducing write amplification and tail
+	latency for multi-tenant workloads.
+
+	If unsure, say N.
+
 config BLK_DEBUG_FS
 	bool =22Block layer debugging information in debugfs=22
 	default y
diff --git a/block/Makefile b/block/Makefile
index e7bd320e3d697..4b76d99bec298 100644
--- a/block/Makefile
+++ b/block/Makefile
=40=40 -21,6 +21,7 =40=40 obj-=24(CONFIG_BLK_CGROUP_RWSTAT)	+=3D blk-cgroup=
-rwstat.o
 obj-=24(CONFIG_BLK_CGROUP_FC_APPID) +=3D blk-cgroup-fc-appid.o
 obj-=24(CONFIG_BLK_DEV_THROTTLING)	+=3D blk-throttle.o
 obj-=24(CONFIG_BLK_CGROUP_IOPRIO)	+=3D blk-ioprio.o
+obj-=24(CONFIG_BLK_CGROUP_IOSTREAM)	+=3D blk-iostream.o
 obj-=24(CONFIG_BLK_CGROUP_IOLATENCY)	+=3D blk-iolatency.o
 obj-=24(CONFIG_BLK_CGROUP_IOCOST)	+=3D blk-iocost.o
 obj-=24(CONFIG_MQ_IOSCHED_DEADLINE)	+=3D mq-deadline.o
diff --git a/block/blk-core.c b/block/blk-core.c
index 5054a6e21020c..ac346f8fe0aa9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
=40=40 -51,6 +51,7 =40=40
 =23include =22blk-cgroup.h=22
 =23include =22blk-throttle.h=22
 =23include =22blk-ioprio.h=22
+=23include =22blk-iostream.h=22
 =23include =22error-injection.h=22
=20
 struct dentry *blk_debugfs_root;
=40=40 -952,6 +953,7 =40=40 static void bio_set_ioprio(struct bio *bio)
 	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) =3D=3D IOPRIO_CLASS_NONE)
 		bio->bi_ioprio =3D get_current_ioprio();
 	blkcg_set_ioprio(bio);
+	blkcg_set_iostream(bio);
 =7D
=20
 /**
diff --git a/block/blk-iostream.c b/block/blk-iostream.c
new file mode 100644
index 0000000000000..c3577c0e24601
--- /dev/null
+++ b/block/blk-iostream.c
=40=40 -0,0 +1,315 =40=40
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Block cgroup policy that assigns a per-device write stream tag.
+ *
+ * The user writes =22MAJ:MIN <stream>=22 into io.stream of a cgroup. Writ=
e
+ * I/O attributed to that cgroup then carries the tag via
+ * bio->bi_write_stream. This covers direct writes issued by tasks in
+ * the cgroup and buffered writeback owned by the cgroup (wbc_init_bio()
+ * re-associates writeback bios with the writeback owner's blkcg_css).
+ * Devices that support write streams (e.g. NVMe FDP) translate the tag
+ * into a placement identifier so similarly-aged data ends up in the
+ * same reclaim unit.
+ *
+ * Per-device entries are upserted, not appended: writing the same
+ * MAJ:MIN twice replaces the previous value. The default state of a
+ * cgroup is inherit, which adopts the parent's effective stream for
+ * that device. An explicit stream of 0 is a distinct configuration
+ * that pins the cgroup to the device default stream and blocks
+ * inheritance. Writing =22MAJ:MIN inherit=22 restores the default
+ * inherit state.
+ */
+
+=23include <linux/bio.h>
+=23include <linux/blk-mq.h>
+=23include <linux/blk_types.h>
+=23include <linux/blkdev.h>
+=23include <linux/kernel.h>
+=23include <linux/module.h>
+=23include <linux/rcupdate.h>
+=23include <linux/seq_file.h>
+=23include <linux/slab.h>
+=23include <linux/string.h>
+
+=23include =22blk-cgroup.h=22
+=23include =22blk-iostream.h=22
+
+static struct blkcg_policy blkcg_policy_iostream;
+
+/*
+ * Per-(cgroup, device) data. The first member must embed
+ * struct blkg_policy_data so the blkcg core can hand us a pd pointer
+ * that round-trips through container_of().
+ *
+ * =40stream is the whole policy state in a single word:
+ *
+ *	IOSTREAM_INHERIT (-1): the default state; adopt the parent's
+ *			      effective stream for this device.
+ *	0:		      explicit device-default placement; a real
+ *			      entry that stops the inheritance walk.
+ *	1..max_write_streams:  explicit stream identifier.
+ *
+ * Writers are serialized by the queue lock, which blkg_conf_prep()
+ * holds until blkg_conf_unprep() (see iostream_write()). A lockless
+ * READ_ONCE() of the single word therefore yields either the previous
+ * or the new complete configuration, never a mix of both.
+ */
+=23define IOSTREAM_INHERIT	(-1)
+
+struct iostream_grp =7B
+	struct blkg_policy_data	pd;
+	int			stream;
+	struct rcu_head		rcu;
+=7D;
+
+static struct iostream_grp *pd_to_isg(struct blkg_policy_data *pd)
+=7B
+	return pd ? container_of(pd, struct iostream_grp, pd) : NULL;
+=7D
+
+static struct iostream_grp *blkg_to_isg(struct blkcg_gq *blkg)
+=7B
+	return pd_to_isg(blkg_to_pd(blkg, &blkcg_policy_iostream));
+=7D
+
+static struct blkg_policy_data *iostream_pd_alloc(struct gendisk *disk,
+						  struct blkcg *blkcg,
+						  gfp_t gfp)
+=7B
+	struct iostream_grp *isg;
+
+	isg =3D kzalloc_node(sizeof(*isg), gfp, disk->node_id);
+	if (=21isg)
+		return NULL;
+
+	return &isg->pd;
+=7D
+
+static void iostream_pd_init(struct blkg_policy_data *pd)
+=7B
+	struct iostream_grp *isg =3D pd_to_isg(pd);
+
+	isg->stream =3D IOSTREAM_INHERIT;
+=7D
+
+static void iostream_pd_free(struct blkg_policy_data *pd)
+=7B
+	/*
+	 * blkcg_set_iostream() dereferences the pd from the bio submission
+	 * path under rcu_read_lock() without holding the queue or blkcg
+	 * lock, so the memory must survive an RCU grace period after it is
+	 * detached from blkg->pd=5B=5D. This covers both free paths:
+	 * blkcg_deactivate_policy(), which frees the pd immediately while
+	 * bios may still be in flight, and blkg_free_workfn(), which only
+	 * runs once the last blkg reference (including the one held by any
+	 * in-flight bio) is dropped.
+	 */
+	kfree_rcu(pd_to_isg(pd), rcu);
+=7D
+
+static u64 iostream_prfill(struct seq_file *sf, struct blkg_policy_data *p=
d,
+			   int off)
+=7B
+	struct iostream_grp *isg =3D pd_to_isg(pd);
+	const char *dname =3D blkg_dev_name(pd->blkg);
+	int stream;
+
+	/*
+	 * Called under rcu_read_lock() from blkcg_print_blkgs(), so the
+	 * pd dereference is safe against iostream_pd_free(). Report every
+	 * explicit configuration, including an explicit stream 0, so the
+	 * readback reflects what was written.
+	 */
+	if (=21dname)
+		return 0;
+
+	stream =3D READ_ONCE(isg->stream);
+	if (stream =3D=3D IOSTREAM_INHERIT)
+		return 0;
+
+	seq_printf(sf, =22%s %u=5Cn=22, dname, stream);
+	return 0;
+=7D
+
+static int iostream_show(struct seq_file *sf, void *v)
+=7B
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), iostream_prfill,
+			  &blkcg_policy_iostream, 0, false);
+	return 0;
+=7D
+
+static ssize_t iostream_write(struct kernfs_open_file *of, char *buf,
+			      size_t nbytes, loff_t off)
+=7B
+	struct blkcg *blkcg =3D css_to_blkcg(of_css(of));
+	struct blkg_conf_ctx ctx;
+	struct iostream_grp *isg;
+	char *body;
+	unsigned int v;
+	char dummy;
+	int ret;
+
+	blkg_conf_init(&ctx, buf);
+
+	ret =3D blkg_conf_open_bdev(&ctx);
+	if (ret)
+		goto out_finish;
+
+	/*
+	 * The policy is activated lazily on first use of io.stream for a
+	 * given disk, mirroring blk-throttle's blk_throtl_init() pattern.
+	 * Devices that do not support write streams are rejected up front.
+	 */
+	if (=21bdev_max_write_streams(ctx.bdev)) =7B
+		ret =3D -EOPNOTSUPP;
+		goto close_bdev;
+	=7D
+
+	if (=21blkcg_policy_enabled(ctx.bdev->bd_queue, &blkcg_policy_iostream)) =
=7B
+		ret =3D blkcg_activate_policy(ctx.bdev->bd_disk,
+					    &blkcg_policy_iostream);
+		if (ret)
+			goto close_bdev;
+	=7D
+
+	ret =3D blkg_conf_prep(blkcg, &blkcg_policy_iostream, &ctx);
+	if (ret)
+		goto close_bdev;
+
+	isg =3D blkg_to_isg(ctx.blkg);
+	body =3D strim(ctx.body);
+	ret =3D -EINVAL;
+
+	if (body=5B0=5D && =21strncasecmp(body, =22inherit=22, 7) && body=5B7=5D =
=3D=3D '=5C0') =7B
+		/* restore the default inherit state */
+		WRITE_ONCE(isg->stream, IOSTREAM_INHERIT);
+		ret =3D 0;
+	=7D else if (sscanf(body, =22%u %c=22, &v, &dummy) =3D=3D 1 &&
+		   v <=3D bdev_max_write_streams(ctx.bdev) &&
+		   v <=3D U8_MAX && v =21=3D WRITE_STREAM_NONE) =7B
+		/*
+		 * bi_write_stream is a u8 that reserves 255
+		 * (WRITE_STREAM_NONE) as the =22unset=22 sentinel, hence the
+		 * U8_MAX bound and the WRITE_STREAM_NONE exclusion: a
+		 * device advertising more than 254 streams cannot have
+		 * its stream 255 selected through this interface. The
+		 * single-word =40stream state and its locking are
+		 * described at struct iostream_grp.
+		 */
+		WRITE_ONCE(isg->stream, (int)v);
+		ret =3D 0;
+	=7D
+
+	blkg_conf_unprep(&ctx);
+
+close_bdev:
+	blkg_conf_close_bdev(&ctx);
+out_finish:
+	return ret ?: nbytes;
+=7D
+
+/**
+ * blkcg_set_iostream - apply the cgroup's per-device write stream to a bi=
o
+ * =40bio: the bio about to be submitted
+ *
+ * Called from bio_set_ioprio() in the submit_bio() path with
+ * bio->bi_blkg already attached (see bio_associate_blkg() in
+ * bio_init/bio_reset). All write bios funnel through this hook: direct
+ * I/O issued by tasks in the cgroup and buffered writeback owned by
+ * the cgroup (wbc_init_bio() associates writeback bios with the
+ * writeback owner's blkcg_css, which requires CONFIG_CGROUP_WRITEBACK).
+ * Reads are naturally skipped by the op_is_write() filter. Devices
+ * that do not advertise write streams are skipped.
+ *
+ * Inheritance: the walk visits the bio's blkg and its ancestors and
+ * stops at the first one with an explicit entry for this device. A
+ * cgroup in the default inherit state (no entry) adopts the parent's
+ * effective stream; an explicit 0 is a real entry that stops the walk
+ * and pins the bio to the device default stream.
+ *
+ * Precedence: if the bio already carries a concrete bi_write_stream
+ * (i.e. anything other than WRITE_STREAM_NONE, e.g. set by an io_uring
+ * per-I/O write attribute), leave it alone =E2=80=94=20the=20more=20speci=
fic=20source=0D=0A+=20*=20wins.=20The=20cgroup=20value=20only=20fills=20in=
=20a=20bio=20that=20expressed=20no=20stream.=0D=0A+=20*=20A=20residual=20WR=
ITE_STREAM_NONE=20(no=20issuer=20stream=20and=20no=20cgroup=20stream)=0D=0A=
+=20*=20is=20resolved=20to=20the=20device-default=200=20later=20in=20the=20=
submit=20path=0D=0A+=20*=20(submit_bio_noacct_nocheck()),=20so=20the=20driv=
er=20never=20sees=20the=20sentinel.=0D=0A+=20*=0D=0A+=20*=20Locking:=20the=
=20blkg=20and=20its=20->parent=20chain=20are=20stable=20for=20the=20lifetim=
e=0D=0A+=20*=20of=20the=20bio's=20blkg=20reference=20(blkg_tryget_closest()=
,=20blkg_get(parent)=0D=0A+=20*=20at=20creation),=20but=20the=20per-device=
=20policy=20data=20is=20not:=20it=20can=20be=20freed=0D=0A+=20*=20by=20blkc=
g_deactivate_policy()=20while=20a=20bio=20is=20still=20in=20flight.=20The=
=20pd=0D=0A+=20*=20is=20therefore=20only=20dereferenced=20inside=20an=20RCU=
=20read-side=20critical=0D=0A+=20*=20section,=20pairing=20with=20the=20kfre=
e_rcu()=20in=20iostream_pd_free().=20The=0D=0A+=20*=20enabled=20check=20is=
=20repeated=20inside=20the=20RCU=20section=20so=20the=20walk=20cannot=0D=0A=
+=20*=20race=20past=20policy=20deactivation.=20See=20struct=20iostream_grp=
=20for=20the=0D=0A+=20*=20locking=20of=20the=20single-word=20policy=20state=
.=0D=0A+=20*/=0D=0A+void=20blkcg_set_iostream(struct=20bio=20*bio)=0D=0A+=
=7B=0D=0A+=09struct=20blkcg_gq=20*blkg=20=3D=20bio->bi_blkg;=0D=0A+=09int=
=20stream=20=3D=20IOSTREAM_INHERIT;=0D=0A+=0D=0A+=09if=20(=21op_is_write(bi=
o->bi_opf))=0D=0A+=09=09return;=0D=0A+=09if=20(bio->bi_write_stream=20=21=
=3D=20WRITE_STREAM_NONE)=0D=0A+=09=09return;=0D=0A+=09if=20(=21bdev_max_wri=
te_streams(bio->bi_bdev))=0D=0A+=09=09return;=0D=0A+=0D=0A+=09rcu_read_lock=
();=0D=0A+=09if=20(blkcg_policy_enabled(blkg->q,=20&blkcg_policy_iostream))=
=20=7B=0D=0A+=09=09/*=0D=0A+=09=09=20*=20Walk=20up=20to=20find=20the=20firs=
t=20ancestor=20with=20an=20explicit=0D=0A+=09=09=20*=20entry=20for=20this=
=20device,=20including=20an=20explicit=200.=0D=0A+=09=09=20*/=0D=0A+=09=09w=
hile=20(blkg)=20=7B=0D=0A+=09=09=09struct=20iostream_grp=20*isg=20=3D=20blk=
g_to_isg(blkg);=0D=0A+=09=09=09int=20s;=0D=0A+=0D=0A+=09=09=09if=20(=21isg)=
=0D=0A+=09=09=09=09break;=0D=0A+=09=09=09s=20=3D=20READ_ONCE(isg->stream);=
=0D=0A+=09=09=09if=20(s=20=21=3D=20IOSTREAM_INHERIT)=20=7B=0D=0A+=09=09=09=
=09stream=20=3D=20s;=0D=0A+=09=09=09=09break;=0D=0A+=09=09=09=7D=0D=0A+=09=
=09=09blkg=20=3D=20blkg->parent;=0D=0A+=09=09=7D=0D=0A+=09=7D=0D=0A+=09rcu_=
read_unlock();=0D=0A+=0D=0A+=09if=20(stream=20=21=3D=20IOSTREAM_INHERIT)=0D=
=0A+=09=09bio->bi_write_stream=20=3D=20stream;=0D=0A+=7D=0D=0A+=0D=0A+stati=
c=20struct=20cftype=20iostream_files=5B=5D=20=3D=20=7B=0D=0A+=09=7B=0D=0A+=
=09=09.name=09=09=3D=20=22stream=22,=0D=0A+=09=09.flags=09=09=3D=20CFTYPE_N=
OT_ON_ROOT,=0D=0A+=09=09.seq_show=09=3D=20iostream_show,=0D=0A+=09=09.write=
=09=09=3D=20iostream_write,=0D=0A+=09=7D,=0D=0A+=09=7B=20=7D=20/*=20sentine=
l=20*/=0D=0A+=7D;=0D=0A+=0D=0A+static=20struct=20blkcg_policy=20blkcg_polic=
y_iostream=20=3D=20=7B=0D=0A+=09.dfl_cftypes=09=3D=20iostream_files,=0D=0A+=
=0D=0A+=09.pd_alloc_fn=09=3D=20iostream_pd_alloc,=0D=0A+=09.pd_init_fn=09=
=3D=20iostream_pd_init,=0D=0A+=09.pd_free_fn=09=3D=20iostream_pd_free,=0D=
=0A+=7D;=0D=0A+=0D=0A+static=20int=20__init=20iostream_init(void)=0D=0A+=7B=
=0D=0A+=09return=20blkcg_policy_register(&blkcg_policy_iostream);=0D=0A+=7D=
=0D=0A+=0D=0A+static=20void=20__exit=20iostream_exit(void)=0D=0A+=7B=0D=0A+=
=09blkcg_policy_unregister(&blkcg_policy_iostream);=0D=0A+=7D=0D=0A+=0D=0A+=
module_init(iostream_init);=0D=0A+module_exit(iostream_exit);=0D=0Adiff=20-=
-git=20a/block/blk-iostream.h=20b/block/blk-iostream.h=0D=0Anew=20file=20mo=
de=20100644=0D=0Aindex=200000000000000..eb3ca243ad791=0D=0A---=20/dev/null=
=0D=0A+++=20b/block/blk-iostream.h=0D=0A=40=40=20-0,0=20+1,18=20=40=40=0D=
=0A+/*=20SPDX-License-Identifier:=20GPL-2.0=20*/=0D=0A+=0D=0A+=23ifndef=20_=
BLK_IOSTREAM_H_=0D=0A+=23define=20_BLK_IOSTREAM_H_=0D=0A+=0D=0A+=23include=
=20<linux/kconfig.h>=0D=0A+=0D=0A+struct=20bio;=0D=0A+=0D=0A+=23ifdef=20CON=
FIG_BLK_CGROUP_IOSTREAM=0D=0A+void=20blkcg_set_iostream(struct=20bio=20*bio=
);=0D=0A+=23else=0D=0A+static=20inline=20void=20blkcg_set_iostream(struct=
=20bio=20*bio)=0D=0A+=7B=0D=0A+=7D=0D=0A+=23endif=0D=0A+=0D=0A+=23endif=20/=
*=20_BLK_IOSTREAM_H_=20*/=0D=0A--=20=0D=0A2.43.0=0D=0A=0D=0A
