Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB985187F0
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750581; cv=none; b=VoxY9WVAMixyKafQMjKMff8TO4VYAeXU30lGovMvIkQ0cePqRjIbKwjLacBgq1CbYktTguihQFNy2m3vaNLudmbAah+PSGRYgdum6quOMScFZ49mfyXk8sETkbHCquMiFwXykv9RB/DRXw+X2/Q2yA4QaLpLepfRpIfkc14Y7VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750581; c=relaxed/simple;
	bh=0/WwajUfcenToCSvWEXAbxTRyKSAq4K724LifS3zM4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVndBRAARe2rN2DWFbKK72LcaumZ2JwC+OAV+J/vJn0Jnm4LKLXt0JQbaq1gB7u7nluPtc5kRyp+/ONPMKJ9zDZUudL3AePV+yk1CVRazBXLsx5V6m6xBl5akVKariLK9gGZjCGMPPILvrSwazzoDoLU3ILye2an83INuXcY+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nvGNbtYS; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nvGNbtYS"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d8fb334ddcso8687065ad.0
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 09:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750578; x=1790355378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=neVDt5BLYMfRKzGN8kfWno0gbQY9XV/RBxErvToTgFI=;
        b=nvGNbtYSzU493Pk8FC+FC4ehAqfpG3A9qanRe4pPZJ3MKo6H9gsxtmHRVlBpO+aBkO
         9Ed2kaQZ2VyXS7qSk4a8aB9iKrUGBBO8fmmfIexT/z/Umk1/O8oeRMpMKJisAPhVlM8G
         ORbbL56l/cqA6U9lPypTYjNegiahiGHIKKocdO+C+iwnE6TTTRJQ7m/G9GSkKXZeAiKS
         Tni4Nc/eZWVMDEoQjj7P5lUvv7j8Cys1iQqcVCAUxSkOgZg9bcqLPL1rzv+x6EqbvMdO
         2XHHEs8o9q6M21dohFpn5AblGpt5y8C6j6r6yQFGa+1yRu4T4C79w7N3Mb1MGvKeySNI
         jCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750578; x=1790355378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=neVDt5BLYMfRKzGN8kfWno0gbQY9XV/RBxErvToTgFI=;
        b=lpBwX7b23nqSEjJCjT3hRqEXSc870onshvUh0x6VWlfkTPgRR0pi+4xfIX/DUiFpLH
         o0idZasoX+uVj4iEBjQh4m9XPD8RL5gOlXX1qCrs6d34uZLt+LwaMfwQXby2+oxbFmLg
         HyldfjJkD4m5EJkLXOm+FTgmPkOMkVOcwjjLMpisYzCiJXlLbYG4zO+gLPDdcpHQNnH6
         xolR97h+gOBuWMHFt8zCeyAf+Ulfggtdw1MylcfzdOQNuGsvAc+fKDE0dCNGU98K8eqC
         vXKWpyc1plULtwkH4ZvMxogzzWPlu3JmtTro9fuqCEktv5GsPjOnLSV2KMMyWNHFWKfm
         kf4A==
X-Gm-Message-State: AFuF++nqlN/SdQ8ah/7Bh/aREe7/LDY6hhpPS5nXolUtNK0DeyIgt3Jo
	klPbzbXpdhjNFnompxtj9bEju8RfvMykOIktp/14bW86ruFliUmd9OaR
X-Gm-Gg: AYBFou1olY+O47qI88NXTGtXPUd2DtIf7RWF+5PmRo8tGGNgSjumltpqvGw295PnoVp
	O5jbnQyNisKeCWXqBPFrgt7oMmQTj6JSHQPQJ6GxCDzpOBZirOfENRYhJNs/wtvaxGKvxIfQoyA
	5VjVl20ELETjQXhTHSGi9S+Fqes6STUC5v5epJFra/lWOVyOsLF8EwhONsMLUj9z/64YU3QNEOM
	Yi2W617lofEni5pSVIlJiBlOHgChot2eJv53ZfhblJ5yYiDOjRYjiLZVjjQOqp/+LKdIL38wbT7
	IQTAnRhuWhSBx8efZqcRTltzEIYbQUCH5Up9FPDOI0ADhAL54mZdIPkX982oU55e6cqCkJnkAjZ
	/jkq6oC6DdAL2FGAfAvAlaCPslS6fFcbhFXqmW46O4JfQS7/gM7/c4No8LJgUatpFPLNdNpq0kk
	f/Z0XV6nBeIA5MHU5stXrYHe2+GWtfZGwiB69DnQoaxp27qoGC9j7Punu508tu2ifU
X-Received: by 2002:a17:902:e951:b0:2db:7269:38ef with SMTP id d9443c01a7336-2ddb1b77ac2mr79752805ad.14.1789750577966;
        Fri, 18 Sep 2026 09:56:17 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75bfe10sm11409685ad.64.2026.09.18.09.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:17 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 1/2] memcg: remove unused page_memcg_check()
Date: Sat, 19 Sep 2026 01:55:57 +0900
Message-ID: <20260918165601.1014666-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918165601.1014666-1-ekffu200098@gmail.com>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
callers.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/memcontrol.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 64c183be8cbf..b57a74617b0b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -498,13 +498,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	if (PageTail(page))
-		return NULL;
-	return folio_memcg_check((const struct folio *)page);
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1100,11 +1093,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
-- 
2.43.0

