Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4043876CD
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607449; cv=none; b=fUR2hBp+IVdyGFzRpjA4OmXwWeAO3XzrZV943L8xILn2J1dWIXz2uLOAKwryI8YVx3sAw8bieLaR4OzktU7/p01e2bOs8ALXpnyDmLKh8/W0SBXJ1qSH72hQuu/hfxs67y2GMRNCv93DOJoZGvC9t6U/KZvMXF5iZCvl5ObdT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607449; c=relaxed/simple;
	bh=9IpPFSzcLdM/8SH0aciFnU7h9JSdrOn6A0jBLTwIgtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8lRCmmpjPU2doClU/oACjzHDn+M2bgAflFuoFcBNEhj9qq6NBFnGzwjxLEz+TsFh15fw8ontn9faO5ajVKvYh975FOBj3+mltxrGqxX6Syf3s7+tEwqiJEoLFWOS6AGrhUdFI4gEkl2mBXll+sDvw5IwngUx4R3kc+kqMinJt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+nBeRzt; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+nBeRzt"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf49dc28ccso3475145ad.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 00:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607443; x=1787212243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=d+nBeRztFbobsBkzQpXOmDm5LZMI974j84U0+OwWbqLy8HC+hQYj6kL6YqdztU8qgH
         353jmcWW6pUfUDGQvMSysMdWt1JhI6AHy4gblquQqFpKf9SHshD3GTNXKZ9s626hVobJ
         B2rZi1/unH53Gc5n1GTNzNW77zLueEVWVFuJ2Z50kW1pfK5J2K1tg9VREsbdVAoH1wbh
         oZWL6Ko5g0jQ4+ngn5PViHxHA1TOQmM0A/l2ZYZxJkQenXP10MrEHrUt8l5gx6NNmE/0
         rYvyAfKIISmzjwbWZG1naP1hcR6vPX2FBgcskCC2T9sY/wL65l0Ji+oY9p4ZDdbUV+rf
         RJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607443; x=1787212243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=UbJTTy3KYkXAS0kMqQ/nek1uF+dWAEC7sM0vGdJfp+HG3MQSi+er1EpzdKzAE5sq58
         OOoiEbebCEVaq+gwMJxQHZQJuEl5S/eNJB8fXwzlBwGJHH4c2m1dAr6F7LrdbMSsFNIg
         HQaICYRXhvZcRLeYDsH00IvhP+MePGUgAFjhU+kd2eEFH0o1sYc+OYOS22SJ/tr6lrS6
         Hvg+2JxMXiBdl4gNrE4DZHraC8WZywDGmDaByr+b2H/cZTggvAgH8DcjXovDnP9spaod
         Yc05obVRqmtJ1UyGEuMjKAR22guEsoHJw6BaVZtjqf9DFiRo9L/LDhQrJBD2O8VQxqfv
         8Kbw==
X-Forwarded-Encrypted: i=1; AHgh+RpDz2E6uGGUeMVTELOuNQd8X6vvfzFuu4yv3jL4dQ1Mlv/eGK4Sj2UNcdPIpLpMie5bOBwltsqx@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/+GmtAKplgUrh3ucqTFfTP7FYsgiPuGD/WDkeKNfDoDhlvVkL
	klEkdq0GH7vWzVmkbKn1d09B4zy3qIUcgzU4duHiznQ35htHg5Yr52v8
X-Gm-Gg: AR+sD11bIbO6hgLNsWzzLj+l/TQHz+3elqrvTY1OufxYEXC0i0a6hys67bW2z9xP3pp
	qZMfgF4K1EGwuattRc0xdAfW+8j4GRmP/RIv2MDYIirx4vU4ZYdTKZpKGnIealVQl/YiCB0r1mU
	+zGrMSi03s13isZNsr7Sux+UB91b+pkih/8eVpAhftxm2Ca84od8AP9euWhV+M0HBAMuV47OkMN
	RI/aOIx+ymvaLfa3yxLDbAtyQvht1vxs4rT3ALGPywCsKhkOSGVXLAMGZ/THUQW2SSUl3yz/DNa
	b9OpV5vjhiysfRSMLs/6jNgSWybz5DQgEauBi/7rWC3Kac+sOw1NTxUQuIEwnHe5AWnOlouXQBD
	57rd/VVM5t6hUIUd7J7lLpS36bX38SKIba4p5IQ+KBMDRS1ieOE/kUqTODNZDfORKKJudm/+95L
	VTXXAEXNXWKKUIssjtdVxr8M+AHdKZjup9d+bHgGLpCgP72kBqyFJzpCBjgzs8Lc+N95ibkgZXm
	zshlzUcWoi8dXDoFA8UViVINln3Mj0knYf3qMrqoIX6gzqpOrBNy/psj/V/JkX3Sn184sBHxV0w
	bgHVIjwsQ6fVgKma
X-Received: by 2002:a17:902:e5c4:b0:2ca:de3:15eb with SMTP id d9443c01a7336-2d388b7518fmr25969965ad.0.1786607442621;
        Thu, 13 Aug 2026 00:50:42 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:42 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 1/4] mm: add page_counter_margin()
Date: Thu, 13 Aug 2026 15:50:22 +0800
Message-ID: <20260813075025.1406585-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Weiner <hannes@cmpxchg.org>

mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
the memcg swap counter hierarchy.

Add page_counter_margin() to return the minimum usable space from a page
counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
is a pure refactoring with no intended behavior change.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/page_counter.h |  1 +
 mm/memcontrol.c              |  9 +++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..07b7cb12249c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -68,6 +68,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+long page_counter_margin(struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..109c08be91cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5670,12 +5670,9 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (mem_cgroup_disabled() || do_memsw_account())
-		return nr_swap_pages;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		nr_swap_pages = min_t(long, nr_swap_pages,
-				      READ_ONCE(memcg->swap.max) -
-				      page_counter_read(&memcg->swap));
+	if (!mem_cgroup_disabled() && !do_memsw_account())
+		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
+
 	return nr_swap_pages;
 }
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..450543f4b318 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -46,6 +46,26 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 }
 
+/**
+ * page_counter_margin - remaining usable space within hierarchical limits
+ * @counter: counter
+ *
+ * Return: The minimum value of max minus usage across @counter and all of
+ * its ancestors. The value may be negative during a concurrent charge.
+ */
+long page_counter_margin(struct page_counter *counter)
+{
+	long margin = PAGE_COUNTER_MAX;
+
+	do {
+		long m = READ_ONCE(counter->max) - page_counter_read(counter);
+
+		margin = min(margin, m);
+	} while ((counter = counter->parent));
+
+	return margin;
+}
+
 /**
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter

base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3

