Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793149577;
	b=4OGD8aDu6ux/naR++sWvma3OlgHl8g9LNp10FBBYR9kb7qZYtOtO5sLQrEDqfRBHkJfs
	 VufsFEN9h4hv5t52zJarQJ4T1izoqtMwc9g7uwSdKnrz9J4mfqeR+Odn7rfuEC6H6lPhU
	 pyQWDFYEMX0qnUw6j+R8902VtF/tkNe+tJl3wjgC8KWkFoxasBHY8jYaUAPvMreXD5rGR
	 KhzEXU75aArDK3/WNiPSaozczXeDM9yZPqzm8zBMckltX3uR9/HJGRNm2FiOcm4fThksk
	 Ab1aFndfZHATeXxUrxP9fxDebJ2qRpVDwg8jq+5oH5ao2TOYRSYBRIRVtHO6E3Dlt+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793149577;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=PpW1w1fTH4pWdwk/odzA2Xx9G09sfx2zMLzLE1poreA=;
	b=RXQ4I7/vkb+Da9rQuAMFs+f0FGPC0TAJmamvbFHg15DMut3xKtL5h4RzX7yXNZmW3Bol
	 +fgq30v5QAuw6YmE4jSgKtZLlp/C0jBlGrp0ICsYsA/Uikh9M8oleWDQS5qwJC56Q/Uru
	 qdR78RL9iSy+vycNdU/l1ESSVKAWz2sXgFWCZD/tchCxq2qc56Fv/b/xTa7Pdq84zjXTd
	 M4WIK/VvAqspOxrVPRjOudJxoo6OOfUSvp9MlwUz5qwssGir6Xx2W8eKf2ZWvygmQJey6
	 OAsQJZRFNbyOoO/FvHsr/pjiXdoVlBeJxGbiLkg+10LNANN3OEJTjhct1YpthjVIYeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IPwkcPFV;
	arc=none smtp.remote-ip=209.85.214.200
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13570606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 01:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13570606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IPwkcPFV
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e9995cea88so3511885ad.0
        for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 18:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793149575; x=1793754375; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PpW1w1fTH4pWdwk/odzA2Xx9G09sfx2zMLzLE1poreA=;
        b=IPwkcPFVyzgfuBUhhocxH+WImzb55zfjbLbDD0hWPoFWKHPSqvkFbDwsbhKGQ4PLrX
         pA60Dbt1ahknus8zsRXikJ3Eb50EO2sCCJ7kPGRTNY5z2Ru0j17dazlzJIx0OxDdDKMc
         3ghrWG56vyaM+9A+P3D1iqqweazvK01ap547sTlu4pTPI1hC85fLahI8y1HoYfFFlPOH
         ZOmeofYNMSGxrU+mDJDfFn5h/79zmSplvr7nT5TCdaCTtBVZIUN95ew+rD+uxuL1SzRH
         fxQTULmmU2FyTt1VKStcaGKSwBaDWZtoHYsou7IgQLM/61JaNgHdIesqZIps11MdVazp
         cnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793149575; x=1793754375;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PpW1w1fTH4pWdwk/odzA2Xx9G09sfx2zMLzLE1poreA=;
        b=DFhcAwkBJfQvzD1+J3Qc6OyDB+zvTtQGz+nsTt43+6+bO9meXyO39tkoE3JVQifVQ5
         SQqr1eXL94Eivv+LQbfNgF09X9gSwGTgeJ773F7NhfmJXOBAEX2/Hzf4P3MCk3hk63tv
         FHxVP8icj2RreJp/84q5hrMzm+B4VUKib5ZqRFbpZ6xF8T1OUBx09c0YSd4tZCiMv2PB
         yFmSW6+NjTBBaRkYzf4vR8eq+obQeOw+Xn1oI0Y0LVMulwkH420ONxNe1Y+B7awWMM8F
         1h+2pnRrEReOpjo0mCY1dobOakvLj+Ex+GKwa/4H8KCHjUFD1A43JpAjOwzlksLc6j6m
         z+pQ==
X-Gm-Message-State: AFq9FYI4n6cw/dxg8A5cmbTXsgt5GQCV5q30R/n1A6JJ+9vuEhfbrPoD
	hSoL3zXscHwWGCwqnkLByLFjqldH8bFoVyrfWefm5lMpNJrR2KszP5xDUMz1SxokVxIqAJcWisE
	IrWNsehn+oDhAlPsEvw==
X-Received: from pldb12.prod.google.com ([2002:a17:902:ed0c:b0:2e8:fa52:c600])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:37ce:b0:2dd:c100:b2c8 with SMTP id d9443c01a7336-2eb005a750dmr7696975ad.51.1793149575175;
 Tue, 27 Oct 2026 18:06:15 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:06:04 -0700
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261028010611.3929937-1-tjmercier@google.com>
Subject: [PATCH 0/2] mm/vmscan: remove obsolete offlined memcg reclaim handling
From: "T.J. Mercier" <tjmercier@google.com>
To: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
move LRU size accounting on reparenting instead of copying it"), LRU
folios and their size accounting are reparented to the parent memcg
before a memcg is offlined, leaving the offlined memcg's lruvec
permanently empty.

This series removes the remaining reclaim special-casing for offlined
memcgs that assumed they could still hold LRU folios:
    1. Remove redundant !mem_cgroup_online() checks in vmscan.c
    2. Stop rotating offlined memcgs to the head of the old generation
       (MEMCG_LRU_OLD) in MGLRU.

T.J. Mercier (2):
  mm/vmscan: remove redundant !mem_cgroup_online() checks
  mm/mglru: stop rotating offlined memcgs to the old generation

 Documentation/mm/multigen_lru.rst |  4 +--
 include/linux/mmzone.h            | 22 +++++---------
 mm/memcontrol.c                   |  1 -
 mm/vmscan.c                       | 48 ++++---------------------------
 4 files changed, 14 insertions(+), 61 deletions(-)


base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
-- 
2.56.0.307.g5fe7bd680c-goog

