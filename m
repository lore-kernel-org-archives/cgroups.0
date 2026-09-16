Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384ED3DB64A
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 12:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563481; cv=none; b=oycPd8dvQcka4oQVh7jv9D66+PCtSBL7WC+GsNSJRaVMtgz9F1u+gE+AtbPUzDViWF+5UDkfR+F32Z5WkVKRURFtfmeewvbGquZdvVVzRAx8OT1RuXa7juzyj/H6zq5r5hP5V/Id+rCcYGP07KB4hJQB+7ipsgB1BMBrgqpDFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563481; c=relaxed/simple;
	bh=IEvxqzkAIU0FGe2oQrIZRwY8Wtj6UnkhqHeEjHY4lJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvZ+Q0yfydeksJx7HAOLDeyfjs80RK5Hs+LgNrI6Dt1tpM5a/qy5JMqdOxVX1SWAPDvHCSe37N2x+xgpmYv20Mw8Sv34jZ8HlZw/Ft0kiFy4iuZb9X7cLwo/e2cSTgS5LAHDrJqnOVhS7n3tXubJpk62FypknHACJJp1iypoXUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RBS8eGq6; arc=none smtp.client-ip=91.218.175.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RBS8eGq6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IEvxqzkAIU0FGe2oQrIZRwY8Wtj6UnkhqHeEjHY4lJA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563477; v=1; x=1790168277;
 b=RBS8eGq66dNjw/qupi3hQrAX1hPenzn0BBU2G0YAcEZmy3604q4V2quHRloawK1GWoYLrqXQ
 /iem2lOctPUNA6qiu6suOgsiF0bu7oBHaK0zuz+D6yoi7NfZsVcCtC2Z/DhkweWZugVddyHGx8V
 galXZSfyQYd3+T+EElFAPCvk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e1f141b1710aa4f6;
	Wed, 16 Sep 2026 12:57:57 +0000
X-Mizu-Trace-ID: e1f141b1710aa4f6
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 1/3] mm, memcg: introduce struct mem_cgroup_v1
Date: Wed, 16 Sep 2026 20:57:35 +0800
Message-ID: <20260916125737.1095414-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The legacy cgroup v1 memory controller keeps its state as individual
members guarded by CONFIG_MEMCG_V1 inside struct mem_cgroup.  While the
v1 implementation already lives in mm/memcontrol-v1.c and its interface
is behind CONFIG_MEMCG_V1, its data is still intermixed with the shared
layout of struct mem_cgroup.

Group the v1-only members into a dedicated struct mem_cgroup_v1 and
embed it via a union whose anonymous side reproduces the historical
layout.  All existing memcg->X accesses keep compiling and the binary
layout is unchanged.  The anonymous side is dropped by the next patch
once the access sites are converted.

No functional change.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 include/linux/memcontrol.h | 97 ++++++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..beb68f39c321 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -193,6 +193,43 @@ struct obj_cgroup {
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
  * to help the administrator determine what knobs to tune.
  */
+/*
+ * Legacy cgroup v1 memory controller state, used only by the v1
+ * interface (mm/memcontrol-v1.c).
+ */
+struct mem_cgroup_v1 {
+	struct page_counter kmem;
+	struct page_counter tcpmem;
+
+	struct memcg1_events_percpu __percpu *events_percpu;
+
+	/* protected by memcg_oom_lock */
+	bool oom_lock;
+	int under_oom;
+
+	int oom_kill_disable;
+
+	struct mutex thresholds_lock;
+
+	/* RCU-protected */
+	struct mem_cgroup_thresholds thresholds;
+
+	/* RCU-protected */
+	struct mem_cgroup_thresholds memsw_thresholds;
+
+	/* For oom notifier event fd */
+	struct list_head oom_notify;
+
+	bool tcpmem_active;
+	int tcpmem_pressure;
+
+	/* List of events which userspace want to receive */
+	struct list_head event_list;
+	spinlock_t event_list_lock;
+
+	int swappiness;
+};
+
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
@@ -271,42 +308,50 @@ struct mem_cgroup {
 	__cacheline_group_end_aligned(memcg_cold);
 
 #ifdef CONFIG_MEMCG_V1
-	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
+	/*
+	 * Transitional: the anonymous struct reproduces the historical layout
+	 * so existing memcg->X accesses keep compiling; it is removed once the
+	 * access sites are converted to memcg->v1.X.
+	 */
+	union {
+		struct mem_cgroup_v1 v1;
+		struct {
+			/* Legacy consumer-oriented counters */
+			struct page_counter kmem;		/* v1 only */
+			struct page_counter tcpmem;		/* v1 only */
 
-	/* Legacy consumer-oriented counters */
-	struct page_counter kmem;		/* v1 only */
-	struct page_counter tcpmem;		/* v1 only */
+			struct memcg1_events_percpu __percpu *events_percpu;
 
-	struct memcg1_events_percpu __percpu *events_percpu;
+			/* protected by memcg_oom_lock */
+			bool oom_lock;
+			int under_oom;
 
-	/* protected by memcg_oom_lock */
-	bool oom_lock;
-	int under_oom;
+			/* OOM-Killer disable */
+			int oom_kill_disable;
 
-	/* OOM-Killer disable */
-	int oom_kill_disable;
+			/* protect arrays of thresholds */
+			struct mutex thresholds_lock;
 
-	/* protect arrays of thresholds */
-	struct mutex thresholds_lock;
+			/* thresholds for memory usage. RCU-protected */
+			struct mem_cgroup_thresholds thresholds;
 
-	/* thresholds for memory usage. RCU-protected */
-	struct mem_cgroup_thresholds thresholds;
-
-	/* thresholds for mem+swap usage. RCU-protected */
-	struct mem_cgroup_thresholds memsw_thresholds;
+			/* thresholds for mem+swap usage. RCU-protected */
+			struct mem_cgroup_thresholds memsw_thresholds;
 
-	/* For oom notifier event fd */
-	struct list_head oom_notify;
+			/* For oom notifier event fd */
+			struct list_head oom_notify;
 
-	/* Legacy tcp memory accounting */
-	bool tcpmem_active;
-	int tcpmem_pressure;
+			/* Legacy tcp memory accounting */
+			bool tcpmem_active;
+			int tcpmem_pressure;
 
-	/* List of events which userspace want to receive */
-	struct list_head event_list;
-	spinlock_t event_list_lock;
+			/* List of events which userspace want to receive */
+			struct list_head event_list;
+			spinlock_t event_list_lock;
 
-	int swappiness;
+			int swappiness;
+		};
+	};
 #endif /* CONFIG_MEMCG_V1 */
 
 	/*
-- 
2.43.0

