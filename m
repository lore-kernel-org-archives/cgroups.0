Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533A03D093C
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 13:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268240; cv=none; b=shwbqsvQQNu2oXTy0OLZ6rCdqRG+tjbt20JzLmHJqOKvaVtVDzAQF3WHBW/RrJlzukL133A6n86lLnwHMpf+6uk2SRtyUw1KzcQu2pWmDDJY7FXy/JRNldPS2p6Sn1rvoM4FoCPDLUUa3SuyLWOdFldLU5e08G0X5ZrVVNhwdLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268240; c=relaxed/simple;
	bh=2MjXv1e8wiIM/gEWm4yDQzgBCSwTd88L75rr88+13fs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O0TGXtBkzlmRPqKnF4uZqCgn/mVoU9CPfUV0zI5wB1HZ8ETD6vLI4zcuIznMzyUzcUBgamCTx675q2Y5thEMrLYtdnvbIi84J5F/eyA5ifftPg5EzpAeS9KsJQA3RINKsbFJx4LmBWIOdcWhER8vKIK6e/3ArjMK5MsXfkTfdks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JppEdgrB; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JppEdgrB"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-396750cfee6so3789072a91.2
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 06:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788268237; x=1788873037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CS6TAB/bDfKrIMRJ1Cd4TjasF33S/34CI8IaymPnMnA=;
        b=JppEdgrBzXCLZrvAy7buXrHiJt0AR2mIuWVg/X9Go0i9gO9v2hN1r7hg5T5feZ6Fy3
         NmYuv5tv7V2zx5FI/fDtEjOFjO3mNiUgASaP1iQBjGtzrBElquaUUZoIjPbXUijivgrD
         n4BedBEC4bVH7q6eRaVykSLWF5v52YtnTha/YBTi5RhQKMF0GXMdtDXQklKyVI/Jhr8H
         JYPzzXvZ8CbHeEhSRnlaXAvKGGyixLJZqp5Ln/UVK5sD6wWRm3Od15S4kXl33rB9aVBh
         bk0yqrPhcsMrr1xospnyDz5ug+W4sRTfAywSWE2zSljpEGVHgbTCiE6Hxl0PtPVWJgyZ
         OuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788268237; x=1788873037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CS6TAB/bDfKrIMRJ1Cd4TjasF33S/34CI8IaymPnMnA=;
        b=jsM5BnFDnsDTAJAybPwIQQa+B/FXD/TvnLfrhC9NbGtA90YrkWyo0NhBj8ifQt9xFn
         cDDxoyzHqrkuQu0K/O2SgkecHma1qU6XqbSOoHgpTglp6wio4UNarDWkZFrHWpqexk/m
         n9BNUlniY48v0s23kMh5Ul2YyVETw1K7HsxL5Quc+t/dmjntEFdIfRUYtWHsoFO+aLIE
         62utcENxNoQ7rmUBZQ7iA03I/i7axXxPbbO1GExTyph2HGhJONjDDqzKQWiHy00kbazU
         nPynpSflMYYoZKLhYjn6IbfCiUicWsc4iX0Fb8B+1iXuoTjMBmXlFF8umavtAIV6j3Mp
         cTYw==
X-Forwarded-Encrypted: i=1; AKwUvBwriMf8T6yMj9z9RkN4szbhXIYlbu68ABGchW38s1gKXiGI5y0LWBevtgoGQWfodAzl7N0/0t1N@vger.kernel.org
X-Gm-Message-State: AFuF++lNpcRO1B9dLVX8e2jWBVjEAQDxsCLp5QJYsNv/RTAhsRXSJfFK
	mUoUAmyp37qVBarDNWmovffe+jg8ZaNa2u+CH3F2QS0EvkE06GDF9UEaZiPoT4vlrUw=
X-Gm-Gg: AYBFou3UamcWQj+kdjxVO3u5y/LIjjw+sLvxWARmSeIrKEhs2hdcxpbX2UKAoHiO6BV
	sGX1dNV/fkSEt5GWUYEK25rGMkmh+/z3ew/4S4MQKBeROU08chbmVRqqxFlSrLBPQJ7MYE1fxdS
	xKY8JBTzPtjkc118btuGzxdrKDAidffH1Mi7NLdfQPJmftpH0ZQrIBvFqVfBgMpGuS/Ew2I1VB2
	wGzJi7XLFW8/ZX7Fd+i9kQjRtLRkrn/b7CknAK173nhLrC8amG/+2X8pyTL0IrK6+cjcyrqgOkh
	uWAMTZ3ylsnBkT95/K7WyX08HvalH983eGfWEsc97BaadkTER/o9j+jYvEkO3TFGL26gDO8YFox
	ytga/j9yXBuQQzriV3H/sOFzLmiN4d/7fkwWONkaNmy2kFE5ibaFyL/Ye5fpj9o3NX28/NJHGwF
	BzMnKjC3gKMkaPDDACnxyVgK8UtgjzDawcavGBy1+XXXKun8n5HMvcQqRH5ReA2y6Msw==
X-Received: by 2002:a17:90b:3c83:b0:398:9bd5:490b with SMTP id 98e67ed59e1d1-3989bd54c84mr38553882a91.18.1788268231587;
        Tue, 01 Sep 2026 06:10:31 -0700 (PDT)
Received: from localhost ([106.38.226.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bcf7ca7sm6520279a91.4.2026.09.01.06.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 06:10:31 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	tj@kernel.org,
	jack@suse.cz
Subject: [PATCH] writeback, memcg: skip foreign dirty tracking for bdev inodes
Date: Tue,  1 Sep 2026 21:10:28 +0800
Message-Id: <20260901131028.1120284-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Foreign dirty flushing handles cases where a dirtied folio's memcg and
the memcg owning its inode wb differ.

wbc_detach_inode() notes that "concurrent write sharing of an inode is
expected to be very rare". This expectation does not hold for bdev inodes.
A bdev inode and mapping are shared by buffered users of the block device,
while the inode has a single wb owner. On ext4, buffer-cache folios used
by metadata and journal I/O can therefore be charged to different memcgs
while sharing the same mapping. Normal bdev activity can thus produce
frequent folio/wb ownership mismatches.

This was reproduced on cgroup v2 with the memory and I/O controllers
enabled, using ext4 on a loop device. jbd2 repeatedly generated
track_foreign_dirty events for bdev folios charged to unrelated memcgs.
When one of those memcgs entered dirty throttling, the resulting record led
to a flush_foreign event and queued writeback with reason=foreign_flush for
the bdev inode's root wb.

Skip foreign dirty tracking when the folio mapping's host inode is on the
blockdev pseudo superblock. This prevents bdev-originated records from
triggering later foreign flushes.

The tradeoff is that dirty throttling in the folio's memcg no longer uses
bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
folios remain subject to normal writeback. This is preferable because a
single bdev wb owner does not identify which cgroup is responsible for a
mapping shared by buffered bdev users. Flushing it can write back data
unrelated to the throttled memcg. Dirty accounting, normal writeback, and
foreign dirty tracking for non-bdev inodes remain unchanged.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..5d7320f76c06 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3898,6 +3898,11 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
+		return;
 
 	trace_track_foreign_dirty(folio, wb);
 
-- 
2.39.5

