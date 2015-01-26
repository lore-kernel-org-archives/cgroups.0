From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v3.19-rc6
Date: Mon, 26 Jan 2015 12:02:02 -0500
Message-ID: <20150126170202.GC21242@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=iNv2cJOwmPIxtdSnFCSg9eJXvuF48+yRApuyEnoeMdg=;
        b=A0MkRgk8zKyQX835x7DSn8dkIspXPB3GUQARoSmz+cyVT76msB9rxP6OigG94nlS10
         hiR849gj0aVBvuOVXPU7SfYLdXTPfKZuWyKew0WowgL2JMoEbv1bCIKy1w31OxfoUCFv
         lpPzHHj7f7mbgDYYgmT0do3ORXtqm7msyEPQJfgdbCK+lrsQj2wqRoy30SM75DiluAqQ
         q/hHWGpI/YUT2Ueeq+JQcGcEIslrJqv/a1UI0VC4RWjfmDK62FZcrsBa6Pw3gzAXTOiX
         j6ALFRGgveBGP/VficUUoJGLO4hhvSPhKAGm8BnfbLfF58e1hENqPo0hn98mkA+J8sV3
         OhEw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>, Will Deacon <will.deacon@arm.com>

Hello, Linus.

The lifetime rules of cgroup hierarchies always have been somewhat
counter-intuitive and cgroup core tried to enforce that hierarchies
w/o userland-visible usages must die in finite amount of time so that
the controllers can be reused for other hierarchies; unfortunately,
this can't be implemented reasonably for the memory controller - the
kmemcg part doesn't have any way to forcefully drain the existing
usages, leading to an interruptible hang if a following mount attempts
to use the controller in any way.

So, it seems like we're stuck with "hierarchies live on till they die
whenever that may be" at least for now.  This pretty much confines
attaching controllers to hierarchies to before the hierarchies are
actively used by making dynamic configurations post active usages
unreliable.  This has never been reliable and should be fine in
practice given how cgroups are used.

After the patch, hierarchies aren't killed if it isn't already
drained.  A following mount attempt of the same mount options will
reuse the existing hierarchy.  Mount attempts with differing options
will fail w/ -EBUSY.

Thanks.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.19-fixes

for you to fetch changes up to 3c606d35fe9766ede86a45273a628b320be13b45:

  cgroup: prevent mount hang due to memory controller lifetime (2015-01-22 10:26:43 -0500)

----------------------------------------------------------------
Johannes Weiner (1):
      cgroup: prevent mount hang due to memory controller lifetime

 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb263d0..04cfe8a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1909,7 +1909,7 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 *
 	 * And don't kill the default root.
 	 */
-	if (css_has_online_children(&root->cgrp.self) ||
+	if (!list_empty(&root->cgrp.self.children) ||
 	    root == &cgrp_dfl_root)
 		cgroup_put(&root->cgrp);
 	else

-- 
tejun
