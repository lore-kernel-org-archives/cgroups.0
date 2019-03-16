From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v9 5/9] kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
Date: Sat, 16 Mar 2019 10:58:08 -0700
Message-ID: <20190316175812.6787-6-guro@fb.com>
References: <20190316175812.6787-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EXXdq7GrYAICjYexP9jF/A5d/mueQ96ws92MW4tT5O4=;
        b=F6A697S/ffgJNB8KpLbzzjE1ufFH+GzS0i5kboYL5MTAgRfj3I850Ka+KDnEYqSflF
         fa8ZyZQg9sxQ+hoKvqeIp0j2j7cVXz2r0cLHumV6M+AJZxpN/KNQKSwgr/Jo4hLqD6ok
         h1CupS8vXwP4Ok8CjXPQrgw60GKElSpuhfrvp2jJ6li9Urea3VCiz+SMoXPk7TEFqdhm
         sLcJzRm6gv4dKSRm79nuXL24mtMmlk/7c2wyZxIGeUU2FcggGH3Vrg70mrY9eOHKIFyM
         L32M2k9DAy6ftffLYNK9vT7/67Uh5h7uytamW4n9IcgamOaZjGky1OUg0ZaKpT+IzS6r
         Yg9Q==
In-Reply-To: <20190316175812.6787-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org

If the cgroup destruction races with an exit() of a belonging
process(es), cg_kill_all() may fail. It's not a good reason to make
cg_destroy() fail and leave the cgroup in place, potentially causing
next test runs to fail.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: linux-kselftest@vger.kernel.org
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
2.20.1

