Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A42E382F1C
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377873; cv=none; b=NowOkWL8APUD0VxzUhn1XHIiGEIRewjU2Iod2EXFX/XfxQJQj3Pjk+SVjXspKas7QNX+ueLZyAkMysg3CNt3re0IblglhZpl2xzFDm02fPDeHu9tuzsJkFQH2FGnQG7Q6KRS6w/QVyDgrw/Azon/StCK8TyImPFTsBu6qdlfVQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377873; c=relaxed/simple;
	bh=1Y8TQLti/rJ09/6fHCHyxsM+mu9hpBi1CgEUMb7XmR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSp6e4kEWmjusPDVPLxxpsNSQ7kygX6o+MXW6ayUCqpuHdW2bQLViiGNHkp/IRd8vw0tdi6fHGlFXHZ54AHb1Em7auU10c/I+8o3lcUsmp92xnAs+NlO47iCbahLgJTHgnjTveIjy4lZ+Iyz6ssDVk+YQKgkzCZWLW+tmwjToiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nmdXiL8U; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nmdXiL8U"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84eb53344afso120183b3a.3
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 19:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377859; x=1785982659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmK9e5hF10OqnDZaWNEoqEbUdk/xAOPMzMn2ymShT8o=;
        b=nmdXiL8UuIhxwYR9UiEU6ymbxCAEhQvMTDtnK0Ko6ld7aSJA6WBQHqPhRxEYuLEfNf
         CnQjVwMELOaZXL5I916GUhr4UbaOYCOnvxCjDjXcIbpKqbE5P7MhSjXKW33T0oupc+Rg
         NTXe1TQ8YHo0yQuPbtfxiGkVvHgR6MC9j2Y3tGadcdyxg843GF9r/ot3sGkwOyypyIMN
         eJpVrpbMguUgYNWVdoBmXvMPw9IDznAfd7Oug5LmO+6KWzkbSD8ghrNC5373U3N+h0rW
         9rQXrfP22fqyqoAKXCC4jLOIMIM+AMI5T3V4kSUNFEctYqYvR0NVCigDKogkWyTGpjZr
         TJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377859; x=1785982659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PmK9e5hF10OqnDZaWNEoqEbUdk/xAOPMzMn2ymShT8o=;
        b=PNY+UeawBeVyzGTIbs3keRqvOh4xro4e+TvoAq+KZWsRFzOZISag9feTJf90QsN/87
         1Q2umALBrI6R4Av7M+gDXDCjZfrVC9xry1gcqWulaBRM44n9SazuGNrHNhuOtKD6FEeh
         D1AWzHfIwUH3jionRyYLd7WHbEk+XX+nF/7Yibe7i5nTHVDV+ZM3SLUcVBCY2VE6i9sC
         FJm4dXdxJiFbDHPd0kYgbapMw0FCV0La7NpvM6xzyfQO2Jqg6XKA18sIbrQ3hbrje209
         bjsGjM6p7Lh/avdru4EVjJzuYXorrZu0U0DLqc0GIaSsJeZm3WWbzbbL0a3yT1sGKUOr
         RE7w==
X-Forwarded-Encrypted: i=1; AHgh+Rrh2wTTbO45JiXT/YMsSP2gaGUHp7QxDEooq5/o33sBn52/EubNytAzo/to3v3mempk4S8Gfe4U@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7D6NySXUJZ9h+4ggoS8zLLCnF2cli22ud+mzcgh0XDmv+yyGO
	7QoJvjOeAFebta4VD2FyloskC8VQtWjbCEh5xa0FfrOAdxlj83wppB83
X-Gm-Gg: AR+sD10Z5xcG+w5tHrzJ/W9FA22xBAJv4WJnCrgj34A9HJuMxQi4zn7D3brDOe/7wlL
	msRAfwLxnz4DyduojI3XJfI9nJHJJrXXMh+bnnJTT94ah39EgQLFMllNcivGkREbUPNaSLJjSIw
	7nP9KdjRWjmLZmh4gbHEMzM1Zh4NvVEYXiOwJplhjr1EBzU305Kc7LDlFAkWrC8mEMqDAHTv/hr
	CGH1Q8nzSdZAfCuhxkgdssdbZp3SLljQ9gKBsDQ0TuvWx+TflcMGclN0FVZE7WZWpw8oAiNl5s7
	fD+UuSlfeuEXH7weIpEuXptaXm3jCtuC0bGMGTqKkMChq9CbSCZha9qm/Uj8YwLJD6G+d4sp4Db
	ve36LFC9ilkTvwH7+h/CtTZt4qRLiQB3a2Lnh1kt4ZmfHdHmKUHc4mVhBBBKMCpnHMUJxanIb3c
	g+9g1YBuPOs6R5i6jq5oLSxLwuGoMnB/wwpkfzSDykD4b5kreBT3MzDhXOS9gwrLk+SjvumlkM/
	rEDVX2/6dHIcgE7BIb9SL3XZjFq3FvTh94gePJhgk6XXL3v0OFX
X-Received: by 2002:a05:6a20:9e48:b0:3bf:b228:10b4 with SMTP id adf61e73a8af0-3c9007652c6mr1025922637.2.1785377859190;
        Wed, 29 Jul 2026 19:17:39 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:38 -0700 (PDT)
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
Subject: [RFC PATCH v4 4/4] mm/shmem: split large folios only on -E2BIG
Date: Thu, 30 Jul 2026 10:16:30 +0800
Message-ID: <20260730021630.2235914-5-xueyuan.chen21@gmail.com>
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
index 6641823bed16..6f959191ef70 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1609,6 +1609,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
 	int nr_pages;
+	int ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1689,7 +1690,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1742,7 +1744,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3

