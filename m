Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C347DD7C
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576125; cv=none; b=p8iaRnJ/r/gkdvdWZu3XEVIvRxAw1XTOZmJciCOh/Wp/+aJVA2Grj3Jnjgy9xUy4GetBoGxiDTnNP30vwAs/JPbelZyrYehI4BXv1dkz2kE2R3lneb12AMY5EgqVq426LEHxXPSHaFX+6ltvtmYTe/0TT1mo7dH/Xk1EniWCxfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576125; c=relaxed/simple;
	bh=rTGbsGvKQACnJtisxUC5ZLec44efZiXOSNd4OQNTaLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+isVb6okgcxpKZrDspbiROhiJL922ATilFVlkHv/W4IbFjXu7pvptJuIysAUdJvxXnPZ1Ntkt08PLi6kki59fZjGfnn5mMCseQnlkj8U/tB0XM2dq/8Z3OlCZ6FdJsP+tu3AWfSkivVRBUWYh+9Uf/zfik5MPBOhK3YF4Xk5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KNaHn0u5; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KNaHn0u5"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92eafc94c9cso824379385a.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576120; x=1785180920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t6FOiK4vob/RxKMxAQwNd3dgf0KAGjN7gNG/YIVjxjc=;
        b=KNaHn0u5ops1R/lZeXIDAUO/x4K11AG1ePxAFRbUhd7TfbL1t9LgN4aTaaNKEmTtjs
         nzppEVg1Q9PX8Y/szIAZHRhmAsCyhFpgETvciNAsYAr7YVRUqsFYcRkrJ1cA0BJYzfV0
         5h3TZYJehbb6t4kBKpCI8ZB2jJZyseGHBoqYgwIuBjPkOZcyiIRzf/kcFdewtJpLa1/O
         2fFQ4cCSeO51sw1iCLcCFiOoCVvSqtOi4L7NkYOIn9TUVDV6s0gfypiwDr5EKWb01FiR
         oFb3+M5V2dmD9yoV/rPUoLqy4kniWwtmd/ATQkFdRXosc90P3z/b9WVijvCzfsZAgfXg
         89tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576120; x=1785180920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t6FOiK4vob/RxKMxAQwNd3dgf0KAGjN7gNG/YIVjxjc=;
        b=GjsYhV2GP+bpxQ8EUIsYjbQo0rtQIiOkevNp6xCLQSP0glTdaI8gjc0sPUpR27cOiN
         oWhhKtZM6jrMShQQw2EY9626GupARt8nhOpdYsDjmr4UUHr5eTVIbIvXn4f3zzays8/Q
         ZqH+XTm9In0Lc0eMcd7k9nC6SHVHa1ncxa7oNYySv81AvJWGFie9L+pG7HBQFlfNuWAY
         j4j//83jj/pc7hKhm7keSakbR5pWaPglpKeKm3sJ+s71PS4XIY7B6l42VijDgGTahV89
         CYBvTSyMfHRxG0lMiTCGswpmaCIv9uNhMnHRHc9ozTJbzY4BvLk/tuhui9pEgHl0Kmyt
         KrPw==
X-Forwarded-Encrypted: i=1; AHgh+RqLgZmw4YgAInaiXu9f3Bnwrviq4U6VlGF4lxBAlG22287QCqmaFpCnXOuHmUDj9HkCDhBtUJlM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5ddZ1xP1CNfsFeopSkgNLu9xf0UlQLkjspCfIONZu5j/JORq9
	tS6bT/6odtYo0rOPduQkmA0ExLCot/D6mAgiED/qtmpBy/vEmIzkheDF5MPdzl5eAuw=
X-Gm-Gg: AfdE7clOQvkeyuK3+PjpY7TTOSCL3F/vcHqhLqdQ+5bqgPXS8K2gJ/deiQzfVc7OPqv
	E2FQGkzsmRdxbCWRKb2HjmhQVdfNV5B6xN5FsrY78gcuKYL6Z2hK1dbLK8ZE5st0pZpH/iuj59Z
	jgzmUis/+ygV6iXlhIfgriOFNjXCOOcR8wQEqMDxhoTBf5xSJT4MsukT7vlAAS9rDWRPthWwqb6
	Ca4JJXZyzMVkJLYFkF8PeNjuKR1AKxguKAoKFHt24EQdk6kSkcGo02Dz00ouT+CF4MROGs0DquM
	02q2/QHs3dd7rRDtxZZ6I5Ga0wSyn6C1vFDptT6PKRDnZciVCusXFvkUgOBpA9LJldEbgwj1mMM
	w7wozMmHrODf0PzxQ7Bv4NN2tPnuwJnbUpXDojdTu9+IiJ7XW1IWjiXIvEkfG23ya9thz1ETkKh
	xFdU5PDQ2ig9KLEnCj+xhxbVtmAkwkr1dV2JPS7DLcP/MKR5hS4B0wzz/GQaVd/fw=
X-Received: by 2002:a05:620a:290a:b0:92e:7745:9a3a with SMTP id af79cd13be357-930b3e4e1f3mr1582641285a.18.1784576120209;
        Mon, 20 Jul 2026 12:35:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:19 -0700 (PDT)
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
Subject: [PATCH v5 16/36] mm/khugepaged: skip private node folios when trying to collapse.
Date: Mon, 20 Jul 2026 15:34:10 -0400
Message-ID: <20260720193431.3841992-17-gourry@gourry.net>
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

A collapse operation causes new THP allocation to occur, and may
migrate memory from one node to another.

Handle this the same as zone_device for now (disallow collapse).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 89ce6bcbc376b..fb4378cc17b10 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -700,7 +700,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1687,7 +1687,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -1944,7 +1944,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		}
 
 		page = vm_normal_page(vma, addr, ptent);
-		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+		if (WARN_ON_ONCE(page && page_is_private_managed(page)))
 			page = NULL;
 		/*
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
-- 
2.53.0-Meta

