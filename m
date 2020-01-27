From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.6-rc1
Date: Mon, 27 Jan 2020 16:47:49 -0500
Message-ID: <20200127214749.GC180576@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=vBfb6b7TVkkhFizHEZ1B5meaSInahJG+9I7ajoLipOE=;
        b=LsCWSTOZ34ymj9MtQDPlDQ7Rx/wZx0JHqXIESlklpvDlbafAnvNcpqkNpgvsz2yWa1
         TIQVSJw7s7fllV15gSsadCaOQJWXISlNQyxP5SIJpXJwC3Gug9vfsuVbDYqMMawaM++w
         ojFtihhP9giu3uc0FuaFx7kA/3pHKbzCmkJVn+zDjqlJdGTn08F6OooO2RwQ/EA0PkvF
         gIaavzW3YXAUmH2iU3W2g8GuOb00m56aFL6rwlcGwSDH50DpsBkyF52iauvuXzG0v0bK
         ttZrZ29mhwFKl2QXqN8H+rj312o3E+i6AUYzk5oxH0ZjiuyK+T3fU4A8g3p81wOBdGN1
         h9IA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

* cgroup2 interface for hugetlb controller. I think this was the last
  remaining bit which was missing from cgroup2.

* Fixes for race and a spurious warning in threaded cgroup handling.

* Other minor changes.

Thanks.

The following changes since commit 6afa873170a612b2b9e392c19c523ed8aae6fbc9:

  Merge tag 'linux-kselftest-5.5-rc2' of git://git.kernel.org/pub/scm/linux=
/kernel/git/shuah/linux-kselftest (2019-12-16 10:06:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.6

for you to fetch changes up to 9ea37e24d4a95dd934a0600d65caa25e409705bb:

  iocost: Fix iocost_monitor.py due to helper type mismatch (2020-01-17 11:=
54:35 -0800)

----------------------------------------------------------------
Chen Zhou (1):
      cgroup: fix function name in comment

Giuseppe Scrivano (1):
      mm: hugetlb controller for cgroups v2

Michal Koutn=FD (1):
      cgroup: Prevent double killing of css when enabling threaded cgroup

Tejun Heo (1):
      iocost: Fix iocost_monitor.py due to helper type mismatch

 Documentation/admin-guide/cgroup-v2.rst |  29 +++++
 include/linux/hugetlb.h                 |   3 +-
 kernel/cgroup/cgroup.c                  |  11 +-
 kernel/cgroup/rstat.c                   |   2 +-
 mm/hugetlb_cgroup.c                     | 198 ++++++++++++++++++++++++++++=
++--
 tools/cgroup/iocost_monitor.py          |   4 +-
 6 files changed, 227 insertions(+), 20 deletions(-)

--=20
tejun
