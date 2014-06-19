From: Lei Li <lilei-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] Documentation: Update remove_from_page_cache with delete_from_page_cache
Date: Thu, 19 Jun 2014 14:32:25 +0800
Message-ID: <1403159545-8029-1-git-send-email-lilei@linux.vnet.ibm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, Lei Li <lilei-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

remove_from_page_cache has been renamed to delete_from_page_cache
since Commit 702cfbf9 ("mm: goodbye remove_from_page_cache()"), adapt
to it in Memcg documentation.

Signed-off-by: Lei Li <lilei-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/cgroups/memcg_test.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 80ac454..b2d6ccc 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -171,10 +171,10 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	- add_to_page_cache_locked().
 
 	uncharged at
-	- __remove_from_page_cache().
+	- __delete_from_page_cache().
 
 	The logic is very clear. (About migration, see below)
-	Note: __remove_from_page_cache() is called by remove_from_page_cache()
+	Note: __delete_from_page_cache() is called by delete_from_page_cache()
 	and __remove_mapping().
 
 6. Shmem(tmpfs) Page Cache
-- 
1.8.5.3
