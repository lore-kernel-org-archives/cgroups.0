From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v2 3/3] kselftest/cgroup: fix incorrect test_core skip
Date: Mon, 20 May 2019 11:01:40 +0800
Message-ID: <20190520030140.203605-4-alex.shi@linux.alibaba.com>
References: <20190520030140.203605-1-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520030140.203605-1-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Claudio Zumbo <claudioz@fb.com>, Claudio <claudiozumbo@gmail.com>, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

The test_core will skip the
test_cgcore_no_internal_process_constraint_on_threads test case if the
'cpu' controller missing in root's subtree_control. In fact we need to
set the 'cpu' in subtree_control, to make the testing meaningful.

./test_core
...
ok 4 # skip test_cgcore_no_internal_process_constraint_on_threads
...

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Claudio Zumbo <claudioz@fb.com>
Cc: Claudio <claudiozumbo@gmail.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 tools/testing/selftests/cgroup/test_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index b1a570d7c557..2ffc3e07d98d 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -198,7 +198,7 @@ static int test_cgcore_no_internal_process_constraint_on_threads(const char *roo
 	char *parent = NULL, *child = NULL;
 
 	if (cg_read_strstr(root, "cgroup.controllers", "cpu") ||
-	    cg_read_strstr(root, "cgroup.subtree_control", "cpu")) {
+	    cg_write(root, "cgroup.subtree_control", "+cpu")) {
 		ret = KSFT_SKIP;
 		goto cleanup;
 	}
-- 
2.19.1.856.g8858448bb

