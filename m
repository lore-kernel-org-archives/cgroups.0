From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for 3.11-rc4
Date: Sun, 4 Aug 2013 20:15:52 -0400
Message-ID: <20130805001552.GC12029@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=Rkr9gZQY1isdaKc9oQHgK5Tnq1Smi02rCYvxqkHEx8E=;
        b=FaI0o8zrx1QBJ0i4sjCp1bXhnIDeMCPmEgea/cqKG06xlV/uAF//DKrN8MfIs7kOPw
         mXo8PzmEQJIA/lOhjbMOCULJ5PYI3ehr8vB8GGlwEDe+TsXjBRcfppkuiCjuzK2gUU3d
         SNs25hDYJqjvEeg2l59IhsCVFhoY0iGBbiHiQLbUUD8xTuw5ay0QKZztUzrpgwgXxeBO
         weiGjEykY+1tzXQm3jIK/mEFScxNEdkKvha+wIjtIswemVryLW0b+fapFt0YYUVvyqCG
         Sp23VzgGrj+RkV2nxe7vmNJAwZcnOMgsymqDKIPEPB2q74+P9xES7t212g93gQ+0SiJA
         yaQg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

This pull request contains just one fix for minor memory leak bug in
init failure path and is available at

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-fixes

for you to fetch changes up to da0a12caffad2eeadea429f83818408e7b77379a:

  cgroup: fix a leak when percpu_ref_init() fails (2013-07-31 06:13:25 -0400)

Thanks.

----------------------------------------------------------------
Li Zefan (1):
      cgroup: fix a leak when percpu_ref_init() fails

 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index afb8d53..468e410 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4344,8 +4344,10 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		}
 
 		err = percpu_ref_init(&css->refcnt, css_release);
-		if (err)
+		if (err) {
+			ss->css_free(cgrp);
 			goto err_free_all;
+		}
 
 		init_cgroup_css(css, ss, cgrp);
 
-- 
tejun
