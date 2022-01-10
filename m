From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.17-rc1
Date: Mon, 10 Jan 2022 07:46:32 -1000
Message-ID: <Ydxw+LLhEmi5B/Re@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=u0Lz9mY57BVHXdIMBERfZvaxhsfkpGuYaUsYOCfAqn4=;
        b=HBqm+po5ZDE4m9WK5MHhyaEMItwNlLIeyMV1c7FLlZsx7PUl5fGzHZp8kVP5Uk1AFB
         O1BdWT+L1Fim/dmH2UqJ4EmUfjpQAk/vZaNt4QndUakC9B0uJYDzoqoH1FTyGanOg6u9
         UbfWpo8GaxVrJ2fIWJqSSinar/9MCGj15+VsZ6TCT0X2rZXToBXeSwhD/r3eFsjpPlId
         CS9XXvUGvbojTmrr1+vbOyd1/OVPRmnsn5enhZ+MWWfkxo421RsVTYdXgsVFzUgblGcQ
         qr9fd4d2G2C8oOituQ2JRaTHG6F3icDyqiuey9ISO7OnW562CNuq5u8PVezwn0QTrsKX
         tw7A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Nothing too interesting. The only two noticeable changes are a subtle cpuset
behavior fix and trace event id field being expanded to u64 from int. Most
others are code cleanups.

Thanks.

The following changes since commit 8ab774587903771821b59471cc723bba6d893942:

  Merge tag 'trace-v5.16-5' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/rostedt/linux-trace (2021-11-14 19:07:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.17

for you to fetch changes up to d4296faebd337e5f76c0fddb815de33d2b0ad118:

  cpuset: convert 'allowed' in __cpuset_node_allowed() to be boolean (2022-=
01-07 12:05:52 -1000)

----------------------------------------------------------------
Michal Koutn=FD (1):
      cgroup: rstat: Mark benign data race to silence KCSAN

Qi Zheng (1):
      cpuset: convert 'allowed' in __cpuset_node_allowed() to be boolean

Waiman Long (1):
      cgroup/cpuset: Don't let child cpusets restrict parent in default hie=
rarchy

Wei Yang (5):
      cgroup: get the wrong css for css_alloc() during cgroup_init_subsys()
      cgroup: fix a typo in comment
      cgroup: return early if it is already on preloaded list
      cgroup: rstat: explicitly put loop variant in while
      cgroup/rstat: check updated_next only for root

William Kucharski (1):
      cgroup: Trace event cgroup id fields should be u64

 include/linux/cgroup-defs.h   |  2 +-
 include/trace/events/cgroup.h | 12 +++++-----
 kernel/cgroup/cgroup.c        |  6 ++---
 kernel/cgroup/cpuset.c        | 16 ++++----------
 kernel/cgroup/rstat.c         | 51 ++++++++++++++++++++-------------------=
----
 5 files changed, 38 insertions(+), 49 deletions(-)

--=20
tejun
