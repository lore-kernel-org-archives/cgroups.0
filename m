Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D303F86EB
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 12:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784291163; cv=none; b=TMHevPhdanYklNznTpqFv/J+Xvd6pYgGM+ygYcKenL1502F0lrzaVX9fa15L5gZls87hh3h2i+LEAHEaoanQqXbWTe6Sk0z/tDsbV1MKh5p8mftGslEGWOaYx+a1LovzCXVWtN5MZHi7eEPummLZzhiJF5ynKEXRZkyPC/AfcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784291163; c=relaxed/simple;
	bh=IC8gzWzxCsIar3IfwGi+djNUC+FAXYvXRt0qdcQ6O8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMd34hcLcUuC7nbKUuaGjrKlWjBL7L7uS2ixYp1A3TcsI785uNZwV1oDwpBxx8NEobmetV9O0DMbYEc+TEWXIB0jx7mfgBN+CxmYJOvL1HbkkjOSiGtVi01NJ1kYcOsZWQfgmYbZ51aJgWs4dYBhBDkjKhfSwXs81s7Xk3XuAR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fIAujvwe; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fIAujvwe"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cc7a269ca1so15915325ad.3
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784291159; x=1784895959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H4y0Flvk61D5jK2+voopkUsDY0AemRgTCBdod4M2Kx4=;
        b=fIAujvwe/u1pvCc8Gmf3QYvSQNtK7FTDI5FiBWFhYoNV/xcM/29xEKARWpaijAfSH0
         BNBu0cVXbDPyMzb3JTpQ5/BdeLXVx2gTAHp9cfaNRxFAAknIeEaHqRm9p0ri1IW3NxJE
         swBWsOIW7zpgxdO4kVgXcIr0Ow5nByQlZix6B1TC5bEBTXAqHxTmAXfja7/8YUj4/3/H
         UFC/XzD6k62vaByvr3YovcwNvC2zm/xK36qs1y63soNf07kmTttWc1VEerIBsRI08oOj
         tL1icAKyKd6rEL1GYpzMfhgtkHMrwIdNT5EU2454ruhv1BHg1/ExzdX10FwY7AgE2edu
         gZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784291159; x=1784895959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H4y0Flvk61D5jK2+voopkUsDY0AemRgTCBdod4M2Kx4=;
        b=nD0wXBiUKbjqlKQQLEWEGOskkURgJn4F7tz0BfPMNrRcg8UvB9cTWUNmY6vCQWtEFW
         ktPEIe/iHc7EhEm0P+Td1AYfyHDo7zUJwcJHM2Nbj1l16s92zTXxZ1LhLYbLtB2SE8al
         Wg1ZAbsjFQFn9F+grwBMUUb14gT2cixvh7EXDD+t213IRVWksaBxzrBsFFKcRqkI5WDt
         JZaTnQ2OgA5D0E4GGk3Eh8GfHiHOqhjERIYuzKamG7Ap4gz49Cdwr4OVA1qKpOQfae5W
         RVp4uif52flsDv7T5enbhlwJX6DINTo4peEiqioI/hQemRslm3UEI8vpWo4ezuSNNm9Y
         Rccg==
X-Forwarded-Encrypted: i=1; AHgh+Ro96f+eo72P+waf3UqFayO2ezxt2Qrku4tdD4ttMFOhwpgoZqWB7SVgnLySWufrlZvv8LRvtCo5@vger.kernel.org
X-Gm-Message-State: AOJu0YyjF5NMaMv0w7o7ow2fVmdHRBFnhhAhr+ebZbP/YXrQfXzq/AB5
	0gEARrOM+MDmas4BnvWRLH9TQgXc9anH167Ib4j3yOC/tVRp/8bdfo7q
X-Gm-Gg: AfdE7ckTYTbaoYrXGhDpD7HukTWAJFZLb9VVr6m0rZ99aGoTJ6/5919NOBIVY0Blb+g
	4K5pZ2Cz59XHmE64ImCivAF5DhuUgUG7eAqbMCQjKE6di85RFy62k2l6fAOlCX/UowQfm8WpluW
	OJC294izt/WQWMYpVKY9NELIm0j3D/gFGZ3De5ykrF2vscu5TGzBv3xQn9gUa+CZA9PelQfJrig
	qf4RmfySlJe2LMq1PJRDSf7Hz21AYMkAs5bWr6YAbcvp0GNN9zps+2SfD3pyRfPoHr7hg2SsgXx
	JwKYzsUk+3l+2aIM4sOk0Q9EAwDrJ6TWKx5zC1eAvnqSiGCCK5Y1QAMQMBA2seV++Oj27o7s/d/
	4dVy+tUntcFR8fwPsLyKAvzr8ouvjStSBTXowSz6G7Gjd7wwekDaPM4u1uiMNvj9kASb+cWK5wf
	COW3LTei3MesOht0ZgC0qxIT48R3JowcZTs0Tzi2K1cBln
X-Received: by 2002:a17:903:2f04:b0:2cc:9d9:b8df with SMTP id d9443c01a7336-2cf349c9761mr23369415ad.5.1784291158894;
        Fri, 17 Jul 2026 05:25:58 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm9935955ad.56.2026.07.17.05.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 05:25:58 -0700 (PDT)
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
Subject: [RFC PATCH v3 4/4] mm/shmem: split large folios only on -E2BIG
Date: Fri, 17 Jul 2026 20:25:14 +0800
Message-ID: <20260717122514.51514-5-xueyuan.chen21@gmail.com>
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

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure. With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..d76812dd3cef 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1599,6 +1599,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
 	int nr_pages;
+	int ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1679,7 +1680,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1732,7 +1734,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3

