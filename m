From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v6 5/7] kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
Date: Fri, 21 Dec 2018 16:03:05 -0800
Message-ID: <20181222000307.28231-6-guro@fb.com>
References: <20181222000307.28231-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CNs81y4CnakkHOiMBhU/ECBjLx8oP0VFMrPLGDOhpII=;
        b=G4KeCjZIzCd4AUKqQLHckdHP0rluxIgkGmhJzHAib9IerLRdW7nakvDpl6t4atSH+i
         hRJ3vjTEwz6X/+plbmMNNlMsep8u73x36C+g2rdBZ8ms1ekG/vTtNcggsKpdU0CrkAwK
         B/BtXIXWNIu9r899zYEu/Wo2cSYXCkJK0VvNzJTABHMYci6v6RyCsh8yIWC0YcaXsOnJ
         VCyagZVsYL2odkr8Gcw8nXxM5YwDTOXJxMk8PPuYkJG5mqHqfMFO+XeHNX1MXHy5DETQ
         LQ/O1HEHAsKFgMJ47mSQhW3NCM+nE7zEAcvUIfdnoZDR68P7OwWr7ErQk40ogzDjtkTF
         OWNQ==
In-Reply-To: <20181222000307.28231-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org

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
2.19.2

