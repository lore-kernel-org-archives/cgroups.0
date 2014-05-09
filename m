From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] device_cgroup: remove direct access to cgroup->children
Date: Fri,  9 May 2014 17:31:21 -0400
Message-ID: <1399671091-23867-5-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jn83qshn+C2luO54Sqq1vQeiX8Ji8ZtZRzhawsysR1s=;
        b=LeS2pBUoE+crd3J8X/0LBJbZGob6F8zxDAAIS3EJPsOA0AsufRL952nXdtFmRU0673
         Kw4d1isNY3kQY417PmLEFlTwWIqqId7Ra5AdFS7HSazzicqP9x6oDN4ouGYcaLHEcJzo
         Dghd15mhQkhkM/Y+n9G9ah673kwaaXW1Jfy6nOiRvBOay85cfJcYYgAV61RKkZBhYtLw
         nga1CWrVeowH5XqmxtyjAyjqLZBzFUdChgqo4molhhGz7kVmTItFFeTD25blBBROtPRR
         gOTgj5IOOrAdEU9uRDWNvqwZ1YkbZhD7frZem9ufPunwUOZw14VIdEwVyDvRvZam0ujY
         WM8w==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>

Currently, devcg::has_children() directly tests cgroup->children for
list emptiness.  The field is not a published field and scheduled to
go away.  In addition, the test isn't strictly correct as devcg should
only care about children which are visible to userland.

This patch converts has_children() to use css_next_child() instead.
The subtle incorrectness is noted and will be dealt with later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 security/device_cgroup.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 3116015..75b4b18 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -477,9 +477,17 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 
 static inline bool has_children(struct dev_cgroup *devcgroup)
 {
-	struct cgroup *cgrp = devcgroup->css.cgroup;
+	bool ret;
 
-	return !list_empty(&cgrp->children);
+	/*
+	 * FIXME: There may be lingering offline csses and this function
+	 * may return %true when there isn't any userland-visible child
+	 * which is incorrect for our purposes.
+	 */
+	rcu_read_lock();
+	ret = css_next_child(NULL, &devcgroup->css);
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
-- 
1.9.0
