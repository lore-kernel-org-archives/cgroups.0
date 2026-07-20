Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3DF4C8FE3
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576156; cv=none; b=FG8FVcU2s69aziPGLmSQS2UYmEmEHsqJGrcFqYK46h0FMJIBWjQrNNCZN9Jufg/SZTlzu3k9KU4eCIAbr2bC1QTsrweL4Ki6Hw/5+ZaUF2WNB0rqO9l+8EdKVed96GYAyoyFnP12LAHIIlESEBNTN6WCOAEbuhh0kZpPe+J+3GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576156; c=relaxed/simple;
	bh=d6pCHtBqoNKDq4P4c/ZFNHldTuhwFRB86ulVg/xnwxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRBIlkBNJ5iGa7PZkjqEs2MxXTvbcWxjzijXk9e+UbxZmXQQbP/uGl4YXVr45iLve9dSlhsC2g9kI12/JekrMu3Ux0ScjsNIDj491KtEG2UGJg6srRySEQwcnHuhabLcLvczx+apJ7XMyi8r+9P/nXpM8Hg2r48vIwGFzcjjpgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BvUhT0LH; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BvUhT0LH"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92edb12cdf2so447598085a.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576151; x=1785180951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
        b=BvUhT0LHNhsRPWnUMUwz2x55Y7zCk2BfbVV3gZazgMXOzoErhwvUDcD86ro9ww56Jv
         H43WS6r7fgNWOFM0WWEGUT13UJFCXrRO2swbm6a1VYJmUh0kwTq2AKx7GZiUWXSq1lEx
         xkfcrSmUoGeuaYkhRV81eMwXAllvf81tWtJDQb4LbvHD8wUngoMWzdlQwwenoR9+rKPe
         rDpyN3ySUZH6a3h+0cVkN+5gBRFnYM0SY0L0MMDkevTj5PscSYmasWQLyLAPk/P2YNpW
         ygVWqNdu6MJ+7+wmn4UrI7khRA+xPN59FKtbvOLNodbmHlYmEJdMajOZAmY+Q5Xgry8B
         13bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576151; x=1785180951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hwwcrXiYs5LXY1nHNJcH4eGwqAhaBzqBMJWfc0nxcvk=;
        b=YrYJA6gjUuf1qys4gds9s3JfwyM8MeEiv2xW7r65gcUU5qJocCUGdFdDLcu4UT8IpU
         Vb9WYMfyJKTCT+pa5f2zWQ3q9Go5rSNpxN+AS//58RAdvH+wSaSASKI96eTTIIP310dM
         29haVKSNhrXgRalc/tBzf69+WvugnnPWQFDt8td74N5j9/+2FE+bYlWfxD64VcWjYaSK
         mAlJMIIqwv/7pHJmNDpsUSMQ7or476UVi+tFE+0dNuqIukU8plHO6eKHR7DAWeKHrTVI
         8mb2kLUJ0vTpoe8h3T4Gq7AENOa4K+8KFifsj66SHZZQnLrUlAgeLVkAOgjjAUSOjh/M
         +mRg==
X-Forwarded-Encrypted: i=1; AHgh+RqFP1Waf503R/x0fJftei5+xEsHHnexjGE9Iz3LU5ceqisv3rWHfDuu7VKZIs8oi2Axtb0x1xbl@vger.kernel.org
X-Gm-Message-State: AOJu0YyRWO8fBguemF2nXl4xLn+RrPAlMi1U4PZg2WjEeAVr+5dEeqUM
	8wIog3e7oSl4pwZr/OS1EYLH+4zneGvd5lymdtjRU/Vge0qkbZMcJYNAbDk97Ut9Zxs=
X-Gm-Gg: AfdE7cksozrU6IbW2tucV1XvxeX0oBFd55xaLoZeKZEH2RZ7E1ECod0OPf7RnS//fIM
	Aq7q2J9BT4atvRI6sS34AI7xwqv1+F5GPpfK3QmJb0xPH9rqmohfuF7sD7aiPtYr9y+mNdGo40y
	6phLiNIYlbMlRRVTWhEC0Sh3oj28qtrHCAa9oF9b6aWWQfJCRM64LEWbZwMl1bdY1iBF9Ana4C3
	N2cgVnWSj0nldhdECBf1q0xqtPdEnMBunfYdroFvqhoJOxuTA7MhADE7/dQ3gZcLgkJd2+jrZVh
	UrGu0J3ouAcJRnkBBw5Et2Bdp1jEzCWWkVyIwUfXhSuQwdvrTRFSU9omE7CmKLed1mu2oORzE+W
	Zd1EUXSFivB1kFRT9pkcbbSeEgsZS9wtm7sIlWgWm7ZMbr2KZJ/6LpP0B/9uEfeaooFjBvWI2oX
	OObp+XboNIMGHOgxxfNqJ7vUctINDIv/RZT6f8SBWRnVH7LO2a052MtrwjAxw1KM4=
X-Received: by 2002:a05:620a:370e:b0:930:9a84:d90b with SMTP id af79cd13be357-930b416db01mr1583254785a.50.1784576151483;
        Mon, 20 Jul 2026 12:35:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:51 -0700 (PDT)
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
Subject: [PATCH v5 28/36] mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
Date: Mon, 20 Jul 2026 15:34:22 -0400
Message-ID: <20260720193431.3841992-29-gourry@gourry.net>
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

Add CAP_HOTUNPLUG, which allows memory_hotplug to migrate a private
node's folios for the purpose of hotunplugging memory.

Without this, hotunplug fails if any folio on the node is allocated.

Add node_allows_hotunplug() - which returns true for any normal node
and private nodes with CAP_HOTUNPLUG.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 26 ++++++++++++++++++++++++++
 mm/memory_hotplug.c          |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 655fe9ec5cb61..7b617b1fa9c28 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -14,6 +14,7 @@ struct page;
  */
 #define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
 #define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
+#define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -97,6 +98,26 @@ static inline bool node_allows_user_numa(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_hotunplug - may hot-unplug migrate this node's folios?
+ * @nid: the node to test
+ *
+ * True for normal nodes and private nodes opted into CAP_HOTUNPLUG.
+ */
+static inline bool node_allows_hotunplug(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_HOTUNPLUG);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -124,6 +145,11 @@ static inline bool node_allows_user_numa(int nid)
 	return true;
 }
 
+static inline bool node_allows_hotunplug(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1f42ed303366c..e9573f90e0dcd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1943,8 +1943,8 @@ static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 		}
 
-		/* Private node folios cannot migrate, fail outright */
-		if (folio_is_private_node(folio)) {
+		/* Fail outright on private nodes w/o hotunplug support */
+		if (!node_allows_hotunplug(folio_nid(folio))) {
 			pr_info_ratelimited("memory offline refused: node %d pfn %lx\n",
 					    folio_nid(folio), pfn);
 			folio_put(folio);
-- 
2.53.0-Meta

