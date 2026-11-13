Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607552;
	b=ZAgP5jHgOLfo9dkR5S9ggrxMmetMzxGxPmsw9PglWDXpENyNG2sUlyMc/vRj8Pwylkrc
	 k5hmS5z0rxUCVutmiww9f8XX+/PRedVa7Bh5jFfw6D0UfXULcOcOU2mSJwPpbEKmwEzLg
	 Q0CSRwbWKjlJqvl3Apcq1wzeZongzvBI2w4JIzrIUCyDDJ+pCdUA0NRWiwCnQ8k/qJC0R
	 DJmi08ggt9urPQBBDoM1DbSVjnyYXUyIe+LMhQtWlkqZVJtYJZHpY7XCESdZiC27OTybf
	 Aqg+Qup52lFL9slgQDrdCO4CBvTo3ITKD5Y5HyskWT5v2Uga4dDGHy8QiyTc2oSaxVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607552;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RjswVOHO5sVxrAeAWnMLkts0RZq5oWih+6CZ1AINTug=;
	b=ZXBPL5FYTY0JADNYfVB06mZIjbJ3rzBJQ18rytmJWkcj7Fe+1xPl+ORoXzYTDxkj9L54
	 LQmlHX0VlvrPTPGAjfJcRNzOYj+bd68ljrYZBfXW+qMwQGuRjsLuhRf+JwfRjHx/N63ib
	 +zXEVBgSEsQd7jc1Egk6iGFtnmhZnJ24bb2hQgYL8NLxBusRZcgYSvaJIcmWcZ8Im7+Vq
	 pcmF0KlDfc2LijoLE17fbc7RTf+i1vUFaPRZXb1ZgYFJV+j7eUP0w95jWh639lQ/m+zop
	 k0ASl/FwUKTkxMBg7zehO6aS5LAYgDC61kZ0/nxcHrntRSV5/s1Dh9OqpD0g8wSnL2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dWiI9rkJ;
	arc=none smtp.remote-ip=209.85.128.171
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF560A2618
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:05:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32FF560A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dWiI9rkJ
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b30ff12f84so11656707b3.2
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607550; x=1795212350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RjswVOHO5sVxrAeAWnMLkts0RZq5oWih+6CZ1AINTug=;
        b=dWiI9rkJM8/P3V4Up77CSk1DZySpRjwmjwJIXpKK9F+VUhkPnE1gF03xIwLwtQTKWM
         HzRQdqqFnjC5YB6nn941qh0j2DqmPuE80Zkr95fNyGPILEyL5bIHFdzhiFCcxjJIbuFP
         sHGS/QyzrC9ZwwTCbEFG92HZtTcM5ooR7az29dZl4qViDe9vk+fTF+iFLTef7eWleJAz
         c11FVIE0+THyTpUjuizXfT5SJ8ooRIRlh7/0DlCWx7TMuBILY4oxOTR6u4OXe43lBXaM
         aAV0m3fzjCAMiA1beZxCZywYMWQt8wEJS7Zt0mSHN2ya83wz8s8B5odL7cixDnzEE5Bo
         WUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607550; x=1795212350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RjswVOHO5sVxrAeAWnMLkts0RZq5oWih+6CZ1AINTug=;
        b=T0RcD3HyJsOhmd0D/DlkfdNS1mmQeDDuultwOYbqiwpNX/0inZnmPbOwQSCygfhRja
         MbcjFnt7SEF6NfyiCMJ72X648dD0stAumFPh/yE84BhYzDMJOYl7Jn/V6G5PQogWALBc
         5kEC8ysvtsG/cXntgi3xbsexYc3xttypDHJmqyizeNoXH3ifoOeZJTy4nnNnbu6F9npV
         AxeNB/N9s1+7Qc4k0TpUAL8UBRgj1yNPmggJLUM7dfsExmvVQT63Jc5M1/yWyAoGjN4m
         ABCB1tbYeDpKanDF0TG2SX7Mi+u0ii8AisE4XuynX/8aaIvAUTd0H0a/vJJfz0tqhV7x
         GT3w==
X-Forwarded-Encrypted: i=1; AL+hErGoUGpQClglA2lOWylTVHH5WGe0t40GCgJ+X0ki8dXDSLPhnqVYM1hC0g6sOAbH9uY2CKZR/Pqg@vger.kernel.org
X-Gm-Message-State: APuU4Z965RPJubSGiTeeYkf5Yiify5SjDL9wG8Nkgt4/xj5BVFz3KPP0
	VZK/WkbwQejwdc64z3fddvMNKkUIneU2XX7CTQyxw4fXINdx6daMgtzf
X-Gm-Gg: AYBFou0tZ3lQF8GZXMwBqZ0VOG4NtZMPzfkw3FdSbEuEQJLs64Gri+zjrQSqkQMNfh8
	gWCndlyei2UzhNWc8nDuhPnnKjPhzWPbBpUYWMc/v6H0C6sV3Fqg+LxVRf+Zrxzr+7dIMc44aEn
	looOXy9FmazQk2ajJTVVacgZsS6e6/26WqfYiJWNqWDsRp7Wg6HY53318rkZBKwniW6BVUPvkE+
	sR4Q81OL5rrKaYqAgncoLUpQwNkQbq6Hzj7AbVEg3Z9Ep/roHswXTvtutGuXkQf3TDUStem7xHf
	LaWaJjy823okezirluBA7gKfFCGeN9UIHO7hFRzSklgIGfPTqH3R3ak+zo9UZNxfdwoFMvqqnYD
	850igq90h/lZIpCYVi1lG4PpQUVUHZfnMFHvmu5pA9mH+bg9FPXOmLZI/fur1W0NsL+Xe0cgjf+
	0+gel7mFJizKdk/XwQvZ3E5r9t7pWawdCLM0cvfdDXYbyyKboalrQL9v7cR3xgEaK4hO1vAYkUJ
	V3Qf/Z0jqlNLJkzY0rrZ3S80rT874YBDVIWWPXERk1w+coVPtoqp3EWQ3sBiEXA8yqABfqDCkdB
	mqqfgz8PMnRoClaiXcQ0Ah10/KKi9zITmj5qiVuec4K40A9u3rIJQohT3A7R47hkk+5a3sxxods
	OwSqKgHA=
X-Received: by 2002:a05:690c:c6c2:b0:8b3:2d97:b8d4 with SMTP id 00721157ae682-8b4aa37bf16mr19608777b3.49.1794607549317;
        Fri, 13 Nov 2026 14:05:49 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa99f7a1sm30911297b3.29.2026.11.13.14.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 4/7] mm/memcontrol: check PF_MEMALLOC after trying the limits
Date: Fri, 13 Nov 2026 14:05:31 -0800
Message-ID: <20261113220539.2275715-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PF_MEMALLOC charges are currently forced right after consume_stock(),
before trying the limits, so that they skip memory.high and the
high_work worker can't queue itself from its own reclaim.

A later patch in this series moves the memory stock into the page
counter, so that the stock is consumed inside page_counter_try_charge().
That leaves no place between consuming the stock and trying the limits
for the PF_MEMALLOC check.

Prepare for this by checking PF_MEMALLOC on both outcomes of the page
counter charge instead: skip memory.high on success, and force the
charge on failure. These charges still do not batch, so the resulting
usage is the same. The differences are that a PF_MEMALLOC charge that
hits a limit is counted in the cgroup-v1 failcnt again, and its
MEMCG_MAX event goes to the cgroup whose counter failed, as for any
other charge.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0e7500624b9e3..fe97b320b2589 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2795,23 +2795,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return ret;
 
-	/*
-	 * Reclaim may need memory to free memory. Let it go over the
-	 * limits for a while rather than fail or OOM kill. Doing this
-	 * before trying the limits also skips memory.high, so the
-	 * high_work worker can't queue itself from its own reclaim.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC)) {
-		/* Find the cgroup this charge puts over its limit, if any. */
-		for (mem_over_limit = memcg; mem_over_limit;
-		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
-			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
-				break;
-		goto force;
-	}
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
+	/* Charges from reclaim or non-spinning contexts don't batch. */
+	if (!allow_spinning || (current->flags & PF_MEMALLOC))
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
@@ -2836,6 +2821,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2931,9 +2923,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 out:
 	/*
 	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
-	 * requests. mem_over_limit is NULL if a PF_MEMALLOC charge fits.
+	 * requests.
 	 */
-	if (!raised_max_event && mem_over_limit)
+	if (!raised_max_event)
 		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	return ret;
@@ -2942,6 +2934,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
+	/*
+	 * Skip memory.high for charges from reclaim, so the high_work
+	 * worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		return ret;
+
 	memcg_enforce_high(memcg, batch, gfp_mask);
 	return ret;
 }
-- 
2.53.1-Meta

