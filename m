From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RESEND, PATCH 4/6] memcg: fix broken boolean expression
Date: Mon, 16 Jan 2012 13:54:16 +0200
Message-ID: <20120116115416.GA25687@shutemov.name>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
 <1325883472-5614-4-git-send-email-kirill@shutemov.name>
 <20120109140404.GG3588@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20120109140404.GG3588@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>, stable@kernel.org

On Mon, Jan 09, 2012 at 03:04:04PM +0100, Johannes Weiner wrote:
> On Fri, Jan 06, 2012 at 10:57:50PM +0200, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: <stable@kernel.org>
> 
> I think you don't need to actually CC stable via email.  If you
> include that tag, they will pick it up once the patch hits mainline.

I don't think it's a problem for stable@.

> 
> The changelog is too terse, doubly so for a patch that should go into
> stable.  How is the code supposed to work?  What are the consequences
> of the bug?

Is it enough?

---

From fe1c2f2dc1abf63cce12017e2d9031cf67f0a161 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Sat, 24 Dec 2011 04:12:53 +0200
Subject: [PATCH 4/6] memcg: fix broken boolean expression

action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.

We should return at the point if CPU doesn't go away. Otherwise drain
all counters and stocks from the CPU.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4ed6737..513ae04 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2095,9 +2095,11 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
+	/* CPU goes away */
+
 	for_each_mem_cgroup(iter)
 		mem_cgroup_drain_pcp_counter(iter, cpu);
 
-- 
1.7.8.3

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
