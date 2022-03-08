From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/3] mm: use vmalloc_array and vcalloc for array allocations
Date: Tue,  8 Mar 2022 05:59:17 -0500
Message-ID: <20220308105918.615575-3-pbonzini@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqPCGU3/YxaZYETOn7Lp2yXhW5De7uTDNtK+spwoHhQ=;
        b=B8zRqxlj6tUvCIQEM0VATH5HXq17MrfwGV3ViUWOV4vl031ZRMEgGx5T9J+onLDN06Qxqb
        tHujEFEjhRHlDq5Gi44oTZjKbFxoJrD/wPVdnwDqMfcuVGKi5XaoETPb7eW3XD9uVssC6H
        iZwqU8SssokTdQuOtS9lzwlk7nsOnQw=
In-Reply-To: <20220308105918.615575-1-pbonzini@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org

Instead of using array_size or just a multiply, use a function that
takes care of both the multiplication and the overflow checks.

Cc: linux-mm@kvack.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 mm/percpu-stats.c | 2 +-
 mm/swap_cgroup.c  | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/percpu-stats.c b/mm/percpu-stats.c
index c6bd092ff7a3..e71651cda2de 100644
--- a/mm/percpu-stats.c
+++ b/mm/percpu-stats.c
@@ -144,7 +144,7 @@ static int percpu_stats_show(struct seq_file *m, void *v)
 	spin_unlock_irq(&pcpu_lock);
 
 	/* there can be at most this many free and allocated fragments */
-	buffer = vmalloc(array_size(sizeof(int), (2 * max_nr_alloc + 1)));
+	buffer = vmalloc_array(2 * max_nr_alloc + 1, sizeof(int));
 	if (!buffer)
 		return -ENOMEM;
 
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 7f34343c075a..5a9442979a18 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -167,14 +167,12 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 int swap_cgroup_swapon(int type, unsigned long max_pages)
 {
 	void *array;
-	unsigned long array_size;
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
-	array_size = length * sizeof(void *);
 
-	array = vzalloc(array_size);
+	array = vcalloc(length, sizeof(void *));
 	if (!array)
 		goto nomem;
 
-- 
2.31.1



