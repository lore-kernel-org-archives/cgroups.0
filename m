From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 07/12] mm: memcontrol: catch root bypass in move precharge
Date: Mon, 16 Jun 2014 15:54:27 -0400
Message-ID: <1402948472-8175-8-git-send-email-hannes@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=Na51WgmbTHupcPwszgLiAM8Xxuhni2lrDUZleVXa/aA=;
	b=BvPy1yhuO5VQa/ICe3izYm7p2l+0VTS5rHpE9Bk9bg0CKcg09x4DB9hmRXDnpjK/FpLD4trLpbj/6LATN1yOmn3l9Hk8jNe1i5WPZgQGFcGWIJG1h+3YYj0YCpmjpj7VJbbgYgPVNE8x43h1Qi1Pso7wc4r+IOSC+I7MPwdwFeQ=;
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

When mem_cgroup_try_charge() returns -EINTR, it bypassed the charge to
the root memcg.  But move precharging does not catch this and treats
this case as if no charge had happened, thus leaking a charge against
root.  Because of an old optimization, the root memcg's res_counter is
not actually charged right now, but it's still an imbalance and
subsequent patches will charge the root memcg again.

Catch those bypasses to the root memcg and properly cancel them before
giving up the move.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d9df94896a7..a3b69d4a6f17 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6389,6 +6389,10 @@ static int mem_cgroup_do_precharge(unsigned long count)
 		mc.precharge += count;
 		return ret;
 	}
+	if (ret == -EINTR) {
+		__mem_cgroup_cancel_charge(root_mem_cgroup, count);
+		return ret;
+	}
 
 	/* Try charges one by one with reclaim */
 	while (count--) {
@@ -6396,8 +6400,11 @@ static int mem_cgroup_do_precharge(unsigned long count)
 		/*
 		 * In case of failure, any residual charges against
 		 * mc.to will be dropped by mem_cgroup_clear_mc()
-		 * later on.
+		 * later on.  However, cancel any charges that are
+		 * bypassed to root right away or they'll be lost.
 		 */
+		if (ret == -EINTR)
+			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;
-- 
2.0.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
