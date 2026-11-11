Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406866;
	b=bOqODD1ppjaeaulbA9uck0l95uV5Gmz4HDDcdrm1+9c5QIzylXRbckGwGC5AvaCu8xXq
	 9s7UmYxC2Tr4JKlpgiXtv9uOq3CGtW6/uSA+I+LKEAlFBBm60rmtwcKKFFjqCIVH43DcO
	 X+hTIVJV6AwX5F75WC6J/Okn6g2SSOcPjZaK7Ws4EVfSwZ22exo8yOOjyvfjPWSyVuVDP
	 104aNVWpT0GCJe0WYYtopkIVcz5EoKzyGeQ01oW1WDcNBFiVky5dovnKmYiFuQu7F/Dir
	 4WCOOAmyGZrN1lqKQrR0xE2ZwG1pBNfYYl1j3ZjQ2f3yO7Bz3gA81dEuWdIUMN3CX5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406866;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=ET7iczPctAVnyXFpp6ZDoVXUaxuU2xX/qY9AdNh6SRs=;
	b=jeKaYhJ7IcYQmAyq7EGeE1+HGclzLGGZVxsQIJwh8gvmRFv4MOERHG0y2ZVhB3YfpM4+
	 j0GTr/sqz5ylQgAI9RQkpp/lfC5Au0K3Wnht9rolpmzoCxxeKzl96yTIkVO5N0jr3SUwg
	 yDfdM2wxEWrEm2MrPjV4v4v2HY6Fllfu06Wp7yL9Za/iYwjImHc9fmESrfQcnimfax33s
	 ak5BVqhUX9nb61s7Mv4Rj/bINCrHXHdogYDjUFyr1VujKUWxbR05Yl6MRl6mlr5JT4GBB
	 rOx9pYdBHxScmf0BLzIYUn8iLFkKjYZ6fJOb3f8jNaJo1b3dPhs7tlTy+TSbUPxxI4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="eCmE0tr/";
	arc=none smtp.remote-ip=74.125.227.129
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52914606A335
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 14:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52914606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eCmE0tr/
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3b0d11b85f0so1935427a91.0
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 06:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794406866; x=1795011666; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ET7iczPctAVnyXFpp6ZDoVXUaxuU2xX/qY9AdNh6SRs=;
        b=eCmE0tr/MZkrX7BUUsIj9yu1bWsl3Tll1RUWJUdLvs8yIcskTfpIJ/aibTlwtdz3Eb
         n07+8jdiTBQNZqEueT6YGu1DR/76j97B3wPK///azQljzOU6q8OndHNu3r5CBcwY8jD6
         eVxworTawmYlQP+rREiV/kqjkh3qb97gHr2DP+i1ndCsvK2dgDKfQtxyPasHw30tQoqj
         3wP/n6+0VQtEZmkKeysRhP08DPM/EW+Qfo2Wn7O6xLLkjHJPE36EMwPwTOCMOcjkkghX
         Nk0toQe4JpnWFdxBGWEXCCnwNDVszm61GHSKWsY9NvFTcy59TyUmWwvrrvjJSkiJhE1o
         AHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406866; x=1795011666;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ET7iczPctAVnyXFpp6ZDoVXUaxuU2xX/qY9AdNh6SRs=;
        b=RnhHVog+L5/TcIl+cD7DHf3FNLo1XuPfqbEL4QQKFWS57KG4xpGn7kO3wkBXZYfwPn
         io5T2jOk2p4EieNvQO3B8B3TMWr8QeeOhVs7UK9qZ3gKsnxqzSEIINoqDfFbQbFNqt6q
         svuVFPgznC1QyTh9/EMTtbRInbDSRb3bFDL3DOaji5bURkaPEAHsr5+wR4oz+y1fMVhn
         xEjQa4fg+COhdUjXyFp3MnBrW52MCYuyEEAGB+DHyIwTmaN3n5aPBy0vpc8W6T9oUHwS
         vNAV39Fggeqr9Qv85Kk8/hjgT3l48cp6x9dRwl6AgXGAmr4LreTbSkRRUEYCe84W4Rep
         heUA==
X-Forwarded-Encrypted: i=1; AL+hErG6DbkqkyxGm26CgUvHO/VBzffMP++g80LEVQVX2S1pi/TTYZtsWJZc0jrNet3y7LRW7CuQ1RVu@vger.kernel.org
X-Gm-Message-State: APuU4Z8syo7TOkFyvDw1ifsfUjO7YulVjybJA8Q4J34CcJiCU7dgPpGt
	Cq6tMDvSqM0kwtQdjbIHt82IdJ8ZB+UQ1Oh5soj0EPLqVouTrhuUOEfB
X-Gm-Gg: AYBFou24reSluqZeHc0fgmnpsHYGMlHY7XWbJ8KAsgPtr4TbT4e6gjlnwRtVKKfK7JX
	hOVA4c5K+chVzZPhl8xEFLzjV5MRpNZfSDTHtT/jLwYgkkgeOysDBhx5YV0WFys/PgWmDn/+DEK
	G19pvtw+ggVU7DAeJwV3ZzEKYF/FmBkJ/RBudKbovIjxp3gKxjpXqGq5a8SbBC9eRVzIHJIBuDm
	sNTz2hhonFf1IZ3tMnLdbe1MJt2rGlvXfNeKwMGm3biEq0WkvjECOkHV25ime+txHUzdPRJAsM8
	lAzqKgOUOgE49Qgjhznck68s+BDKMZnRvLfJUBWRGSD8683ssxfK2mdKcFMqGEzir+W1xNv8TVF
	iD7smqtZlP2iRCWibWgLBgrMqgnuNGFvLy4jYi7Ke7l34fI2ueizjN2tzWP8UDySI30+IT7KKLU
	lXfCIa95k8B2Dkke0jO2AXBUcKihzbH2ErAWs64vR5r5AdDArqcHhK4VGeO+1knGWRM65ZYXwFG
	4l+We7zp2OU2vBkKD1O0WDHqlKdQQHklyiuOdUOIU8dohzoKkjT2XepgnRefdKSYpj0wjhkMqsi
	pC6neBxkdkAr24jRaFPJLRZqMVrEDimORBAq1uWO9fJJF/9xnFmIKq4f0252RhTPjpdcDrqDyoo
	Iasw/93tP73ReOqpeH6Z+qefi2w==
X-Received: by 2002:a17:90b:2541:b0:3b0:a757:4f85 with SMTP id 98e67ed59e1d1-3b182df3396mr2481822a91.2.1794406865432;
        Wed, 11 Nov 2026 06:21:05 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b186234c12sm2844333a91.10.2026.11.11.06.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:21:04 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 12 Nov 2026 01:11:35 +1100
Subject: [PATCH] mm: multi-gen LRU: migrate every mm owner on memcg attach
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-mglru-memcg-attach-fix-20261112-v1-1-4c3c707ba922@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2NwQrCMBBEf6Xs2YWmFFv9FfGw2axJxERJ0iKU/
 ruJgsc3M7zZIEvykuHcbZBk9dk/YwV16IAdRSvoTWUY+uGolBow2EdaMEhgi1QKscObf+O/nwy
 PJzOPUz8zVMsrSe2/D5frj/Oi78KladtCUxbUiSK7FgXKRRLs+wdXZ6+snAAAAA==
X-Change-ID: 20261112-mglru-memcg-attach-fix-20261112-7dc49d84708c
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Yu Zhao <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brian Geffon <bgeffon@google.com>, 
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, 
 Oleksandr Natalenko <oleksandr@natalenko.name>, 
 Steven Barrett <steven@liquorix.net>, 
 Suleiman Souhlal <suleiman@google.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0

When a task moves to another memcg, MGLRU should move the mm it owns to
the new memcg's mm list.  mem_cgroup_lru_gen_attach() only checks the
first thread-group leader in the taskset, though.  A taskset can have
several processes, e.g., when +memory is enabled on a parent, or no
leader at all if the leader has exited.  An mm missed this way stays on
the old list, so the new memcg's aging doesn't walk it, and it keeps the
old memcg alive after its memory controller is disabled.

Check every task in the taskset instead.  Skip this when MGLRU doesn't
walk page tables, since lru_gen_migrate_mm() does nothing then.

This takes task_lock() for every task being moved.  Moving a 256-thread
process via cgroup.procs got about 2.8 us (26%) slower in a QEMU/KVM
microbenchmark.

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Reproducers for both cases pass on x86_64.
---
 mm/memcontrol.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..4590a9bfd9ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4762,27 +4762,22 @@ static void mem_cgroup_exit(struct task_struct *task)
 	task->objcg = NULL;
 }
 
-#ifdef CONFIG_LRU_GEN
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
 static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
 	struct cgroup_subsys_state *css;
 
-	/* find the first leader if there is any */
-	cgroup_taskset_for_each_leader(task, css, tset)
-		break;
-
-	if (!task)
-		return;
-
-	task_lock(task);
-	if (task->mm && READ_ONCE(task->mm->owner) == task)
-		lru_gen_migrate_mm(task->mm);
-	task_unlock(task);
+	cgroup_taskset_for_each(task, css, tset) {
+		task_lock(task);
+		if (task->mm && READ_ONCE(task->mm->owner) == task)
+			lru_gen_migrate_mm(task->mm);
+		task_unlock(task);
+	}
 }
 #else
 static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset) {}
-#endif /* CONFIG_LRU_GEN */
+#endif /* CONFIG_LRU_GEN_WALKS_MMU */
 
 static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset)
 {

---
base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
change-id: 20261112-mglru-memcg-attach-fix-20261112-7dc49d84708c

Best regards,
--  
Aveline Noir <jm5905938@gmail.com>

