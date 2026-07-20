Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7537443B3D0
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576106; cv=none; b=H3VDJ4GT3pd0N9ggVsWYT6PG5l77FmdNFOGt7DS6gQMD6RVJb4PN588aFTaZFshOP8CLsAttBKlSlsTW8Lx4l69oNxlxvB73pTv8UIQrGJsxwGVBbIHbD624/vBdrVz70XqEM0KbiTTnxDj5beeH+SbpWtgbDmEwf4huiDVL2YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576106; c=relaxed/simple;
	bh=IH9XmY5lZ74Lh/qC51Vmj6nJ/SlEkb5m+xVKm1fBETo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCdhXNROjh9JjaUZmlCODjNtdk7/VQmHDVXIPBCxHrcX6ye5RWBfkjMOUfnHCvXNmq/kY8MBkbItKI/G30tgKuhqC+PTGUiRMwV+ZXuwCbwTQxyXBQFn/Siy3saTPDKtHtfbVEZ1i+BBBrGDvRK+EI85ZbhwIDjrxVw9ex3Tu98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=d0h7rOhU; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="d0h7rOhU"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9305a2121a1so722923985a.2
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576102; x=1785180902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pZmCSk3Ktta7GM7YUNaW3uB9vhWdsptSIGrgvbOB7hc=;
        b=d0h7rOhUVRLfrDoaAL8llbupY5GuA7xThH9ldIu2SnfXravQpuZIJ0VnKtATtUkBVt
         4GyDeUNi0CufD1NDEV/wu5OqZvDZxDLLlcqy0IB1nQnhsx603JCf/DgVrnC6on2prveu
         /Boq93AE1EyPP0a14G9QmHGR4vLQE/yM5jrhwBudtWMEdsAJ5RkbHRCOFlI5TPNkcHz6
         ptShotJbKiePrY+XbJdX3TtnSLbxiEZifI5Yol0nqYfDfFCsNGyj7fu2tAgbw+JATcgw
         6zWewHR4bkgHsqfXC5lekiZGUOA34p347MISOcRcWma7Ay6no59iP7HLbvxD8GnhnUaJ
         jq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576102; x=1785180902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pZmCSk3Ktta7GM7YUNaW3uB9vhWdsptSIGrgvbOB7hc=;
        b=WMdKrPDHoqPuZTguiD4p17nm5GrTJswe5G1H9k9Tlnsz9t9E4y5OQb9WOC1RK0Vh2k
         aoYaTPSqWm/emgp4FxQ8PX7WBoK+A8gL1AoPtyEnu3NO2U6xUYe3uTP3QmspD5oCUUXX
         yQVL2jnBE+1qWQPSlw7WZoYQI50z8p8cE8glZPBDpNwu+yFzraWtyAFtJkcAKmSdGrGO
         Ij9AA3PRDetPSpUQUNW/DRs3bAYZq+T11C0LXzzKh0k+ZJOfGkdSeumXXvNzU8T7oQ85
         W020hlx41n4FHfBWd9E/q9vs73BpM/MtfF0puKsBJH1r4x4ScYRDb2xr1SZs0GZD2Y2m
         YQhg==
X-Forwarded-Encrypted: i=1; AHgh+RoKGTotIp54AICRptV+nA6Og3YwP/pKlbAUUsBkPSFwX4+JcbSdYWnFtIxcEZeIZGv3xpJD8j1y@vger.kernel.org
X-Gm-Message-State: AOJu0YxQxQWb3dlbLYAE5t0NhhdyOiJ1938b/hJcn+cbvYv2/REcIxKt
	7mve+5TS8xhPeNwcFprD33mWeOaDHC9Q/vlWK6DuKWfWikoQTaT38mYEeqYsULHh8hU=
X-Gm-Gg: AfdE7cnbafIleIsZfnabAFiejkzJPmHunu6uZXJTAAVSCewzeVOfN86BSrxWODZPlN5
	NiCLqqwiO/RfgvmFPqLwMkAuqaY4DiNRi7nCqOGKmnkfZX9qEjrnMmeB+GPgMChfRViePhcyErH
	9MdxYfEJLcqmxI4qtshm6UWX2HUMob1u70zLaKC4uJRZD7ARrZKzZgzLMkDo4kkCE1INgoMy/4i
	n7E7bJtSG7RUN88wxaJnVFsjTfO6FFAA5pGvqj1WKuoelFD1V4I2GRL8PeOqXRwvSR7tXz2dlpD
	MPFjPF+4/5R1fMd3bZwY7Vg1Gv6fkF7uue4Io6EBzMr/OIc1s2mPOc0+NtzIOkBnIJY+q6nXkRG
	GhIeMzL21bHNaNrJV83t8rLX/W9CQHNznepJnbqP7IoMOIZEBF4BWpO1/QMLJy4DHweGptW/WJd
	vaeMLva762s/B8e8w2DiKMULHmShYzOMJoGXmoJxFEg5PQ6wR193cGmGl/UYOikLb4odC7FjtOe
	X3P1QPrE4f/
X-Received: by 2002:a05:620a:a481:b0:92e:cac7:9706 with SMTP id af79cd13be357-930b431c958mr1298084185a.52.1784576101920;
        Mon, 20 Jul 2026 12:35:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:01 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 09/36] mm/migrate: disallow userland driven migration for private nodes
Date: Mon, 20 Jul 2026 15:34:03 -0400
Message-ID: <20260720193431.3841992-10-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the same filter locations as zone_device folios to disallow
userland driven migration requests for private node memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index a8a86141dbb54..d20674c07b947 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2268,7 +2268,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
 
-	if (folio_is_zone_device(folio))
+	if (folio_is_private_managed(folio))
 		return -ENOENT;
 
 	if (folio_nid(folio) == node)
@@ -2477,7 +2477,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 		if (folio) {
 			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 				err = -EFAULT;
-			else if (folio_is_zone_device(folio))
+			else if (folio_is_private_managed(folio))
 				err = -ENOENT;
 			else
 				err = folio_nid(folio);
-- 
2.53.0-Meta

