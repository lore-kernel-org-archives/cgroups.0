Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0A138D3E6
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782237731; cv=none; b=L8gcxIelXJVjRy12ebqysw5wpWgzvl9wgqY80lrXcjuw5D7sfrNVAEGdnSFmfy0ixtbohWIy5zAwQlKDuvQj+UX+q66TDcojNuBeduB0ZFVQhdUX+u7A3z4gBODgFX7RsLI0gRlemSw5HwdUFTfmc+2CQmHqD1A7soLFB5f+JzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782237731; c=relaxed/simple;
	bh=Jh+o5uMNVOhQ+P6EcPC3ygD+Ch1h+HVJp9Xn5lLIfd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXyD0BFTV3dx5YDNR0PC06QXPsIfRqJKN9qt3mRjqTds0m+FVJ0M5CwBMfPg9fCSwrYdCaukgBuwR0fqHUfHV1pIIStPmpVc37yOwhqgbLyCgF5C1W2KA09WFKtWInJk5HYLvwqooDJStkbB31KJkKcYBlfA3P279uN0hsvgYVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUgmPwA8; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUgmPwA8"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6a0ddedcd00so92375eaf.1
        for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 11:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237729; x=1782842529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trCYdPhQh348weekSBC7Ceo7XQeHFRdxOAyYAHYqFjo=;
        b=nUgmPwA88+PS/WBOjlCzs5+7HoE1jX0UpgOorJKU5uNM7pl5lH0O1nfok1xgS9eQzf
         bzJqOk+vGUHR6SlOx+xy8+YpOjbI5DWsylBOJSYWwKt2nEeYkbhAVvGkLarqu+wQi4X+
         ju/rzuIGuK09rp/10UxhWmMapPZ1uT5zu1qZV+/wPGSjbLXTCIPdy6xgRoy5051gpd51
         o1UERCh8XEr2H33h+1jd26raO97HOVWnnfyid5rfN26PO9OWE1HXUpd7PL8hRhAEFxaQ
         Wa0InS0RPXSo09d/2QgQfoYWWgkwOB+wqnEBxDTkGwcWRxPjCI1TSKojUKEHAJX5KBuA
         MzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237729; x=1782842529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=trCYdPhQh348weekSBC7Ceo7XQeHFRdxOAyYAHYqFjo=;
        b=D91AbFK2muZx0IdJwXndUu1/ICHA4k/NbIUd6IX4ekgRDFwweq8OjywrrlGPe45Y1l
         ZUrbDlI1i/2/yrN59omSHsBxaO3q5Hg21lHNPxbH0zxv2/DInJL3cxdvCrWA0BxLZwqK
         lr5Azgy0ZmiaBPq3jCZIuTcJTk6hEkiVPXxzEwee9qNxVAa809ObmoH6tZ6b59j31VPs
         LyRZPCd9/B5GyqHbxVLc+6PLOqwhwFndtQ8gSApwIERt1MSc1O4zxW2Vxjssk98XmdfC
         CrhylFH1c5my5Mv7p8caQy+pInRDhzD+G8n0vBLp7k4E2zlIXXN37e+Z7TD8vIOngegX
         /qFA==
X-Forwarded-Encrypted: i=1; AFNElJ9aqaUdOvjrs7QNn3lPDukAOTfJ/wAyqQ/0rxKVXq2GTpGLhqKN50C+s2NiMUhw622SfrDkqrLa@vger.kernel.org
X-Gm-Message-State: AOJu0YwHJ7y5ossm/F4sPBm8G0Jp4AK5w/JdapSDfvMD32hwQWKHk8hK
	8zIn86g3nwsuLdfsY8+kJaT3D/U2mXUIqumyKZif3rxqusNaDxTp4YM8
X-Gm-Gg: AfdE7cm7IQareof71TWgvuHGg8FkYnZNYrmSpS5VfBDQiRFOfrkW7QXGknNV3hS9v34
	wYwhGfJ2cZ6l9idwIPiW+u5EhVsSCrkpnI9Bp1ocFjC2I+Z+kLs7eQOE0Ik6q02z4OCQjh9JANi
	x/jXWzMdKGao4h68lbGSsYDdmlHvzuvqQ5tctpEtZd4tbZVKdRAYn6QeZ6HbI3MbFtANEiVW/Tx
	bj4yHIwvEIfec8WFwNvv/7+vlDy/JOztw5lFYnd8GGmRPYAj048v3tuN1rfAzlSsY84hxOqof6n
	2boAoR/UqpaBKiJ7fHRMJnDY8qJDA8AE0owhHgili/GjkCmx2n/bOOsVz4y0oOaUF7UvSJ+VaI9
	2ugi1lZDl/gpYHUEXH6SH6rfqsv1eQloAc8EBbCiu+ePYiHeISnmmRB6TolgdypNl//Ob69f/Km
	wOP+hzbn13HaC0C1CX9ABKUkr9IqkEQKXMF5Rsz7r8gZY=
X-Received: by 2002:a05:6820:3082:b0:69d:f855:b748 with SMTP id 006d021491bc7-6a11623b266mr2355735eaf.34.1782237690173;
        Tue, 23 Jun 2026 11:01:30 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9f2a583sm7583532eaf.1.2026.06.23.11.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 3/5] mm/page_counter: introduce page_counter_try_charge_stock()
Date: Tue, 23 Jun 2026 11:01:21 -0700
Message-ID: <20260623180124.868655-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a stock-aware variant of page_counter_try_charge.

As before with try_charge_memcg, it first tries to satisfy the charge by
consuming the per-cpu stock (and skipping the hierarchical charge). On a
miss, it tries to greedily overcharge up to counter->batch pages to
refill the stock. Finally, if this fails, it tries to charge exactly the
requested number of pages.

The number of pages that were charged to the page_counter is reported
back to the caller, so that stock hits don't trigger memory limit
checks.

The variant is unused for now; memcg is converted in a later patch.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 +++
 mm/page_counter.c            | 48 ++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 4abc7fe7c3494..b97b5491447e4 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -84,6 +84,10 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+bool page_counter_try_charge_stock(struct page_counter *counter,
+				   unsigned long nr_pages,
+				   struct page_counter **fail,
+				   unsigned long *nr_charged);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 6bb48a913a90d..cce3af3f19e03 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -172,6 +172,54 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+bool page_counter_try_charge_stock(struct page_counter *counter,
+				   unsigned long nr_pages,
+				   struct page_counter **fail,
+				   unsigned long *nr_charged)
+{
+	struct page_counter_stock *stock;
+	unsigned long charge = 0;
+	int old;
+
+	if (!counter->stock)
+		goto charge_exact;
+
+	preempt_disable();
+	stock = this_cpu_ptr(counter->stock);
+	old = atomic_read(&stock->nr_pages);
+	while ((unsigned long)old >= nr_pages) {
+		if (atomic_try_cmpxchg(&stock->nr_pages, &old,
+				       old - (int)nr_pages)) {
+			preempt_enable();
+			goto out_success;
+		}
+	}
+	preempt_enable();
+
+	charge = max_t(unsigned long, READ_ONCE(counter->batch), nr_pages);
+	if (charge <= nr_pages)
+		goto charge_exact;
+
+	if (page_counter_try_charge(counter, charge, fail)) {
+		preempt_disable();
+		stock = this_cpu_ptr(counter->stock);
+		atomic_add((int)(charge - nr_pages), &stock->nr_pages);
+		preempt_enable();
+		goto out_success;
+	}
+
+charge_exact:
+	/* stock is not enabled, no need for surplus, or greedy charge failed */
+	charge = nr_pages;
+	if (!page_counter_try_charge(counter, charge, fail))
+		return false;
+
+out_success:
+	if (nr_charged)
+		*nr_charged = charge;
+	return true;
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta

