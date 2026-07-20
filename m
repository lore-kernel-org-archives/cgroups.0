Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B491048033B
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576123; cv=none; b=F3CBcmHrCgwPuBSsSQoI9axA3UNZPjJRIMgoUvk2Dabf/Nk+RJotKwt39iOEdRX7W33QzVerSQjouxtpbLIrSfh07ilHRxGnklj5vpYHlsAzd2HuD5kazOk06ZyWkfVDCa71Q7rZk6mOS+SszBQVSxec6GDq47QWKnWB3iOstkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576123; c=relaxed/simple;
	bh=wTYQxiwnnNn1fQlaf49KQEuG8RjOnNBI3U36p9hX2rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qddpJe/ppTHyEBI+LqFiPLl3JatvTS8hLCTV8t6tY9N1L3WJFE/Mo+J5//INbdEnpTZhTkYcjIQbZC/UEti/JBOAfin6UR0hyQow1VpVI30BFCinbKfZILTWsfAIEtpQbzZuspgM4kkTE0bf6UrMPvchZE1M/CByA2L7lw6fJXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=vLMs9sBk; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="vLMs9sBk"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8efec2c28f8so47236086d6.2
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576118; x=1785180918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgkUnnQve0Rn/Pvs0Z/0q3yFfFJ0c7Ckz6K5pdtr6eU=;
        b=vLMs9sBkiBOQ7nWM2/JvINrnxvZuXiHaXQoiMxPSr9eLnxFZ+Jzubfq8+Y765V6jXH
         Qn8sZ2I2RIRe0s69fsIAccrMwJQGCsw8WCY05tISAT99hWL7opQyW484byM6FeBWNaka
         m8yYTUY6rBYH1WE5qrmHC8lRhBH3osqitPluMLWB2m5jHl/iIAHL4mhmjmPkqlZ6M4n3
         6kxnHP7O1qeE8JGHbnySHwQdHdAcGUIsO8lJmjhLJSppROXwONURxUzeicmaHtBoahjW
         kfzSqFvXdhsznzyA2nTDknEFEDy98eJefQV3l5V0+vjf0VGjoLjx3uEklcDvL4B5rIL0
         HlWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576118; x=1785180918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HgkUnnQve0Rn/Pvs0Z/0q3yFfFJ0c7Ckz6K5pdtr6eU=;
        b=FGFA+ug+Qb+th0zvMLFEnFBrX04XSw6glJV6mWPQfRg52uBv3keyhVzC2sm3eCYODy
         ofA3+++NSt6m71pG5ZGg22Db7+aU6+zVcAQzLVWRigt2PnHGNoq5FvLz7puPdjJyXkkS
         kZvapDmo0g4JF3T04ozL4eYodwOs/5RwOIlkdfVR9xF7/E+HVo+t5kumq3oPtRLd8BKF
         BEaU/Nn+ie6Fj8t4Lcq561QeYCNh8W4L2YzdyFGB3rzdWte6KCA/utleEawyevBFpOH7
         d4v2GIAWjuMFa3RR8mFnpSYpeFWbxNV27s49C9lq0eDgv6YZ+Y5qbD7cLmcDpWuHYeFT
         6Zjw==
X-Forwarded-Encrypted: i=1; AHgh+Rqt1IZxYkVlu2n/V0yEALINFnVZ8XTc/tKcuBFKWlyj6PQc/n+85XOBrvL5teRzEVCLJvnBbtEb@vger.kernel.org
X-Gm-Message-State: AOJu0YzlWUKNIRR8lHYKVAPmAEUBXML0cb0CMWspvKFfBh5yahUe8v/D
	PH8XRqC108lZeR1XxwRc9qpFSqn1ztTb0D9QBs5r1ExsK97ev+mTsvUvDv5R2M9KCfE=
X-Gm-Gg: AfdE7ckU8DCPZ2oxd+1zbRlu/l5FIyn2M0TIBW07TrXYQcxnAGGwHNA5G8u63TIfl+8
	HVfAgNBvaJUjIEyJxSueEJx/ZvQrbeE8t5zl12IkqrhkeD7HycAwLr4+rb/d8AfinkmPtj2WpVb
	GucQx0N/eU9fbKxIp561WQTJzsTL27Zy3gryIOao5Zfy/1ffmnyhpfJdi2r/s7roTG77ND+wsD3
	1dr85W8o7jGQ5nzGWJgRdcuEbk9xBVdXfot10L0++gDWo7hqXPDC6I8wyxWDqEnNTMj93YERMbL
	lHfZ3CeoD6p7G7zVIu2I++WZigmkZu5dXUJj1bw2K8IK/35jGDqexthQi+nUUK8Kjgj34o/2aEE
	DKXG8HxtBvXGQR3eztG2OlsZLD4KeeOsX42TjKiRn31wqSL5dZXUIEcbYvoHoSbOF3kVtPU6OcD
	rIp6txodPWnb62QYO+gcsMyEVPhB5jEbzBcJf8zIBSGqIqeCtqKRQ170Z4dMtikto=
X-Received: by 2002:a05:620a:4007:b0:92e:c116:bef9 with SMTP id af79cd13be357-930b4315599mr1572701485a.86.1784576117793;
        Mon, 20 Jul 2026 12:35:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:17 -0700 (PDT)
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
Subject: [PATCH v5 15/36] mm/ksm: skip KSM for managed-memory folios
Date: Mon, 20 Jul 2026 15:34:09 -0400
Message-ID: <20260720193431.3841992-16-gourry@gourry.net>
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

Since private memory is intended for explicit placement, allowing
KSM to operate on it by default would completely defeat the purpose.

Skip KSM merge and scan operations for private node folios using
the same filter location as zone_device folios.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/ksm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 47006f494fcb1..dcc5c46a29eac 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -827,7 +827,7 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 
 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
-		if (!folio_is_zone_device(folio) &&
+		if (!folio_is_private_managed(folio) &&
 		    folio_test_anon(folio)) {
 			folio_get(folio);
 			page = fw.page;
@@ -2558,7 +2558,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 				goto not_found_unlock;
 			folio = page_folio(page);
 
-			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			if (unlikely(folio_is_private_managed(folio)) ||
+			    !folio_test_anon(folio))
 				goto not_found_unlock;
 
 			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
@@ -2582,7 +2583,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 			continue;
 		folio = page_folio(page);
 
-		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		if (unlikely(folio_is_private_managed(folio)) ||
+		    !folio_test_anon(folio))
 			continue;
 		goto found_unlock;
 	}
-- 
2.53.0-Meta

