Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAFB175A6C
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 12:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784291138; cv=none; b=jJNXmawACFEoGw0q3yvt8kEEYSlM57NAYy94n518x7N4opuvZce7YjXEnvAaLQSCSmnfBJRU5izhPIh6N8LgVRelJlgqNahXrchdqN7ZRG5SUhNA/wwr15s+oCginjgjNLwSHcP04WqG30hT+S5Vd29Wl4e1mQXseKv6YwnkXZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784291138; c=relaxed/simple;
	bh=nNPnbebxFqFvlbhtNKSssD58ich+0e+YV1xULpS8b9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwschKIkdQQQ4XN3wVT3IxzffLE0CPHEEerPlmiYHK8nePkC/Q3dDMvHHVuQRJW/hGcxzUESiE1PFiwEcPsY+TBzzLPoC8M8ng86d2+U1i46uTtnqtoQOiGyEhQEwb4VxO+atC6vnWrwKsZCpdcPIaNCohSiCkS+YWmwAcvWhI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlFN/P19; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlFN/P19"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ca6d9c91206so611100a12.2
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784291136; x=1784895936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A8FQitk+4ag8anobMv4zmmc0PaWJJPYKVTqkunfaASE=;
        b=nlFN/P193WjDPIHvCUq3bneqkOmfMATCFIASffNjFa/hGB4D9zWhxYbAAKPJRL2jyi
         aRdQw2Afs1m/cnrlgPf/lUCquvRIMSzIjzEIDEXeGPUidxD0VrqnXkRBdFpwkr2rONJK
         S5TyopjWZ8Bbyq+LsyyAr91i1jxoZmc4P6u/lEZUrWA2IoibjKWxvZ4N9XNig+w+qlFh
         dymcWBMkWeqZUqggtz2r271+o8wYFDC7oCxLnmnf0JeQHAZP9S51q2F9Hesjk0p5TTfA
         i5lMyKY/Rlpn37uUpbseSr63wgB5Obb8N2wcyFxJVFml30uQk2tUveIzG39IiHN5MQBB
         AyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784291136; x=1784895936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A8FQitk+4ag8anobMv4zmmc0PaWJJPYKVTqkunfaASE=;
        b=cWsoZS5xFxXvj5AZdkM2cRP1pIku3BkCqr+ReH3302jUby7GoHzEb9nYlEQkQ7EBhv
         wTgACXrUbqexq6CuI3D4oWXDHKuK9j/HfgSmJgalsyukb4PUQGLxCpUxsjLJ5s6B/J2W
         c6EpAQLSUVng8iMLJI0fkzQ5Xu8ZByeD+TjMMrhbeJRRs8Nx+jsjtYHYzba5/nrkmEew
         dMCLecWRUSCtXKQcDjcw8vaNBAuSPEhqOcMRT6fAR20CHbWbqe2wpizP2qUMNeYjgnpp
         3EVHSQwNHCvr6QYRuauMkXRcq4gAenG8dauam/wUxKAyZknvv01wIDR1alGXAQY8mJgU
         00OA==
X-Forwarded-Encrypted: i=1; AHgh+RoOcmUVp7jcFnvJmHlMSDHFcWTqr7bI+w1YiILi2QuBXmZ4Qv6cEgpDmsEjztIQb3dY4XBB9yy4@vger.kernel.org
X-Gm-Message-State: AOJu0YyIH5FPAFN0HUuVd73EEZ+nXaO+2Om2oZrxw7XkFDnqnQSauVVu
	MB4TTtsju+rYvz+kFaLIOs5Jqq9g/QBz3z7Tv6dOZA8gTTlS1y7LqOqA
X-Gm-Gg: AfdE7cmGUPik5NipUr6fiH171+1cjW2h7DdmQoaoJu4ALusPEDHnF58g2szJyEw1QQo
	VcjJC3XIENjJmcaUNoBu3TxC4E/Uxkfgshzx+kZ9zbHw5rAYJrf+hBVeGjY9NhEJ68jM6J4ZRBO
	7iFOw8dtPlamkVdWLJiok30/0ZrVqAsVs8oKh70b2/suTt7Le23xdAOPhPU/zoES0V+lF5Hrunb
	EmMW3X2EDvcjYGeRfQkhMUqMQVhXNtkk2OcNPYgQ62zDku+sl88x72nIc2r8Hj5zEKArDgV26iD
	eUsz+rMt83p/HQqVCrAwz/qENLqtNz1f1ALlSYFr+MpKrkI3r21cvoo0atpYrjUs6LDFxMZep/R
	FAyb2+G9fMGxFh8Xu6nfzhdqvRKPJtpkQbaL9eJ2ZK/a/0/BIffcaiRkGzQF2yUDusNmfQ3FODN
	Rctj+m7SVKs4T8m9wMq6OiBbPpGxAfzUTq/X0xxeoRJ98aReJGP/EpQkA=
X-Received: by 2002:a17:902:e889:b0:2ca:d9ec:3217 with SMTP id d9443c01a7336-2cf349c0b89mr20319995ad.7.1784291135912;
        Fri, 17 Jul 2026 05:25:35 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm9935955ad.56.2026.07.17.05.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 05:25:35 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v3 1/4] mm: add page_counter_margin()
Date: Fri, 17 Jul 2026 20:25:11 +0800
Message-ID: <20260717122514.51514-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
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
---
 include/linux/page_counter.h |  1 +
 mm/memcontrol.c              |  9 +++------
 mm/page_counter.c            | 17 +++++++++++++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

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
index 177732fef010..1e10f493d2a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5548,12 +5548,9 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
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
index 661e0f2a5127..7300dca90632 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -46,6 +46,23 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 }
 
+/**
+ * page_counter_margin - remaining usable space within hierarchical limits
+ * @counter: counter
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
-- 
2.47.3

