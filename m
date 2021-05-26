From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v5 0/2] cgroup, blkcg: prevent dirty inodes to pin dying memory cgroups
Date: Wed, 26 May 2021 15:25:55 -0700
Message-ID: <20210526222557.3118114-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=m2Usb8pBnaJ5JSG5ZmqsO2PX6YX/Fcc3JtrbDbrn2J0=;
 b=KdozIGjxtdV16VDlebccLJllHB/zniP9jY3DhAld5mU9GLWGdhf3kZaoO5kOGPJRY8kh
 jNbnoEJrtEhRXaPGxoMaan0dLQiIpnFSPcI6Lfh/2PqW+J4sKIdSBlGt9OfUtcsKDWoA
 aSqcZSNH0A4aJQB/Vdp+AG/T94NDmp7SzKY= 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

When an inode is getting dirty for the first time it's associated
with a wb structure (see __inode_attach_wb()). It can later be
switched to another wb (if e.g. some other cgroup is writing a lot of
data to the same inode), but otherwise stays attached to the original
wb until being reclaimed.

The problem is that the wb structure holds a reference to the original
memory and blkcg cgroups. So if an inode has been dirty once and later
is actively used in read-only mode, it has a good chance to pin down
the original memory and blkcg cgroups forewer. This is often the case wit=
h
services bringing data for other services, e.g. updating some rpm
packages.

In the real life it becomes a problem due to a large size of the memcg
structure, which can easily be 1000x larger than an inode. Also a
really large number of dying cgroups can raise different scalability
issues, e.g. making the memory reclaim costly and less effective.

To solve the problem inodes should be eventually detached from the
corresponding writeback structure. It's inefficient to do it after
every writeback completion. Instead it can be done whenever the
original memory cgroup is offlined and writeback structure is getting
killed. Scanning over a (potentially long) list of inodes and detach
them from the writeback structure can take quite some time. To avoid
scanning all inodes, attached inodes are kept on a new list (b_attached).
To make it less noticeable to a user, the scanning is performed from a
work context.

Big thanks to Jan Kara and Dennis Zhou for their ideas and
contribution to the previous iterations of this patch.

v5:
  - switch inodes to bdi->wb instead of zeroing inode->i_wb
  - split the single patch into two
  - only cgwbs maintain lists of attached inodes
  - added cond_resched()
  - fixed !CONFIG_CGROUP_WRITEBACK handling
  - extended list of prohibited inodes flag
  - other small fixes


Roman Gushchin (2):
  writeback, cgroup: keep list of inodes attached to bdi_writeback
  writeback, cgroup: release dying cgwbs by switching attached inodes

 fs/fs-writeback.c                | 101 +++++++++++++++++++++++++------
 include/linux/backing-dev-defs.h |   2 +
 include/linux/backing-dev.h      |   7 +++
 include/linux/writeback.h        |   2 +
 mm/backing-dev.c                 |  63 ++++++++++++++++++-
 5 files changed, 156 insertions(+), 19 deletions(-)

--=20
2.31.1

