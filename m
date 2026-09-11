Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D576E49BD68;
	Fri, 11 Sep 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142762; cv=none; b=EcWOCpO2498oTiwNiU7H9H2ysFgI+Omrlwm+yEM/ePTsv5a6EmGoB6fVtCIZk5OitNrPKATpNZaB3CINbTYgnb6ZqNQ+60hgO1ZhnSZDS6xlL0lBbVWVNaDaDLdQprRV5QqvCJP/TDUiB/2EO/vWYNlgAUH9ESywbnpkag1x97I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142762; c=relaxed/simple;
	bh=ZyoDMU6G3eZNpaZLhRifByQ7O2mJsMjwDSX7TXRIQjg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KeaAPnGpPEfWRI5fYBo3R6Q9LWZ5sKh2YGxNh4IBlp1p9UavSHDgytBAg50VTghDwQY16xjeHxxSI7R0/hL0jISkH1NLyxe7mgnl8fMNa9qiMUO4MKu8xijCkAN6t8NSXXNyCIA62Un8xgEOJfTP/1GZZ00EiZwcZwYSSkx0nrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JGGiA5sq; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JGGiA5sq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=D8RO0QRG4E2Br/0EmqPhuKnJGH+9/OFKD0ff0d6/hCM=;
	b=JGGiA5sq1olT/sW26ABQv0Qc73jCAsz2SNWOPmkuTt2okq+8skxSPavdM8+vSP
	LHbJVQJxhXxEifa53CMgNwExkXVI68+EkNSXbRKKIJS0plH4SkDmsMWsRdaL7ORo
	5t5im51eDFjw2s2ctcWP0tB9u3izKLkhBnEd8YmlNxn1U=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDHb8uqJqRqfB1jAA--.31618S2;
	Sat, 12 Sep 2026 00:04:58 +0800 (CST)
Date: Sat, 12 Sep 2026 00:04:57 +0800
From: Hao Zhang <hao_zhang_kdev@163.com>
To: linux-block@vger.kernel.org
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai@fygo.io,
	ming.lei@redhat.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Subject: [PATCH] blk-cgroup: save IRQ state in blkg_tryget_closest()
Message-ID: <aqQmqb1k57PXj8Ef@192.168.1.215>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-CM-TRANSID:_____wDHb8uqJqRqfB1jAA--.31618S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF4DZF1rZr4Dtw43Wry5CFg_yoW5JFWrpr
	WvgF90k3y0qry0ga1kGF1qvF1Iga1kKrWUJrWkWwsakF4rtr1fXF1fZ34qvF4FgFZ7Ars8
	ZF4UA3yvyr4j9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UhtxgUUUUU=
X-CM-SenderInfo: pkdrs65kdqwshngh4qqrwthudrp/xtbC3Qp3amqkJqrNEAAA3V

From: Hao Zhang <zhanghao1@kylinos.cn>

bio_set_dev() associates the bio with a blkg through bio_associate_blkg().
If the blkg lookup misses, blkg_tryget_closest() takes q->queue_lock with
spin_lock_irq() and releases it with spin_unlock_irq(), which
unconditionally enables local interrupts.

Callers may call bio_set_dev() with interrupts already disabled, e.g.
dm-thin's pool_map() does so while holding pool->lock taken with
spin_lock_irq().  The nested spin_unlock_irq() then enables interrupts
while pool->lock is still held, so an I/O completion softirq can run on
the same CPU, re-acquire pool->lock (thin_endio(), or overwrite_endio()
-> complete_mapping_preparation()) and deadlock.  lockdep reports this
as inconsistent SOFTIRQ-ON-W to IN-SOFTIRQ-W usage.

Commit 3a762de55b4e ("block: save irq state in blkg_lookup_create()")
fixed the same problem while the lock lived in blkg_lookup_create(), but
commit 9327a865e395 ("blk-cgroup: don't nest queue_lock under rcu in
blkg_lookup_create()") moved the locking into blkg_tryget_closest() and
reverted it to spin_lock_irq().

Save and restore the caller's IRQ state instead.

Fixes: 9327a865e395 ("blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()")
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
---
 block/blk-cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2b5c29434e42..b56db1cc6778 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2091,6 +2091,7 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	struct request_queue *q = bio->bi_bdev->bd_queue;
 	struct blkcg *blkcg = css_to_blkcg(css);
 	struct blkcg_gq *blkg;
+	unsigned long flags;
 
 	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
@@ -2105,11 +2106,11 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	 * Fast path failed, we're probably issuing IO in this cgroup the first
 	 * time, hold lock to create new blkg.
 	 */
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irqsave(&q->queue_lock, flags);
 	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
 	if (blkg)
 		blkg = blkg_lookup_tryget(blkg);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irqrestore(&q->queue_lock, flags);
 
 	return blkg;
 }

base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.15.0

