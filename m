Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795411043;
	b=i7+XE5yZK2DzzYgsGhEuqvOMUsE1iTctO5e4HLq5kCKS6th9clHt1C4P25M5o6I+MUFT
	 VGNI6ILa6KSxBEWboLw3Ae9S696A6cVQT5zqH7Vee9v7mpQNiEDAG8A8EhSIlcwH+TIXe
	 2BpG/Ph2K3qVzwLZzVkH07ZD/ncvsK5OHEXcM0x8nIHAHgdbBYVdVTWGCbe6erpM1bjH0
	 Od5iHEDcqhfrgpKFM9UcZX7jjh8Ue1iFC5xV+gcaaH2RvG68CFAjPgMWBnlktWCJel6ep
	 kDkbH4hxotn+o348NIM3QSLjV5/XnSKZV/JfKubKW4HoBdOMTM30fc/Wbbde2q7EhMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795411043;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=XjwQogUsoyRFdgCnU0LIu5D/7i9Sr44fsqA27qpL1x0=;
	b=1YfdPNqFWjr/I53QIaBmG0jg72EzkWPOXj/FCfvm9HnhWMYp6wDHF36KWnFmqI+MhgOa
	 CTfHbrNTonQ61uvrskon/BynolZn81IAgyL6/fntx+fzjQXpNcLDVZpKLKgpaMsmcKsA8
	 K8ahfHWCfzxrb5lLAnHxY/3pHyEyynXoQuG0+RxctKZOpD9xMAhpZxz8/sQcMRAKvEz6Y
	 Mbrch1hYTiR51CztkuGJ74tqxydnb5S3lmHIBrUoUZV/ZtztpiRUZ8t4iQ9DiK8/x/tIq
	 QZj5Xu5Xyf1P+rsUoU1n+MwLaoygalEjLCofV/XOIrhvRUshmfIDwFylzVQy8ObCmiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=X2DlppWu;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248A606A334
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 05:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9248A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=X2DlppWu
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261123051720epoutp0110459989b852f27ee701fd04c43cb0f7~qlNRG3fSm3238832388epoutp01G
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 05:17:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261123051720epoutp0110459989b852f27ee701fd04c43cb0f7~qlNRG3fSm3238832388epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795411040;
	bh=XjwQogUsoyRFdgCnU0LIu5D/7i9Sr44fsqA27qpL1x0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=X2DlppWubsz7uFKeuYudjyBV2RzR8clvwwwkX3ezcRUEJPB+24V9OAm4QXmfbUE7/
	 iIJP4uF+OS729LiUY0vZLsBLDd/QcZ9zELkl7hfPSfQ0gO3Mf6hdnWuS/pdZWeUj8+
	 ebJgsKBv/04jVnXOhDMm2ZGduw8gM0QYR/mKgFKM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261123051720epcas2p44130b112e7509ec140a11c1f9228a226~qlNQlzoHh0293602936epcas2p4J;
	Mon, 23 Nov 2026 05:17:20 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.208]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jXvMM75lqz6B9mL; Mon, 23 Nov
	2026 05:17:19 +0000 (GMT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: [RFC PATCH RESEND 2/3] io_uring: add IORING_WRITE_STREAM_DEFAULT
 for explicit device-default placement
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
Message-ID: <20261123051719epcms2p2273654d46ba1890e9ebc86e5a28a434f@epcms2p2>
Date: Mon, 23 Nov 2026 14:17:19 +0900
X-CMS-MailID: 20261123051719epcms2p2273654d46ba1890e9ebc86e5a28a434f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e
References: <20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
	<CGME20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>

From: Suho Son <suho.son@samsung.com>

Add a reserved sqe->write_stream value, IORING_WRITE_STREAM_DEFAULT
((__u8)-1), that explicitly requests the device-default stream for a
write.  Unlike an omitted (zero) stream, which lets the kernel derive
one from the inode write hint or, with the cgroup policy added later
in this series, a per-cgroup io.stream value, the reserved value pins
the write to the device default and suppresses both.

The value is translated once in __io_prep_rw() into a request flag
(REQ_F_STREAM_DEFAULT); io_rw_init_file() then converts it into a
concrete stream 0 plus IOCB_WRITE_STREAM_EXPLICIT.  Deciding at prep
time is required for re-issues, where ki_write_stream has already
been rewritten to zero, so the selection survives kiocb
reinitialization and IOSQE_ASYNC deferral.

The reservation is visible in the UAPI: 255 previously failed
validation with -EINVAL on any real device, so no working application
regresses, but a hypothetical device advertising more than 254
streams can no longer have its stream 255 selected through this
interface.

Signed-off-by: Suho Son <suho.son@samsung.com>
---
 include/linux/io_uring_types.h |  4 ++++
 include/uapi/linux/io_uring.h  | 26 ++++++++++++++++++++++++++
 io_uring/rw.c                  | 16 ++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1468bcb028930..550928cd4ad95 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -622,6 +622,8 @@ enum {
 	REQ_F_SQE_COPIED_BIT,
 	REQ_F_IOPOLL_BIT,
 	REQ_F_DMABUF_BIT,
+	/* sqe->write_stream is IORING_WRITE_STREAM_DEFAULT */
+	REQ_F_STREAM_DEFAULT_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -719,6 +721,8 @@ enum {
 	REQ_F_IOPOLL		= IO_REQ_FLAG(REQ_F_IOPOLL_BIT),
 	/* there is a dma map attached to request that needs to be dropped */
 	REQ_F_DMABUF		= IO_REQ_FLAG(REQ_F_DMABUF_BIT),
+	/* sqe->write_stream was IORING_WRITE_STREAM_DEFAULT (see io_rw_init_file()) */
+	REQ_F_STREAM_DEFAULT	= IO_REQ_FLAG(REQ_F_STREAM_DEFAULT_BIT),
 };
 
 struct io_tw_req {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cf1afd11bb871..3ae504d9ec1a0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -122,6 +122,32 @@ struct io_uring_sqe {
 /* sqe->attr_type_mask flags */
 #define IORING_RW_ATTR_FLAG_PI	(1U << 0)
 
+/*
+ * sqe->write_stream reserved value for explicitly requesting the
+ * device-default write stream.
+ *
+ * sqe->write_stream carries a per-I/O write stream identifier for write
+ * requests to block devices that support write streams (e.g. NVMe FDP):
+ *
+ *   0			the issuer does not express a stream; the kernel may
+ *			then derive one from the file's write lifetime hint
+ *			or, if configured, from the cgroup's io.stream
+ *			policy.
+ *   1..max		an explicit stream identifier, validated against the
+ *			device's max_write_streams.
+ *   255 (below)	an explicit request for the device-default stream.
+ *			This overrides both the inode write hint and any
+ *			cgroup io.stream value: the I/O is placed as if no
+ *			stream had been requested by anyone.
+ *
+ * Any other value above the device's max_write_streams is rejected with
+ * -EINVAL, as before. Note that a value of 255 can therefore no longer
+ * select stream 255 on a hypothetical device offering that many streams;
+ * the bio-level write stream field uses 255 as its "unset" sentinel, so
+ * stream identifiers are effectively limited to 1..254 through this
+ * interface.
+ */
+#define IORING_WRITE_STREAM_DEFAULT	((__u8)-1)
 /* PI attribute information in sqe->attr_ptr for IORING_RW_ATTR_FLAG_PI: */
 struct io_uring_attr_pi {
 	__u16	flags;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3ecb842147a4d..d1d154533bf14 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -273,6 +273,8 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 	rw->kiocb.ki_flags = 0;
 	rw->kiocb.ki_write_stream = READ_ONCE(sqe->write_stream);
+	if (rw->kiocb.ki_write_stream == IORING_WRITE_STREAM_DEFAULT)
+		io_req_set_flags(req, REQ_F_STREAM_DEFAULT);
 
 	if (req->ctx->flags & IORING_SETUP_IOPOLL)
 		rw->kiocb.ki_complete = io_complete_rw_iopoll;
@@ -851,6 +853,20 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (unlikely(ret))
 		return ret;
 
+	/*
+	 * IORING_WRITE_STREAM_DEFAULT is an explicit request for the
+	 * device-default stream: carry it as a concrete stream 0 plus a
+	 * marker, so neither the inode write hint nor a cgroup io.stream
+	 * value can override the issuer's choice. The request flag is set
+	 * once at prep time and survives the ki_flags reinitialization
+	 * above as well as async re-issues, where ki_write_stream has
+	 * already been rewritten to 0.
+	 */
+	if (req->flags & REQ_F_STREAM_DEFAULT) {
+		kiocb->ki_write_stream = 0;
+		kiocb->ki_flags |= IOCB_WRITE_STREAM_EXPLICIT;
+	}
+
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
 	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
-- 
2.43.0

