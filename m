From: Lei Li <lilei-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] Documentation: remove remove_from_page_cache note
Date: Tue, 24 Jun 2014 17:17:42 +0800
Message-ID: <1403601462-32167-1-git-send-email-lilei@linux.vnet.ibm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lei Li <lilei-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Remove this note as remove_from_page_cache has been renamed to
delete_from_page_cache since Commit 702cfbf9 ("mm: goodbye
remove_from_page_cache()"), and it doesn't serve any useful
purpose.

Signed-off-by: Lei Li <lilei-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/cgroups/memcg_test.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 8870b02..67c11a3 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -82,8 +82,6 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	- add_to_page_cache_locked().
 
 	The logic is very clear. (About migration, see below)
-	Note: __remove_from_page_cache() is called by remove_from_page_cache()
-	and __remove_mapping().
 
 6. Shmem(tmpfs) Page Cache
 	The best way to understand shmem's page state transition is to read
-- 
1.8.5.3
