From: Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 01/12] rdmacg: Replace strncmp with str_has_prefix
Date: Mon, 29 Jul 2019 23:13:46 +0800
Message-ID: <20190729151346.9280-1-hslester96@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnLXcFhj+Go8GG8/vsP0gGZ0JCfmJSZ7rbeDeF2qVeE=;
        b=XUK3INafO/K7rNvFDvDF8JVU+N+jADLF5S80ly0dl6c7dAg3Bn2NK4Xi3vS3+cBW6z
         k530Dav9ZNTwqZJ1gPbBE7huyQlh36P5Vt5+PcuZ+3tereumhe73oBeYjt1CandmYOwd
         csjOa6nhfGoWBtDgy7w/dzUn92301/n8eILgg62MHBX/MGo7k6jt7YTO+EnilKFCQ6S4
         pJvgnA1r2WpJzbU5JnudrG5cZ8fgRfu/22BfZiAonM2S0O9Y0ne4MrC1X7Arz7HUp/sr
         +2k/LOkqHrtganDCGLJRHHxYjM62wplT1spDMbekbbFIAQNKSCXVIhJ3xLzI8pJfJFrI
         LqOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>

strncmp(str, const, len) is error-prone.
We had better use newly introduced
str_has_prefix() instead of it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 kernel/cgroup/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index ae042c347c64..fd12a227f8e4 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -379,7 +379,7 @@ static int parse_resource(char *c, int *intval)
 			return -EINVAL;
 		return i;
 	}
-	if (strncmp(value, RDMACG_MAX_STR, len) == 0) {
+	if (str_has_prefix(value, RDMACG_MAX_STR)) {
 		*intval = S32_MAX;
 		return i;
 	}
-- 
2.20.1

