Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5A2376A06
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 02:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377838; cv=none; b=swe2E8S3mUeZqmqfR4BdTHo1JimkxKZUCl2WNLBjiz4JKyPglQT+51+uZ5NPZjv6AA62OAmw6e/9D60sV7qDQ1sZ+mJ6giZBzWNpE3ycTJD+B5rdmsXQxYY/Q6ND/r0RY37MU5QIWKCwGLuDgYDIDyy0bTu7CT4+ONUjQ6HhrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377838; c=relaxed/simple;
	bh=coS1tSO1PH7P7MGA5JhrzcXmMaJf97nd03fPtvUFa2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duqDA39PtWdgs3P0uiP+9Cz8U0VLReJYEUHnKZpZb+jXoW8TxNxrw/Or7PGcLHGKWFQKscHsVoYXmjQV+ym65AotB179Y2CRnqxg9rSEuY5fSnNVPGJrBNelVoH1pAIQz3OlQdE/++N3iWvJljwYcb0vgulo0wPxewDMid5kfMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YLSYnbPM; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLSYnbPM"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e252fbb7bso145103b3a.2
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 19:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377826; x=1785982626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=YLSYnbPMUvL4AVV1G0Bcq+17Lq5QlL8WHaaZBMo9lFgFXdJqXj4LuvnLd2JvLvdvsJ
         48cu1eYSJtluvtDZJdkzB3CZLeQF4g9UO1kgyzaMtyUruxIsaxUq1I3q/Qd7pAcZb8Td
         bXHsxY3eEW/vXY6EJbpNLvQ4FQo2r0wdvHzVVgcoUMfsW+2UTZwSYaAN3LQQj26CBGeL
         2d2X67Xcpzu8oXYKDl5CVuzhEnLG5BLde7W0nBfSadplbV3pZXXZJVkeDw5tlkndTap+
         QoJaADKJ6isrHBAXLqdalXpXBcUNBiW/sqYrLG2HKs8h9pSZ64HCCbmrlLJ7/fRH2lYJ
         Frzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377826; x=1785982626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=lirhk6qV7NkY3l+kbmpLP4DYNmvviqt+2cm6b2uzVQ823WpPsrc0uFHZCSbkotnAjq
         rfq8bI7/8k1nbG74VxWjCQWD/p84plJ960FjflkEcR89uqirQTAnFBtoX9RIifsU7Cvm
         O1VCAKqd1/WODoxYlfFjJ8LASgxRwPxSsVVIawcrF0JLoc9nzwTmLT8AknWRnJ0ZX1df
         Vug70CqDvybXlOXJgT5J+MZW9gSzGzB/m/9HkvepQFZAlc5LnKB5DQuNw6GGMGIQNq/R
         iqWNotZ/1rBrzshILz1P6OK4J0uBHqrWzxYzL4yRRnKyIjZoZ33jon2cOe+gnV7abQgm
         UN+g==
X-Forwarded-Encrypted: i=1; AHgh+RooW0meWfZhhk1hhLDBECsrGmYLdWN9T5/iuLCEHdN4OdHWFFd1kYNyJhvgEWYmN551rb453kXY@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6eOjSVZTZCN5YAeDu3LjOfD/0pVkfMh0s0EXz56yxH8OBsAhk
	KMpEcUuqtbTK6/O9rJ0B53hnbepCoSqqG7d9NZfgvnS3HGsZXXxhWogt
X-Gm-Gg: AR+sD11qAjhkrgjluJV2OmbiNZqmRLzi1U+qD4NJUsWv3xsRbFqqfiU0gu8tomshmq8
	Wict8EPI1lBbW0D9uOhC8L/FAjiCtOR4N8cLcIOuQ8jpqQwNN26+X0ygA9iuoq1qz2GWU++Ok+P
	l7t+69qhgKKUPQ0qA1n73Gd3N9C4g/NxanYNfz1KmhSAWCZILh0pA9J8YYst1SwGwSAjsofaOj0
	gyWDsXqzM6NVRXJXi6hSJCBTXpJ5/pn1AC6rbBizov72ZqmB9c4hA81mrnY4diLwUWU/NmZZJWZ
	An9adfs7l0mcSXWTnzlqE7WTqKcoC+k9jVkEaYgWanBAvlYKs5xiSnVG1zmHWTdWIpUkYK7lqJy
	dYVWbMdwzf5IxIj9ZHNvo4dhZHusK1htcZ+daqFOenTx5uu6f4FOs5MP5gSDCZMjLL2TwV0UT4/
	zdJF42G27SAB83hlNJuFQj7f2qzcX6AI18+D/6vnF3qkmeIvwfj1HWy3RkKLZl0uYSQviNGl5+e
	3+p7O/elaFXh2POFUpYJqZy6gQ7jJ/U85+r1VNETiwYp1gYH461
X-Received: by 2002:a05:6a00:188d:b0:847:9b61:375d with SMTP id d2e1a72fcca58-84ebc3f9d24mr1072794b3a.3.1785377825889;
        Wed, 29 Jul 2026 19:17:05 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:05 -0700 (PDT)
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
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 1/4] mm: add page_counter_margin()
Date: Thu, 30 Jul 2026 10:16:27 +0800
Message-ID: <20260730021630.2235914-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
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

