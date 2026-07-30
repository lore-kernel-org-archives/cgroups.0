Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1E42642E
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 12:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414216; cv=none; b=IwrlahTjypuET7ursyf6j2ZJt4ofhZlVj7OZSsZsTRWhdwFQvXGuxEanhVFuoFXoDfKo912UPJwVO1x3mxdT/z1qEOLPyl24PJi/Nqwv1fWANDer3NDWTzTecZUX9J035wHzgFzjPGZGUkG88v5eNTHRfb/SwVv1he0FZ+GnRP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414216; c=relaxed/simple;
	bh=coS1tSO1PH7P7MGA5JhrzcXmMaJf97nd03fPtvUFa2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfhJpaHLSjGkFoSqPDdg2UaIZT778xhciz7GXj/SKEZaVgTrtyya6JDzUFIbWvNvRg4+xZXt0MdwdzrPSTdWDxFuse4ToHGA3KsU0Xkxv+GdC26ZERP18w4iMfoc4/LDozh+yGc06cGd0Jnk+ktLvUtMylPwRCvYG7ZSAn8Eql8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r1dqozf1; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r1dqozf1"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-384422b05b5so217113a91.2
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 05:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414214; x=1786019014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=r1dqozf1enR2qJiL+74aapH4v+7hGXL7wAzp1TA4VCslQ7pq3kfue3GOTBnmdS7khY
         AMZ1OXhwDYU7eksO+MQORgUjXUMrnX9UDNqhMrT9pGzkrYUs1Q7xaxg4IehSHo413TGF
         3wMkwozlneaP+O7ij8uIQKFtMxjGzRDLsxHOwZfzuQ21FPxknDdEcvMNjzkxhoESAnGx
         zK8LzRE5jgfvYPm0bhI2FERHdmvWNAPM967SM7QYh8ifmoaKZoNnlx62KfIWUvn6kT9n
         nRL5fHM7sFYojFcjcfn6EpTa3T0jyvXiznfg0t9p/p7Q3D7v7jCE8M23aEs3E0eCjjxi
         lRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414214; x=1786019014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=MpSOBVQW7Zfg3DTZ78hsGvj3sPO1g8VgEi3b5hfK33egOwEimdtw0d8rxcSEJkuil4
         Zi/gWwRfJf7uvHsI8Ge5Sv7BHgaEflBaKHQ7q5HI95zY49rjYf9Cmwe62G0lZ9HQPu10
         9F6idgFDhS9LWY8P6eh98RiE1vWaB8rIVdlsPGkKnEokHrLHRVjC1Od/RM5fYxjNpCIu
         C/DQs648xgW995dU6GT06fbArnYrctneSSar9NRFbvjVokMdSW3pRRbvETns0nxQrEnQ
         lsoAXF41CocidJwix1rU/GJkytNNvQNKjoQX/KydGEXmD1r1r9LFX7ajMcoo8YNGlrFx
         I1LA==
X-Forwarded-Encrypted: i=1; AHgh+RoLZKQzOUhSsEPwRswFvCA5+lGo+lJm59DcWHN9EqFNMm4/eK2Nu97I3Mzs33glrwK9CVlI4f86@vger.kernel.org
X-Gm-Message-State: AOJu0YyFGPuBK42iKb6pAM9AMt+5ep6ZdwzzMvBZX2aU+onO4mgGKqNk
	HhWXgDtBlTm/hIP4zm0dKSFog0RSFD9dR6ZxGcv/kvhnEvCnXmj69ayp
X-Gm-Gg: AR+sD11+cb/kOlxvB8tkWZW8JCE4/TDaeHs14r/mFzWfCaPnbBq8tAMAqniZvSrTO+U
	c4l9FJB1edG85hvTVGVS4CFXYAE7oRf22Oy0Yrw8ez5d526EQ0itMJR0WhXRzMcr+m/lVDZmeFX
	ujj43s4MpHFd0Rbu2r+gfinXq937Wzon+k7r6jBk8oGrK71nMurOUZe84zame6CIqchEx4bE34h
	aOfT7NMFFgyW1xRgm2oECVvIHVjPqObjwbVdPgU/7kwpN7ZZ+7GTcM6VMYJ+7EDhD2Nz5UeVScV
	hXbF0t41EJLbr+XIel7eXBynKuep+C3wsT8M301alo7wdZM8X2Mu8LpbCPQ8zzlJUkQ5c49UIqk
	/rupfET3RzDLf7x2v/rv8y4YyAilpN8Tp/0+QZsOa5Ywfs5Ru/JUanNQ+L0DIB/MF5Ja/6QskX3
	YlXZ9P6V+QktaMxDPQNrzH3TzKWLuRpy606vrUV/R4uc6uA3kqgfUyaXZrj94Uv+amUluy2aOUP
	cVGDNr5nXoSsldbNm7KtAbih2BVek/8jUyOv3yHoVemf7J6TRJ6gQ==
X-Received: by 2002:a17:90b:4c0b:b0:38e:6a7c:abbc with SMTP id 98e67ed59e1d1-38f9c036a34mr2474415a91.3.1785414213845;
        Thu, 30 Jul 2026 05:23:33 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:23:33 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 1/4] mm: add page_counter_margin()
Date: Thu, 30 Jul 2026 20:23:01 +0800
Message-ID: <20260730122304.2496440-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
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
-- 
2.47.3

