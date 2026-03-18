Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7925839657D
	for <cgroups@vger.kernel.org>; Wed, 18 Mar 2026 22:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773873025; cv=none; b=tC01h+fALgqDOs3a8S1zC1jICNyLvOHvkPLF3tLlFTV9Y3FUgm6A6MIMpP0HJcX7hL1A+9lcNqPjAf4y1bmN66A6SpqNwEpV5LyZw/CM3sstaEHTXR+wMAl0P5Vhsgk83i5qiX8NNxxikqzTwFcW57BY/x+QVKekhOclwsrRb0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773873025; c=relaxed/simple;
	bh=XUG2nMpJeoG6B9ljhBEIzGZmx65mAIf5essHdmFCXwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbM7mQcOpJjZTzP0qQs3pkXvEgfhkY+bD9XkMr2up1GyU3WVpQwAk9Y5plH/Wi9tydlyWvnFC6Z9TMS0LTP9qT81JW1FAcLeu8aPvk7/vQk2Tv1ipMqKfp0pfT12cryrEZXKDaI4UusotyFSnXqQry4E3YXL4G2/X9AOP3NSbkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1FK5mud; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1FK5mud"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67bc1b08afdso15278eaf.1
        for <cgroups@vger.kernel.org>; Wed, 18 Mar 2026 15:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873019; x=1774477819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
        b=N1FK5mudQcE3fXighw0xP7NsaVdH4YqhKiHyb7kJO8zob8omU4FgxwVL6E6VFzwLyW
         HdIf4S66cUz1KHWEKh3R2k4mB5fP4wh/RRmQaundb2vgUHxzASh6kZvW+RfZP0UaEyZf
         a4pG1ndpONim1Cvzfv0zY4qf7DLodxDAliP42orDJRgBk77mOhga4Q70rV05epfM7O3g
         yh+brGbHN8nV3/gVsPQfKgslFToDdmvm1+f6PwrpYyoefADU35i6hPAEqr/kPWGQBlW8
         aBdRaj3ZBIAcyVDrmhJURbc3ZJEXC0jRwQ9DYfFXgaDx1SWNTnxBdrV1Jb3Y+zdyvtgo
         EqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873019; x=1774477819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
        b=MzjRvuYcK5ticrrAt9T7SNMJ+3DFl1roySNkxtjsdprZkQJJy7Xj184mPApVzaxwoL
         bN6FYGmxPM7/oOrnTkipcnD0bp1o/VgHK1vwHmbPvrV31FDncR6dmBhItwu7zFVSTSZU
         MyDGybq2+MwaMXfyb8GfopYt2xHGMU8LlWYXILG4pHf1ly204CNrljCi4vFo5On5rx96
         UXy9CRmNn6AK/py4HZAoGNr7JpHKQxPxSQtnUnvH1EFGcTvH1BpBnJJ/b4Y5z0p64VPZ
         0XKDeuexZ3uK0W7kHqkUcNEb/7Ei/7te8f7apnu4yz8Q+l1NfGapuBSGNRGR2xHd7QvD
         lxoA==
X-Forwarded-Encrypted: i=1; AJvYcCXlAx7rIivo2ZvRWXRnb+YPMPI2VdY8j1xq3lYWnGvkcPVS+ks0sB9ZvGQT3sSkY8mVxXe+CwSt@vger.kernel.org
X-Gm-Message-State: AOJu0YxZgctKrhDGhbmPlupbYqMH0dDCWArS1xrWg38YVHwJT4b8Ek0+
	KThgeDzu8ZwxR4xuq2ZOI8pT/RmfO0oiyUoCLiWYImD7p3BIaYB5tJtk
X-Gm-Gg: ATEYQzzA6C2xZKGV3WD93zBuxbAOGTOjnWnc/e9H59s24eWMTLi8ULI5gm4ffy3HuyD
	b5d6woXVl6lov4o66epm1K7b56ZRoix9A42wwpC9IcBkxzP8vaVdXVpyHgtlDQJktBiTkfnq+fo
	0cFlGT9t9waolnlcHslunrVJ1XdLlDVXPNChz4XQ3t/4YuoTtZ9Vw4qrxz6EcT5dxXB9Yn8KTBP
	jYp51BzYRHN2pr3lhCMoKtRTMnqT4ljciFdAHQUuuzehEn+Fr/OWUPVBvxiKW3Y5ielQVSyGTsS
	KgC3ih3EZeGBC9+BeegojATxQmWvP6TPJxHLh7j1d/tYbHiU3fzQ6kGLk3JDC2yTXurDSg46o32
	eAwwu+d5aWNiuT8mtJnUR5YvfQq2QChiScwKFPDsCZmqMJFcY/KMfC3Glr8d20SmlTVBknia2q1
	5yaf12oflL/7yqPRZmZ31xxCWbAxMRqfkXtgBpMdtk79abJB4nUUnfyyc+
X-Received: by 2002:a05:6820:c89:b0:67b:ad6a:ac10 with SMTP id 006d021491bc7-67c0db1a703mr3715865eaf.50.1773873019226;
        Wed, 18 Mar 2026 15:30:19 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c0d88c5bbsm2544446eaf.10.2026.03.18.15.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:18 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 15/21] zswap: do not start zswap shrinker if there is no physical swap slots
Date: Wed, 18 Mar 2026 15:29:46 -0700
Message-ID: <20260318222953.441758-16-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When swap is virtualized, we no longer pre-allocate a slot on swapfile
for each zswap entry. Do not start the zswap shrinker if there is no
physical swap slots available.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index c5e1d252cb463..9d1822753d321 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1211,6 +1211,14 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	/*
+	 * When swap is virtualized, we do not have any swap slots on swapfile
+	 * preallocated for zswap objects. If there is no slot available, we
+	 * cannot writeback and should just bail out here.
+	 */
+	if (!get_nr_swap_pages())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
-- 
2.52.0

