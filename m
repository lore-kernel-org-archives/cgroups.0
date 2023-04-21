From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 1/5] writeback: move wb_over_bg_thresh() call outside lock section
Date: Fri, 21 Apr 2023 17:40:16 +0000
Message-ID: <20230421174020.2994750-2-yosryahmed@google.com>
References: <20230421174020.2994750-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682098824; x=1684690824;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=abvwWBWOn0vLHIokwPNC/tHyu1Fa1R/g8ZqTWIaeK3o=;
        b=XiTBjh0uy9kBhESmjZrsmo27Fd2heaOUEeGy+wI7JgY+55BFi83KpJfUElFkBAdtm2
         /9Y+dOWIDQQOwVTZr/9l2zpPw4NhLuSad5LwurXNF9rM5PxMETajnAk6IdSR9itjleO5
         5RCZOU6uWoQn/XlBfG6L6Ut73QqfPkSzpxRKMZq9c5dNC03EQysfXGAmQsX7vQIaMlXI
         wrYrPEcgEz4/6R89vEXhItTLbmEid9U911aGVkkoSTQdm4KxH3ssyAravljY6M6dDyLy
         P40RfGznmXP1ykBLl7M1nQBK+thu7rJX9Fwoe+MatBRuu3PDwmPEoG+B+msi8iGqptyL
         Fwng==
In-Reply-To: <20230421174020.2994750-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>

wb_over_bg_thresh() calls mem_cgroup_wb_stats() which invokes an rstat
flush, which can be expensive on large systems. Currently,
wb_writeback() calls wb_over_bg_thresh() within a lock section, so we
have to do the rstat flush atomically. On systems with a lot of
cpus and/or cgroups, this can cause us to disable irqs for a long time,
potentially causing problems.

Move the call to wb_over_bg_thresh() outside the lock section in
preparation to make the rstat flush in mem_cgroup_wb_stats() non-atomic.
The list_empty(&wb->work_list) check should be okay outside the lock
section of wb->list_lock as it is protected by a separate lock
(wb->work_lock), and wb_over_bg_thresh() doesn't seem like it is
modifying any of wb->b_* lists the wb->list_lock is protecting.
Also, the loop seems to be already releasing and reacquring the
lock, so this refactoring looks safe.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1db3e3c24b43..11aa1652fb84 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2024,7 +2024,6 @@ static long wb_writeback(struct bdi_writeback *wb,
 	struct blk_plug plug;
=20
 	blk_start_plug(&plug);
-	spin_lock(&wb->list_lock);
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
@@ -2049,6 +2048,9 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (work->for_background && !wb_over_bg_thresh(wb))
 			break;
=20
+
+		spin_lock(&wb->list_lock);
+
 		/*
 		 * Kupdate and background works are special and we want to
 		 * include all inodes that need writing. Livelock avoidance is
@@ -2078,13 +2080,19 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (progress)
+		if (progress) {
+			spin_unlock(&wb->list_lock);
 			continue;
+		}
+
 		/*
 		 * No more inodes for IO, bail
 		 */
-		if (list_empty(&wb->b_more_io))
+		if (list_empty(&wb->b_more_io)) {
+			spin_unlock(&wb->list_lock);
 			break;
+		}
+
 		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise
@@ -2096,9 +2104,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		spin_unlock(&wb->list_lock);
 		/* This function drops i_lock... */
 		inode_sleep_on_writeback(inode);
-		spin_lock(&wb->list_lock);
 	}
-	spin_unlock(&wb->list_lock);
 	blk_finish_plug(&plug);
=20
 	return nr_pages - work->nr_pages;
--=20
2.40.0.634.g4ca3ef3211-goog

