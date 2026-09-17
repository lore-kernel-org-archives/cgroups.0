Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7434457C5
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 06:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789628297; cv=none; b=mUTdMUYwb0ow3lkJWOdwsiAEBGTuX9c7R/I55Drr4us3Q7Bx3cwNElw7ErPnJ85Bx1obfs2o2xG+41+uuz6FiMhS78sLW5ZDyOsW/OUfrMT58YqYDZrrBKZVjO4a8esO5zyO3YZZOovkKZtUnRv3Eq8ye2mAiDPyu9zyivJa5OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789628297; c=relaxed/simple;
	bh=mavxj8Ed+X9L0RNO9bApjFiE/TIWG8+FWgXsB+xZV+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iq9TIl5gTU+lXtdm9VKriGwjq3Ovk/STmcjWV+LLjXNijeSpkwbBK1HPX0JB2r1Eodg4ZHgKcxu+3B4VdpTb8E7asGU6kyeUbG4freoZVNWpcJ5JtDBp/n1U2xexiIZjzQjwIqLpSt4A2lMozK9dV7gcF+HR85VKkdlIuxxVF44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=WCOanMW3; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="WCOanMW3"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d249c6so422448b3a.1
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 23:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628294; x=1790233094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
        b=WCOanMW3QsB7z8oi6HqRlAFXNsKuJowZo72q9vmHM6wQr3FH+ibUwcRBQ9qU0ACgnz
         cuLbDTJg6NGmueuKVrHEDeTxnQHiDXvt00HslqS2a46EcsoMdZqvmRx72wQY3a5tfXdn
         ZpSHr4Tk03ANJ7esfcog/ckorLWCNC+hEbxbD6+twlz973fZIxyEybUrACOdTPyIKqxR
         7mG84lCzC6SbPrdUsEKG4ymfuE249XHyFQF7EJ9XconUwc0/xnhYoNbSPSCLPY/anfPW
         p8hJnQgEZWVpectO6xqGB9UZmAjSMVkNNPuPkFOateonT3eCBbCpxOZygBP/A9MVTR+D
         gbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628294; x=1790233094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d1V3VqzoDektllB8P7/EET50iFOSf0nM57ENcu/U5Xw=;
        b=SF8dwLphWoYbGdL7s9njy2+/g0Bt9xIwidvs7LD0fMvG+0jOEQuO2LUVRLfXnlUDvt
         nSx2AUK8cVEui0ORdTGkg3XLGP2I5Y6+T/MAqpQyLV8EVYH5nsiDtaqTdZ+CiBQqVJ3W
         Mpz3u8W6KicdTcamiLtCQb6yfdo6eJAGI9S8roMty1oNz33Xd+P8yvVGXjj8nOcJxv6T
         8H0WNNjv+TApvwmLZthC0LmPE4ojvBwZLba+Ze6+IbZ1LZ2g7THeF9Ub5OhDmWlkCRFv
         XcwEx/Hy5Y+wg8bW42I7xRjIP9ZnkPQHFodapPtl923jnx2M5YXZQ6W7rNe2s5iS6IU/
         EGzA==
X-Forwarded-Encrypted: i=1; AKwUvBzeolELuUJUMxSqc37U9M7IeAxCOiaMr9PaNR2ganX4DeRoA5uQ5s/2OJB9iSlLDd5o8d7SyJFY@vger.kernel.org
X-Gm-Message-State: AFuF++n/LsXk6dn8kzIYvxRc+d9cJRkINlfSURI1Nc/j+mAL+slYSbFt
	E7r7yrGkLUV6SB9KiR9Bv15Q1ee/oub3qDeu8vjgdkx2sal4Z0reCYy3v8PsO/cUrks=
X-Gm-Gg: AYBFou1djdiM0OfPVplIIgvBApzlpchVy9gAfZZR7GFBLoUxOl7pw9k7MwG6ITzICMV
	RFi4Qg2VpV8OVXskvlEh0/K4d5VIu4yFdbwsd0DkOxjOv3/LlLIeanP4Nu4KLvbUImroC/3kGF6
	cG7A5WKVT5o9NLZH56WXaLwdKEsjKBqbOsVAf3OKpJch6tlgdeWiNONdnQti/5YHaj5aq2Szrro
	+ZOc69faIURUMaMxGIh2cO51rksN29a5m0io7qvC1oxU/Cyqf4q6kYmXzTjJJcqj4NYXQRLfci4
	lktTEHEMpgoxUnhiZYsYxD3/o5LwFRc6UuRFigWwi0hSDroaOcadYoVA7x2GvHJVF6qPOIqYhsS
	I7vGveqqnuBxHPhYWCApgjVI85oGxLT6fqjW8aYHnvrg4zwAELRo4NasK1I16GZiApxgaWHdmn2
	3hRMA/wulJWbEKNovcbnUM2J5U+wTdLFzGlTYZDnfApEl5g6wQ376IaV1SD34SU97CqpbPubA4j
	HQ=
X-Received: by 2002:a05:6a00:244a:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-872369ec1c8mr11578319b3a.2.1789628294219;
        Wed, 16 Sep 2026 23:58:14 -0700 (PDT)
Received: from localhost ([106.38.226.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8720173842csm2311245b3a.41.2026.09.16.23.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 23:58:13 -0700 (PDT)
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
Subject: [PATCH v6 1/3] block: introduce bdev_flush_by_dev()
Date: Thu, 17 Sep 2026 14:57:57 +0800
Message-Id: <20260917065759.2643940-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
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
 block/bdev.c           | 24 ++++++++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..da1fc56926fd 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -264,6 +264,30 @@ int sync_blockdev_nowait(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
+/**
+ * bdev_flush_by_dev - attempt writeback of a block device's page cache
+ * @dev: target block device number
+ *
+ * Skip closed devices or devices whose open_mutex is busy.
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
+	/* Prevent the device from closing between the check and writeback. */
+	if (mutex_trylock(&bdev->bd_disk->open_mutex)) {
+		if (atomic_read(&bdev->bd_openers))
+			sync_blockdev_nowait(bdev);
+		mutex_unlock(&bdev->bd_disk->open_mutex);
+	}
+	blkdev_put_no_open(bdev);
+}
+
 /*
  * Write out and wait upon all the dirty data associated with a block
  * device via its mapping.  Does not take the superblock lock.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..7a5f3e2f17d6 100644
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
-- 
2.39.5

