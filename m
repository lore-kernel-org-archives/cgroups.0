From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v2 4/6] kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
Date: Mon, 12 Nov 2018 15:04:20 -0800
Message-ID: <20181112230422.5911-6-guro@fb.com>
References: <20181112230422.5911-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DzcE5bixymM64ursY5BeupFFYZWpXSHlxEvgaLA1wns=;
        b=TQbfUstoE9l37hyzHmN9qEUsPBITbxGKzsyNTkbv/1Wr/Yk9R3vRC7gcz4A6Iy1cPt
         SAHYtJ2D7QJOz7obNNnltT6BOC1FUBkbHupPCsoZOKeN3P+8MJdw21I5leaDpOjXf1dy
         mS3j8tDy2IzD7U8btOEGyjb7rkgPkR/NQtSO0hCcKb1EGAQPaGy+Vhnes7hVT/CNwToG
         qHa0YcQ5FeTc1xtdOIY/qJ/thA9oSVS/vy9VFYOr0lMvPd8dTaaqQ/K12g6ocwFfjheb
         A6+4+oLqQHsdnapMF03hGjCcvvIC/x3uEgg015EHw6jWRgzQzyyIz09q4OjpRcON6DC3
         +C1Q==
In-Reply-To: <20181112230422.5911-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>

If the cgroup destruction races with an exit() of a belonging
process(es), cg_kill_all() may fail. It's not a good reason to make
cg_destroy() fail and leave the cgroup in place, potentially causing
next test runs to fail.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
---
 tools/testing/selftests/cgroup/cgroup_util.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 14c9fe284806..eba06f94433b 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -227,9 +227,7 @@ int cg_destroy(const char *cgroup)
 retry:
 	ret = rmdir(cgroup);
 	if (ret && errno == EBUSY) {
-		ret = cg_killall(cgroup);
-		if (ret)
-			return ret;
+		cg_killall(cgroup);
 		usleep(100);
 		goto retry;
 	}
-- 
2.17.2

