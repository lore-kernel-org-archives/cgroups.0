From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH 4/5] kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
Date: Thu,  8 Nov 2018 15:15:59 -0500
Message-ID: <20181108201600.9129-5-guro@fb.com>
References: <20181108201600.9129-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DzcE5bixymM64ursY5BeupFFYZWpXSHlxEvgaLA1wns=;
        b=G9W+9a9Owr0udn9+avJL0Cm5EE2JVW/Y6IAVePlgAQzQaJSetWPvajRzsuemZwsSLn
         NieBizmjVwCJaDYHQcO1iFS1oH4vq4EhggaeGy/EC8G8PUziMlSuCRfjb6ud2pT3C/eD
         Y4f5O0VcC62DRnyBT48R6hueokdmbs4TfzQA9PAs2MEo1TabjDzEeKApDqnEVmzyaWiv
         hQ2ewi/imNIVRf7DBrOn0cPhzGDcFDqJMPA2/tR/aj9t37UOa638LoDnpiEuoO9LGn0N
         leHI7hB1TL7J3DYcuRJwr/NkY/4Va7WCBuDRmcOk4SCJiowXWBhhXzynsqmRQzSSzR0c
         Oetw==
In-Reply-To: <20181108201600.9129-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>

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

