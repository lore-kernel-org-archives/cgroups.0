Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA06453A33;
	Fri, 14 Aug 2026 08:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786696858; cv=none; b=FgQcR/WvILDJnnV6rCmX/U1AtvqKvOlEPifkrvJsuxEyJVniHYFuDKop5ldaiNBt7eR7bbIMsfV9SDT4Oh0fn2VXp0T0z2tdPDjVMVeRdgKZX4IOJeIFSo1CCB6ZsQw3c4bsMY0wsBMTskjMN8P+pzqNK98yYb6UQ3oSd+kmbY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786696858; c=relaxed/simple;
	bh=jks90ZPXy9hSYdmvt+EHKHi7vy0MCjyRvvYPvNJt5XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GNzlXV22zOmNu+25uaoNWVAw2jDnxkWKQbksyNZ8SYuXpwriz9ocMyfagw3jzoeCdI5kmOkdklmymk/h0WeFWWtxxlcC4KyNxYSe/oyPkuzIA7mrfei8Xbi17j9DPD+2fzJrQrzvzCGW/d6IBiUQzZH/oE19ZayxY5Fpz1TdvXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=N1x1ONvY; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="N1x1ONvY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=FY
	FTiO+aYu3AE/ZEKJ0U5m5nVCD0391UqFOc6xX6bok=; b=N1x1ONvYdZT0Vd1Z15
	wSRn76MowF2TZWjWDfn9lhBRBuIvuTxmJnXKAPtE1bLjYtvXWgL+lFjZxEWy21se
	85OB4lBVc1k/62MOFUdUgIN/p8A8uHZPCj0tD8hj4R5KsWvAgVxZaoVBEflAwom8
	WBDJ7AZLpGcWgppQwCb+SQbcM=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wAnSYJ01H5qjsbzBQ--.7177S2;
	Fri, 14 Aug 2026 16:40:20 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangjn_dev@163.com,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Shouxin Sun <sunshx@chinatelecom.cn>
Subject: [PATCH] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Fri, 14 Aug 2026 16:40:16 +0800
Message-ID: <20260814084016.123741-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnSYJ01H5qjsbzBQ--.7177S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWryxJw13JF4rKF18Wr4kZwb_yoWrZr48pa
	s0k34fJw4rJrW8KFWIy342gFyrKa18Ja17Kr1furWUJr43Jr4qqF129FyjgFyDGFZ3XrWI
	vF45ZF9I9r4qvr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pELID7UUUUU=
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbC7RSMImp+1HRH-AAA3Y

From: Junnan Zhang <zhangjn11@chinatelecom.cn>

cgroup1_pidlist_destroy_all() flushes the global
cgroup_pidlist_destroy_wq while destroying a cgroup. Because all cgroup
v1 pidlist destruction work items are queued on the same shared workqueue,
a single slow or stuck work item (e.g. waiting for pidlist_mutex held by a
user-space reader) blocks every concurrent cgroup destruction path.

This can lead to kworker tasks stuck in flush_workqueue() for over
hung_task_timeout seconds, as observed on busy systems running Docker or
Kubernetes workloads.

  INFO: task kworker/0:1:1438499 blocked for more than 120 seconds.
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  kworker/0:1 D 0 1438499 2 0x80000080
  Workqueue: cgroup_destroy css_free_rwork_fn
  ? __schedule+0x296/0x900
  schedule+0x28/0x80
  schedule_timeout+0x1ee/0x3a0
  ? kvm_sched_clock_read+0xd/0x20
  wait_for_completion+0x12c/0x190
  ? wake_up_q+0x70/0x70
  flush_workqueue+0x132/0x430
  ? cgroup1_pidlist_destroy_all+0x7c/0xa0
  cgroup1_pidlist_destroy_all+0x7c/0xa0
  css_free_rwork_fn+0xb5/0x390
  process_one_work+0x195/0x3e0
  worker_thread+0x30/0x390
  ? process_one_work+0x3e0/0x3e0
  kthread+0x113/0x130
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x1f/0x40

Fix it by moving the cgroup's pidlists to a local orphan list under
pidlist_mutex, clearing their ->owner pointer, and then cancelling each
pidlist's delayed work outside the lock. The destroy work function now
checks ->owner and skips freeing orphaned pidlists, so
cgroup1_pidlist_destroy_all() can free them safely without flushing the
whole shared workqueue.

Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
---
 kernel/cgroup/cgroup-v1.c | 53 ++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index a4337c9b5287..874fe4dc6ffd 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -206,13 +206,31 @@ struct cgroup_pidlist {
 void cgroup1_pidlist_destroy_all(struct cgroup *cgrp)
 {
 	struct cgroup_pidlist *l, *tmp_l;
+	LIST_HEAD(orphan);
+
+	/*
+	 * Move pidlists to a local orphan list and mark them as owner-less.
+	 * The destroy work function will see ->owner == NULL and skip freeing.
+	 * We then cancel and free them outside pidlist_mutex to avoid
+	 * flush_workqueue() blocking on the shared workqueue.
+	 */
 
 	mutex_lock(&cgrp->pidlist_mutex);
-	list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
-		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork, 0);
+	list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links) {
+		list_del(&l->links);
+		l->owner = NULL;
+		list_add(&l->links, &orphan);
+	}
 	mutex_unlock(&cgrp->pidlist_mutex);
 
-	flush_workqueue(cgroup_pidlist_destroy_wq);
+	list_for_each_entry_safe(l, tmp_l, &orphan, links) {
+		list_del(&l->links);
+		cancel_delayed_work_sync(&l->destroy_dwork);
+		kvfree(l->list);
+		put_pid_ns(l->key.ns);
+		kfree(l);
+	}
+
 	BUG_ON(!list_empty(&cgrp->pidlists));
 }
 
@@ -222,21 +240,26 @@ static void cgroup_pidlist_destroy_work_fn(struct work_struct *work)
 	struct cgroup_pidlist *l = container_of(dwork, struct cgroup_pidlist,
 						destroy_dwork);
 	struct cgroup_pidlist *tofree = NULL;
+	struct cgroup *owner;
 
-	mutex_lock(&l->owner->pidlist_mutex);
+	owner = l->owner;
+	if (owner) {
+		mutex_lock(&owner->pidlist_mutex);
 
-	/*
-	 * Destroy iff we didn't get queued again.  The state won't change
-	 * as destroy_dwork can only be queued while locked.
-	 */
-	if (!delayed_work_pending(dwork)) {
-		list_del(&l->links);
-		kvfree(l->list);
-		put_pid_ns(l->key.ns);
-		tofree = l;
-	}
+		/*
+		 * Destroy iff we didn't get queued again and we're still
+		 * owned by the cgroup.  If ->owner was cleared by
+		 * cgroup1_pidlist_destroy_all(), it will free us.
+		 */
+		if (l->owner == owner && !delayed_work_pending(dwork)) {
+			list_del(&l->links);
+			kvfree(l->list);
+			put_pid_ns(l->key.ns);
+			tofree = l;
+		}
 
-	mutex_unlock(&l->owner->pidlist_mutex);
+		mutex_unlock(&l->owner->pidlist_mutex);
+	}
 	kfree(tofree);
 }
 
-- 
2.43.0

