Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275636;
	b=QhYQiLtZMEPNvqlYRTC+tCiyLsTve2RkFhqn7xVKwAPY/PjCVvHvTkvet1ZbRd5QWAVl
	 rSuj6yaczWVx6nrzIeTcSPOc8tHZjj7nJlGATYy4+ggXUvYi/nW97FH5cv4HIhwYKUQXF
	 o+G6kksLi+B6/VvEu9whEQapuGuaSKKq8OrvpNqt9hh8jkOJ4r3hH/J/Y9S7TGbK7h/65
	 Bnvene0T74kUfc7x3PfIyuRu2cCPsm/YQ9a37AAYaYIwiPbuRhg7SvSQx4ye4aVadZdV6
	 vHDfGt61yuJZFdyowNbw/KF5nvXrAsRyxAVaD9yRWROv5MY2npAI9PnwInSQZk7s3hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275636;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fUH2iaJE8DQ9XreGrrxcpLj5+gSWzYR66IHD/grDUA0=;
	b=Hk10m5brNHCW+vRsZvyTNssumHAFQOwqTWXZ75YDhzorOcDX8L+kHdbyt9DjVPosWgRM
	 f+TpfG98zmEAHm49iXRw3dLbJjI6jM7/2t74uRIhBbLd+uHe13N7RbJ7gkH4VBIyOWRjW
	 VXl+AAstk2VcNWKJh+4s7Jy+ZHZnhlz9mbgUGU+kqeXZtRp+LxBU3H1f1jkRBzDSQpNAH
	 cqmsVd2PPEoRjR6vRE6EOzWtIMmcumo/YH+i3IBPueYMiTcafoUF+6DZNdi+gajYdq5nt
	 RzLvySFkdIiejU4S4pUBXCYl/b4SJtYczSB8fXiIdyNST1PnDl8gURZse5tfKWhxohA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zNZkOMb7;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D511606A326
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 01:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D511606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zNZkOMb7
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b0e61a4decso1170620a91.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 17:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275635; x=1794880435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fUH2iaJE8DQ9XreGrrxcpLj5+gSWzYR66IHD/grDUA0=;
        b=zNZkOMb77hSKJWxWb3v9tQ3foYpQvLz1XpPjkyaETLTGdQMSFBmjlu2/TZ6o0uLlsD
         T7YGK3a3rSiwoTq0WUiGc7IqiVpN4GFS1beKsPt2PjiOBTU4H9z2M2Wu4Qdf9r3Nzd0o
         MzvzMSpSCdh2Cz9tsr9PE0YviRLCetxyqjrzVk0cqJoRuB8mIspOCrRMndUBAzSan5Fj
         fzIKtXMhD03QHlbkp/VtkVRMLeu6Y/TsthDQVwN9cB45HFyBVADsMAS3QhrQlywAM9Ty
         CajSpB34Kax/Oztsso9HtT6jOc+X8uKwnGLfeTGaqJmrpHXph7qYpagru3ABD2N2V7wx
         6u5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275635; x=1794880435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fUH2iaJE8DQ9XreGrrxcpLj5+gSWzYR66IHD/grDUA0=;
        b=oMILggvQRixnOsEBkM1NXpYPNsOmjhuBxbErmzn/tOIUAMypveVEoz6KEOJF7ApVLU
         VJj7/biVVpUs10IyGZgHttsu08y7VEYarVXUvwO6GyuaFICjkBuctCWntDuQDmpAKvpy
         Ap7S+LEbkJPh9u/mBgHMd8y+sOnxfZXW7g7SH9RL5ESsxgCNg7E+PxXdvfvd/J+Jlbe1
         0ZsHs1Nuib46Ts5TKiOxVbB3PJE24U6EcKN0mNA2/9g8kmYZ9peQHTvXhIrYodfd5/28
         6qCEE9eJr9WBEYZvuWp2Oy/13QzyhjW8Ii8yjgDCtLerKI6+bXdD/mjp99uTq9n19L49
         ak5A==
X-Forwarded-Encrypted: i=1; AL+hErG7N1l2TVN3bD2o5RbCTYiXHWRfFF5ekh/wyeF2SAY4nqpB0KvYkYEWgbbpogweim5vOVO5SvMr@vger.kernel.org
X-Gm-Message-State: APuU4Z//jiPdmNFxtqNMUrx0rNwadmpeKD8iCCP9VN7xPohezXmnp66u
	ZsEvUzmIDggqta12SfQXDFssT5MZEK7/eKBYld5Zi6eIkkVAQ5DpUspX
X-Gm-Gg: AYBFou0ItJLjVLw3yO9H4xhcAX3V/2N1zPo7EU9Dt7MVkFUB3cG4456ngrpo/QDAYLA
	RCs3e5LCsfsmYXxthgoLUlU7h3LbaJtFuyIffOY7TlLt716aQZ2vq2pqChm86FXpZcOFHdH37f0
	CNbUS2Zo45EQMu/qxcCnfOmloGDESzart79vSE/NOlPEogA5yxRhQERJWA92Dd81DX+9r6TNs5K
	seIBctvVF6ADcaVJkqAyzCDtD+WRZ9fIh2djBnPk7KFmNfKO45188P+N6HsAxWYSf5Naf33jfst
	RQhAvRGsRDmxNTC+KrWhvwm9qfnepbMy9nVxjqgUPfQNhObrMF29PhiUdn4JMoMIz2sqXRTOqhW
	FOEB90aNybOZcmKvJC/a5UhmdiyHZAlUkRouHdg1KrOGYYvSMnWvOtuE9MSWXyCmmzZp5zZDEsk
	Un7kU5EpVutKC96SE+q9+vk0h54P8cLmhPmtgR3cNSASBSUrqf6Nb+Fnx/wMbXoeAZtLiTIUcUO
	yjE+nZR+7eZcsaCNdJyYMaCDpR8KpGsHh+xIoeWix6r2eEiAQOJ7d4PiQwsRByy8L1G+fFFQs3/
	MyUP0wWsZyUpmBf0yCRWU3sbk7TriJey4wf/EaCR0f8kqejHLtRPct36C7Wm8rH7dKtU0ESOsnB
	p94QYHg==
X-Received: by 2002:a17:90b:1c09:b0:3b0:9a2e:b491 with SMTP id 98e67ed59e1d1-3b166d31311mr1425834a91.66.1794275634865;
        Mon, 09 Nov 2026 17:53:54 -0800 (PST)
Received: from localhost ([2a03:2880:ff:58::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1678d1c0csm1631708a91.6.2026.11.09.17.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:53 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 2/4] mm: memcg: read root lruvec stats from the node counters
Date: Mon,  9 Nov 2026 17:53:19 -0800
Message-ID: <20261110015321.611093-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the root memcg, lruvec_page_state() returns the rstat value, which
needs a flush to be up to date. Flushing the root memcg is expensive, as
it flushes every memcg in the system.

Most memcg node stats only track memory charged to a memcg, so the root
memcg's hierarchical value equals the node counter, which is always up
to date and doesn't need a flush. For those stats, have
lruvec_page_state() and lruvec_page_state_monotonic() read the node
counter for the root memcg, as they already do when memcg is disabled.
Callers that only read the root memcg's own lruvec then no longer need
to flush it, which the following patches take advantage of. It also
makes the root memcg's stats more accurate, as callers that ratelimit
the flush can otherwise read values that are seconds old.

The exceptions are the kernel memory stats (slab, kernel stack, page
tables, secondary page tables and vmalloc), hugetlb, and
WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
objects). Their node counters also count memory that isn't charged to a
memcg, which falls into two categories:

a) the allocation isn't accounted to any memcg (eg kernel page tables,
   or hugetlb when hugetlb accounting is off)
b) the allocation is accounted, but it comes from a task running in the
   root cgroup, and the root memcg isn't charged for it

As such, these stats still need to read the rstat value, since the node
counter value can be higher than the rstat value.

One user-visible change is that the root memcg's memory.numa_stat (and
the hierarchical_* entries of the cgroup v1 memory.numa_stat) now
reports the node counters for the non-excluded stats, as it reads
lruvec_page_state(). This is more accurate, but as a result, it may not
exactly match the root memcg's memory.stat, which still reads the rstat
values.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ebc9330aeae..2575bf2ba0ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -389,7 +389,14 @@ ino_t page_cgroup_ino(const struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_cgroup_ino);
 
-/* Subset of node_stat_item for memcg stats */
+/*
+ * Subset of node_stat_item for memcg stats.
+ *
+ * Stats whose node counters can also count memory that isn't charged to a memcg
+ * must be listed in node_stat_includes_unaccounted(). Otherwise,
+ * lruvec_page_state() returns the node counter for them for the root memcg,
+ * which can be larger than the root memcg's actual value.
+ */
 static const unsigned int memcg_node_stat_items[] = {
 	NR_INACTIVE_ANON,
 	NR_ACTIVE_ANON,
@@ -504,13 +511,52 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
+/*
+ * Whether the node counter for @idx can also count memory that isn't charged
+ * to a memcg (eg kernel memory that isn't accounted). For these stats, the
+ * node counter can be larger than the root memcg's value, so the root memcg
+ * has to read its rstat value instead.
+ */
+static bool node_stat_includes_unaccounted(enum node_stat_item idx)
+{
+	switch (idx) {
+	case NR_SLAB_RECLAIMABLE_B:
+	case NR_SLAB_UNRECLAIMABLE_B:
+	case WORKINGSET_NODERECLAIM:
+	case NR_VMALLOC:
+	case NR_KERNEL_STACK_KB:
+	case NR_PAGETABLE:
+	case NR_SECONDARY_PAGETABLE:
+#ifdef CONFIG_HUGETLB_PAGE
+	case NR_HUGETLB:
+#endif
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * Whether @lruvec should read the node counter for @idx instead of its rstat
+ * value. For the root memcg, stats that only count memory charged to a memcg
+ * have the same hierarchical value as the node counter. The node counter is
+ * preferred since it is always up to date, whereas the rstat value needs a
+ * flush, which for the root memcg flushes every cgroup in the system.
+ */
+static bool lruvec_use_node_stat(const struct lruvec *lruvec,
+				 enum node_stat_item idx)
+{
+	return mem_cgroup_is_root(lruvec_memcg(lruvec)) &&
+	       !node_stat_includes_unaccounted(idx);
+}
+
 unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
@@ -551,7 +597,7 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	const struct mem_cgroup_per_node *pn;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-- 
2.52.0

