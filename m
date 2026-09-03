Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1F2440647
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 08:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424389; cv=none; b=KwgUwnLo6Z8J2X3JlTAfqIMdiKNN9X27+eTcziNjuUUrMVEk+vRoMgBqA0Cc0di7h9IJQfcxRu3d/rKxXhKdAAH+skr1iLoqH7FNLXddmst183VRImSBlbCMqk5AGFTSBBTOWKhJSxhMpbtlT9PuqL/6cdX0JalZ6peYYfPpHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424389; c=relaxed/simple;
	bh=7w/b7B7kFuxlXwOkqCyvvlyEYDg8ezW5ErFjW6OK1Cc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pGdVKyk9APSVk70OTBKnmz/zYf5rsIe/+pQLmicvrqZd0eJnyUqxCHnlUePw9lM6TvZ7c0ZJKlQQ7ktw2u+umrvmbaoByljIA1WlspG4I0EIf0rBVTZJBB0iO9qJ/+wiE6merBGQnhyyBeiuo4WcVqGrOydAcJ9pA9NZHCw2G/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=iR4tu4Zp; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="iR4tu4Zp"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc147d86bebso830716a12.0
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 01:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788424387; x=1789029187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BaXToYLkp4W1X8Rn05QhvduOjOn9yVBdgHfyyN+fIII=;
        b=iR4tu4ZpJNGmh2xb5OngXUqAXxfr9RCWrRzSHPjSgycIz+EJqy4ZjM0O+0UFfEhTF/
         Jz6lSS9pF4MH9V76GbUYg9UT8FYPryKc5XdI34BiK7bderI4JsABltx15DmAQG2f5V7I
         qaAmAm0clqBQdt3DV6paOjTtOmv5tZJ6uvbDrIPTGKlrpnUcE/uXdW6R3+c82ZUbKBNA
         IDAWZOjZDpb8HL5usLsFvIajzMP88KC1O0K4dTnBMy+pCNEWlF+sx5YxDWk3hvvnCDuR
         SSusnp4xuF1SA5fdX8cuUzjfNc2DJQuKCSSGbg8b4Req2UcRfQyD2ofm3f2TXI3X7KYg
         S/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788424387; x=1789029187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BaXToYLkp4W1X8Rn05QhvduOjOn9yVBdgHfyyN+fIII=;
        b=VX2b2tZLSIZp8bw3EMXTGDUiDMHuaGm7tf26ngGs1VXCMK8EUSEiFYPQabvF+9nd0u
         eNenh/EyDOkUB/jHEAIIM6GAuiQUHhd8fTznWu05oLS2S79jBoRlClhQoJBrhyCwYGNL
         4WbgbzznhbpLhJPo9tGFe/nPmKNay0ci8+MrhOcfoKwG4dyg+P9e/7tLNCSD+7Q9EI5i
         vkWb9dPapkQaK0wySn0qrO8ivEC9TVeDAGjWrM9C06GgroKjo33sJ1rk7filXsTr+esj
         X8UlKwaBxL2lATalVXhZZQdH4cjnieupwuhqPIYZtSQi67T1uheLUe+W1dnl3YUXioFb
         Cn6w==
X-Forwarded-Encrypted: i=1; AKwUvByrTU9A5jybY2lrmjaaxj1pNVyerUSL6iqkezKtC8V2EQGDlwRn5f8hjFSv6t3k2+GRBgh9aozZ@vger.kernel.org
X-Gm-Message-State: AFuF++k1fZacmTLWTYh1ko96+lWSz1VKP+mH7IBz8BYQ0snBk4+9zZWk
	Warun0sEjeNq0XbxC1PCzT5Yx1/zWzD39HiUVrPmnobydDqQuEL/HcgqPT4D0iafnI6VUlLkI5/
	MUPFb0t4=
X-Gm-Gg: AYBFou0VFkSYFJQVAFSNt2x5ZDV+AtOuIq0Rk58T9AC27k6wISSFEL73Uv42++9tdZe
	dKfNCVCVy3MoAYU0shly76X9E0ttlkHOC08hxBGqfVbSXH0EVW5Mi1pCinmWVc9hm1bwm1t2rz/
	xfxVyBf2WUA4AoOD7HanEKXhXXbmXf5f36wUgknN9ARteOduXuA9qIVkPly8POeQ40alE1dqIoO
	0GFyN8mG6EGwnA1F14+eC/LRYLO4yn2dtaGBLK3PU5iB2g4jrN61IUNN3wzLX5v8QNJ5rTVAxmk
	iHA4B17o9huVqzbMjeliZD1YB9ZW34jJGX3eqPZJB6YgfnsEFTiJtzHnVcF07fiFwy5VMjeuPQD
	4Hwx2cDMY0w/e48SY1YdmMN/TQXvokb2XtBdCZRzfvADqW2KsI0t2gU/+RNL2x8Mtwq/ErwY/Xx
	UglguWMhEbaFVLw55LVqBfiQnWBDvf+D+n5ouR1wEXFI30uHyvdFlBReoOTm+fdA==
X-Received: by 2002:a17:90a:d60e:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-39b131c0c34mr1941697a91.1.1788424386961;
        Thu, 03 Sep 2026 01:33:06 -0700 (PDT)
Received: from localhost ([106.38.226.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ce4221sm4590357a91.14.2026.09.03.01.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:33:06 -0700 (PDT)
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
Subject: [PATCH v2] writeback, memcg: skip foreign dirty tracking for bdev inodes
Date: Thu,  3 Sep 2026 16:33:03 +0800
Message-Id: <20260903083303.2769873-1-sunjunchao@bytedance.com>
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
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..6e8f7ff7d44a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	/*
+	 * Bdev inodes are usually shared by many memcgs so foreign
+	 * tracking leads to frequent flushes which is counterproductive.
+	 */
+	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
+		return;
 
 	trace_track_foreign_dirty(folio, wb);
 
-- 
2.39.5

