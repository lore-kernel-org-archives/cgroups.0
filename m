Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692847;
	b=XYPkUpFOIQek2jswR9+N48qzELuPPJqxDN7eooQ9F1YBxtxraVjx8QoVOIRAPMtmmrs0
	 jNii1UyDCTNwA0bwkqjQOhLKtNbL2qvuxwhBccAXqcVUMRsF+5juP7xi5+vmbI7MdEgrd
	 87Gs9b5H3mDM47kaOKD/gHxhBpNgqU6NxyS1hDgBQ0x5KSfVhMROznl+td+/ljHx39iK0
	 lyQtUb8FrrxsC+/FbIxVXsFBu9tgEAUQwOx0R1KiSZrB683MXhChYKENz9AmBUkIiOK+V
	 rRZs6TVtupsdRiGdIqJAzy3g/b2KB+kOFUfByiBBSqVyZ8d45ePCk2vn4/EG0bZTpkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692847;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=axvLEFAtLHuXEMPFGyntKrpt+rf9qpIaNSM/g7iVnHA=;
	b=4z7QNxmJFYht/UblDQUT/Nm0tSDnMNJ5dQ4nzt6SDfHdx0qcd2GfwEy4dwkq0Jf9mqNC
	 DT/vStRulBzLEfoQKdkBFM7+yaGeDXYXmmLLVJH8R18DCXSbZqEVjYBEn/wvauFbpS+pk
	 Of2NvVKnlII7wU1o02a1oIVZlUVR1kTKTLzsUztxA9AafuhnwEoU/2DJE9TOH0Qn3gKeX
	 Q1Uak/JTwsIcOih6eoh4Mhu47t55mnC9r7EIJVegpLmbrWdA3eU/h6oPZhDwDyrytgLQB
	 X3Boy9/LXszuYDBC6ltOzhhrWcQJKGsGzrhbv6kd3s7oKR1cM7ceEukV/o6MidsGpBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TkbN7JC4;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65880606A32F
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65880606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TkbN7JC4
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9C62F3F4D6
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692844;
	bh=axvLEFAtLHuXEMPFGyntKrpt+rf9qpIaNSM/g7iVnHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=TkbN7JC4NwqwaC8NlTPVX/z0ilUl0WHS85fzKdAsXkY2S3lCCkCafb5uW3wMznFqa
	 hXOoWSGdS4uYj+BQrSVsUoq3i3TCwB4sIYpQhEzvJq2Q/rGCo3jWE1rWY8mAISJv7n
	 fQ0z3ycWoMEhu8Ae4o3M54WwrNFGkm+j+MQ4dSrwkvJUB+nCY/V/aqyRXSRq2YvH6F
	 ebSDs/NRiNOhRY0FdCzlFQF7uHHwB0P5YS0SXMgqODf2Fa+9xsPXUmxQA4ZweNmo2t
	 x56+D/u/jDkNrUL0GdmNazJkgC+kG2f4ihQq01MDpzvxCvvKIvw4rXMwQEZYpoKC9o
	 Er5zf8sX3yQ53VTLE8j7+xyHR0lqAMZzfF1TT8ijpSBasT+UaBgwafhE235h4GjS03
	 wu7LQBv2vtjzsznTJC+w8rFQ3D9EupmUopDCUqCbz07pdvrH5UJAoGyRgmjpoWzY0z
	 xQmgwTJmDPCMOjoTmvE3TWjWU5/VbMIKoiGqR2bxbU/pDgHIHeXLCPQj1KES8LXhd6
	 BzhdNA/n1AdHw64yga6Ul6PrAdOIGITUZWU6ImoV7WGk0Q7MQcaV6zmCrMiurTcyVB
	 fRnEDhn+jPMXKQITdX9nfGSBnXlawAoOLf01P38gwr38Op/7es+qRYwWKXWOGMsluu
	 gRQjUo+kqELeGE80P3LmFDrc=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3662e7a9299so15571196eec.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:00:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692843; x=1794297643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=axvLEFAtLHuXEMPFGyntKrpt+rf9qpIaNSM/g7iVnHA=;
        b=0CI/H6ySdxaIHPuB31UmJOEtTfkUfG+oS+yR+xFRSgbG2L4/q87oaUbYnGuF9S++4+
         H4bBS8OYvK0Psf/RZyROgwKJkrH3YC9lrMmycUqiV8sTYsD6YsdvLfyzX8PobafXoun7
         MP07K2w7HJBgD+8O09UaY9sx/6kzLvUtRS1XVpalotAqQs6Sd0vuN+WcC4Rj44V6lrmq
         pyi92idkTcmHmr2ZZs/8l8iVLDROiKWTnKBITO4CZTztSEIyvMCg5tD0p0Sn0g2XV5g5
         AA6f4XlCLmhVDlRu5GjGXQNJ4lIUVjpCgNUzNZLIe6i8twSEpoQccYRB3qKcuonQ98IC
         Rx3g==
X-Forwarded-Encrypted: i=1; AKwUvBw/Qppj56tzWArF3+/rMyvM8ioxNJPb5Vlnf46/JOh36PL9BMvrH78hr8TWRgUOuivc9ShGNsCs@vger.kernel.org
X-Gm-Message-State: APuU4Z9ekZ19Lut/jYpKe5x4rBvB1spATr790hV16lHx8TQsUpvABnQU
	Lnv/cOdpr+GXlqydzDQpxGYqcFb9zmD1GEP9Fog0ZdLnVa4fY9UHdDkJHy6gDIzboDDWGtiq+2E
	6nmeVmKVdAl3crnbHbfCi0zdoT2HdetM69P2KIffDj1iZ44fR3rCCpzTXKuv8ZIXi0EizfHgIBE
	4=
X-Gm-Gg: AYBFou0FrynksGVn4dm2gpxL/TS//Ev7j0t0yBkmbtiUv5g7NQLBINClpl3tBCxgwM1
	aS9n3caUst9lM1et+ikGLOJX4sFCxq2rkTacxE3Yc9JpdrOe8i2W6PAyNCUllfa+9ja9ZfepSWz
	6bvtllmiYf4Qsyy5E2DU3j35Cj7T32KPJKh45+c4ej5aeQqQDWTH0l0KWq9hcZmboLEMHSXwUwG
	K1ycaNK4FDDFrR178LLnilZaFFMp581hY6cudNeAlMCFPEiY5XqI2LCdDZeH9ugAv9QIhFXNbMs
	cEI2Kjd2ZNnxjRVTVlqvdTsfvzyGryzsqd97TXUtzsWWcft82VV/0hU7vDBN1C9vfegkL9LPCuR
	8K3CNqOAXcFIOePnWVfdxIk/+B9gGVIBtowB/Cd366EQnYGLz9HJbq0Rg+YPZqknRdBpt5JLwvF
	Nfbu7BQN+u9zW/jmcUCw==
X-Received: by 2002:a05:693c:65d6:b0:368:72f0:353a with SMTP id 5a478bee46e88-36a42431e17mr15518451eec.38.1793692842702;
        Tue, 03 Nov 2026 00:00:42 -0800 (PST)
X-Received: by 2002:a05:693c:65d6:b0:368:72f0:353a with SMTP id 5a478bee46e88-36a42431e17mr15518408eec.38.1793692842058;
        Tue, 03 Nov 2026 00:00:42 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:41 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU LRU caches on isolated CPUs
Date: Tue,  3 Nov 2026 20:59:37 +1300
Message-ID: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
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

From: Caron Wills <caron.wills@pulsar.com>

Folios are collected in per-CPU folio batches (cpu_fbatches and
mlock_fbatch) before being added to or moved on the LRU lists. Another
CPU can only empty such a batch by queueing lru_add_drain_per_cpu() on
the owning CPU and waiting for it in __lru_add_drain_all(), which is
what every lru_add_drain_all() caller (compaction, khugepaged, memory
hotplug, memfd, drop_caches, ...) and every lru_cache_disable() caller
(page migration through cpuset.mems, mbind() and move_pages(),
alloc_contig_range(), memory offlining) does.

On an isolated CPU that per-CPU kworker may not run for a very long
time, or ever: low latency deployments pin a SCHED_FIFO busy-polling
thread to each isolated CPU, and since RT bandwidth throttling is gone
nothing forces such a thread to yield to a SCHED_NORMAL kworker. Any
folio left in that CPU's batch then blocks the waiting caller.

LP: #2165410 hits exactly this. Writing cpuset.mems for a cgroup on a
192-CPU AWS instance with nohz_full CPUs 18-95,108-178 running FIFO
spinners makes cpuset_migrate_mm_workfn() -> do_migrate_pages() ->
lru_cache_disable() -> __lru_add_drain_all() -> flush_work() wait for
the kworkers on those CPUs, and PID 1 (systemd), which flushes the
migration workqueue from task_work before returning to userspace, stays
in D state for 2 to 10 minutes. logind cannot create sessions meanwhile
and SSH logins fail. The reproducer, a FIFO/80 thread per isolated CPU
that touches and MADV_DONTNEEDs a 24 MB buffer in a loop, keeps 1 to 14
folios in the lru_add batch of every isolated CPU at all times.

Stop batching on isolated CPUs: when the current CPU is isolated, move
the folio to the LRU immediately through an on-stack batch, without
touching the per-CPU batch at all. The latter matters: __lru_add_drain_all()
samples the per-CPU counters without the owning CPU's local_lock, so a
folio that sits in the batch even for the few instructions between
folio_batch_add() and an immediate drain is enough to get work queued on
that CPU. A first version of this patch reused the lru_cache_disabled()
add-then-drain path and was caught doing exactly that in testing.
cpu_needs_drain() now stays false for isolated CPUs and
__lru_add_drain_all() never queues work on them. The per-CPU buffer_head
LRU has been skipping isolated CPUs the same way since commit 8a237adf213d 
("fs/buffer.c: disable per-CPU buffer_head cache for isolated CPUs"),
and mm/memcontrol.c schedule_drain_work() does not queue memcg stock drains
on them either.

The cost is one lruvec lock acquisition per folio instead of one per
batch of 15 on isolated CPUs, which are not expected to do bulk memory
work. Nothing changes on housekeeping CPUs or on systems without CPU
isolation, where cpu_is_isolated() is a static-key guarded test.

Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 mm/folio.c    | 21 ++++++++++++++++++++-
 mm/internal.h | 28 ++++++++++++++++++++++++++++
 mm/mlock.c    | 28 ++++++++++++++++++++++------
 3 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..7f85747910d7 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -208,6 +208,16 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	folios_put(fbatch);
 }
 
+/* Move a single folio to the LRU without touching the per-CPU batches. */
+static void folio_move_lru_now(struct folio *folio, move_fn_t move_fn)
+{
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
+	folio_batch_add(&fbatch, folio);
+	folio_batch_move_lru(&fbatch, move_fn);
+}
+
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
@@ -220,7 +230,9 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+	if (lru_batching_bypassed())
+		folio_move_lru_now(folio, move_fn);
+	else if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
@@ -856,6 +868,13 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
 	smp_mb();
 
+	/*
+	 * Isolated CPUs don't batch folios (see lru_batching_bypassed()), so
+	 * their counters stay at zero and no work gets queued to them.  This
+	 * matters because the per-CPU kworker of an isolated CPU may not get
+	 * to run for a very long time, if ever, and flush_work() below would
+	 * wait for it.
+	 */
 	cpumask_clear(&has_work);
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..5888f7b5ea5c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -17,6 +17,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
+#include <linux/sched/isolation.h>
 #include <linux/leafops.h>
 #include <linux/tracepoint-defs.h>
 
@@ -1006,6 +1007,33 @@ bool need_mlock_drain(int cpu);
 void mlock_drain_local(void);
 void mlock_drain_remote(int cpu);
 
+/*
+ * Folios are normally parked in per-CPU batches (cpu_fbatches and
+ * mlock_fbatch) before they are moved to the LRU lists. A remote CPU can
+ * only empty such a batch by queueing lru_add_drain_per_cpu() on the owning
+ * CPU and waiting for it, see __lru_add_drain_all(). On an isolated CPU that
+ * kworker may not get to run for a long time, e.g. because a SCHED_FIFO task
+ * busy-loops there, and every lru_add_drain_all() or lru_cache_disable()
+ * caller in the system then blocks behind it.
+ *
+ * Isolated CPUs therefore bypass the per-CPU batches entirely and move
+ * folios to the LRU lists right away, through an on-stack batch. The folio
+ * must not even transiently sit in the per-CPU batch: __lru_add_drain_all()
+ * samples the batch counters without the owning CPU's lock, so the few
+ * instructions between folio_batch_add() and an immediate drain are enough
+ * to get work queued on the isolated CPU. The per-CPU buffer_head LRU
+ * (bh_lru_install()) and the memcg stock drain (schedule_drain_work())
+ * already stay away from isolated CPUs the same way.
+ *
+ * Callers hold the batch's local_lock, so smp_processor_id() is stable. The
+ * housekeeping cpumask consulted by cpu_is_isolated() is RCU protected.
+ */
+static inline bool lru_batching_bypassed(void)
+{
+	guard(rcu)();
+	return cpu_is_isolated(smp_processor_id());
+}
+
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 static inline unsigned long __vma_address(const struct vm_area_struct *vma,
diff --git a/mm/mlock.c b/mm/mlock.c
index 67ae9b18b923..3bb8195e5c5f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -209,6 +209,16 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 	folios_put(fbatch);
 }
 
+/* Handle a single folio right away, without touching the per-CPU batch. */
+static void mlock_folio_now(struct folio *folio)
+{
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
+	folio_batch_add(&fbatch, folio);
+	mlock_folio_batch(&fbatch);
+}
+
 void mlock_drain_local(void)
 {
 	struct folio_batch *fbatch;
@@ -254,8 +264,10 @@ void mlock_folio(struct folio *folio)
 	}
 
 	folio_get(folio);
-	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (lru_batching_bypassed())
+		mlock_folio_now(mlock_lru(folio));
+	else if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
+		 !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -277,8 +289,10 @@ void mlock_new_folio(struct folio *folio)
 	__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 
 	folio_get(folio);
-	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (lru_batching_bypassed())
+		mlock_folio_now(mlock_new(folio));
+	else if (!folio_batch_add(fbatch, mlock_new(folio)) ||
+		 !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -298,8 +312,10 @@ void munlock_folio(struct folio *folio)
 	 * which will check whether the folio is multiply mlocked.
 	 */
 	folio_get(folio);
-	if (!folio_batch_add(fbatch, folio) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (lru_batching_bypassed())
+		mlock_folio_now(folio);
+	else if (!folio_batch_add(fbatch, folio) ||
+		 !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
-- 
2.55.0

