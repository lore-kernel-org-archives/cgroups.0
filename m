From: Tejun Heo <tj@kernel.org>
Subject: [PATCH for-4.6-fixes] memcg: remove lru_add_drain_all() invocation
 from mem_cgroup_move_charge()
Date: Fri, 15 Apr 2016 15:17:19 -0400
Message-ID: <20160415191719.GK12583@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2fARWTu9gtMo4iF3G9bESh2dSY3Y3Sv54wjSfoOZqmQ=;
        b=PhZlFWTmXzF8Mk60TK+FzVbrqUJwQhGloPv7CkY9lnJvHAUsu7BY8NFMsMYB1ggVsA
         ezJJjiin7lzJQhb0nT5kFeEtzHhEfmetLQe0/xOIDGE0K/YVIw6UfiK7x1QSYSpHGghf
         g/x/WerVsq+HsmGvXA3+IaOxMg8pCB/FarlM1GGaidhOBMKW81/ctWFI00iaQLwNY/uz
         AqyBOyMgpbdb8GYg+bk+h0+PKeeHDGvScfOuljbGYe1TolNrAimZvPfY2RWrGsc2QTkL
         uFoIaP8KlgOyDtp0dNbD2ogNuqwA9nxo8C5NibxKhKLLNQZYsnNVpI8dadi+ekbkkxm1
         IROA==
Content-Disposition: inline
In-Reply-To: <20160414175055.GA6794@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Petr Mladek <pmladek@suse.com>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org

mem_cgroup_move_charge() invokes lru_add_drain_all() so that the pvec
pages can be moved too.  lru_add_drain_all() schedules and flushes
work items on system_wq which depends on being able to create new
kworkers to make forward progress.  Since 1ed1328792ff ("sched,
cgroup: replace signal_struct->group_rwsem with a global
percpu_rwsem"), a new task can't be created while in the cgroup
migration path and the described lru_add_drain_all() invocation can
easily lead to a deadlock.

Charge moving is best-effort and whether the pvec pages are migrated
or not doesn't really matter.  Don't call it during charge moving.
Eventually, we want to move the actual charge moving outside the
migration path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Fixes: 1ed1328792ff ("sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem")
Cc: stable@vger.kernel.org
---
Hello,

So, this deadlock seems pretty easy to trigger.  We'll make the charge
moving asynchronous eventually but let's not hold off fixing an
immediate problem.

Thanks.

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36db05f..56060c7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4859,7 +4859,6 @@ static void mem_cgroup_move_charge(struct mm_struct *mm)
 		.mm = mm,
 	};
 
-	lru_add_drain_all();
 	/*
 	 * Signal lock_page_memcg() to take the memcg's move_lock
 	 * while we're moving its pages to another memcg. Then wait
