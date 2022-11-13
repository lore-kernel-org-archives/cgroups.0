From: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] kselftest/cgroup: Fix gathering number of CPUs
Date: Sun, 13 Nov 2022 11:44:49 +0000
Message-ID: <20221113114449.18693-1-leitao@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leit-M8Ki61LpUEw@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

test_cpuset_prs.sh is failing with the following error:

	test_cpuset_prs.sh: line 29: [[: 8
	57%: syntax error in expression (error token is "57%")

This is happening because `lscpu | grep "^CPU(s)"` returns two lines in
some systems (such as Debian unstable):

	# lscpu | grep "^CPU(s)"
	CPU(s):                          8
	CPU(s) scaling MHz:              55%

This is a simple fix that discard the second line.

Signed-off-by: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 526d2c42d870..564ca8c33035 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -25,7 +25,7 @@ WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
 CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
 [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
 
-CPUS=$(lscpu | grep "^CPU(s)" | sed -e "s/.*:[[:space:]]*//")
+CPUS=$(lscpu | grep "^CPU(s):" | sed -e "s/.*:[[:space:]]*//")
 [[ $CPUS -lt 8 ]] && skip_test "Test needs at least 8 cpus available!"
 
 # Set verbose flag and delay factor
-- 
2.38.1

