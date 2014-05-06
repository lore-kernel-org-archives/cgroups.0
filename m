From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
Date: Tue,  6 May 2014 07:50:40 -0400
Message-ID: <1399377044-29873-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=285DKegyoAZ6zzzjc81dMbX3U3k60KizwoSuOoJFGj8=;
        b=ov6x5oLckXs386JtesgQm4wmXpW1cKrwoXwanyT73nMRXCPJpjdLf0BXJd+MWL/L8o
         39eZc7XfTF0DOT2dRCkjhvANXAh56T1F9q4j1SXilInLj8IueWB7JZ/O1XeYaNPPYhwt
         M46nMoFy1W5F0Ggi3xBC0Dzy8cMf+cCWE6N5YdH3AEYtUZ5DcSI79Uoyzfqz8azx3TfY
         CU0BvwiITUZynGmsjmcwg5AMWMKCWlxxldYMbC3tGxASsyDo5KB5z1ySaCbD3HHOXr16
         CPrl9kkGLXHuu7wP/wjrPAXb2kP3Bxuri4z/PCzTHzow6Q8u97wVkqpd8Pg6wVpRS12F
         aRkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

This patchset contains the following four patches.

 0001-cgroup-fix-offlining-child-waiting-in-cgroup_subtree.patch
 0002-cgroup-only-allow-space-as-the-separator-for-cgroup..patch
 0003-cgroup-use-restart_syscall-for-retries-after-offline.patch
 0004-cgroup-use-release_agent_path_lock-in-cgroup_release.patch

0001 fixes two bugs in cgroup_subtree_control_write().

0002 makes subtree_control parsing stricter.

0003 simplifies cgroup_substree_control_write() retry path by using
restart_syscall().

0004 makes cgroup_release_agent_show() use release_path_lock.  The
original conversion missed this one.

This patchset is on top of cgroup/for-3.16 12d3089c192c
("kernel/cpuset.c: convert printk to pr_foo()") and available on the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates

diffstat follows.

 kernel/cgroup.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

Thanks.

--
tejun
