Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE603090C2
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646053; cv=none; b=N03ZOaPG7dSP4jKVRTXP/4ilvCxAddzf0SBOCv8vqB4Il3M6Elr1424lbL1BEUd/RYKxWB/5mL9uOfaEPDLtLxMPzTCDrFVqquWu0Nd28JyDXJaIHROn6+1RxENXlHqYjVa6KthnAdeJKSQRdn+gh9ciFF8XxlnM0X9fTXrrbvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646053; c=relaxed/simple;
	bh=k3FhHbwW2RXNLjd8N+JMVRKns6C9cTKRbg4ZWValOHo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FpGNbYskWyjFRaCabDUF9a15R8bXkvw0saw3909mTI2+nwnA5vtV02QrPxHFg77QcLExIw4ihapDCclBiDByRiS7SWBlEb2BgqJGRf0KarHvB1BEtM1E7yWIR4uBJq5KQ1KX6mhWVu9Dqyx1DBw2+aRr1AyWy3WscJllCVioLUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=V2CqsPVf; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="V2CqsPVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790646050;
	bh=dwOFY0qA5zD55AfPP2BhFlWQOukNC8X93CuuDPIXWvE=;
	b=V2CqsPVfJBbfRYyinyh+FJtmr4QhKgpU2YPj/cC4TizZjrjTHayiXpxG7fzxZydRa9Cn
	Xb3qkfdpGKgjJ7V3FJCkHbOT3kj/5EPEIfxIuxmoMd1CWsFNB1Xpu6D4Gp/lQSvkMsYjhN
	Ce3xAxmvJ7Biw4OpnWWr9f4uzsv3TFDqVcAoVADia8UHTS8X5cUxZW1fm1U/Mflx5pvJBj
	l7633gj8MLp2DixCMz6y4KYDD4MUSfUSGUNwn6upzYIJaBrIEa4D/w00pc/Jx8haBD8dpl
	O0oSeHt8yNuU7EN4p5INirNZmtPK0CQqiRL7HDW7aUKwwui+BYmh0zq6tLGEzcRg==
Received: by recvd-b456b577c-x5bcp with SMTP id recvd-b456b577c-x5bcp-1-6ABB1722-1
	2026-09-29 01:40:50.01666974 +0000 UTC m=+366934.602086333
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-10 (SG) with ESMTP
	id AT0MDOB4SIWqYp-aCCxf3Q
	Tue, 29 Sep 2026 01:40:49.967 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Tue, 29 Sep 2026 01:40:50 +0000 (UTC)
Subject: [PATCH v3 2/2] writeback: kick writeback on a cgwb replaced in
 cgwb_create()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-wb-dying-cgwb-flush-v3-2-e35374884667@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
In-Reply-To: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3680; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=k3FhHbwW2RXNLjd8N+JMVRKns6C9cTKRbg4ZWValOHo=;
 b=owGbwMvMwMW49NyVx9PXrj/EeFotiSFrt7ji5N3up2wZ3h65byH0uy35g2R5qw8Tz4rMlXNPx
 fkblkpP7WQ0ZmFg5GKQFVNkmR8ddN7Zw0gtS1ieHWYQKxPIFAYuTgGYCM8z9v9uC65uWaFRk6zh
 ctGgONdxk8AVa42LRndfvv9ncPDGSZnWRjG2/uyNlWaXJY+4FS8Ilw3a3KdrdU/reDnD1dIG6cC
 O+udhPE2fHjw/nnHhW5FZVZZvafpt/ZMVsWbqfb6aDRb+p7+f/Vv42tKAxd5btkF2ycuXDC8ybs
 aYB599l+19iln74tWXq6OE4luXe+2anKI/pa1ccXns4vRFdry32lZPkNeQNn/DdyLj1rTG+Zwfq
 8I6XZ9UBbW4dXrfjrt444NgbcUDbjMu/5ZggdSs9cf/MQoZPXi5VLZeR+z3f5utU5R3N//d07wo
 rFfSrqZ26iqhsDY5xqY3RzSyCswED79OvK7ppf5/wy8VAA==
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeQxdL6xrv8qB?=
 =?us-ascii?Q?WzapFsCTIloi2i4Yganbi21=2Flv2BnuBPW4JAD40?=
 =?us-ascii?Q?hFkLgjm1aulnZiGp0kZUCWIhotKi=2FEFDIjRD72A?=
 =?us-ascii?Q?FnCOqmYykHyhAottxTbYSXY9OkE+R3IL5pfPXi1?=
 =?us-ascii?Q?SLmDtlsOWQtq=2FouglR9jfdTdNjCDzxlo9vP5hHe?= =?us-ascii?Q?wRS5?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==

When a live memcg's blkcg association changes, cgwb_create() replaces
its killed wb in bdi->cgwb_tree. The old wb is then out of foreign
flushes' reach, but its inodes can still be dirty, and they only move to
the new wb as they are written back (see wbc_attach_and_unlock_inode()),
which may not start for a while.

Start writeback on the replaced wb after the takeover. cgwb_create()
can run with interrupts disabled (folio_account_dirtied() ->
inode_attach_wb()), so do it after dropping cgwb_lock, and make
wb_wakeup() irq-safe.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c           |  8 +++++---
 include/linux/backing-dev.h |  1 +
 mm/backing-dev.c            | 15 ++++++++++++++-
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..b9d69ec0649c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -131,10 +131,12 @@ static bool inode_io_list_move_locked(struct inode *inode,
 
 static void wb_wakeup(struct bdi_writeback *wb)
 {
-	spin_lock_irq(&wb->work_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&wb->work_lock, flags);
 	if (test_bit(WB_registered, &wb->state))
 		mod_delayed_work(bdi_wq, &wb->dwork, 0);
-	spin_unlock_irq(&wb->work_lock);
+	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
 /*
@@ -1334,7 +1336,7 @@ static unsigned long get_nr_dirty_pages(void)
 		get_nr_dirty_inodes();
 }
 
-static void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason)
+void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason)
 {
 	if (!wb_has_dirty_io(wb))
 		return;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index f7ef5895625a..7d5e2896711e 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -37,6 +37,7 @@ void bdi_unregister(struct backing_dev_info *bdi);
 struct backing_dev_info *bdi_alloc(int node_id);
 
 void wb_start_background_writeback(struct bdi_writeback *wb);
+void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason);
 void wb_workfn(struct work_struct *work);
 
 void wb_wait_for_completion(struct wb_completion *done);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 839a3c476c5b..0b09c66eafc6 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -676,7 +676,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct mem_cgroup *memcg;
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
-	struct bdi_writeback *wb, *old_wb;
+	struct bdi_writeback *wb, *old_wb, *kick_wb = NULL;
 	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
@@ -748,6 +748,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
 			if (wb_dying(old_wb)) {
 				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				if (wb_tryget(old_wb))
+					kick_wb = old_wb;
 				ret = 0;
 			} else {
 				ret = -EEXIST;
@@ -763,6 +765,17 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		}
 	}
 	spin_unlock_irqrestore(&cgwb_lock, flags);
+
+	/*
+	 * The replaced wb is out of foreign flushes' reach but may still have
+	 * dirty inodes.  Write it back so that they move over to @wb, see
+	 * wbc_attach_and_unlock_inode().
+	 */
+	if (kick_wb) {
+		wb_start_writeback(kick_wb, WB_REASON_FOREIGN_FLUSH);
+		wb_put(kick_wb);
+	}
+
 	if (ret) {
 		if (ret == -EEXIST)
 			ret = 0;

-- 
2.53.0

