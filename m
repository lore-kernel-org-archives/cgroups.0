Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835037;
	b=5g2R9V55Gq/SL6l2G15Oqqsv8JNu25IYqxvbtguz+pWI77NKf+FvB4Y43zDZiWMd7MpL
	 OnFQwga3z8giWFsN14GmA4xtTY+4E3kZQ2D1lp34q7DmUwS9AXYiP136cOr/3lZXkj6vI
	 X8CTJdSZ+orup/TBM1P6Wdx/xmg5j1TQFrko+xjqMlfLQi/nIWd7ZnLHHArzWSwOaUhQi
	 qM2PTq38AbWt2L/waHG80Av+vl4x2+MELLIAG9tu6uhHQmBoac16t2Kzx8SwSvm010UTx
	 E6w9Q9XTgO9+PtLZcJ+CCIIofzKg/kEdLyDStiJ6GT+00kXN2g6mw0mGyTEKqUlnVvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835037;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXyL3iz4X1JZRSqfChrbLBr2JBJDe4gGCHENjeInkiY=;
	b=nT+VhPdVS2T9qnBte5c7ruRVUjIyowHotWkRBbKTFAOr2bfh1xfvdbD6/sVzLLLv+9FX
	 x3o5jqPTntrjILa79+JqGea5zGW9yAI3+exNrIae18ZA7bfWmAdIy61c53ijlJ+bwl9SM
	 T2ojSPvpPQxEFsViZ0yjg9Bb373x6zoIqAMmMdBWVp9PlirzBV9gdSEtZ3lg+55RbYJie
	 agYY10EACX5yKzO7DpGUXGcqq+MB8kqve6LA3U0rVwPmn7XUfJscuVhByk6LjLeAw6Hnt
	 ZxQ/za1tjWle5y3rAYUNLhGU4TbOw8sKeW/i5sDQodf/ApdUpvw8ooT+El2Ba3Ma94g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BAydySsK;
	arc=none smtp.remote-ip=209.85.128.178
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73061606D824
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73061606D824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BAydySsK
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b30477a320so11442667b3.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835035; x=1794439835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HXyL3iz4X1JZRSqfChrbLBr2JBJDe4gGCHENjeInkiY=;
        b=BAydySsKnmSB6IvUnKPQLkN2GZUIFNq9zc5g+hcvSn3YrDvExO3qQQJmXAP/rnN1Nt
         aG+EZYvRt6+oNE9EpvY3xMBc3U60wJSbxSeubT6Ehf2QSBvwVN2dSXa9zaieGu42vRdb
         7OBf25eqaHfkcjZp/GzXIz6/4YRE4NlAFbYKQOX4yeKh5ShcsCNwy8QM3O/9iiVbToH8
         8Q21NSi1SbY06ByPgk411knlnOZDY/bRfPo5t9JomY1ueT6LecgKdvV4eqpFJGsFQBon
         9wHfkjX7t8m6guWnfr+E6whyJXTNpdj0D3e+9FltM7LJpJ7rzZckOxeOroaYucJOp9Wc
         wedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835035; x=1794439835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HXyL3iz4X1JZRSqfChrbLBr2JBJDe4gGCHENjeInkiY=;
        b=KGmg9NXbTgFu3E4yUwjXjPTljo6l6hohLzTsJ4roV2r/D/Cogqcs44uAdftDOXz3Ct
         n5bfKo2r+nDalJNwbRsmd8RH+KbJHWhd8AgTrdqcCbYQWwJeUAqy75cw5zd5TmFhgXs1
         njV/tEEIBXklTHdPk0hRmBebZ9JUBdS0HGRCRZNLlWZauEmotT/bdSsjuId3dBgIFCLV
         L8fd7X1MrRjQz0+z0bnygSLQXUhTRYCL216T+2TVr5B36cQa52tM0+UDXGxLmJr15XBw
         XgOgjfT33U5KhDA2vZaUqEhbLEwq7WZVk1Y03WULoChnlRI+7XxvW9puJlTg017V0Q20
         3R9A==
X-Forwarded-Encrypted: i=1; AKwUvBz+jPxsuQdXTjA1w+K0x+fGrjmDoSNEhkQBrPOrOqCVp8g+OxnETvtNt1R7VfFvd5Wc2OHKldvI@vger.kernel.org
X-Gm-Message-State: APuU4Z/q8YSYI+rtCCRMmEHvVJJwDKsA5P9iwJJn09/3C++odWwW4v8c
	WA3ocOKrX8W65qJ4sc45EP9STnelbVEk3bcCOHTqznOFCKFQXtg9Hmsp
X-Gm-Gg: AYBFou1aNJ52a5FGr/xDf5o9TS+0vgH0ZvZAwycI02RI9anW1N1nBfKNjPzwbTW3xdD
	JD3X22hnfq9OwM7IIij8hlDM6FK3KbboFUAOS8mXbZNHDzF/INmP05s45Q+h4U9MfE1DPyDbuVc
	zbdzw43WLWLj40uTnaBF6g53T3gpYdU7mLQW8iArA5LlPK9RDOHbkdwckKfcejkVMuC6uAvS8h/
	9JjfnBGuusSw/p5WFKpYgLZjYunp/gCyc7YmQcdFZsBSBoi04X+JmnAZ/KpEP4X6yVEwQPRUkhc
	dY5nl70pXy/p1UuHPAG3RzjWwyzvIJovzR+wGc/0y+ytvwQtTUbE9dXWKnknOTwdKbLRXCF2h34
	UimY8Z+HbP7ZXbSL2JCcmPbug0XFtqJmZ2mTX38m89U/R3g1MpzldSQwNJNTFWineOrH3zYZWqL
	uUb3Ze5cidcrjFSr1/1OW1HZWmtvFgUrGYHvfgeN3h6h1FFPRSaeNY5plnR7IgSrGOTRZNaHm2d
	XSkaeMP7EW+JagY4Hg6B3kdmWGsTCFBTfib2tIB4sEi6PwK0mP3mhfJt6G5iggIHUcVde6rf1jX
	UlymUYKgzvAKo9CmdSQ/5WWT90kSJsiOeVnpylc8jNj0BlD8BW66TNmqwjQ=
X-Received: by 2002:a05:690e:13cb:b0:67b:f91c:109c with SMTP id 956f58d0204a3-67bf91c2553mr1172619d50.46.1793835035335;
        Wed, 04 Nov 2026 15:30:35 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee27bfddsm2429362d50.15.2026.11.04.15.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:35 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
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
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 4/7] mm/memcontrol: check PF_MEMALLOC after trying the limits
Date: Wed,  4 Nov 2026 15:30:25 -0800
Message-ID: <20261104233029.3282438-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
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
index 311bc2fa644a3..75b915febb06b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2791,23 +2791,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2832,6 +2817,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
 
@@ -2927,9 +2919,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2938,6 +2930,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
2.53.0-Meta

