From: Qian Cai <cai@lca.pw>
Subject: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Tue,  4 Jun 2019 10:00:36 -0400
Message-ID: <1559656836-24940-1-git-send-email-cai@lca.pw>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HA9nmzXQ1v1EpP1te6eSn7ZdKChVSouT7677WSi9nIU=;
        b=FjD0vS909bew//7s7kZ4U68BxVAcYNK5lIoo28VJ0iR1cKCHo5uwPCWhKdZwvb5R3h
         l+JLi7kgdhHQ1mXfsVZvplZ78xwVC8/ftBcb4Y1CP7AfT7ECrvsLzhzJmhjoXKQ+9YfW
         jkK1KfkjNxpW1xSRKQnYK4mvUMqCOfcP73zC3WHA+ooGIl+psI9Q4jqvA7bBCK7mH9Ef
         w3/bC3nfoSs3iDZfv8dHX2070J87acrVGFg6U4tChzCNpv8wZEvISzXrFjF4d2cH+dQg
         CW65qtmF/xSV9/UwnhEaWAjNq9r1a+ZARBE5OytTmcBx9/3tgsvUzYwtXDaZM5w9ZTBz
         LD/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: rppt@linux.ibm.com, will.deacon@arm.com, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

The commit "arm64: switch to generic version of pte allocation"
introduced endless failures during boot like,

kobject_add_internal failed for pgd_cache(285:chronyd.service) (error:
-2 parent: cgroup)

It turns out __GFP_ACCOUNT is passed to kernel page table allocations
and then later memcg finds out those don't belong to any cgroup.

backtrace:
  kobject_add_internal
  kobject_init_and_add
  sysfs_slab_add+0x1a8
  __kmem_cache_create
  create_cache
  memcg_create_kmem_cache
  memcg_kmem_cache_create_func
  process_one_work
  worker_thread
  kthread

Signed-off-by: Qian Cai <cai@lca.pw>
---
 arch/arm64/mm/pgd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
index 769516cb6677..53c48f5c8765 100644
--- a/arch/arm64/mm/pgd.c
+++ b/arch/arm64/mm/pgd.c
@@ -38,7 +38,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (PGD_SIZE == PAGE_SIZE)
 		return (pgd_t *)__get_free_page(gfp);
 	else
-		return kmem_cache_alloc(pgd_cache, gfp);
+		return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_KERNEL);
 }
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-- 
1.8.3.1

