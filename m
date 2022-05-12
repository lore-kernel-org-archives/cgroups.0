From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.18-rc6
Date: Thu, 12 May 2022 07:29:58 -1000
Message-ID: <Yn1EFgZdbSSjTatf@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=AyYwNHrrFSveH2j8M/8x/XkyABlhchvxowKUFBK5pvg=;
        b=NlFGVJUc203qX2UEbtIf5QdXTzhQ97zk2FRQ6bfBDGBWadHki9DCSwoXnNuLGJKFhd
         75jmHjdopWJ/sBMRqPeCqc5UQlGOYEDi/Ky2Wcp55+lnwrkwcnmV633o1dPRWBJzLbos
         UePpWrykeOT5OvB4JfTD6upm2VTxF7Bu8Us4AAchm+8Trj9N9USQAFC+2uyFMZdrnU6r
         kRg5JaR17Sgw3H0zaPeAG4Mm9BthlWJppfjADw5AvWu7U3dT4Da3X//88AEOVZix7reF
         L4waIWDyg9FbmRhO7zsK48FcovRP8CDdNjAFEyLfyI7x3UiXzY1l9augkfkTvh1Ez7ng
         fxXQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This pull contains one commit - Waiman's fix for cgroup2 cpuset bug where it
could miss nodes which were hot-added.

Thanks.

The following changes since commit a7391ad3572431a354c927cf8896e86e50d7d0bf:

  Merge tag 'iomm-fixes-v5.18-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu (2022-05-04 11:04:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.18-fixes

for you to fetch changes up to 2685027fca387b602ae565bff17895188b803988:

  cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp() (2022-05-05 08:57:00 -1000)

----------------------------------------------------------------
Waiman Long (1):
      cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

 kernel/cgroup/cpuset.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..71a418858a5e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3390,8 +3390,11 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed set to v2 values in the initial
+	 * cpuset_bind() call will be reset to v1 values in another
+	 * cpuset_bind() call when v1 cpuset is mounted.
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
