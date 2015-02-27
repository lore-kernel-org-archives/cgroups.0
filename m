From: David Rientjes <rientjes@google.com>
Subject: [patch v2 3/3] kernel, cpuset: remove exception for __GFP_THISNODE
Date: Fri, 27 Feb 2015 14:17:49 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1502271417270.7225@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1502251621010.10303@chino.kir.corp.google.com> <alpine.DEB.2.10.1502271415510.7225@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=0C6rxwnlg//C2CnBRP91cwabAwxEoKzsWcr9iU05c6Y=;
        b=e6mNux97nixPg4MnKs6z9/y9wAW1QKwKPYgzfX4qEZOxlnmAUm6t6c0ecgYcu8G4/w
         +Ishs33XkNTuDAiNz7ZrsXP+Anp0arz+zWAv1AgM8WO6VmIKs2Yup8WCL7Uj+YYaEx08
         nDokAsBa2dv6TlUqpIQ+bZWUgd8USOc14dMBZzDRmtTO2ubT0ViGXj4NqHxQyUJ1iGHi
         j7BemYtoooDfsb8vLweYHM5OgWA8j+Axh7izSG7IJzEogc1ymLsukaJ43YrsIp1venX7
         ky+hN7BCCs1kuOEGy+hLoTNSPmW051MF4iOCOrFTkV+/4QkWRf/DhBJgmgrkvwkYfZOY
         gyAA==
In-Reply-To: <alpine.DEB.2.10.1502271415510.7225@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Pravin Shelar <pshelar@nicira.com>, Jarno Rajahalme <jrajahalme@nicira.com>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, dev@openvswitch.org

Nothing calls __cpuset_node_allowed() with __GFP_THISNODE set anymore, so
remove the obscure comment about it and its special-case exception.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2445,20 +2445,12 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
- * set, yes, we can always allocate.  If node is in our task's mems_allowed,
- * yes.  If it's not a __GFP_HARDWALL request and this node is in the nearest
- * hardwalled cpuset ancestor to this task's cpuset, yes.  If the task has been
- * OOM killed and has access to memory reserves as specified by the TIF_MEMDIE
- * flag, yes.
+ * If we're in interrupt, yes, we can always allocate.  If @node is set in
+ * current's mems_allowed, yes.  If it's not a __GFP_HARDWALL request and this
+ * node is set in the nearest hardwalled cpuset ancestor to current's cpuset,
+ * yes.  If current has access to memory reserves due to TIF_MEMDIE, yes.
  * Otherwise, no.
  *
- * The __GFP_THISNODE placement logic is really handled elsewhere,
- * by forcibly using a zonelist starting at a specified node, and by
- * (in get_page_from_freelist()) refusing to consider the zones for
- * any node on the zonelist except the first.  By the time any such
- * calls get to this routine, we should just shut up and say 'yes'.
- *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
  * and do not allow allocations outside the current tasks cpuset
  * unless the task has been OOM killed as is marked TIF_MEMDIE.
@@ -2494,7 +2486,7 @@ int __cpuset_node_allowed(int node, gfp_t gfp_mask)
 	int allowed;			/* is allocation in zone z allowed? */
 	unsigned long flags;
 
-	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
+	if (in_interrupt())
 		return 1;
 	if (node_isset(node, current->mems_allowed))
 		return 1;
