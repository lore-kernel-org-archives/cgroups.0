From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 16:30:39 +0200
Message-ID: <20150514143039.GI6799@dhcp22.suse.cz>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514103148.GA5066@rei.suse.de>
 <20150514115641.GE6799@dhcp22.suse.cz>
 <20150514120142.GG5066@rei.suse.de>
 <20150514121248.GG6799@dhcp22.suse.cz>
 <20150514123816.GC6993@rei>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150514123816.GC6993@rei>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Nikolay Borisov <kernel@kyup.com>, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org

On Thu 14-05-15 14:38:16, Cyril Hrubis wrote:
> Hi!
> > > Then please send a patch to remove the test.
> > 
> > I think we can still fix both tescases and expect not to fail with
> > regular mmap but fail it with unreclaimable memory (e.g. disallow
> > swapout or use mlock).
> 
> That sounds even better.

untested patch below:
---
From 4a53f301804bfc9df33ca226f941b46c4c9aadbb Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 14 May 2015 16:24:38 +0200
Subject: [PATCH] controllers/memcg: fix force_empty

testcase_29 and testcase_30 are no longer testing anything because
the kernel allows to use force_empty even for memcgs with active
tasks since f61c42a7d911 ("memcg: remove tasks/children test from
mem_cgroup_force_empty()) kernel commit.

If we really want to test this functionality then just expect the
success for regular mmap and expect the failure when the charged
memory is mlocked.

Signed-off-by: Michal Hocko <miso@dhcp22.suse.cz>
---
 testcases/kernel/controllers/memcg/functional/memcg_function_test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
index cfc75fa730df..399c5614468a 100755
--- a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
+++ b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
@@ -211,8 +211,8 @@ testcase_29()
 	echo $pid > tasks
 	kill -s USR1 $pid 2> /dev/null
 	sleep 1
-	echo $pid > ../tasks
 
+	# This expects that there is swap configured
 	echo 1 > memory.force_empty
 	if [ $? -eq 0 ]; then
 		result $PASS "force memory succeeded"
@@ -225,7 +225,7 @@ testcase_29()
 
 testcase_30()
 {
-	$TEST_PATH/memcg_process --mmap-anon -s $PAGESIZE &
+	$TEST_PATH/memcg_process --mmap-lock2 -s $PAGESIZE &
 	pid=$!
 	sleep 1
 	echo $pid > tasks
-- 
2.1.4

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
