From: David Rientjes <rientjes@google.com>
Subject: [patch -mm] mm: memcg: remote memcg charging for kmem allocations
 fix
Date: Sun, 18 Mar 2018 13:24:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803181318530.241887@chino.kir.corp.google.com>
References: <20180305182951.34462-1-shakeelb@google.com> <20180305182951.34462-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=2W/02XBuWIo95g142aAkDkpAeBEC6wtcHwEmwOp8Cc8=;
        b=Ar5vIRqKr3XXOWr7061vrSh8B44m78Wctiq7Xz+CZm8mj+J33fyZxNEtnC06a+yfnO
         fDPI+zteruVsAiu9FsnX4FdlmM5uI0qOBoHPzXVbp8VIZMlaKkpMhP3F+gawAuqK+biM
         NqI84ZOWgURL3reE7YRobt6iSAlVnfGauvUwbxcynyK9eDWkKVcFxVnEoB3ipMf6VBAn
         8kHB+K+pVvCxTvim6bK7OndeNH5nEGzUCUW2VxJIOYXTxz0y30lBFItJ5dt6UZf2RPSo
         APF4ddn7JPZa0xRPdrfckQ4uqoEV9u9tIH9RGe4MyrBXtbFmnSrSbIC4467GiXPch0bn
         zYWA==
In-Reply-To: <20180305182951.34462-2-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

fix build warning for CONFIG_SLOB:

mm/memcontrol.c:706:27: warning: 'get_mem_cgroup' defined but not used [-Wunused-function]
static struct mem_cgroup *get_mem_cgroup(struct mem_cgroup *memcg)

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -701,15 +701,6 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return memcg;
 }
 
-static struct mem_cgroup *get_mem_cgroup(struct mem_cgroup *memcg)
-{
-	rcu_read_lock();
-	if (!css_tryget_online(&memcg->css))
-		memcg = NULL;
-	rcu_read_unlock();
-	return memcg;
-}
-
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -2128,6 +2119,15 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 }
 
 #ifndef CONFIG_SLOB
+static struct mem_cgroup *get_mem_cgroup(struct mem_cgroup *memcg)
+{
+	rcu_read_lock();
+	if (!css_tryget_online(&memcg->css))
+		memcg = NULL;
+	rcu_read_unlock();
+	return memcg;
+}
+
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
