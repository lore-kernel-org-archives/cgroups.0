Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB80493644
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992429; cv=none; b=YpuUVhQQPkAkGJWDWhw0Qma1GqLKC+ITIhk3an/L4zw9hp2Q5poiDRGYqtrbtVfyacqkpbKcUCXGl/aG9i1E3c/9S00VWlzq3MwX+cwO0IO2uYAIhR1zJSQhizW6vpJEkm4Pu6wksOCsk9jH9+K/kZvl5CFAGWOZPX9XpK9M9hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992429; c=relaxed/simple;
	bh=Lc9voE0hgiCsYr7Bd0maJaijHuhYngT7G2qBAu3lQ30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CrSBBfmC6BecffQm2C0clc2dxVc8IwQ0nL7EJDWVXpVJXow6buPmrqyg+oNg8qOPpk1fuyYsHiJ7+fRKeeE3OTEb7CLvL3dn/HYVf8/YlqRCyvApem6NArcevhzHIiOl5OSCJDdvw+tU8mF5Wv5gch7NcRZR2WEI0nSrLL8bhPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=d2Ra8aUm; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="d2Ra8aUm"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469e211a0so3141196b3a.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 05:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992427; x=1790597227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fYYfPRZ9YElxZosA1zWn6OE24o4j3HFVT3Jg17cOppw=;
        b=d2Ra8aUmesZ/+UvDFdW3tgT9d73JcodTig1oNzz0IQmknOzJMr7qPf7YPfFSHoxTsM
         Za1L+zkRc+WyyLJpyks2bdvUOXgJfScAcDFT7WNaL46UO3gPn0z0TCkF886jYqCxmU3G
         eePok3Pz93YUeZ+LrmvopKkYXWDm1ajufRgYksLetnDOgUdc8B0krJ4HuNTC8ekv3y/c
         /6Qc8OIIi+y2dpq7ntn49g1khz3CJ2pUONB3iToe00HX48KW78ITYUI0ldPRjCX9gUZS
         96KxIvlsWpKc2AiiUgVE0rYfU+IgQU8zQEgoQkEpR9JgQEbbWDeQzw6JB6zsx6Vldz3Y
         71Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992427; x=1790597227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fYYfPRZ9YElxZosA1zWn6OE24o4j3HFVT3Jg17cOppw=;
        b=ya1NyGGen73WdWEXpZfEnK44wu26p85oAaThdohJEEVBGvYur5ByFzBqS0jWS88YQx
         shW4yuioynjJTdSQMkR28NazJXBmEzNRxyG2Sv+oOGvWmIFDQLpDvj/bbPbm6SxAgFEa
         Pyh2rRxmwusrjAUfxEvBUHAPF+2igahuRWmgrkvtWxJvzf0+htP7nxUagmWGKbURPHtg
         9mLfM7liGeMVvGaUYuyh7ToMElRp7nAbQot3gRxfhhwL1msdKLN1LP5dYOFI3+pYwXJj
         VT0nvm/Hfl7mmHfQWhvWyx7clLBX3WVGdnISAe4txSCzNdvhAu9VGUOf2/rzkSkZKOnW
         JqmA==
X-Forwarded-Encrypted: i=1; AKwUvBwnMbYmnwDyJF7qWdK+AOR8i0ukiZCgoHtE3h4CRkVuP1fvBq8MSftpPodVY0H5V3GJARWZHF2l@vger.kernel.org
X-Gm-Message-State: AFuF++nlzVARA5cvbljil096CRDvw6Cg4OnV58J9T27CJ48c1nfc9WHD
	/uW2ypt0BzJ2zBoyJptRhfIcE00CvtFHeYUacsQfAd6BUyg4JJqnx90Qwn2hhncVrtQ=
X-Gm-Gg: AYBFou0uRj6tsB21Y75dP2UESbP+mrfXI3JbtqI4RKSx07kVAcjducZ7UL73/tdQow+
	XB42rFLPicw8EeNGB+21tvDBzlV8ta5CBqmcQ2/ebNEgj6ANgpsNcowZmv0k36jmCK8uln4k+gh
	AExM359lI4cvfL1gq6w6ZUfgJAXvppSzOidumVRfso1VOWUGIetLPo15K2AC5YaTvGbfJ2cDZJH
	G4VukL63E02VeEfDVlPCm3jZLBb0EIJyecdhfKeYwXBz594s+2I1Cx884SkKENemww+x7Nd1bF1
	STOE4IZrnvLqLxReYQH2iMzvAZpMQjpmlw37pSVcLttwXxO58a6CIVIWh9Rp2J4rQD7HSu9PEdm
	Sox9DXen8o506k+iIsY9jH1CViUrGhEgXEm9HTMRDLfC9QjTaPwqPcJ/g7MtkwodIc/mHRNPRJR
	viaiShaktZTReOomjpUihplft/+BlI/9EhSNsQrcy1LHOq0n+gs33j/uELxYJaHa89nB/AWSQb7
	ha08Asfxyf5
X-Received: by 2002:a05:6a00:44cb:b0:869:2b72:525d with SMTP id d2e1a72fcca58-874db7f1b4bmr15010249b3a.7.1789992426597;
        Mon, 21 Sep 2026 05:07:06 -0700 (PDT)
Received: from localhost ([106.38.226.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa11153dsm3186329b3a.51.2026.09.21.05.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:06 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v7 1/3] block: introduce bdev_flush_by_dev()
Date: Mon, 21 Sep 2026 20:06:56 +0800
Message-Id: <20260921120658.1627992-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921120658.1627992-1-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bdev_flush_by_dev() to submit page-cache writeback for a device
identified by dev_t without requiring callers to hold a persistent
device reference.

A subsequent patch will use this helper to flush foreign bdev mappings.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 block/bdev.c           | 18 ++++++++++++++++++
 include/linux/blkdev.h |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..5cbf01a13a33 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -264,6 +264,24 @@ int sync_blockdev_nowait(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
+/**
+ * bdev_flush_by_dev - attempt writeback of a block device's page cache
+ * @dev: target block device number
+ *
+ * May sleep while submitting writeback; does not wait for all I/O to complete.
+ */
+void bdev_flush_by_dev(dev_t dev)
+{
+	struct block_device *bdev;
+
+	bdev = blkdev_get_no_open(dev, false);
+	if (!bdev)
+		return;
+
+	sync_blockdev_nowait(bdev);
+	blkdev_put_no_open(bdev);
+}
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..27afe3ff6fb5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1710,6 +1710,7 @@ void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
+void bdev_flush_by_dev(dev_t dev);
 void sync_bdevs(bool wait);
 void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
 void printk_all_partitions(void);
@@ -1726,6 +1727,9 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
 {
 	return 0;
 }
+static inline void bdev_flush_by_dev(dev_t dev)
+{
+}
 static inline void sync_bdevs(bool wait)
 {
 }
-- 
2.39.5

