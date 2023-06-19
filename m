From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests/cgroup: allow running a specific test with test_memcontrol
Date: Mon, 19 Jun 2023 05:17:15 +0000
Message-ID: <20230619051715.2306134-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687151840; x=1689743840;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wIJtbiNHWORZFFJvZlaFdgy0aymB8UjaLQ1n2ZbqAGA=;
        b=gF61XMV36bH0I0OFvVtMJMGfMqtsf5GRLhWCa6KadS7mbkOfJd8Nx9f6fyfD0xONPr
         gWmimxA9RjSurXO02roA0UblNhg0/LzFtfe/76MNLOqk8f9E40XXbrQ+OXLQjhme9er0
         6CVWLC/hLBlwKdhfotjAtiyH1l14V+xB12eI5kJJf84Jn36fg+DSVCh+xi1dPFJmsGgw
         6oXNg/F33JJmP82PkyDzdux+9ZZZBoRQOXweSvCZJwPQafOLvflD1OXS0vtB8Si0QDor
         NrjaREvL25r/7Hjs1fV4HN2tV5ZQ0H55KOrMpxqUn40TA3clVeMbmIoNBPOWMcYoU+Gz
         x87A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

It is handy during testing and/or debugging to be able to run a single
test from test_memcontrol. Allow passing in a test name through a
command line argument (e.g. ./test_memcontrol -t test_memcg_recharge).

Change-Id: I0e0d74d81fdd9d997987389085a816715160467f
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 .../selftests/cgroup/test_memcontrol.c        | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index a2a90f4bfe9f..d8f8a13bc6c4 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1308,9 +1308,36 @@ struct memcg_test {
 
 int main(int argc, char **argv)
 {
+	int opt;
 	char root[PATH_MAX];
+	int selected_test = -1;
 	int i, proc_status, ret = EXIT_SUCCESS;
 
+	while ((opt = getopt(argc, argv, "ht:")) != -1) {
+		switch (opt) {
+		case 't':
+			for (i = 0; i < ARRAY_SIZE(tests); i++) {
+				if (!strcmp(tests[i].name, optarg)) {
+					selected_test = i;
+					break;
+				}
+			}
+			if (selected_test >= 0)
+				break;
+			fprintf(stderr, "test %s not found\n", optarg);
+			return EXIT_FAILURE;
+		case 'h':
+			fprintf(stderr,
+				"Usage: %s [-h] [-t name]\n"
+				"\t-h       print help\n"
+				"\t-t name  run specific test\n"
+				, argv[0]);
+			return ret;
+		default:
+			break;
+		}
+	}
+
 	if (cg_find_unified_root(root, sizeof(root)))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -1336,6 +1363,9 @@ int main(int argc, char **argv)
 	has_localevents = proc_status;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		if (selected_test >= 0 && selected_test != i)
+			continue;
+
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
 			ksft_test_result_pass("%s\n", tests[i].name);
-- 
2.41.0.162.gfafddb0af9-goog

