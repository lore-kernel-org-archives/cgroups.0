From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v5 5/7] kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
Date: Fri,  7 Dec 2018 12:15:29 -0800
Message-ID: <20181207201531.1665-6-guro@fb.com>
References: <20181207201531.1665-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oiVWgL/WHUTd0gentorRc6DDTrlDET1vasHz44Fkvas=;
        b=Tl6AQp5NBS+Vty8MRgicYJ/jVsKR0CryNf5wkhgDTDviSmtB5Wz5KcTOni7EQWYiOH
         M7G/A/ahbj0zI4CX/oWxaTi3eJ6MDEIHpJoed0IEfumnekz0XOS5c/X94GXsjpeRxgu+
         l2CL4eRuaWgoJimP0SL5rSZ5XqAxlywguM+C8fB+TRPnFh7lzKNozNYlW0wRdQBzUa/a
         ao6SOAXWMayp5gxtmPSMC71qWuSZw4ETGeggMgxoH2KE8z3aAC0/mT4J9+OJA3FOHaru
         l5GNQdJ37yTs4EbHlaXxMHzY7kffSwszM0uq23KIDYpnEAM7yJecJW8OXtILW++JSxuo
         zwQQ==
In-Reply-To: <20181207201531.1665-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org

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

