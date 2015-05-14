From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 11:23:01 +0200
Message-ID: <20150514092301.GB6799@dhcp22.suse.cz>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514092145.GA6799-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>

Cyril, what about this to fix the rounding issue?
---
From b83d740193490d78547197f47eee918732ed1f60 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Thu, 14 May 2015 11:08:20 +0200
Subject: [PATCH] controllers/memcg: Fix limit alignment expectations

since 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") kernel
commit the limit_in_bytes is round down rather than up. This behavior
change has been discussed during the review and it was considered a
reasonable so fix the test accordingly.

While we are at it remove the test case 24 as it doesn't really test
anything more than test case 22.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 .../kernel/controllers/memcg/functional/memcg_function_test.sh   | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
index cfc75fa730df..e3baf9d032f6 100755
--- a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
+++ b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
@@ -158,17 +158,12 @@ testcase_21()
 # Case 22 - 24: Test limit_in_bytes will be aligned to PAGESIZE
 testcase_22()
 {
-	test_limit_in_bytes $((PAGESIZE-1)) $PAGESIZE 0
+	test_limit_in_bytes $((PAGESIZE-1)) 0 0
 }
 
 testcase_23()
 {
-	test_limit_in_bytes $((PAGESIZE+1)) $((PAGESIZE*2)) 0
-}
-
-testcase_24()
-{
-	test_limit_in_bytes 1 $PAGESIZE 0
+	test_limit_in_bytes $((PAGESIZE+1)) $((PAGESIZE)) 0
 }
 
 # Case 25 - 28: Test invaild memory.limit_in_bytes
-- 
2.1.4

-- 
Michal Hocko
SUSE Labs
