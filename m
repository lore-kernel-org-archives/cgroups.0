From: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] blkcg: have bh disable for 32bit UP system reading 64bit stats
Date: Wed,  6 Nov 2013 19:14:44 +0800
Message-ID: <1383736484-393-1-git-send-email-zhiguohong@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=/nW8ZuLfGsEQfwb2NFT1+qkpdFwc4U4F6MrOCJCi7/4=;
        b=uSFjYAnMT1EYn14qGlRG9+RIk49m6Wh+zVk+LgqnNiBHLURfPxCAoIxwlkuzVqxq5S
         vYzI09dXjStHftQdMzvLksHKgBypHVKb7pjcoS6eF/YGYY7Z1vfOYUsiEvCaJvucW3y2
         1+NX4L+gtk+xvnRFUZr+DfwiVEs2+s9N9MjC+q5RLOQTGqvxAumLwLAAXeQycZUWa+/7
         qN7FkoHlCnX8iT6Dr6I2wD1zKNN6H4axjBs4i1GyZUGtXi/ULFH0vPtmxjltunkQ9oPt
         N9rAqjR2HFFn+hOshu74BvqyH+4v0RUYQdxUdA0XaxeMlwmfWYeizSGxCQadtKODTZ7b
         fFTw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Update of blkg_stat and blkg_rwstat may happen in bh context.
While u64_stats_fetch_retry is only preempt_disable on 32bit
UP system. This is not enough to avoid preemption by bh and
may read strange 64 bit value.

Signed-off-by: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-cgroup.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ae6969a..2e34c38 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -430,9 +430,9 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 	uint64_t v;
 
 	do {
-		start = u64_stats_fetch_begin(&stat->syncp);
+		start = u64_stats_fetch_begin_bh(&stat->syncp);
 		v = stat->cnt;
-	} while (u64_stats_fetch_retry(&stat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&stat->syncp, start));
 
 	return v;
 }
@@ -498,9 +498,9 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
 	struct blkg_rwstat tmp;
 
 	do {
-		start = u64_stats_fetch_begin(&rwstat->syncp);
+		start = u64_stats_fetch_begin_bh(&rwstat->syncp);
 		tmp = *rwstat;
-	} while (u64_stats_fetch_retry(&rwstat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&rwstat->syncp, start));
 
 	return tmp;
 }
-- 
1.8.1.2
