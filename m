Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45942375F81
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 02:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377858; cv=none; b=noIBmvqq7HLB4aBusXajv0gb56X+illTVERCe9YhQEMClGuERbHXB5mCRJkSeDVoC0juxti7AzMb+PnInHAjsqaqKaMseLUS19QH65aoQYkFDnxFWWrrxgRAXMbmYlXTM0Xp7X6TEcxKeqNzV2gZxrOZPAx7iQzirAykuK3z1R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377858; c=relaxed/simple;
	bh=SrO8m8JswAT8suAdpfXa2RGXk/+AtgAOmXnIBG8y1zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKAVw50VEHgsmOkaQ1EMT4iWTE+VcAAZwthIx883eVxFddbDLEZS3GFKUpl0CfA4mA4NPcaGoa9gqFiD04RGVLCHbGrpaiMvl3vbQo7VR0QvrDbjQFRKFOLZMe+vqxTKZ5UNZ+j2RmoWisU3KBrX6CfKxiyivO0BdDIrvR07o6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pw3oIcHU; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pw3oIcHU"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-ca132e9c54aso153290a12.3
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 19:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377849; x=1785982649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FTwEzqeF97wumJIcsz5S3t64bdWHEEiMpofbG9ulZh0=;
        b=Pw3oIcHUQwejTcoMkbqBErzgxtxGkzpI8wOeoEksmPb5NyjXPfSJ3lhHS8cblNzTTA
         c7tUdYopnKBAC/DpmWXlGxHyWMgNLx8z40TGa/PmNGUe7saWBPGQsuWXIOveUvTK/ULd
         ZgRpzHY2854gK4SKli7KjeUCMB4afsCaKDo3nkoBmm+vlwxMRkFjHFCpPBD8hrNcgUpT
         kvUrcELoJt7Fuv04I4w32Hu4dotsJrD+TrcdUbR0SfIlUlON1fjEkuoec5AcgGv0BRFc
         SuJGdXxm/C/Q+JD+9eKH0DMjSVHSCoCkwndsQUlhyemNPwVk2j8izYGy561Za/pZR28M
         Bvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377849; x=1785982649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FTwEzqeF97wumJIcsz5S3t64bdWHEEiMpofbG9ulZh0=;
        b=BnX8JFGpGsNlXoY00zMX7c3AFURuRhBirOe0F5gA8ypKySDl5HoIEUTfNwzj03zF7e
         SEfJr+9beK0kcds/5O4Gv/1Gbm4bLhe68rpZk5dw3ehorxd3sa9k9aCwXqtTMvFz84Ky
         AjyL6Sv68Kt11LMsEYvULdtmtFbrOpgd6s1M4LVRizUGmMY4xH4gdd6wzIeG5IHFJtyS
         JPFdGBkM9kw00+ZZrAkuh0P7ikTeI0B01UlxsQstCqQMTG9HmKwZqimZRyv20nZTHP9A
         qoYjhOijolIQUjG8iZNZ0BfSamIT8DOvigkei/SEkoVTPeBposHRsZZ6WYYGL9S5TNRZ
         NRWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqBUF/fBH/cce00XR9zTqYUW3pX6G548Z7YcBQ2QvXR8tGyHjvC3jTzqaL38t4PHxru+C8YchXa@vger.kernel.org
X-Gm-Message-State: AOJu0YwGrUXBW1ySsbfsmlG7OEwqswIsp489uD8RHwPh2qIyH+eTsOZF
	s0WXfBRMxrLhe8zJy6tBsJ++1qjmkFHn1W0oTM3UVhfStoS0YG7RehCGqOxZIkT1RLDbDDt3
X-Gm-Gg: AR+sD13TpoxXtuhrnyiC8ldSBR6ya2aFoqhs3IE7TkIz8lMlbO2gTbh/UAOo7Etddbc
	VHu5k4hAlva1BB9/J6Cijjk3T6w+ZhGOFrdSMfftpKyNyLRXbxYGZQvZJeMTwi3YckOBEvQY0bL
	D/H5fESk+siy+8LX43Dn9o5N2JP2+J0hFyT706U9JZpp6qu6ew5T5vFoX+3TssHmd4dOFUWb1Ew
	yE2Z7ptt4gVzygOb2jmtvan3EJQTMeOySgJHuMjKoE6VLNWgsXu0PHEQvgiBPSuk114FuNHyq/y
	uTrCGU79yEhgGlpo1UR0Fb61qYtXJsZnsoFQCVbDMhtF4sQ9p6ALPkxeuIdzoUpo2uLcXH3uBH2
	Fyc2iqDNy/5VAuMlL3ALjHOr+HDtEpWWIjDlG/St7ir9um5jp9qgd7lNudpaJ3orqE1vyUGEK6s
	MNxVZgZG8zjvLH57eF+4G8Bt2rwnv4SssZea3HF9zTInFXhk5qOZtth5crmeqTkiVR8O1SrQ/4t
	i1bSfu9rJmzo54GaFVaWii66HpsFFY9kq2eJ11X4VR+jhIzTFxL
X-Received: by 2002:a05:6a00:2193:b0:842:732c:569a with SMTP id d2e1a72fcca58-84ebc3d1c4cmr1021107b3a.2.1785377848496;
        Wed, 29 Jul 2026 19:17:28 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:28 -0700 (PDT)
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
Subject: [RFC PATCH v4 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu, 30 Jul 2026 10:16:29 +0800
Message-ID: <20260730021630.2235914-4-xueyuan.chen21@gmail.com>
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

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

When swap is disabled, exhausted, or unavailable due to memcg swap
limits, splitting a large anonymous folio cannot make swapout progress.
The fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces. For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26df81e773ff..e9110afad29f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1263,6 +1263,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1281,11 +1283,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (ret != -E2BIG)
+					goto activate_locked_split;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
-- 
2.47.3

