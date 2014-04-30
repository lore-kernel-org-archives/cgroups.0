From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 4/9] mm: memcontrol: catch root bypass in move precharge
Date: Wed, 30 Apr 2014 16:25:38 -0400
Message-ID: <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=EHzGJDizDfHYuEpVuvuy18gBzAVMRvmTUEYLqGSpl+8=;
	b=Aa3gYgauVC+5HfroTIHTsrl/OhAKcSdC2iUzVYUzBNSqyzIg2fpyA0j52Dy32dEZoTn+S2e6ukv82u5D7R4dLnKq1g4+WX0uFqAZB4vnd6JDPY1z3Hf/JpzOjPFh1sL/rVnsa6KL8Mbn+eLGDnApTdnASMalj5wegswOjcoGlGk=;
In-Reply-To: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

When mem_cgroup_try_charge() returns -EINTR, it bypassed the charge to
the root memcg.  But move precharging does not catch this and treats
this case as if no charge had happened, thus leaking a charge against
root.  Because of an old optimization, the root memcg's res_counter is
not actually charged right now, but it's still an imbalance and
subsequent patches will charge the root memcg again.

Thus, catch those bypasses to the root memcg and properly cancel them
before giving up the move.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c431a30280ac..788be26103f9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6546,8 +6546,9 @@ one_by_one:
 			cond_resched();
 		}
 		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
+		if (ret == -EINTR)
+			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
 		if (ret)
-			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
 		mc.precharge++;
 	}
-- 
1.9.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
