From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v3 5/7] kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
Date: Fri, 16 Nov 2018 16:38:28 -0800
Message-ID: <20181117003830.15344-6-guro@fb.com>
References: <20181117003830.15344-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oiVWgL/WHUTd0gentorRc6DDTrlDET1vasHz44Fkvas=;
        b=m5fAvgNT0ALbznjtvQDpaZKTEG8H7cKwcf7NZSMkS7GDc3wwPXOT9aJhJG1yuOphcy
         Ype74/TsezjxgQ+Lyae2iX6zHipWQGMFHQfw0cpdoj9sM8zO2WQnWbksMaOHqPLv6QLQ
         Iq74qlz3SF/U31I6Oubkse6RKmaXQ+PzYgo2OcAwJouAEZCTj9imtUWLkLPkPw0FoL5H
         ADjavVl+7kUX5V9BfBQcTWjfiMqekvMYKJ3iCIW30WDAWdD4VbNKf0oLbnVyHmMq9qvZ
         bqDqJzB0n7yLtOWq7hGxoVwDpXban2gdBcN2eWeF+MyHgw7J7MIVPE4diChQIztmI7vB
         l3qQ==
In-Reply-To: <20181117003830.15344-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org

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
2.17.2

