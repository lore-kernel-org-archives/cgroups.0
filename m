Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F0A42A797
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576101; cv=none; b=RA38Q+Lg7tZDApQTbJWwaFNImW6PTv4NzQOnU50A0S8JIo3qWbDwYiJwpubsnHEHSRZmH+xi6h7q+aOPZ8wkgbwPgzSS/yOg7ygCmggogrcmNxgUCq45jtp/kYXZyc63fBuQFGl0MLYcN6Qeob/HkZAcUh1jdHx2zMJMhP/XyME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576101; c=relaxed/simple;
	bh=5WsZz3rVrHU17snClfl3M7UsKRdvN7wn8MZmoue9j4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STJV1x2w2YYbfvkHICvgcUq+J166wCoA4cQn43DV3lRvXioU+4mwXF+NRhrcYN7p+7ueA2ukOq1PkBnjbk3wGiGauUaHy8b8dEyUeOok8vAwbXnZLUJgWVFXOUrmWzDWuXPIYhg4o22RrNYOKHeJXBMpqecNCm2RWGppajq14+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=AeO2JDVY; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="AeO2JDVY"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e5d50b0dbso540099885a.1
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576097; x=1785180897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xdEOlYqIeVdUG1DfkuvgY4asc0OjHWyQnI3tw1EXx60=;
        b=AeO2JDVYr4O4Zalcb0OS5SE9Jc10O2vFAgaj9xZdut8hoHmRchSeoKM0BvhpKROxAj
         TpuEQQHgBvlffX0b8VIu1nV8QGREocf9JjP9UxFZ9eQXVahhg1tRrUD9A4iLJnjqnU/D
         XIPoxcFJZpI2KVfzaHdaKMiYwn6HUcDzRSXafy0wt6fsDi7jgUlsm4Z+YkBdBlbXgULG
         RMbHG9yXaXWjXzjsV6CaTm5w4lwraNEUyE/0uyFHlQ3BQoNARJguOH8jZENaA3p2vTJw
         Yz9e0Q/xakbbN00AJ15b+UP3MeSow5DU3WquVLj2BDWd+eB4x1EcbXJLqt210bh7OWze
         Ik5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576097; x=1785180897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xdEOlYqIeVdUG1DfkuvgY4asc0OjHWyQnI3tw1EXx60=;
        b=fXZjOLFP98ldMHkxAx/tg7tu9yVYWu/xmvrxLmW+9j/N1jKCBWMtSjZb0Wmc1cAeho
         Cc1HGeb6fMZA8ZY45h5/ZLw7YF+ao+cdA7EWfgm4Is/3LpZLKGVTAEP35ImDEEI5dVcn
         wS3HIXhiU+KxL4dks7woIp//hdhTaYiuLM61nQ3Smk+MeTO4/9ONCV7PrrA8YEaBZ06c
         yGON6n7F3D1ps+eQxhYA7yHap1nwDfTXH3vxm9Ib1nnhmvcpq9umM6epkSprJpbhBN/0
         NKCfg9CkZJgGd+CxGNTzQcOc5IVFcS2MQYchi/dym6BiElFuNPCD0jFFsp0Vh1zG9WGL
         AZ8Q==
X-Forwarded-Encrypted: i=1; AHgh+RpIICq278uTKy9NW0EXmXXrnHuukX9sFJ07bIk71+6bfqbmw/6kbntqhPIYxloZXFPiTx7P6lvl@vger.kernel.org
X-Gm-Message-State: AOJu0YxOSu+bJjLTf0POlLl2vjWu1Ql+2FLdngCx8JcN4U6aJTfDT8V4
	lyE8aAt0DLrzTQEDrmlVW7+vUWJv/CPhDgvnVdjNBPne9Nm/Ygsghaos1ViI3RO7pFc=
X-Gm-Gg: AfdE7cnGGgB07HICe1ceNQ/DyMcr/Uc2nI3621ZNeymSuac+fAyqsh9MrZUv7yRjBU0
	RRIIi1oNEj4gOzAY82Tmbk+++cGdwhUEtRAzKltBwKILHQv/ZpL21CUU1vEIOhcT0ISBna6/9FC
	2yUns5NMJLmRZfaxC0KbWgHyMhGjlM+tcZnOFoiwIZVQPSpzQJWvikDSVjxpVsRzXAa8mgcS0Rk
	cMjNHsRLJ6+Q1U8Rar/JCyoVjGdgSVdJl5SiHk/Mw9DJgtlWUoPdqdU4tzLDEZeJp4b83aKeVMK
	xtbqim2Jq6aMmoPT3oYllYNAPPEEgAt4Nb5yGzxKWxZYpF+e6wQiE2dOvTwiXNQqpYSk6+JdnC6
	i9GCbD+rUy2e4VfJuIcs/VOq/hQJb1Pc03B+FValzwX9wUsfkLT1+qM+yp24zsgCK/vLotHAue5
	IJPSE94vp58MQRilnP7WW7T3e4Lko+eCWknzQ7xAv6utCRUw9YrICj7U07zQFGHFM=
X-Received: by 2002:a05:620a:a2c5:20b0:92f:196:209c with SMTP id af79cd13be357-930b41f9aa3mr1179416785a.71.1784576096734;
        Mon, 20 Jul 2026 12:34:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:56 -0700 (PDT)
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
Subject: [PATCH v5 07/36] mm/memory_hotplug: disallow migration-driven private node hotunplug
Date: Mon, 20 Jul 2026 15:34:01 -0400
Message-ID: <20260720193431.3841992-8-gourry@gourry.net>
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

By default, device-backed private node memory may not be safe to
migrate without coordination.

Do not attempt to hotunplug private node memory, instead fail the
hotunplug attempt, and require the owner to drain the folios
safely before allowing hotunplug to proceed.

Unlike transient / longterm pins causing failures, this is not a
transient condition - so we can break out of the hotunplug attempt
entirely instead of spinning forever on a failed migration attempt.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078ad..2b9c0830821e6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -34,6 +34,7 @@
 #include <linux/memblock.h>
 #include <linux/compaction.h>
 #include <linux/rmap.h>
+#include <linux/node_private.h>
 #include <linux/module.h>
 #include <linux/node.h>
 
@@ -1843,11 +1844,12 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct folio *folio;
 	unsigned long pfn;
 	LIST_HEAD(source);
+	int err = 0;
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
@@ -1884,6 +1886,15 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 		}
 
+		/* Private node folios cannot migrate, fail outright */
+		if (folio_is_private_node(folio)) {
+			pr_info_ratelimited("memory offline refused: node %d pfn %lx\n",
+					    folio_nid(folio), pfn);
+			folio_put(folio);
+			err = -EBUSY;
+			break;
+		}
+
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n",
@@ -1931,6 +1942,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			putback_movable_pages(&source);
 		}
 	}
+	return err;
 }
 
 static int __init cmdline_parse_movable_node(char *p)
@@ -2067,10 +2079,11 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			ret = scan_movable_pages(pfn, end_pfn, &pfn);
 			if (!ret) {
 				/*
-				 * TODO: fatal migration failures should bail
-				 * out
+				 * A fatal migration failure (e.g. a folio on a
+				 * non-migratable private node) bails out; transient
+				 * failures leave ret zero and are retried below.
 				 */
-				do_migrate_range(pfn, end_pfn);
+				ret = do_migrate_range(pfn, end_pfn);
 			}
 		} while (!ret);
 
-- 
2.53.0-Meta

