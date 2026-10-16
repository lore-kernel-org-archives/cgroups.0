Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E26438D011
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 05:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792128498; cv=none; b=Fu2PW/R3aX1qzhoSfpqqdC2E57ahim1wvlnxp+0UFNO9+8937FbRnmAlynKc6YrRmMY/MINxrYBklBS3OZbIFugAtFU+TkSLhKex1YmH+hobhOpmXij3eLWEQf9kOlD0P1pXnDxAn45a5VOl3TUoSHJ1fx37qDr24mxcG+IaT8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792128498; c=relaxed/simple;
	bh=mAqJpBLhTBtYmazTeWfNObJBJAo0yrk99XqA9DI1Uv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HRGgwIdHO3rxn+/hEtaAcluuNrn2QADWFExxXbNeCvCelwk2izKDRiOHzd8D/NN+gHeY7YsuNKkXNN/TPwtH3MUsaHVNUjESh5leHI2EMGAfPc8EpLPecwEw4LOwz7ixTqP7IxyZi7LkXpD0Fka6s5BjEP215vX+BusuCiVzVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EFjsLkwJ; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EFjsLkwJ"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so3838972a91.3
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 22:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128497; x=1792733297; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ka7IOJqjFZQU0cr0Ja82jGg8FVBRQylVa+iOg0roN5c=;
        b=EFjsLkwJuia+f8M2RKkikgHqJZ7nSPz3Ud9T2jXcFR63JTtyHgn7thAwDRfLvBzRDe
         65JbJ07B/z/G15rj16bVajsYEFjpeE7BaxQqyMROZeNN3jVePZZ32JMyLCbZI6s3PPH0
         t6vUn6wWa4KNQJ7yeZFlQ4817IX7xSpg8dv2qEuIJcCvueVKlxWKDCwKJIcemeZ0PSkG
         9PGoYyxw04sXlVVEvXkMRoFCFZIqAngLHFTaF9eHcddUpxsrjqfUOYm3s17/qqk1e5Fg
         FTBq7w9TvNd1jKwATby0OXb0gMroVGfdUmyqTjn/KSEtHXQUYUvhwq9mrqUHC16jTYKe
         E0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128497; x=1792733297;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ka7IOJqjFZQU0cr0Ja82jGg8FVBRQylVa+iOg0roN5c=;
        b=W3jqlU+EbU2onxLf7SOBsPdy35zKoEk6v+bMQH2wf/d/qOMx5i5+s8HVTUY1k4Df0q
         EUS4KeFACfGD89VTI43CtcPnvD0Nt27bQN9vyf1SgC2fBpLN27CrjEYIfrKUNRRGkeX3
         OQUS80m5b65PBX9ddyMCl7YyL9nVWco0X6ZE9q6RjbLu46gtUTRm936zS/HKqB63On2r
         ZWuddyGJS2wNhT76+WXBH5n14mhfGj6jGuFUFYQR4mPAt3/RLerE0nKjEypcZ1WOUPo5
         OzZvmbmYO2dWaitkDLZEHCcKteca+jqb5caDYSgWBLdo7C8g1dx+ioJPY6DXCSRQk4r+
         5OJg==
X-Forwarded-Encrypted: i=1; AKwUvBx0GDvocejFpuJ1Vz6EiuBP/w/mcURT3w3Zb71ObtIIwl3E0s3PqEp9TyiRUKawJFasj8vI4Re/@vger.kernel.org
X-Gm-Message-State: AFq9FYK46jKVP7UxqkNVjWkhsMY+eXneRYmui5/XyX3YfmKG/+sgrQSE
	FqBeUbxMSaWSJZ9I2+KpNW+baKPzJDkTJJqo1kiHdw0wFroplWQg6axeT4GeRPgKtbq4luTOfuD
	dFkzUbw==
X-Received: from pgbdk10.prod.google.com ([2002:a05:6a02:c8a:b0:cd6:688:c1d2])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c87:b0:3ab:d26b:c2d1
 with SMTP id 98e67ed59e1d1-3abd26bc3demr18378897a91.11.1792128496210; Thu, 15
 Oct 2026 22:28:16 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:46 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-3-kuniyu@google.com>
Subject: [PATCH 2/5] memcg: Reduce nesting in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A later patch adds more code to the most nested block in
consume_stock() and refill_stock().

Let's reduce the nesting to make the later change cleaner.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 59 ++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c268a7864547..7c722a593cb5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2139,15 +2139,17 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				css_put(&memcg->css);
-				WRITE_ONCE(stock->cached[i], NULL);
-			}
-			ret = true;
+		if (stock_pages < nr_pages)
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (!stock_pages) {
+			css_put(&memcg->css);
+			WRITE_ONCE(stock->cached[i], NULL);
 		}
+
+		ret = true;
 		break;
 	}
 
@@ -2229,7 +2231,6 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	uint8_t stock_pages;
-	bool success = false;
 	int empty_slot = -1;
 	int i;
 
@@ -2257,29 +2258,31 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == stock->cached[i]) {
-			stock_pages = stock->nr_pages[i] + nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
-			success = true;
-			break;
-		}
-	}
 
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
+		if (memcg != cached)
+			continue;
+
+		stock_pages = stock->nr_pages[i] + nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (stock_pages > MEMCG_CHARGE_BATCH)
 			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
+		local_unlock(&memcg_stock.lock);
+		return;
 	}
 
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_MEMCG_STOCK)
+			stock->drain_idx = 0;
+		drain_stock(stock, i);
+	}
+
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
 	local_unlock(&memcg_stock.lock);
 }
 
-- 
2.56.0.212.g129ede20d9-goog

