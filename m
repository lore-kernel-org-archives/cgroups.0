Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7F2363082;
	Mon, 22 Jun 2026 07:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782112460; cv=none; b=crxd1uv4eYOiJ1VP8dAvubUNPKQzmmfCl0CkDqTKrI+epiimYI26ZNYRUT0Rt4nXuj9WrDHKzEYvJMBKvbLm4fWAStV4mjyoVoEjRgtZmNz41Ux0OQNjnN15zl5RZ58Vip5J6FMQrCAkPqfMD1y1xpfZzTwBgeFQSaWEUwn1Ruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782112460; c=relaxed/simple;
	bh=vPVy/wJ+66mHqq7NOVagQqa6rFjN9slbQdTVqkdlBRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N65ywQkr21O6DoR1PdF6jzJ0TZWRBM7WZ258D1qnHgdYfrczwLkQkq6ZIleiGYZ0CDB/f/jMKLKNbE/ZajxcbtxOaBKKSh3w7+Kk4pveFy3aGr4RNimdnC9R0HwWjsloM4SQLy4f4Ur7tq6lbebcFFt9/zBa839+rpJP6tE62Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gkKDS0rspzYQttV;
	Mon, 22 Jun 2026 15:13:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C758F4058C;
	Mon, 22 Jun 2026 15:14:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgB3eT694DhqGkK7Cg--.42632S6;
	Mon, 22 Jun 2026 15:14:06 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	houtao1@huawei.com,
	yukuai@fygo.io,
	wozizhi@huaweicloud.com
Subject: [PATCH 2/2] blk-cgroup: fix null-ptr-deref by freeing blkg pd on blkg_create error path
Date: Mon, 22 Jun 2026 15:07:13 +0800
Message-ID: <20260622070714.1158886-3-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260622070714.1158886-1-wozizhi@huaweicloud.com>
References: <20260622070714.1158886-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3eT694DhqGkK7Cg--.42632S6
X-Coremail-Antispam: 1UD129KBjvJXoWxWryfCF47JFWkWF1kWrWxJFb_yoWrWrWxpr
	W3K3s0krW0gw47ZF45Zr1jq34F9r48t3W3GrZ3Gw4Ykr43A3sYv3WUAr4v9F4fAFZ7Jr15
	Zrs8KrWYkF4jkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AK
	xVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcV
	CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUczV8UUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

When blkg_create() fails before the blkg is linked onto blkcg->blkg_list
and q->blkg_list (e.g. radix_tree_insert() fails or the blkg_lookup()
returns NULL), the blkg is freed asynchronously via blkg_free_workfn().

Since such a blkg was never linked, it is invisible to
blkcg_deactivate_policy(), so its blkg->pd[] entries can not be cleared in
it. blkg_free_workfn() then calls blkcg_policy->pd_free_fn() on them, which
can race with bfq module exit (bfq_exit() -> blkcg_policy_unregister())
clearing the blkcg_policy[] slot, leading to a NULL pointer dereference:

[   72.597786] KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
[   72.598690] CPU: 35 UID: 0 PID: 458 Comm: kworker/35:1 Not tainted 7.1.0+ #33 PREEMPT(full)
[   72.599518] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
[   72.600342] Workqueue: events blkg_free_workfn
[   72.600991] RIP: 0010:blkg_free_workfn+0x115/0x3d0
......
[   72.613278] Call Trace:
[   72.613988]  <TASK>
[   72.614357]  process_one_work+0x6b4/0xff0
[   72.615251]  ? __pfx_blkg_free_workfn+0x10/0x10
[   72.616041]  ? assign_work+0x131/0x3f0
[   72.616962]  worker_thread+0x4eb/0xd50
[   72.617599]  ? __kthread_parkme+0x8d/0x170
[   72.618565]  ? __pfx_worker_thread+0x10/0x10
[   72.619566]  ? __pfx_worker_thread+0x10/0x10
[   72.620213]  kthread+0x327/0x410
......

Fix this by introducing blkg_free_pd() to synchronously free the pd and
clear blkg->pd[] in the blkg_create() error path, while the blkcg_policy
is still valid.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 block/blk-cgroup.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6386fe413994..673886d71c26 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -109,28 +109,37 @@ static struct cgroup_subsys_state *blkcg_css(void)
 	if (css)
 		return css;
 	return task_css(current, io_cgrp_id);
 }
 
+static void blkg_free_pd(struct blkcg_gq *blkg)
+{
+	int i;
+
+	for (i = 0; i < BLKCG_MAX_POLS; i++) {
+		if (blkg->pd[i]) {
+			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
+			blkg->pd[i] = NULL;
+		}
+	}
+}
+
 static void blkg_free_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
 					     free_work);
 	struct request_queue *q = blkg->q;
-	int i;
 
 	/*
 	 * pd_free_fn() can also be called from blkcg_deactivate_policy(),
 	 * in order to make sure pd_free_fn() is called in order, the deletion
 	 * of the list blkg->q_node is delayed to here from blkg_destroy(), and
 	 * blkcg_mutex is used to synchronize blkg_free_workfn() and
 	 * blkcg_deactivate_policy().
 	 */
 	mutex_lock(&q->blkcg_mutex);
-	for (i = 0; i < BLKCG_MAX_POLS; i++)
-		if (blkg->pd[i])
-			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
+	blkg_free_pd(blkg);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
 	spin_lock_irq(&q->queue_lock);
 	list_del_init(&blkg->q_node);
 	spin_unlock_irq(&q->queue_lock);
@@ -436,19 +445,28 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	spin_unlock(&blkcg->lock);
 
 	if (!ret)
 		return blkg;
 
-	/* @blkg failed fully initialized, use the usual release path */
+	/*
+	 * @blkg failed fully initialized and never linked, so its pd[] is
+	 * invisible to blkcg_deactivate_policy(). Free pd[] synchronously
+	 * while blkcg_policy[] is still valid, otherwise the async free path
+	 * may call pd_free_fn() after the policy is unregistered (e.g. rmmod bfq).
+	 * The err_free_blkg path below frees pd[] for the same reason.
+	 */
+	blkg_free_pd(blkg);
 	percpu_ref_kill(&blkg->refcnt);
 	return ERR_PTR(ret);
 
 err_put_css:
 	css_put(&blkcg->css);
 err_free_blkg:
-	if (new_blkg)
+	if (new_blkg) {
+		blkg_free_pd(new_blkg);
 		blkg_free(new_blkg);
+	}
 	return ERR_PTR(ret);
 }
 
 /**
  * blkg_lookup_create - lookup blkg, try to create one if not there
-- 
2.52.0

