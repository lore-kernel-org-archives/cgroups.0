From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.17-rc2
Date: Thu, 3 Feb 2022 06:13:32 -1000
Message-ID: <Yfv/LMxqHSa3s5YS@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=uOJP/dHIjrt3Mk14YimQ7oK5vd7nsEQbU3Iru0dLJMs=;
        b=DctRaEel5LO3as8bp8Q61ufK6PmYwfRynGpoS9S0XFEZDYYnIvtW5bLY+wBWVVI1pX
         xt/CFxBrzuvUFyGTTkuJCSbVDUvkUANCQuSpKo5YiAoNeiL9X2IcJB3jxTlQ3aTD/EBy
         suVMO53T83SDzqZF9CXZRS1wDrXInC6sU01MR99dATKQSO1puIbKbwJk7c0d2l8Tl9mK
         keVyFE3lpmOedsoGf25+HK7KhvAlouycn9FFw9CAvWwqnA5V9DN4DC2Uk4DALP0xw0q6
         6IfDFk5Hnz4ZW1LmvdYJI5VUWskhDW/g6cE0zkZahFVCXGLEmm6LRZMIGdxdDwbD0Sjk
         MO+g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Linus.

cgroup fixes for v5.17-rc2 including:

* Eric's fix for a long standing cgroup1 permission issue where it only
  checks for uid 0 instead of CAP which inadvertently allows unprivileged
  userns roots to modify release_agent userhelper.

* Fixes for the fallouts from Waiman's recent cpuset work.

Thanks.

The following changes since commit daadb3bd0e8d3e317e36bc2c1542e86c528665e5:

  Merge tag 'locking_core_for_v5.17_rc1' of git://git.kernel.org/pub/scm/li=
nux/kernel/git/tip/tip (2022-01-11 17:24:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.17-fixes

for you to fetch changes up to 2bdfd2825c9662463371e6691b1a794e97fa36b4:

  cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning (2022-02-03 05:=
59:01 -1000)

----------------------------------------------------------------
Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Michal Koutn=FD (1):
      cgroup/cpuset: Make child cpusets restrict parents on v1 hierarchy

Tianchen Ding (1):
      cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpuma=
sk()

Waiman Long (1):
      cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

 kernel/cgroup/cgroup-v1.c | 14 ++++++++++
 kernel/cgroup/cpuset.c    | 65 +++++++++++++++++++++++++++++++++++++------=
----
 2 files changed, 65 insertions(+), 14 deletions(-)

--=20
tejun
