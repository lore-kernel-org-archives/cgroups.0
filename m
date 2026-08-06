Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B164D2ED5
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 19:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044183; cv=none; b=MwLXuvDolgYHq7lvtl7DSpD9sLzX1a3SfPY0v8/ps5FStMmW8BTdt+84zCaPjVUcFeTZPCoICcIPVj79b8EfUd/8maYIzy2f6R4xhz7BDDOHxSjRY/qBDYZggjQboSoRkvFxrEOVJO7nn8YdXQ3LfNkDPtjBmU8i170D6yZSr34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044183; c=relaxed/simple;
	bh=ME7CCmjQSMxbxa8R/0a230jAQXzXTBvmZaSkqnRSTRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbQG1V+MTSdWdU9u3IMwCXeE93oJLAzfj5lZq10iLVg8tXQH0LM6xfEylbVUQr9UCdpjeT+C116mni48uh4fEDG5vNJtyir8av5t0ylVxxz5hrQbZ84NqrKDxfmGZ+bUDFOz/UjApPuiN3H/A3aiduISDmq+v0ic1JglNvHcz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=nq4ZPLbm; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="nq4ZPLbm"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso9559276d6.1
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 12:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786044172; x=1786648972; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ed/LSBroZxO0PfqLTAzd0hHdaL+KK4UGWxAVAlrHj6I=;
        b=nq4ZPLbmS95ANh0DLp/PNHeV0PsEKwswoBK7SaMtY/pGormBLk5+i/JeFCGtkBdRf2
         PczvFwzLgGQBETd4n3wb9LqZm72B+Ucf4LOIbtDZfHQMBjkOPih4hlduWLIH6kLWrGHy
         4R1yYbIh9Hd0/Lsy3hK02LR2W4STMMBmexQGMeq/vo7yAffMI7d3/nEMi18F3vUXiVEV
         X4WT9lQh6xJW5RRb+vQKXEONRruDp6D7cGRv5nNM4OZMh53AydJYwT2g6Sei+/Zx3UI9
         PSXACM73PUlhG1UYS6QmelBoqR9qnsswfoGCmDAsnOA5B2dSXMpGz7v4+47xBK+3A9cf
         cA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044172; x=1786648972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ed/LSBroZxO0PfqLTAzd0hHdaL+KK4UGWxAVAlrHj6I=;
        b=Dps+Tij3QT2UlxQjDEZJozqGOw6M5ubkZKnl7kI70U/7vyeNGF9HnWeSC8f3V2NtCL
         lBaYbEQ77lFRE0gePlt/MmWVTFfxdzYlf1fk7Nz8hicXG0nIOf6L6krnAwK3CEcFbe/p
         2ppU7zsEZv7xIUmaBEMfidamNj5g5Y/x4Wpf6xoMYTcQ5w4Df/i1HliAOuHpraVxBj/q
         k23iSQvco54Bkh7o7ENA7jX3d/pafhbC5zc4Wutzyl/P0Ht/DIT6ugmIbu9JkA7bgQCH
         KpUolBuDMA+ydRtP7nXY9GGQM2Qww5RckfdmyP+2S96j5fKJGXGecABPYiqCqlzaffZZ
         pq7w==
X-Forwarded-Encrypted: i=1; AHgh+Ron70SH/VmEEnnYmw+sg3mKJTlDeKhDFIbTH6h62DLg8ifOjyLzPq5kajBjjeIWldRt5b/Ni646@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/WNUGrzQPUIJ9iU0ErDmjPxh2L904HuYdK5oUG8oIynE4YfYm
	Y7C4GkQYs95/dKkSZ2MJZl6p7BcAk40SnmV+gzIubQ1Ytnqhz57Z8YPKmozz/BYXSfqZc7vAGnD
	ukM3a
X-Gm-Gg: AR+sD12rJI8Fl0ITqVmxRRW3XR7h7AJYxxcjtPZIyOPwujSq3dnGEbAgehHrxw87mMb
	7m5mrfJbrh1rmIkbtak6h2sm8v9pg9s/KI++F6BKTBmAtssExAxod2hXdpPWIXlh9rgHY69FTxe
	N6Q/DDB/wjzPapIJfOE0ZT+XIBzwFCTnkT0Z1cTn46E7WjvnCwgHlDF3+eXICumIB6f+49GrRYn
	GyVJO7hYkxHHDSNeNOV9P1jqBve4rHe4+eI+FcZao9PCsK78ziRBE8RsW97RNuc4H5U/WG1owHo
	qR2ZupGkv+Xv5XgbKEqbt7dIRARy6e+dCQzol8bnPQwMpT4alUrHEShSPHweafNPHYd7zo+GDUZ
	9dmfA64xZYugTEe6dSERa2XFRw5onOZlxO76woiHoJxi6HhrCoWJiTSNET9rA3MWGRYcuLpn9bX
	eslDbq1il8h9y0OVhgB82NoKqqGz/sUulXiBguVZiUDGu0ScZK9xTLluKk0Ik=
X-Received: by 2002:a05:6214:3210:b0:8ee:756a:bc32 with SMTP id 6a1803df08f44-90893232a46mr86763646d6.15.1786044172481;
        Thu, 06 Aug 2026 12:22:52 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800cabedsm58786346d6.46.2026.08.06.12.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:22:51 -0700 (PDT)
Date: Thu, 6 Aug 2026 15:22:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] memcg: keep folio's objcg same as its node
Message-ID: <anTfChWlK998-7sY@cmpxchg.org>
References: <20260806165813.2526415-1-shakeel.butt@linux.dev>
 <anTPPr5hVV4aQLRD@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTPPr5hVV4aQLRD@cmpxchg.org>

Hm, it's still not quite right.

When there is a root mismatch, we cannot fall back to committing the
old objcg. That would reintroduce Karl's issue. Not as broadly as
before, but can still happen if the memcg tree died up to the root.

So we have to commit to the new objcg, always.

What obj_cgroup_is_root() then comes down to is whether uncharge will
balance the page counters or not.

mem_cgroup_replace_folio() gets a new charge for the new page. We can
just conditionalize that right away on whether the new objcg will
actually uncharge.

mem_cgroup_migrate() currently trades the charge, but that won't work
if the new objcg is root and won't uncharge. So we have to settle it
right then and there.

This?

@@ -5319,6 +5319,46 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 		uncharge_batch(&ug);
 }
 
+/*
+ * An LRU folio must hold the objcg belonging to its own node.
+ *
+ * memcg_reparent_objcgs() reparents a dying cgroup one node at a time:
+ * the folios on that node's LRU lists move to the parent and that
+ * node's objcg is redirected to the parent, atomically under the
+ * node's lru_lock. folio_lruvec_lock() relies on this to provide a
+ * stable folio<->lruvec binding. If a folio holds another node's
+ * objcg, its list membership and its lruvec resolution change in
+ * separate lock sections, and an LRU operation in between can re-add
+ * the folio to, and strand it on, the LRU list of a dead memcg.
+ *
+ * So when migration transfers the memcg state to a folio on another
+ * node, re-derive the objcg for the destination node. If the memcg is
+ * dying and the destination node has already been reparented, the
+ * lookup walks up to the nearest live ancestor - which is also where
+ * that node's LRU lists went.
+ *
+ * Returns the objcg to commit to @new, with a reference for the caller.
+ */
+static struct obj_cgroup *get_migration_objcg(struct folio *old, struct folio *new)
+{
+	struct obj_cgroup *old_objcg, *new_objcg;
+	int new_nid = folio_nid(new);
+
+	old_objcg = get_obj_cgroup_from_folio(old);
+
+	if (folio_nid(old) == new_nid)
+		return old_objcg;
+
+	rcu_read_lock();
+	new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						new_nid);
+	rcu_read_unlock();
+
+	obj_cgroup_put(old_objcg);
+
+	return new_objcg;
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5347,21 +5387,27 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	if (folio_memcg_charged(new))
 		return;
 
-	objcg = folio_objcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!objcg, old);
-	if (!objcg)
+	VM_WARN_ON_ONCE_FOLIO(!folio_objcg(old), old);
+	if (!folio_objcg(old))
 		return;
 
+	objcg = get_migration_objcg(old, new);
+
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	/* Force-charge the new page. The old one will be freed soon */
+	/*
+	 * Force-charge the new page. The old one will be freed soon.
+	 *
+	 * The rootness of the committed objcg decides whether the final
+	 * uncharge of @new goes through the page counters (see
+	 * uncharge_folio()); charge them only if the uncharge will.
+	 */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5373,14 +5419,15 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
  * @new: Replacement folio.
  *
  * Transfer the memcg data from the old folio to the new folio for migration.
- * The old folio's data info will be cleared. Note that the memory counters
- * will remain unchanged throughout the process.
+ * The old folio's data info will be cleared. The memory counters remain
+ * unchanged, unless the charge moves out of a fully reparented ancestry
+ * and has to be settled (see below).
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *new_objcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5401,12 +5448,30 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
-	/* Transfer the charge and the objcg ref */
-	commit_charge(new, objcg);
+	new_objcg = get_migration_objcg(old, new);
+
+	/*
+	 * @old was charged through a non-root objcg, so its charge is in
+	 * the page counters. If the re-derivation walked up to the root
+	 * objcg - @old's entire ancestry is dying and already reparented
+	 * - the final uncharge of @new will skip the page counters (see
+	 * uncharge_folio()). Settle them now: this is @old's eventual
+	 * uncharge, moved up to the point where its charge record ends.
+	 */
+	if (obj_cgroup_is_root(new_objcg) && !obj_cgroup_is_root(objcg)) {
+		rcu_read_lock();
+		memcg_uncharge(obj_cgroup_memcg(objcg), folio_nr_pages(old));
+		rcu_read_unlock();
+	}
+
+	commit_charge(new, new_objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
 	old->memcg_data = 0;
+
+	/* @new holds its own reference now, drop @old's */
+	obj_cgroup_put(objcg);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
