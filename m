From: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix incomplete dd command.
Date: Wed, 2 Dec 2015 10:28:43 +0800
Message-ID: <1449023323-14224-1-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/blkio-controller.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 52fa9f3..76d4d9d 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -84,8 +84,7 @@ Throttling/Upper Limit policy
 
 - Run dd to read a file and see if rate is throttled to 1MB/s or not.
 
-		# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024
-		# iflag=direct
+        # dd iflag=direct if=/mnt/common/zerofile of=/dev/null bs=4K count=1024
         1024+0 records in
         1024+0 records out
         4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
-- 
1.9.1
