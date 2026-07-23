Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36932471417
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818234; cv=none; b=DiTcg7rvomZxOmTSNhv2lI8MzBZqoODijX8m4sqb1JIza6MYopA7/5+znrnW+yTnerBZo3mIsbU+r81FDfkoJm+bZ0iqPQnQOuf/5jB4FGdsellT5qL/QuxoCzaeSyPyhVkNpVxwVwXOVA3gDFseWk/JIPTNxQ5VXizjsLE5aFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818234; c=relaxed/simple;
	bh=6NlNGEP0Y09x3sooTcs+Yg7XmATSEEilWDXsyOnW1Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AR5V2oCo11ddnuTcDMgfb+A7mRqqrgeeSXxvPB5rygzdiB0PnjDY++Toi2koMzxZ90IbX/3PAlikZek/aEl9bttOnyb1zZv8zCxomK217OplU8GtjHJt0o1JHCHTSf6EuXPK0E2Aw8+6W6+kYsyUBrwzZKDLZyypq3gIAyd4r6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZKA7kqHJ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZKA7kqHJ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c166f1bbeaeso128931966b.0
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784818226; x=1785423026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sMNX+3I4sgI7mC5rRPgv1P42neSWIMRKOJpGLsqrlQ8=;
        b=ZKA7kqHJtP41or9/QAlqVFdIikjn5+leaPSq7QCC9bFS79PY0w0i/3+f6QPCLF1Y3D
         SWtwuNnZcwE5U5A/YtQ45oM2TDaPt1qSsBl8rIYhksDQUFt7OYsy83c4ghHygebrrNTP
         TqgBPP8iWqoeJ2lBNqITEmYvisekurwUE9aSwxs5GSdFCt7cq9KWzsxEUl44sMejrB+N
         XBubEeS8u1XZGnB0SC59mcHYj7ItDmeQ2LLaFWR4wAWr7zKfXLz6C9uppN9Ky0Xf7ecY
         725X2jpLPDLVulYGKMeLfP9ibzmfVvZID6m1q7jPGlkQw6sjgqFDhNMmllGtbemeZT0k
         QmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784818226; x=1785423026;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sMNX+3I4sgI7mC5rRPgv1P42neSWIMRKOJpGLsqrlQ8=;
        b=TzARJTLqrPPez4KKIlrV0l18AnFUU3xoXc6hZO9Dys8ooTi+R55pEdkAkOHn0sIQdu
         IBWOclg2VkZqH+cYC+msX9g7inq9Ye3nA2pHmsQ20xsrzDjaFxyhvhpiPAU22VrDVYJq
         DBUmFdEJnHKnWxUpx47r0qQLWGqhDVebH2dqtHCHYgupQ3BbkDaI7RY0n1xWvnebISEU
         66egL5LIOxrN77CauNPbxvM13m22BmLdaNmFCkz/8n2CqOmW1Eg+7x3Kzs8nCRtusyIT
         FJFGV9Mb2WoKGtUyl3/9BZfu9ax3WEQpZ0NZlQzj/Gh6rDA4jJXvueKvGo0Spyd3rvca
         lVYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrVARumg8eE2iiUtUACgDdkC1XKiBDLNbPAQdBsd6gXEUCm/10/X5oOUDRgrzcptezPc3pL+RQy@vger.kernel.org
X-Gm-Message-State: AOJu0YwbD25lRNgqp3Rb1PjWDD/9quNq1OhsSAP4wPopB02CR/C/Wxh/
	o6dRdJ8QZ0QsARyTmUzZtmTuQNbp5IqEGrg7kq11xqmU/O+UoTpUeuKq
X-Gm-Gg: AR+sD13xcOWp2Rn51FNqxyN3a0KKh7hwAlz0ITM15SjbeptOpuxWMWygSF+O9WUPlaK
	+sFWOuBFAU2Hrd8JBafTFA483KWBZf3+A7GBv/55J0ac+pDZzMBh4PboaR3Zt7x7wZRTscHPda6
	yxNoUAyQdrTshgbCNgz8AiYHuSM2usX9OpxSPSrJialS7K2NtodzloU5Nlc6wQC3qAZ8D1zbdp9
	mqe++2QZsDgnUoEA1RF+oCcqK/jveQCpxLHm9YoLFsX5ZtvtZ59jFLV2Hhit8kJhrn9Mcm2/xxm
	dXavb0Y+zAjqGS/VeuQeOT7iiuOO9dtwmoHysV8laso37wBfteiCLbWNp/YojOPvMNlACDpcdsy
	UmNHQ7VLEGlKu0Qf52Z0n+JKss7y/QnH2utF7jq1Ir9FSQwmV4AxWsfZtrq0rGVKTJewoDdLdHn
	+jGWfuJYR0S4iziehX1pQgum9VP/mX6/nKRHYwDr+odWxYf0msziUTTbCEo3Cf6Awf3Q==
X-Received: by 2002:a17:907:d649:b0:c16:e3b:7d6 with SMTP id a640c23a62f3a-c1c50d8eacdmr161031766b.54.1784818225309;
        Thu, 23 Jul 2026 07:50:25 -0700 (PDT)
Received: from debian.lan ([155.117.85.25])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ac6ff3sm245282166b.19.2026.07.23.07.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:50:23 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: baohua@kernel.org
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
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
	baolin.wang@linux.alibaba.com,
	hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 23 Jul 2026 22:49:55 +0800
Message-ID: <20260723144955.374136-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
References: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On Tue, Jul 21, 2026 at 04:15:13PM +0800, Barry Song wrote:
>On Fri, Jul 17, 2026 at 8:25 PM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
>>
>> folio_alloc_swap() reports most allocation failures with a generic
>> negative error code. Reclaim cannot tell whether splitting a large folio
>> could make progress or whether there is no backing space at all.
>>
>> Track the global free swap count around the allocation attempt and let the
>> memcg swap charge path cap it by the remaining hierarchical swap margin.
>> Return -E2BIG for large folios when a smaller allocation might still fit,
>> -ENOSPC when no swap space is available, and -ENOMEM when the failure is
>> not helped by splitting.
>>
>> This only refines folio_alloc_swap() return codes. The reclaim caller is
>> updated separately.
>>
>> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>> ---
>>  include/linux/swap.h | 10 ++++++----
>>  mm/memcontrol.c      | 10 +++++++++-
>>  mm/swapfile.c        | 21 +++++++++++++++------
>>  3 files changed, 30 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 7a09df6977a5..0695ac56457f 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>>  #endif
>>
>>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
>> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
>> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
>> +                                long *nr_swap_pages);
>>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
>> -               swp_entry_t entry)
>> +               swp_entry_t entry, long *nr_swap_pages)
>>  {
>>         if (mem_cgroup_disabled())
>>                 return 0;
>> -       return __mem_cgroup_try_charge_swap(folio, entry);
>> +       return __mem_cgroup_try_charge_swap(folio, entry, nr_swap_pages);
>>  }
>>
>>  extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
>> @@ -592,7 +593,8 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>>  extern bool mem_cgroup_swap_full(struct folio *folio);
>>  #else
>>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
>> -                                            swp_entry_t entry)
>> +                                            swp_entry_t entry,
>> +                                            long *nr_swap_pages)
>>  {
>>         return 0;
>>  }
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1e10f493d2a9..7c9e7072fb39 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
>>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>>   * @folio: folio being added to swap
>>   * @entry: swap entry to charge
>> + * @nr_swap_pages: optional swap availability to cap by memcg margin
>>   *
>>   * Try to charge @folio's memcg for the swap space at @entry.
>>   *
>>   * Returns 0 on success, -ENOMEM on failure.
>>   */
>> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
>> +                                long *nr_swap_pages)
>>  {
>>         unsigned int nr_pages = folio_nr_pages(folio);
>>         struct page_counter *counter;
>> @@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>>         rcu_read_lock();
>>         memcg = obj_cgroup_memcg(objcg);
>>         if (!entry.val) {
>> +               if (nr_swap_pages && !mem_cgroup_is_root(memcg))
>> +                       *nr_swap_pages = min(*nr_swap_pages,
>> +                                            page_counter_margin(&memcg->swap));
>
>This looks a bit odd. Could we decouple *nr_swap_pages from margin and
>have the function always return margin instead?
>
>I don't think this function needs to care about the initial value returned by
>get_nr_swap_pages(). While folio_alloc_swap() may depend on it, they're
>different software layers, and we shouldn't couple them together.
>
>
>>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>>                 rcu_read_unlock();
>>                 return 0;
>> @@ -5509,6 +5514,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>>                 mem_cgroup_private_id_put(memcg, nr_pages);
>> +               if (nr_swap_pages)
>> +                       *nr_swap_pages = min(*nr_swap_pages,
>> +                                            page_counter_margin(counter));
>>                 return -ENOMEM;
>>         }
>>         mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 9174f1eeffb0..53a921ca099a 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1690,12 +1690,14 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>>   * swap cache.
>>   *
>>   * Context: Caller needs to hold the folio lock.
>> - * Return: Whether the folio was added to the swap cache.
>> + * Return: 0 on success, -E2BIG if splitting the folio might allow swapout,
>> + * or another negative error code if splitting would not help.
>>   */
>>  int folio_alloc_swap(struct folio *folio)
>>  {
>>         unsigned int order = folio_order(folio);
>>         unsigned int size = 1 << order;
>> +       long nr_swap_pages;
>>
>>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>>         VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
>> @@ -1706,7 +1708,7 @@ int folio_alloc_swap(struct folio *folio)
>>                  * the caller should split the folio and try again.
>>                  */
>>                 if (!IS_ENABLED(CONFIG_THP_SWAP))
>> -                       return -EAGAIN;
>> +                       return -E2BIG;
>
>We could also have the case where we're running out of swap space and it's not
>worth splitting, even when THP_SWAP is disabled.
>
>>
>>                 /*
>>                  * Allocation size should never exceed cluster size
>> @@ -1714,10 +1716,12 @@ int folio_alloc_swap(struct folio *folio)
>>                  */
>>                 if (size > SWAPFILE_CLUSTER) {
>>                         VM_WARN_ON_ONCE(1);
>> -                       return -EINVAL;
>> +                       return -E2BIG;
>
>Similar to the above.
>
>>                 }
>>         }
>>
>> +       nr_swap_pages = get_nr_swap_pages();
>> +
>>  again:
>>         local_lock(&percpu_swap_cluster.lock);
>>         if (!swap_alloc_fast(folio))
>> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>>         }
>>
>>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>> -       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
>> +       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
>> +                                               &nr_swap_pages))) {
>
>As explained above, we shouldn't couple two different software layers.
>don't use nr_swap_pages() as the initial value of memcg charge.
>
>Best Regards
>Barry
>

Thank you very much for the careful review, Barry. You're right that
passing the value from get_nr_swap_pages() into the memcg charge path
unnecessarily couples two separate layers.

How about the patch below?

This version keeps global swap availability and the memcg swap margin
separate. When swap allocation or charging fails, the memcg charge path
reports only the remaining margin in its own hierarchy.
folio_alloc_swap() checks global swap availability separately and uses
the two results to select the return code.

If swap slot allocation succeeds but the memcg charge fails, the global
allocation has already succeeded. In that case, folio_alloc_swap() uses
the remaining memcg margin alone to choose between -E2BIG and -ENOMEM.

The early rejection paths now return -E2BIG only when splitting may
still make progress, addressing the cases you pointed out for
CONFIG_THP_SWAP=n and size > SWAPFILE_CLUSTER.

I added mem_cgroup_get_folio_swap_margin() to return the minimum
remaining swap capacity across the memcg hierarchy associated with a
folio. Unlike mem_cgroup_get_nr_swap_pages(), it reports only the memcg
constraint and does not combine it with the global free swap count.

I also added folio_alloc_swap_error() to avoid duplicating the checks
that decide whether to return -ENOSPC, -ENOMEM, or -E2BIG. Do you think
this helper is worthwhile, or would it be clearer to keep these checks
directly in folio_alloc_swap()?

Thanks again for pointing this out.

The updated patch follows:

 include/linux/swap.h | 16 ++++++++++++----
 mm/memcontrol.c      | 33 ++++++++++++++++++++++++++++++++-
 mm/swapfile.c        | 31 ++++++++++++++++++++++++-------
 3 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..87c58f69d11d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *swap_margin);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-		swp_entry_t entry)
+		swp_entry_t entry, long *swap_margin)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, entry);
+	return __mem_cgroup_try_charge_swap(folio, entry, swap_margin);
 }
 
 extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
@@ -588,11 +589,13 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(entry, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     swp_entry_t entry)
+					     swp_entry_t entry,
+					     long *swap_margin)
 {
 	return 0;
 }
@@ -602,6 +605,11 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
 {
 }
 
+static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	return PAGE_COUNTER_MAX;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e10f493d2a9..0ebbbaffb522 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
  * @entry: swap entry to charge
+ * @swap_margin: remaining memcg swap margin if allocation or charge fails
  *
  * Try to charge @folio's memcg for the swap space at @entry.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *swap_margin)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
@@ -5495,6 +5497,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!entry.val) {
+		*swap_margin = page_counter_margin(&memcg->swap);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5509,6 +5512,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
+		*swap_margin = page_counter_margin(counter);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
@@ -5554,6 +5558,33 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return nr_swap_pages;
 }
 
+/**
+ * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
+ * @folio: folio whose memcg margin is queried
+ *
+ * Return: Remaining chargeable pages in the folio's memcg hierarchy.
+ */
+long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	long swap_margin = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (mem_cgroup_disabled() || do_memsw_account())
+		return swap_margin;
+
+	objcg = folio_objcg(folio);
+	if (!objcg)
+		return swap_margin;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	swap_margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return swap_margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..f90ee2de53fa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1682,6 +1682,16 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+static int folio_alloc_swap_error(struct folio *folio, long swap_margin)
+{
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (swap_margin <= 0)
+		return -ENOMEM;
+
+	return folio_test_large(folio) ? -E2BIG : -ENOMEM;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1690,23 +1700,26 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: 0 on success, -E2BIG if splitting the folio might allow swapout,
+ * or another negative error code if splitting would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	long swap_margin = PAGE_COUNTER_MAX;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. The error
+		 * classifier decides whether the caller should split and retry.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			return folio_alloc_swap_error(folio,
+				mem_cgroup_get_folio_swap_margin(folio));
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1714,7 +1727,8 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			return folio_alloc_swap_error(folio,
+				mem_cgroup_get_folio_swap_margin(folio));
 		}
 	}
 
@@ -1730,11 +1744,14 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
+						&swap_margin))) {
 		swap_cache_del_folio(folio);
+		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		return folio_alloc_swap_error(folio, swap_margin);
 
 	return 0;
 }
-- 
2.47.3

