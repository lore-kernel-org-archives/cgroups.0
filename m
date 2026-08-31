Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE484A2A65
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194277; cv=none; b=U65ugD1Ie6PNk/Dzoc6cg3hxyXZC44lQA4Xcd15dwnmbhSwM7x5AqKqqvacbnIXMPyifKzvckXC+XzXHXD/Spjc2X8PO3b6o/yCE5BVfEdKN7V/KQ+H/k2wyFgcvISYkveNL7o9y70F5PF1JrK33xK014UYM1x9kCL3wWsXu4Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194277; c=relaxed/simple;
	bh=GYbb3qr5zDuvMPL4+OMnJHI4rslRuEhrqPm0smt3Vuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCkRfm4xq5Yyx8V6m9MWaAG88WAs2gISmKj5LLSmLJBQVK/F5BXZctQWO8xzwm/IolUfJmXiEkVHhlrt8tmjKxZ6stfQYztvaLFj36nC4dnXnKnhKSRZd5LfIUJZ7+ypxCaoon3NooUZU0Do8s/toEx4Zttgt0jHjPKCc1X4cSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BY1bOPRO; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BY1bOPRO"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-43bf9548df4so3538914fac.0
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194275; x=1788799075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q9afrDjj3OiNFQNFlcWPaAJKUnSQO06bnnIAXSq7zMg=;
        b=BY1bOPRO72g7bDo/cyTQmRavUOzPDHdR3Om4uMaxzchkjXXfGZSh303BWPAHG96Szk
         7s2jisFglfTJY7EKhcs3qlTjtzjS+ImJ54HEod4HHG7oPCofSpfwfUyq+8Pmg0gT9Lf6
         3xd50Ivu+m9qbpJLvXGLoxXziYvqPRvJ0V1dYABL0C74Xr2w93dxj7Qz/yYCjSrvi4eJ
         SGQUh7rnaYZX43a+VIRKpJV2HX/H7QMRAWKqFrsnrUoZmpglSKwzRFDJTepnZGa4Fkkk
         DE1twcwhIjF8t3nU+HaOeIX1+LzYpAYxI4dLqvx1r//YVDLL79tWS5eaDXZyO9z8b2PB
         hhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194275; x=1788799075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q9afrDjj3OiNFQNFlcWPaAJKUnSQO06bnnIAXSq7zMg=;
        b=XPY3+VgT2W1Udg8SXNHeVHo51cR1QTT8HW0j+9dBRcSwgtShvr7MlpjoqV8XgRM4Ac
         25sFVIoU1eY/7o1pKjEBCaDw5WybhxQF/qnwrqv1Wp/Zc/5GkHZJJd1bMCdpSK5YOPbn
         /yI7Uyc2Ji3huntglmb1Z7O79juQcPhLgDQfDKP7p1sd4euJXdQw3xCib18b91+cZxSy
         kpNOyeR9vXScNUrXON8tEzT/Vh1tDRITDVI3dcI74RDnMph2InD5F6Chpau2sQoqACII
         GaMNA1LfbIu0hIAu3R7I6yoi+fQlDczb4V34VWxRQWojI5s3r/CCyacQKn4aDJp9MF65
         9snQ==
X-Forwarded-Encrypted: i=1; AHgh+RqR1URP/07923KVXnKZ3VGkd56d8/xUVNkUrlSOYsW14o7o4helCvY/A8Sv2ZZwxWuFpVnsGhlD@vger.kernel.org
X-Gm-Message-State: AFuF++ko4+ZnQJmiyRjBTbPd/56AfDYiY9KyfU27xGsctPlyBsWLkcFP
	DLi+aRA7836yF4nRlrpz9SvtFFhzLdscP1XEy9x4i//5UYrfW8e3/SLP
X-Gm-Gg: AR+sD12XDGu/ncucfD/nFS+6fO0eL140W80U/pjVAfJx6bhw9rYCntjRpxP/2xQIQOT
	750Qy3efxFXiZXXtuL1SjSSRd8x8fn9HuWiZa8F/w82S1N9DrtyVx+8sLVGFrGDtz7YPDvCrHkO
	mlqscdQQO+2d/LDhsWmqRvI5wuHR77o8XZu9R5KPqTJapG7HSkDpfaM6v25i+1ePNa33A5pBhoG
	OVVCiS8klovQXRpbsznMhW2i+GmIscYwKY/VHFKFU1QXl2iTRGTdfypX+p3ZsE/EJ1KC5G8y3Gw
	8jGdfC3UuBHwqB2EApKZJvb5lsqHmEOUgmTxpsMoh4dfTk3gOtQ5YqfksTXgLIJ7cppVUMF4Y4N
	E70UkYD/jFu0pgTuyXEWh/cD6NYeHT1/lwgu7IVB5fOfbrRPQejRbtc3uewuokB3YnXGX3hJ0dJ
	o5R8Wo38gAHTSDA2HEu2ghRO0AnO0QpvTRs5qPWZDh1A608KhvAQ/kyqNielKmCD+EZUHnjnmCW
	jj9roFYdRNcu0ajIQ==
X-Received: by 2002:a05:6808:1921:b0:4b1:b83a:5878 with SMTP id 5614622812f47-4b5b81e2f8emr2412176b6e.14.1788194274813;
        Mon, 31 Aug 2026 09:37:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b3a1995f2fsm8537880b6e.11.2026.08.31.09.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 1/7] mm/memcontrol: flatten try_charge_memcg control flow
Date: Mon, 31 Aug 2026 09:37:45 -0700
Message-ID: <20260831163752.2193337-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf829638524b5..93c2fa04da4fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2679,18 +2679,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta

