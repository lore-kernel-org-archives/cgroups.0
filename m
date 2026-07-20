Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B79E3CB2DC
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576117; cv=none; b=AL5W4YzZ5oBWFRhpGr6MaE/9r81FlwCW7jT2j/c23aekzxx9eQHZ5pAL+3XVIaPQEappWd5/PXzdB6qHVJne7s/VHiyZNBYUfLvGMReL9ZpRo1sfpwyT6R7B4nvklCBu18OH+VOa/r5aoxqFS2NV4VCrb9GtVd1j3oxizWU8ZdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576117; c=relaxed/simple;
	bh=rQ3ZLRwttPY5U7qx79TyOlCHcsHd1SWTIks/cm1EO0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdoYbCHUuBrxLhLElK2TnGY3O9DWH85BqGqRqycHdKm4Re8lxEkLpKfUOrgVrUH1BPBT3TslF5TE3cic9+93mP/VXQ+6iHjP9Pj6ErJgtIomG4Xsx0yMpT5r403eYqEI1WotcTRKse60kHXzCxDfyTVMOVQmXd9IQCY46awyN78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Jzb7G+L+; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Jzb7G+L+"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f032b47e3cso89920626d6.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576113; x=1785180913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
        b=Jzb7G+L+pWevO30ha/zRsPrDNzrFGAKggAwxk7Yv/LsBZKPzLyRZovMh8ZirvuBknj
         weVss9OdLNVU7q9vh5b3czjhw28LQfkCgK2M23dqsahaKyXPJJ321z4Rp7/GpypsLFqy
         fC/YLDW53VfGKqk7BbghBQgYdNzcuvR3i/rDGfcoXIBP6RovKh9nfxC1yPe1niSFf0ma
         gvcy13NKniHDM13kC5OMDbuPdrx7zJASklqNQtn5RWem1tHLcXm75R1wtYzkLXDVvn+r
         InJLCTnfyYPJScL6Gkwm61ta05M3o/Xverw/GjLi4m8y+mAGBVWdhhyr/Eg3fQF5FtH0
         rWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576113; x=1785180913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
        b=VxjB5EYmP+2tD0tdJsHT7aA1o1VjqwQc+3DP9DDXJa+Hfdkw5l318aXfwRS1yNUFvm
         apsgRYPM8iw2GApUyHLK4W2OQ7NzVIMrSCp5jAbnoWCf5go7AdHv0JY8VRssu0B1zQyy
         bNEc4x8OBJHGEhRjqAKFRaEK5ZKZpXfvUjX9DFblZMIyAgeVl6tuLsCJhLvrCMj1FW6c
         2hDBPg+GxWQPLY/A/PSBWbrc9ijIWJVa07PMJqbNf6DCUIs/43jhRvIJ5XTSZpHiLiWK
         /qKLMLSC/ibqSDFBv6sJmtFk5sqn6MgkxYIEmXGtkqzfFQ4BuEBpYCdNgagQ4cydTEoE
         oJDw==
X-Forwarded-Encrypted: i=1; AHgh+RrDQXGe4wFrDZpkY/GQJ28qUxaerei23EoG5rFfJfpsD0/mB9ao34UY5FEbuqezEZ3gC+WSSXf2@vger.kernel.org
X-Gm-Message-State: AOJu0YwdVGC3idzCAiyA5EAQomrHXqP1B8d0Bgjp8fMGWDyN3QTQq8OB
	XaNgGJqbCOWnmsklgUbrClmKscUE82Uj+xBYxAMuW+lLTPMqiyXOUjqBhqgpMkpNvtQ=
X-Gm-Gg: AfdE7cld0K2NoxSNyDAAzr/yVg89N7ZJ7YU4PgstxuJjntamwimqUML/ndMlrmE62FS
	kfOSDItUhvTd7Tf/0/NyESJKGgsk/yD4jIuyHdD1mHVAhp9eu2expXOEdxlqDV3H/E+9PqSwWmP
	3A05ddARqThOhAs08x4k2p6GNn7SoZ7brkmC6In2bToYnBEh1x+K8PitvLf7G3JN39OJ25Lzl5t
	EycLcNIHimAzG1VRs8aTzc9ibS0qt2tE5pKFyNDPSg00nPuA2Q10IeRzt5IY6a6pTKVuN1gGbU0
	Sn7UPL9eNuJD1UL/RNTc4M9FbKi1qaddQFc6v1O7vNLZCrFviNA004i/Nr04UmiKzOETFVp6SLB
	v236w1OAMHVUKV1ZeoFMfZ781hTv/H959x4B/CJ0DFCAES3MY5MGDS7J0FaCGprZryguB1LVTqd
	maoe1t71q4v7akZK9p1z/FxFMj6CU06M/mUCi02fAxfWgq2hAcxnvrUzhhDStp7eI=
X-Received: by 2002:a05:620a:45a4:b0:930:af44:c3f6 with SMTP id af79cd13be357-930b416db87mr1543521885a.43.1784576112837;
        Mon, 20 Jul 2026 12:35:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:12 -0700 (PDT)
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
Subject: [PATCH v5 13/36] mm/mempolicy: disallow NUMA Balancing prot_none on private nodes
Date: Mon, 20 Jul 2026 15:34:07 -0400
Message-ID: <20260720193431.3841992-14-gourry@gourry.net>
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

Skip private node memory the same way zone device memory is
skipped, since private nodes do not presently support migration.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8e8763f6e5f5b..2b76c57a460c9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -845,7 +845,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+	if (!folio || folio_is_private_managed(folio) || folio_test_ksm(folio))
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-- 
2.53.0-Meta

