From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.17-rc6
Date: Tue, 23 Sep 2014 02:33:53 -0400
Message-ID: <20140923063353.GK11740@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=iwgWHXMAMsfnvvm+ZKJ3LsLpAKJonRP+sMbNPvFrnXs=;
        b=ZP02AarZjUg/kkhjYCFaERGqb6oeLxzvwPsZnDcKbpc6vOfZ6a2n1nNjilR+9suYel
         YSsxICO7gsKnBp1U7lmAmxi8vD8a2RjjlE3+HRjs7dIYYXGOmyruNUpVaoyxIUbr9XIi
         tDOpr6y4bMsdA35ZpSQWFXjww8E7rlw0A/LAIeZLHPORaosb/FQugQ3iGWia/KADL1ID
         2+gktyOaPBH8cYaUb5YRhbxW+RfhOT122aHfv/0vyzIKRcRkiVjT6yUXqv1zYyjVVAWJ
         yn0Bv1qn4WHr7qmuTvLpj1R4VjfqRJTXI8HU9X5wZdCr9Zi9PV9XfhgtB6/7aAmm0y7L
         g70g==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

One late fix for cgroup.  I was waiting for another set of fixes for a
long-standing obscure cpuset bug but am not sure whether they'll be
ready before v3.17 release.  This one is a simple fix for a mutex
unlock balance bug, which is detected by coccinelle and probably won't
trigger in the wild, introduced during this devel cycle.

Thanks.

The following changes since commit aa32362f011c6e863132b16c1761487166a4bad2:

  cgroup: check cgroup liveliness before unbreaking kernfs (2014-09-05 01:36:19 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes

for you to fetch changes up to eb4aec84d6bdf98d00cedb41c18000f7a31e648a:

  cgroup: fix unbalanced locking (2014-09-18 12:32:52 -0400)

----------------------------------------------------------------
Zefan Li (1):
      cgroup: fix unbalanced locking

 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 940aced..3a73f99 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3985,7 +3985,6 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {
-		mutex_unlock(&cgrp->pidlist_mutex);
 		pidlist_free(array);
 		return -ENOMEM;
 	}

-- 
tejun
