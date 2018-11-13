From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.21 2/2] cgroup: Add .__DEBUG__. prefix to debug
 file names
Date: Tue, 13 Nov 2018 12:16:37 -0800
Message-ID: <20181113201637.GO2509588@devbig004.ftw2.facebook.com>
References: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fOLxB5SbrWg2mxlzqt0Xgj9bBC+U68lAJfHs13rndqs=;
        b=CK+ChHM0Q0vmnMKLQKfuuWFwMLHPDJ+GoPJHfXdh1y+WS2hwDnxt38baL7D6e9KYHA
         Wqjte8qOt3bQVade1JoZtdv4JlUCG3xHoXpuFmvQEP69U2uegaTVum17RLHOVIT14OsP
         5l9SZW0GaM0EMBjn6lKHrQSsS8axklAAEpTdciUWxji4xddpCDPt/dvoe8XPUXNBdZAu
         Fioan6CcAi/AUunOAQHRHS0y5pI5FZvgAALeFPg1nBT7xxHkA8CNx1YBN70DgWevlxwQ
         IMrl+FkibG1htRJknIvmmWNcMt9QLKlq3W3VIPupQmmH7lg1lvK63NVmiKHFBcIB+9tM
         pVWw==
Content-Disposition: inline
In-Reply-To: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From c1bbd933e5fae83f96acd3f748bb01a0300b315d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 13 Nov 2018 12:06:41 -0800

Clearly mark the debug files and hide them by default by prefixing
".__DEBUG__.".

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ed7f0bfe6429..e06994fd4e34 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1400,12 +1400,15 @@ static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
 	struct cgroup_subsys *ss = cft->ss;
 
 	if (cft->ss && !(cft->flags & CFTYPE_NO_PREFIX) &&
-	    !(cgrp->root->flags & CGRP_ROOT_NOPREFIX))
-		snprintf(buf, CGROUP_FILE_NAME_MAX, "%s.%s",
-			 cgroup_on_dfl(cgrp) ? ss->name : ss->legacy_name,
+	    !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
+		const char *dbg = (cft->flags & CFTYPE_DEBUG) ? ".__DEBUG__." : "";
+
+		snprintf(buf, CGROUP_FILE_NAME_MAX, "%s%s.%s",
+			 dbg, cgroup_on_dfl(cgrp) ? ss->name : ss->legacy_name,
 			 cft->name);
-	else
+	} else {
 		strscpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
+	}
 	return buf;
 }
 
-- 
2.17.1

