From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.17-rc5
Date: Tue, 22 Feb 2022 11:59:06 -1000
Message-ID: <YhVcqpUHepfxgL88@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=ZD9aczGWM/RyGSNkYUTlRQgGJLx3CbLeoXY5+amhhW4=;
        b=hwJbYCxcK63zg7KrWjPb+4bg3PQWZ57DqhR7888nkaxNFUdkMo2Jkc8ZxAkFQP2AKX
         HERYhbUli2++fWI6akh0iGzAvztV4FFXuMi/OkQYugOPuqVDmnlbETT0YJYi711/9ihv
         NCZQ+/1g6Y+/VOFBh/GSjoVwvneMELHlH9OSGC9o3sLQC9uKvToXg45fpVyi0u7oFGYq
         wJr+1243JGXb908MFwC1Yade86/BQ94ikg2WcEmg3d9OP+m8yr2Wds1N8tNGBfzGMoDP
         l8zpp5rOBM2ffqFEMiuMJ5inGqiAT0DpA5a9I2AGQD5XPjCnSXt3gd+hYsf5HwYyOVmM
         aFzw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

* Fix for a subtle bug in the recent release_agent permission check update.

* Fix for a long-standing race condition between cpuset and cpu hotplug.

* Comment updates.

Thanks.

The following changes since commit 2bdfd2825c9662463371e6691b1a794e97fa36b4:

  cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning (2022-02-03 05:=
59:01 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.17-fixes

for you to fetch changes up to c70cd039f1d779126347a896a58876782dcc5284:

  cpuset: Fix kernel-doc (2022-02-22 09:49:49 -1000)

----------------------------------------------------------------
Christian Brauner (1):
      cgroup: clarify cgroup_css_set_fork()

Jiapeng Chong (1):
      cpuset: Fix kernel-doc

Michal Koutn=FD (1):
      cgroup-v1: Correct privileges check in release_agent writes

Zhang Qiao (1):
      cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug

 kernel/cgroup/cgroup-v1.c |  6 ++++--
 kernel/cgroup/cgroup.c    | 14 ++++++++++++++
 kernel/cgroup/cpuset.c    | 12 +++++++-----
 3 files changed, 25 insertions(+), 7 deletions(-)

--=20
tejun
