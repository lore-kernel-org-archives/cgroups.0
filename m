From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 5/5] cgroup: Add config file to cgroup selftest suite
Date: Sat, 23 Apr 2022 05:30:54 -0700
Message-ID: <20220423123053.2982931-5-void@manifault.com>
References: <20220423123053.2982931-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220423123053.2982931-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Most of the test suites in tools/testing/selftests contain a config file
that specifies which kernel config options need to be present in order for
the test suite to be able to run and perform meaningful validation. There
is no config file for the tools/testing/selftests/cgroup test suite, so
this patch adds one.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/config | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/config

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
new file mode 100644
index 000000000000..84fe884fad86
--- /dev/null
+++ b/tools/testing/selftests/cgroup/config
@@ -0,0 +1,8 @@
+CONFIG_CGROUPS=y
+CONFIG_CGROUP_CPUACCT=y
+CONFIG_CGROUP_FREEZER=y
+CONFIG_CGROUP_SCHED=y
+CONFIG_MEMCG=y
+CONFIG_MEMCG_KMEM=y
+CONFIG_MEMCG_SWAP=y
+CONFIG_PAGE_COUNTER=y
-- 
2.30.2

