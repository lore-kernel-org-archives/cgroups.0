From: madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cgroup.c: Use built-in RCU list checking
Date: Sat, 18 Jan 2020 08:40:51 +0530
Message-ID: <20200118031051.28776-1-madhuparnabhowmik10@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kCkFnYkawO75Slclr1NGNbFjc/K/Z8ax1mgdyxXyluc=;
        b=kFFMSn6GQbVrsB7xcz6GHNYsvWVsZtZLtyarkvcW4Qjn8R2Vlklx5fkrNTwwRZulTD
         Jjnj/FKMP1+IzHx8ruolwTiB6z+Z3Y8NZWo1QTXIis3LaKm2v0/NYOdnner2pO9hrV3U
         Ock9seKbMjAL63Xn7eeqrCFS6F4e3bYHJIFHESFv0x7zzpG5oh2xf5aR0alR+kcSYnxC
         LG9Aeugqhvwf/kv2MkGt9FH7Y2RXdgoKAowTagWQUeVtagogRbE2cDQ/xhduU5oOB2Hz
         CMgcvKpqoCE6iquWtUM+Fqj57BHjyIdrVoGA6eEf5Rud/K6I9FFqrL1asp7kDWRlW57+
         0S7A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, frextrite-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Madhuparna Bhowmik <madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Madhuparna Bhowmik <madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

list_for_each_entry_rcu has built-in RCU and lock checking.
Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when  CONFIG_PROVE_RCU_LIST is enabled
by default.

Even though the function css_next_child() already checks if
cgroup_mutex or rcu_read_lock() is held using
cgroup_assert_mutex_or_rcu_locked(), there is a need to pass
cond to list_for_each_entry_rcu() to avoid false positive
lockdep warning.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 735af8f15f95..c2959764ad95 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4152,7 +4152,8 @@ struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
 	} else if (likely(!(pos->flags & CSS_RELEASED))) {
 		next = list_entry_rcu(pos->sibling.next, struct cgroup_subsys_state, sibling);
 	} else {
-		list_for_each_entry_rcu(next, &parent->children, sibling)
+		list_for_each_entry_rcu(next, &parent->children, sibling,
+					lockdep_is_held(&cgroup_mutex))
 			if (next->serial_nr > pos->serial_nr)
 				break;
 	}
-- 
2.17.1

