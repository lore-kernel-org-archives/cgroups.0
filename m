From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-4.6-fixes] memcg: remove lru_add_drain_all() invocation
 from mem_cgroup_move_charge()
Date: Thu, 21 Apr 2016 11:56:52 -0400
Message-ID: <20160421155652.GM7822@mtj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tAd6A9uGPp48sDVJl3sohHH7k8QYD/lzL1WOKxd+pmg=;
        b=zbaDzf5YB45qi0oI5/+N0ziSlVH/szjY+s+w8G5mUCFFIA0t14h7fu2gvfvW1Op7jW
         HU2VwR9GCxLEkvNf3BuMux0JS5prLRlpNmaPiql1mJnVbOSupvz6815ivyjewJssDt85
         V4LiP+2oiBEE8HCBO3Rnt/sdFC5wYuNsVHTfFqyofaCkq1dZiASBchXGsGHIoRtzZEnD
         gOV6rF1068qDZT2m9Ofe8L1iH3FgCsBCxHJzLnMKAtwozGeYJrunLSsVKG0ybJnYvfXU
         U8H4NIkB52VCpmgdaGAXXZEBvaRAhkm60MfB2vG0ltHOQqkbWThvdbL+t/coSA0b1j2S
         CYFw==
Content-Disposition: inline
In-Reply-To: <20160415191719.GK12583-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Debugged-and-tested-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Reported-by: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Fixes: 1ed1328792ff ("sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.4+
---
Hello, Andrew.

This fixes an easily triggered deadlock when using memcg charge
moving.  While the issue requires more invasive changes, which are
being worked on, to plug completely, this works around the immediate
issue.  Can you please route this through -mm?

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
