Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761B5423764;
	Fri, 14 Aug 2026 10:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702894; cv=none; b=MBINpuYYmyWaHy2kBIWGx5gwYsMiuE6Mrgq7KO0gP5FX0rhAYYAVF/2VC48Sa9ERMG1l+0pXVP00NPo2OwC1teeegvI+xiozCXLUzDXmerfVqJNqQqIUc6MAQabm/Edg8DZ9vnfMSbUKMovkajpmo/0WvhbrxA9UhR+w0HbUeTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702894; c=relaxed/simple;
	bh=dFhtZgD1piRpddfEMWF7eGzsbeBOObV4TBH7AssNP9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB4VQcKUaWaEnggRYWYvNSkKCTj60vdE0AaXv4ZjzV7S2VJL+2c9HoKwxMEIhf351yLcUH39prE44uwSGECV/6BVYNhdcdlKfLvdLp6h/hAyQL5JStJJz4zz+PZw6KrLU2UOj/5gWx/u269MeAiy9A3o+l3qyySZMuHeipSU2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KXGpWr4I; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KXGpWr4I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Du
	pWwdEkfpiGHlnzP82RzaheeaZpWsb+7g8CoR7iJik=; b=KXGpWr4I3iSh5CPS+R
	vsn44UVL2FTdyZEBhgbvzN5yzXhhlVcbenNICZaNu4hC4KYtIdP52/yjfXzuVQoQ
	JD/DxjRcLTjJgIdG3t9IBz7niCibKqLX9QjcbKjuDPDtkjb+653Fa6moLQXs6Yhg
	hRceY+GSvmPYlbtu/s9jjqJg0=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAXNgsJ7H5qkWIGPw--.60595S2;
	Fri, 14 Aug 2026 18:20:57 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangjn_dev@163.com,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Shouxin Sun <sunshx@chinatelecom.cn>
Subject: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Fri, 14 Aug 2026 18:20:52 +0800
Message-ID: <20260814102052.147408-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814084016.123741-1-zhangjn_dev@163.com>
References: <20260814084016.123741-1-zhangjn_dev@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXNgsJ7H5qkWIGPw--.60595S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWryxJw13JF4rKF18Wr4kZwb_yoW7Jry3pa
	s0k343Jw4rJry0kFWIy342gFyrKa18Ja17Kr1furWUJr43Jr4qqFy29FyjgF98GFZ3XrW0
	vF45ZF9Ivr4qqr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEveHDUUUUU=
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbCxQl3DWp+7AnMqwAA3g

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
v1 -> v2:
 - Fix a NULL pointer dereference in cgroup_pidlist_destroy_work_fn():
   use the cached owner pointer for mutex_unlock(), as ->owner may have
   been cleared concurrently by cgroup1_pidlist_destroy_all(). Spotted
   by Sashiko AI review.

v2 -> v3:
 - Use READ_ONCE()/WRITE_ONCE() for the ->owner field shared between
   cgroup1_pidlist_destroy_all() and cgroup_pidlist_destroy_work_fn() to
   prevent data races. Spotted by Sashiko AI review.
---
 kernel/cgroup/cgroup-v1.c | 53 ++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index a4337c9b5287..9abe8b791bb1 100644
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
+		WRITE_ONCE(l->owner, NULL);
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
+	owner = READ_ONCE(l->owner);
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
+		if (READ_ONCE(l->owner) == owner && !delayed_work_pending(dwork)) {
+			list_del(&l->links);
+			kvfree(l->list);
+			put_pid_ns(l->key.ns);
+			tofree = l;
+		}
 
-	mutex_unlock(&l->owner->pidlist_mutex);
+		mutex_unlock(&owner->pidlist_mutex);
+	}
 	kfree(tofree);
 }
 
-- 
2.43.0

