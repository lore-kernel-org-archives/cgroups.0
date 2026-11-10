Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311214;
	b=Je7zra2lDb5BY/jkgGLKv8Q/BMl/9U9XOjgHnBMXC/VKYLKf9Jmwxaevdo/1VjkE5MFk
	 WhrMpojfq2s/ZizxfYjTIsWq4NgCsTE9BjnTwf3sSk86NyphqM1uQ8kD2NAILrxV0TmzG
	 4aDvOC7FeVuf8EfWAWq3ENOAqo+Pi+furTltWaEndAUwEfeNU70hPx1n4DbOoVfPsdeVm
	 ww62pCP/DRz+ykOL4dZ9RQdzKJFexnlB5p5d6INt0uoGLEgMUTQRU1OTo76tI0vJWqVOg
	 7BrdTJfLE2KpYHR0JfPvT9KOXqJUQgsYIHUX5x9T3AvNG4ZQBcZdHPFxAWTJhamczQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311214;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=hFN8Efe0ZyMi3/7epxVojqOnqpr05jI2UzOY/RNMMn4=;
	b=EzFNDu0UxRzzfFsP1XugGybebC3nRaPbIbNLdVNtLyl3A5r5qFlxIavqq4T5BWFq1fAy
	 UcHpgv6rqv8qVIOpT/aIjFsa6GqV6Qm+M6qD/F+76Zdf/QDILTYWPvUMcINWKSkc2sWhi
	 5s5AXWNYz+dGL8IexmeFZ3I5oXIufjabN+CfQ7UQI16JNcK6+Ce6oNHWqGBEyw9rCatEe
	 KN2vJm61Pm1tZsTqQlP/WZQFVww2t5LalI510lxNwXtyGJoHM3zO9FLGv1qPZtW69TTOM
	 enWSvf18YIcu1MqAfNlBzpG3eJiM7IhBY82Jy4ttvQHpiI348s+68/lS9pW0ol7QvXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BjSRiFmh;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940F260A3806;
	Tue, 10 Nov 2026 11:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 940F260A3806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BjSRiFmh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=hFN8Efe0ZyMi3/7epxVojqOnqpr05jI2UzOY/RNMMn4=; b=BjSRiFmhygykO7PXhCPSjJ9BYr
	T8tNdiHctE/fNPWcPLjd/96AkqxNU6ReoCqcAO7sbaU8DlE9WymOB11O8N9ltLIDqetVFLsMvVRWl
	/4agiD2KKw36XY6BXaGsmTEezUhDhyIk9dflXl9h7uK8PZFvqjZWoHgu9ZOaaWDpnVTLKJYrs12PT
	vlL52FevuAbhRP5U4b6L2lw5U8l1kHRcbHmRDR/uv4KGKu/UcYE3KZ1MqZVxBE5cAIqIiEQ55lqtG
	mdUYvjy1r7lNZ/VchSEOoNxId+ozpg+nubxOud+ZFhfOFD/rCJyzR4V1UShY8nkm9xNqqpRpyTMH4
	boIRKo5Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJN-00CNSz-0D;
	Tue, 10 Nov 2026 11:46:49 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:28 -0800
Subject: [PATCH v2 2/4] writeback: name the bdi in the slow writeback
 report
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
Message-Id: <20261110-writeback_stall_report-v2-2-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
In-Reply-To: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5458; i=leitao@debian.org;
 h=from:subject:message-id; bh=PkvGbMkIVWW50tZgDleH6tDuM9JtcVvOQSQLHiupoRI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQY7Km2qT9G5oWqhkGeOJ0iet/oqcMqKB3GX
 tSt3uEcCieJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bZliEACaCQoV3P5pNnXcAk7Vk2hH6lUDDtyHOB0Bdofa8Dpd6zWsB8fL/SYkymfLlRxkY7oKlhy
 Rcd3SQt12Pz83HF7mzkwGab1hfB87Cc5w3fuCSmB2QEhU3dKlfZTq6D9ie3hvlQtkK0N3aDjS2b
 wZaHfaoR41JWYQY1ZJOKuOxv2EQCME39EZNeUQLzRs2kDGK7yBlZ7tbMwhlgM28o/VV52+W8mGX
 SD3UUnu8zCRZ7UfNztfeBImsjYKeLP6FQzNelczWbf/uiaI0vdxlMHOaMOXG/9yZm5F7tI0giv1
 xMIqql/+Y3GkVgLfFcmNqieMaHXP7pAnNZ6849B7KrkoceRLFsrpLw3LN+fy/UUl+BQgBnlHPhs
 2qyfNToSAJDzQ4+0h24z0AxqO6PoEXS1UPPyB0RJnCqNBemvWw/7ukgP0Asr3CnnDGIEAuesBRV
 bmMou6FWfM1pYYWWJrWMkESt8dW1qO68qqBkRV5uV+0QfqYQxTxARb3lhhwu4tkzD+bq9U+eOqM
 FCb5wi70O4UViaTzTsXDRmepTSsPfzdSvmpw/1vCHsyeLMChOFtBDKHVmKeFbQ1XRD7kmNYm2d6
 C/6LS5wKGKfpsymIUs4vQ2BkMZ2yubK4FOdRgcKSGC8x7zv+XCkKedjzE9k71uLLuHc5RLEbejh
 fjc0DeDMxvct4wQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The slow writeback report names the waiting task and how long it has
waited, but not what it is waiting on. On a machine with several
filesystems there is no way to tell which device is slow.

Pass the bdi to wb_wait_for_completion() and add its name to the
report, together with the number of work items still outstanding. A
sync issues one work item per cgroup wb with dirty inodes, so the count
also shows whether a single cgroup is holding up the others.

wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
("writeback: Generalize and expose wb_completion") made it usable for
the memcg foreign flushes. memcg tracks those by bdi id only and passes
NULL, which bdi_dev_name() prints as "(unknown)".

A sync of files dirtied from two cgroups, on a throttled null_blk
device, now reports:

  [   10.043698] INFO: The task sync:276 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c           | 20 ++++++++++++--------
 include/linux/backing-dev.h |  3 ++-
 mm/memcontrol.c             |  2 +-
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 01a00d7542b371..c5e9e5c0d506a9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -196,7 +196,8 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	spin_unlock_irq(&wb->work_lock);
 }
 
-static bool wb_wait_for_completion_cb(struct wb_completion *done)
+static bool wb_wait_for_completion_cb(struct wb_completion *done,
+				      struct backing_dev_info *bdi)
 {
 	unsigned long timeout = sysctl_hung_task_timeout_secs;
 	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
@@ -204,8 +205,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
 	done->progress_stamp = jiffies;
 	if (timeout && (waited_secs > timeout))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
-			"completion for more than %lu seconds.\n",
-			current->comm, current->pid, waited_secs);
+			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
+			current->comm, current->pid, waited_secs,
+			bdi_dev_name(bdi), atomic_read(&done->cnt));
 
 	return !atomic_read(&done->cnt);
 }
@@ -213,6 +215,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
 /**
  * wb_wait_for_completion - wait for completion of bdi_writeback_works
  * @done: target wb_completion
+ * @bdi: bdi work items were issued to, NULL for the memcg foreign flushes
  *
  * Wait for one or more work items issued to @bdi with their ->done field
  * set to @done, which should have been initialized with
@@ -220,11 +223,12 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
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
@@ -1164,7 +1168,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		last_wb = wb;
 
 		rcu_read_unlock();
-		wb_wait_for_completion(&fallback_work_done);
+		wb_wait_for_completion(&fallback_work_done, bdi);
 		goto restart;
 	}
 	rcu_read_unlock();
@@ -2972,7 +2976,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
-	wb_wait_for_completion(&done);
+	wb_wait_for_completion(&done, bdi);
 }
 
 /**
@@ -3069,7 +3073,7 @@ void sync_inodes_sb(struct super_block *sb)
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

