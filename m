From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH cgroup/for-6.1-fixes] mm: cgroup: fix comments for get from
 fd/file helpers
Date: Tue, 11 Oct 2022 22:51:55 +0000
Message-ID: <20221011225155.4055415-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XusyGq/BtMQpus8wnubVaoCLzcnzByi/X6aLyv7q1P0=;
        b=UlX7ihEkCl9FTBOFGfPO3DjyEi8CbSe6MA2faSMYt79GLuSxcIOtuzUSEFmFkHCPYh
         gi7YM1+Nt+S5BAVbQvLteUDGKHWYm03X6cCGqMHwq7pv2G85gNAdFTiS77dnLorKJ1f6
         nYqCJ+6PS3v5vJ9YPhfBWZ94wmXD01ITcD2kdxwtyIWriAd2itVtC7Ig/JdhFbyErTe9
         ZHhCGmy9Pi/DwtUnITIdz86i0G4SjZIfe599rMN5YW1SpazJSg3G4t/2kqFRouwhSa8f
         9Wr8bWO6+LF96EpW1TT9pJbuISKI9P12B7iyro72q13+yU3cPqym7NizIvJ046Qax/Qb
         cyNg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix the documentation comments for cgroup_[v1v2_]get_from_[fd/file]().

Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
I cannot reproduce the warning so I cannot make sure it's fixed by this.

Again, apologies for missing updating the comment in the first place.
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6349a9fe9ec1..d922773fa90b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6246,6 +6246,7 @@ static struct cgroup *cgroup_v1v2_get_from_file(struct file *f)
 /**
  * cgroup_get_from_file - same as cgroup_v1v2_get_from_file, but only supports
  * cgroup2.
+ * @f: file corresponding to cgroup2_dir
  */
 static struct cgroup *cgroup_get_from_file(struct file *f)
 {
@@ -6753,7 +6754,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
 
 /**
- * cgroup_get_from_fd - get a cgroup pointer from a fd
+ * cgroup_v1v2_get_from_fd - get a cgroup pointer from a fd
  * @fd: fd obtained by open(cgroup_dir)
  *
  * Find the cgroup from a fd which should be obtained
@@ -6778,6 +6779,7 @@ struct cgroup *cgroup_v1v2_get_from_fd(int fd)
 /**
  * cgroup_get_from_fd - same as cgroup_v1v2_get_from_fd, but only supports
  * cgroup2.
+ * @fd: fd obtained by open(cgroup2_dir)
  */
 struct cgroup *cgroup_get_from_fd(int fd)
 {
-- 
2.38.0.rc1.362.ged0d419d3c-goog

