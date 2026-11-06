Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968079;
	b=hs5kE16lJ4QIiMpIpmkxgDGlGkjt9g1wjE8x64IF1/xjwwJEIiMu62e7BTthOAVhJIVG
	 HuoEfxNKhrcEPoHviMNtij3mHv4J+ii6UEu1RRST5082eo2896xSmYbMSI6NDXpXysxDp
	 VDIu5P+Shk3TWHCKlg+3i1lBNF3kUCTWdxKZrM0wrTP6/FBlVXZ0fFH9dai32z7fF8F6k
	 JSOuzIHYlEjB1ziCmEtxC9uKgJNJ/cuw7LXJRjwzYD/dMlIU0uZ5x7o+WYEXKeV8TzbFk
	 TdRZeORJuO4ROqtd9MMMpVTAPZ37Kg36QcKsNJi2ZVLtJ+q3/6ibvzjwi4T2f1weoSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968079;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=0K0z0yTceTksPqIamPM3k9tvhF76ci83nLwd5+1KHsQ=;
	b=I/SemGXNl/kwFO8c6SZoa1QCLnNPrai8okAAi8PwcSWtZLMMwXqFpptDNvXEp67oyDiD
	 AjCCgBcGJTznQozocWoPoksJHi2dgFJEHvJ9VyQf9TEY7myFA7m9DSqwlcnxqhewhAHk9
	 RP6NRcjIMUl1BiufRXwS8kH3vMjDp08abkmA2saeq/hODAeHSWpRsY4POwhhP6/osK8HE
	 IDcGFo/eUdyiOYXLpmLEJ3xg97ltR5b9gWP6ELGrab0NQeRr/lR6ddM4y+omixechI+T+
	 dqGxDo2ZNcBDe9BTTM1yPzR+XNnrxwkDYLiwcLowv/H8pPCfrvOvP0ok3Pt/vnYYHCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Lz18xgjT;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BA3606D801;
	Fri,  6 Nov 2026 12:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65BA3606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Lz18xgjT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=0K0z0yTceTksPqIamPM3k9tvhF76ci83nLwd5+1KHsQ=; b=Lz18xgjTW3Eh2aHokixjfUhLYn
	sHr5VrLzB26C2/gOGJRnkURgsccY/mjIAN2CRGMpBPifNXnD7Da24Z6fpRFePA+KA02Ns9/yLDcVF
	2MqcwCN3mgS6+JHkHJk7egJDedXHFVmyWe+sGGcyM7CArpvW8L23m5GNKuaT9J0hyO7RQU317YkE8
	1udLIzUOkygs6zXojidQRGE+46sK6b2s38FreI6PAxLSqx0RI0sxxnc3y1NjECNR6NUbGf3mx40cK
	ferojonEagaetim6BeonRxtuXJSTjPy3GwC35zYj7HXuun8orkM0iI6VGmo76edkVzilm5KjjtFpj
	xvYv6Rww==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2o-009HTw-0F;
	Fri, 06 Nov 2026 12:27:46 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:32 -0800
Subject: [PATCH 2/4] writeback: name the bdi in the slow writeback report
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-writeback_stall_report-v1-2-bf0c3b9023a5@debian.org>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
In-Reply-To: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Julian Sun <sunjunchao@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5387; i=leitao@debian.org;
 h=from:subject:message-id; bh=vGPPzg1eXn3iHlKOFVYXRKo9IwFuhJPYRhoA+zYRKhY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexJKO2ZNZa6uneAZzk/9PkGTt4+gcQMjO9d
 sjqxOz84Q2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 ba0mEACb2ydFMss9vayqjlC4o0sYYVPjf/oQTk01jLCDvdcx/IcMETO5xiJO8Uc6U3qXefvYCyT
 PoqH0YU+biQqdkC+avIMnMEE3Mav3MTIsbNvv/xgn/4dF316MQRfoEbY2rmMVr2/fPCQihc6gFt
 Ak7231toocCUeA0RaydMw90EaqDqOhSYtUb2GmFwtKRGTounUAkQ46DZzjCaPCOM5uhO8aUgCVR
 GXo9SQpomJqb91/20gJXd00YH73uYfk/DlRD7CW0xUb8QW6CpyXOE8wZToWnzHSuCOf07AULN11
 9SrT5RXEBJ/mi9O7LqSgiTj2gx3ZLViw1r6yoQcZI26VjrtqJZI/kKRGlr+1yzv8UuiHRrxVoHN
 F2g+kX8HNGRP+Y28e8sN1ktjICQ1Ww+x4bIE//mYdSsVOg9A8qB+Bb4EnkZIrwyruP3gUXVp/qF
 F7hlcqSnzNfLJgVlfWhVRMdiLhlvx9b3cwRa2KLq0wXZnk1nazMkgnquobNVVgDpKWifmnnMKIZ
 wgHTd/OoQZt9g+YoD1W1I9pFWt3iuCzS2MAg8/DW8W7yCkt6vHO77wPZcWT3tZNWH+4k9XkpoKV
 jzR2dwJQMudeDpBjMXz9ZNoUMZnOB75a0QG/8oIPVFAzOvTSBVY9UwQkbdw5HhdNQRRmADcyuRT
 qlhip55y+TPZnXg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The slow writeback report names the waiting task and how long it has
waited, but not what it is waiting on. On a machine with several
filesystems there is no way to tell which device is slow.

Pass the bdi to wb_wait_for_completion() and print its name on a second
line, together with the number of work items still outstanding. A sync
issues one work item per cgroup wb with dirty inodes, so the count also
shows whether a single cgroup is holding up the others.

wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
("writeback: Generalize and expose wb_completion") made it usable for
the memcg foreign flushes. memcg tracks those by bdi id only and passes
NULL, which bdi_dev_name() prints as "(unknown)".

The first line does not change, so anything matching on it keeps
working. A sync on a throttled null_blk device now reports:

  INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
        bdi 252:0, work items left: 1

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c           | 20 +++++++++++++-------
 include/linux/backing-dev.h |  3 ++-
 mm/memcontrol.c             |  2 +-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 01a00d7542b371..3dee9d65eaf721 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -196,16 +196,20 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	spin_unlock_irq(&wb->work_lock);
 }
 
-static bool wb_wait_for_completion_cb(struct wb_completion *done)
+static bool wb_wait_for_completion_cb(struct wb_completion *done,
+				      struct backing_dev_info *bdi)
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
 
 	done->progress_stamp = jiffies;
-	if (timeout && (waited_secs > timeout))
+	if (timeout && (waited_secs > timeout)) {
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
 			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
+		pr_info("      bdi %s, work items left: %d\n",
+			bdi_dev_name(bdi), atomic_read(&done->cnt));
+	}
 
 	return !atomic_read(&done->cnt);
 }
@@ -213,6 +217,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
 /**
  * wb_wait_for_completion - wait for completion of bdi_writeback_works
  * @done: target wb_completion
+ * @bdi: bdi work items were issued to, NULL for the memcg foreign flushes
  *
  * Wait for one or more work items issued to @bdi with their ->done field
  * set to @done, which should have been initialized with
@@ -220,11 +225,12 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
  * are completed.  Work items which are waited upon aren't freed
  * automatically on completion.
  */
-void wb_wait_for_completion(struct wb_completion *done)
+void wb_wait_for_completion(struct wb_completion *done,
+			    struct backing_dev_info *bdi)
 {
 	done->wait_start = jiffies;
 	atomic_dec(&done->cnt);		/* put down the initial count */
-	wait_event(*done->waitq, wb_wait_for_completion_cb(done));
+	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -1164,7 +1170,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		last_wb = wb;
 
 		rcu_read_unlock();
-		wb_wait_for_completion(&fallback_work_done);
+		wb_wait_for_completion(&fallback_work_done, bdi);
 		goto restart;
 	}
 	rcu_read_unlock();
@@ -2972,7 +2978,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
-	wb_wait_for_completion(&done);
+	wb_wait_for_completion(&done, bdi);
 }
 
 /**
@@ -3069,7 +3075,7 @@ void sync_inodes_sb(struct super_block *sb)
 	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
 	bdi_down_write_wb_switch_rwsem(bdi);
 	bdi_split_work_to_wbs(bdi, &work, false);
-	wb_wait_for_completion(&done);
+	wb_wait_for_completion(&done, bdi);
 	bdi_up_write_wb_switch_rwsem(bdi);
 
 	wait_sb_inodes(sb);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c2284466e7aa66..808d939d2ca7f9 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -39,7 +39,8 @@ struct backing_dev_info *bdi_alloc(int node_id);
 void wb_start_background_writeback(struct bdi_writeback *wb);
 void wb_workfn(struct work_struct *work);
 
-void wb_wait_for_completion(struct wb_completion *done);
+void wb_wait_for_completion(struct wb_completion *done,
+			    struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a6d..df462d279a655e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4525,7 +4525,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+		wb_wait_for_completion(&memcg->cgwb_frn[i].done, NULL);
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);

-- 
2.53.0-Meta

