Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D634F251
	for <cgroups@vger.kernel.org>; Sun,  8 Feb 2026 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770587929; cv=none; b=amJD6+LfJMh0xGSx3LtUUITgi5ZeFFnev7IjZYFhGZ2mCldHfWQ+QYIAlbS4gQINxeeJ/WgzH32ZGnUkgzlAt5HbkeCErKR/ldp+tXDW2PHmx55B1T/VSv31k7A3Glg6KZkm9kHzEOlvFdGQcGYC1Qzi4gu9PGr5ZubmLHsb71Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770587929; c=relaxed/simple;
	bh=ygHLVQvf13Cv8oj9q9pBIyTvrB7Fok7pLI1My4ZIj50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuHFqyGEjAVoLC4wCf+EzW0e7855o2OstIyGx644quN6ILNzynsViN9vZLvFLz+fKxoLkOWW3q6RAMcpf0dK2QoJ0DToky9t2ku/qAxNiW6nxs2f5ycMDNYS2gBaZPpN2L+jJLff3gaAIgH+ZtwGjbJzYpKx4bou3MBox0Esymg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K23cYOG3; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K23cYOG3"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4094b31a037so2295661fac.1
        for <cgroups@vger.kernel.org>; Sun, 08 Feb 2026 13:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587928; x=1771192728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdck4kEatqeWpIk5x4ugOl36FqvjbgCoyttMgxaBORw=;
        b=K23cYOG3uBJ//B+ooZw/JR7ZMb4vKfan8dQhrBwUXhcADUEs+pw25TNDO88bc92ACw
         oIMKRe467U3MkVWa14TBdEe/cyWSTHZu/YjX6N0O4ip/YjQhj9vIeaAY8BM6B9eMZeC3
         nVQ7FR0SxEdgAty9DzTKDHriSusE5b6Me1nlrYRKDlvQEXhPkWV35DgCqWVkIN5pDPe0
         ptJcKn+QARKmbxST9rlAQ1rxRp/otXfPjrK/uDTNCequcJtX2ZkLdROdbEtt+fknwspt
         wvO2b5+uTE8lCmtjX87nC6icbAD2HmfqgVmQtG+C2H3qOF/1q/m2FCzdgialr7uxYFK6
         3YZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587928; x=1771192728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bdck4kEatqeWpIk5x4ugOl36FqvjbgCoyttMgxaBORw=;
        b=brQKdZDalHZAC/75C12i/h2LlR+2npslUyyo99G/YLheOMDnkB9jWQSbu9djtSU0AP
         mBVwWtzGYEwwfjxZs55NJq3+7DJUDQKlJBEOP/nU+BkRVfbwmnmiPTiREwbmcD0kPP0k
         JkWxDmAHiQnh4bauBQVthaUxhv/pejNPfT7Ar+z6gVBhB1xLbbfszrWiHRzgW4comLbd
         k3/aYDrFE/Hq+3oOwLd3h+82YFYM8lW3kTrT+NMC5H6Cex3Xmm20fGAo4t7PnULxgOpR
         zJhnXkv2qAVSwoMQyEFPrKoLy+pYR3oTujLNUXwsiDLtM4D+MXW7HAhL0U9sio/fgCky
         JCeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvx1WHCSVkQy72FKYupzjccohXJnBKiD+uIqmKArBzB1ReFXQh0Y1AMxaZWrX1dynlc6QBVqRS@vger.kernel.org
X-Gm-Message-State: AOJu0YzCt5li5lr48M48JFk3SJNXrdj5o9XVs4ZSexHuwwsModXdcNHG
	+sCa08FE8tf+nMctoiRHtSa7Il3sUyUINwTZRz0G9LrTmRgh0Wtwlvq1
X-Gm-Gg: AZuq6aLdv5as0cyR1LJAR+6bXb61mY2c2nnmgOeQ5JyHBHaHic+Y+0eb944JyzqLPjw
	6OCDp5Pc9Y2qB8zK/RFaV9+Dqptua/gBf7E4mTj/qApJ+OBvo0qDG4SvR0uVM2AqzwHYnwQ5RCp
	kcBIWYXV6qvIFYbohbP1b9vj7aAwo4BDYfVcxMT+GLYXgf6z99xVfPr1ez3SsYt2zc5vui3VdbG
	XSKk3TaIJLfvqYuO5Q3NnvywRABC9b+l51kUEAbMvusK+wJ3PbWUwe1o2P7QeLgGAOTL+Y4T5uW
	mQ2/HTVHkUA8+5EDfzWgJEaxKOz3UB1E2pVeMzoEQKHUQ31dPZ+532+Flelko4vSSAFwZacwXQi
	15WXh842KZiGJYR7T8iU/0PG1I6+1ZJhW5t3en1d4TOUpOMRxqjhqb10cqYjAT+zDsTemoGTTsR
	B6JIW3HPJoxqk0GUWWlQgo09Ot7N6FuqXn6xfHWBBiPHo=
X-Received: by 2002:a05:6820:986:b0:65f:6655:9db3 with SMTP id 006d021491bc7-66d3262bbfamr4616076eaf.5.1770587927690;
        Sun, 08 Feb 2026 13:58:47 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-670c3849609sm832927eaf.0.2026.02.08.13.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:46 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 02/20] swap: rearrange the swap header file
Date: Sun,  8 Feb 2026 13:58:15 -0800
Message-ID: <20260208215839.87595-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the swap header file (include/linux/swap.h), group the swap API into
the following categories:

1. Lifecycle swap functions (i.e the function that changes the reference
   count of the swap entry).

2. Swap cache API.

3. Physical swapfile allocator and swap device API.

Also remove extern in the functions that are rearranged.

This is purely a clean up. No functional change intended.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 53 +++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df687160..aa29d8ac542d1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -423,20 +423,34 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
-int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
-		unsigned long nr_pages, sector_t start_block);
-int generic_swapfile_activate(struct swap_info_struct *, struct file *,
-		sector_t *);
-
+/* Lifecycle swap API (mm/swapfile.c) */
+int folio_alloc_swap(struct folio *folio);
+bool folio_free_swap(struct folio *folio);
+void put_swap_folio(struct folio *folio, swp_entry_t entry);
+void swap_shmem_alloc(swp_entry_t, int);
+int swap_duplicate(swp_entry_t);
+int swapcache_prepare(swp_entry_t entry, int nr);
+void swap_free_nr(swp_entry_t entry, int nr_pages);
+void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+int __swap_count(swp_entry_t entry);
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+int swp_swapcount(swp_entry_t entry);
+
+/* Swap cache API (mm/swap_state.c) */
 static inline unsigned long total_swapcache_pages(void)
 {
 	return global_node_page_state(NR_SWAPCACHE);
 }
-
-void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
-/* linux/mm/swapfile.c */
+void free_swap_cache(struct folio *folio);
+
+/* Physical swap allocator and swap device API (mm/swapfile.c) */
+int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
+		unsigned long nr_pages, sector_t start_block);
+int generic_swapfile_activate(struct swap_info_struct *, struct file *,
+		sector_t *);
+
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
@@ -452,26 +466,15 @@ static inline long get_nr_swap_pages(void)
 	return atomic_long_read(&nr_swap_pages);
 }
 
-extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio);
-bool folio_free_swap(struct folio *folio);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
-extern swp_entry_t get_swap_page_of_type(int);
-extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
-extern int swapcache_prepare(swp_entry_t entry, int nr);
-extern void swap_free_nr(swp_entry_t entry, int nr_pages);
-extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+void si_swapinfo(struct sysinfo *);
+swp_entry_t get_swap_page_of_type(int);
+int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
-extern unsigned int count_swap_pages(int, int);
-extern sector_t swapdev_block(int, pgoff_t);
-extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
-extern int swp_swapcount(swp_entry_t entry);
+unsigned int count_swap_pages(int, int);
+sector_t swapdev_block(int, pgoff_t);
 struct backing_dev_info;
-extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
 static inline void put_swap_device(struct swap_info_struct *si)
-- 
2.47.3

