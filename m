From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] cgroup/cpuset: Minor updates to test_cpuset_prs.sh
Date: Fri, 17 Mar 2023 11:15:08 -0400
Message-ID: <20230317151508.1225282-5-longman@redhat.com>
References: <20230317151508.1225282-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679066135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQ/fbLiMTxYvcy4Xv+isuWXHLsrugKjziame8MLcKpQ=;
        b=EE30zdnXa4imFeCY54+AIDEPKPIha2s7E5PtIY15p+72PIByifqRo3MABdXSU24TnYaUQn
        TalxLnA3JDX/f0jtecWlpS4lyu2wDjuod1C/DsvuuDYH2wgTv1q2vH1ZQLhImxe6PFfHQa
        COR871feI6Bp+G77WCymWdt20CfL2UQ=
In-Reply-To: <20230317151508.1225282-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch makes the following minor updates to the cpuset partition
testing script test_cpuset_prs.sh.

 - Remove online_cpus function call as it will be called anyway on exit
   in cleanup.
 - Make the enabling of sched/verbose debugfs flag conditional on the
   "-v" verbose option and set DELAY_FACTOR to 2 in this case as cpuset
   partition operations are likely to be slowed down by enabling that.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 75c100de90ff..2b5215cc599f 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -15,13 +15,6 @@ skip_test() {
 
 [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
 
-# Set sched verbose flag, if available
-if [[ -d /sys/kernel/debug/sched ]]
-then
-	# Used to restore the original setting during cleanup
-	SCHED_DEBUG=$(cat /sys/kernel/debug/sched/verbose)
-	echo Y > /sys/kernel/debug/sched/verbose
-fi
 
 # Get wait_inotify location
 WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
@@ -37,10 +30,14 @@ CPUS=$(lscpu | grep "^CPU(s):" | sed -e "s/.*:[[:space:]]*//")
 PROG=$1
 VERBOSE=
 DELAY_FACTOR=1
+SCHED_DEBUG=
 while [[ "$1" = -* ]]
 do
 	case "$1" in
 		-v) VERBOSE=1
+		    # Enable sched/verbose can slow thing down
+		    [[ $DELAY_FACTOR -eq 1 ]] &&
+			DELAY_FACTOR=2
 		    break
 		    ;;
 		-d) DELAY_FACTOR=$2
@@ -54,6 +51,14 @@ do
 	shift
 done
 
+# Set sched verbose flag if available when "-v" option is specified
+if [[ -n "$VERBOSE" && -d /sys/kernel/debug/sched ]]
+then
+	# Used to restore the original setting during cleanup
+	SCHED_DEBUG=$(cat /sys/kernel/debug/sched/verbose)
+	echo Y > /sys/kernel/debug/sched/verbose
+fi
+
 cd $CGROUP2
 echo +cpuset > cgroup.subtree_control
 [[ -d test ]] || mkdir test
@@ -65,7 +70,8 @@ cleanup()
 	rmdir A1/A2/A3 A1/A2 A1 B1 > /dev/null 2>&1
 	cd ..
 	rmdir test > /dev/null 2>&1
-	echo "$SCHED_DEBUG" > /sys/kernel/debug/sched/verbose
+	[[ -n "$SCHED_DEBUG" ]] &&
+		echo "$SCHED_DEBUG" > /sys/kernel/debug/sched/verbose
 }
 
 # Pause in ms
@@ -571,7 +577,6 @@ run_state_test()
 			echo "Test $TEST[$I] failed result check!"
 			eval echo \"\${$TEST[$I]}\"
 			dump_states
-			online_cpus
 			exit 1
 		}
 
@@ -582,7 +587,6 @@ run_state_test()
 				eval echo \"\${$TEST[$I]}\"
 				echo
 				dump_states
-				online_cpus
 				exit 1
 			}
 		}
@@ -594,7 +598,6 @@ run_state_test()
 				eval echo \"\${$TEST[$I]}\"
 				echo
 				dump_states
-				online_cpus
 				exit 1
 			}
 		}
-- 
2.31.1

