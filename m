Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD98930F52D;
	Sun, 25 Jan 2026 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769381282; cv=none; b=fwNlt6rN7u5ZKxwdvEuwcbqLfvuoDk9etUJvqjUnni8LtGeoUfk8qeiuzfksTw/5sziU2A9PT0IaTGD/kRguwDC2UCo54qgfljMRb7/5ZWTgDnDKWrQhYD1DAOJ215XW0Q+SAk3pIQS5S5GhLbNVShPwfQiOXx95hWSZ+aYf26c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769381282; c=relaxed/simple;
	bh=FCpWtWiXviPK0JfRDl7l6gUIkKLhd7cslD/kQrH3RoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA+YzZJgRk7q9/3cceQkKN/Jauqxq2IprJAvLfghyuXWIazT+CmjkNZu0Fs+y3elZhzje/2GHcEFBd7QjNgxX7Q2SHKZPud/j/ld6/0Y1Va8wU5RQQQVQxFHvn2JlzE4GNASOzu6GgeIz1D/ADMcyhDdpDIGcAA+MW6RiNGLpy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AvvAZEyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AvvAZEyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0DEC16AAE;
	Sun, 25 Jan 2026 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381282;
	bh=FCpWtWiXviPK0JfRDl7l6gUIkKLhd7cslD/kQrH3RoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvvAZEyEtKaCfqe5rzGN+Pe7C6GMyaY0JllgN4JVMYWGnLlNJNMdrE82nXGnwhGuM
	 ig2aZgk1vOhsGKD2pYrRPiiWKmtUfAKadlZRhaB1yrmh3eS7VR2seQ+xqGKuFuHfSR
	 Xe3L01V3/QzIUf8hJqhxfK9DybKbaI+P+ICudgL1O9w944OVckhr3wBFBAGPdKXFW+
	 53ZA6GDuvwES6ssJ+Rq8iWRon/KwIXxTepltZWSJLs9qqxHWwXCSZ8iJQdkGLBwt87
	 tcu6mPw9TRNqDDyUxf0NxLM88mYLKgvwTbBktZFTFcjcJU3VVNLG8MOcbxDic9KV7e
	 JLkSJiy8P+F6A==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 16/33] sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
Date: Sun, 25 Jan 2026 23:45:23 +0100
Message-ID: <20260125224541.50226-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The HK_TYPE_DOMAIN housekeeping cpumask is now modifiable at runtime.
In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is still pending or executing on a
newly made isolated CPU, the housekeeping susbsystem must flush the
vmstat workqueues.

This involves flushing the whole mm_percpu_wq workqueue, shared with
LRU drain, introducing here a welcome side effect.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/vmstat.h   | 2 ++
 kernel/sched/isolation.c | 1 +
 kernel/sched/sched.h     | 1 +
 mm/vmstat.c              | 5 +++++
 4 files changed, 9 insertions(+)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3398a345bda8..1909b945b3ea 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -303,6 +303,7 @@ int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
 void set_pgdat_percpu_threshold(pg_data_t *pgdat,
 				int (*calculate_pressure)(struct zone *));
+void vmstat_flush_workqueue(void);
 #else /* CONFIG_SMP */
 
 /*
@@ -403,6 +404,7 @@ static inline void __dec_node_page_state(struct page *page,
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
 static inline void quiet_vmstat(void) { }
+static inline void vmstat_flush_workqueue(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_zonestat *pzstats) { }
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index f4053ebf4027..160b3fcab209 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -145,6 +145,7 @@ int housekeeping_update(struct cpumask *isol_mask)
 	synchronize_rcu();
 
 	mem_cgroup_flush_workqueue();
+	vmstat_flush_workqueue();
 
 	kfree(old);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 65dfa48e54b7..2d0c408fca0b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -68,6 +68,7 @@
 #include <linux/types.h>
 #include <linux/u64_stats_sync_api.h>
 #include <linux/uaccess.h>
+#include <linux/vmstat.h>
 #include <linux/wait_api.h>
 #include <linux/wait_bit.h>
 #include <linux/workqueue_api.h>
diff --git a/mm/vmstat.c b/mm/vmstat.c
index ed19c0d42de6..d6e814c82952 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2124,6 +2124,11 @@ static void vmstat_shepherd(struct work_struct *w);
 
 static DECLARE_DEFERRABLE_WORK(shepherd, vmstat_shepherd);
 
+void vmstat_flush_workqueue(void)
+{
+	flush_workqueue(mm_percpu_wq);
+}
+
 static void vmstat_shepherd(struct work_struct *w)
 {
 	int cpu;
-- 
2.51.1

