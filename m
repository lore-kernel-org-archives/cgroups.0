From: Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC 2/6] mm, mempolicy: stop adjusting current->il_next in mpol_rebind_nodemask()
Date: Tue, 11 Apr 2017 16:06:05 +0200
Message-ID: <20170411140609.3787-3-vbabka@suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170411140609.3787-1-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>

The task->il_next variable remembers the last allocation node for task's
MPOL_INTERLEAVE policy. mpol_rebind_nodemask() updates interleave and
bind mempolicies due to changing cpuset mems. Currently it also tries to
make sure that current->il_next is valid within the updated nodemask. This is
bogus, because 1) we are updating potentially any task's mempolicy, not just
current, and 2) we might be updating per-vma mempolicy, not task one.

The interleave_nodes() function that uses il_next can cope fine with the value
not being within the currently allowed nodes, so this hasn't manifested as an
actual issue. Thus it also won't be an issue if we just remove this adjustment
completely.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mempolicy.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 37d0b334bfe9..efeec8d2bce5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -349,12 +349,6 @@ static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes,
 		pol->v.nodes = tmp;
 	else
 		BUG();
-
-	if (!node_isset(current->il_next, tmp)) {
-		current->il_next = next_node_in(current->il_next, tmp);
-		if (current->il_next >= MAX_NUMNODES)
-			current->il_next = numa_node_id();
-	}
 }
 
 static void mpol_rebind_preferred(struct mempolicy *pol,
-- 
2.12.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
