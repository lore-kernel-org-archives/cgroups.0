From: Juntong Deng <juntong.deng-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] selftests/cgroup: Fix awk usage in test_cpuset_prs.sh that may cause error
Date: Tue, 26 Sep 2023 03:38:19 +0800
Message-ID: <VI1P193MB07522BFC89B6B6DC5A89153999FCA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CVD3Q27nJ01Fi3J203j4E6t6HvjGWGCK3DuwnLbYCo=;
 b=D8EQyz4jg/6CC4JQm/FP5pf4VTLA59h3U2ePZ6fJdQvanEzYQMDI4fDgrYAbqYNTBBaGzd7QPPmoMFc176wHOXK2hiXswA3WEwVd9kDRKcmkUEo2Y7VlEKo6t7cBR0nuTDxZx/5dBEPixwdvX/F6P9ap9CNkcJRKvolB4EI8yk53NtIW4KTWstKaArEParXravT0wu0Q/F05+Zkl5P4Mmokpc2YYYfICVtQAl00cqyjeZXPc3Pf3lcu0ztiKSKubM140/fEObSFz+LyJ9bt/RfqYKaGoe8CuNBQ81yrSsa9H6mWHzKS/z3z9q7IVyv9vDeqw5EoOSU/cVnuHZv/mIw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-mentees-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org

According to the awk manual, the -e option does not need to be specified
in front of 'program' (unless you need to mix program-file).

The redundant -e option can cause error when users use awk tools other
than gawk (for example, mawk does not support the -e option).

Error Example:
awk: not an option: -e
Cgroup v2 mount point not found!

Signed-off-by: Juntong Deng <juntong.deng-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 4afb132e4e4f..6820653e8432 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -20,7 +20,7 @@ skip_test() {
 WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
 
 # Find cgroup v2 mount point
-CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+CGROUP2=$(mount -t cgroup2 | head -1 | awk '{print $3}')
 [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
 
 CPUS=$(lscpu | grep "^CPU(s):" | sed -e "s/.*:[[:space:]]*//")
-- 
2.39.2

