From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET cgroup/for-5.5] kernfs,cgroup: support 64bit inos and unify cgroup IDs
Date: Mon,  4 Nov 2019 15:59:34 -0800
Message-ID: <20191104235944.3470866-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=1Zg4NM4L65BwHYcai+2O54GGM0p3wG4erjr6tQWRcZo=;
        b=EBABFhcW/4CbrVfst7qrvYwEisArwJDXkGvHeGIs6q50PrJnHJsYbvayJGlGq3KFPI
         s1dyozt349s6fP7eGa4SKiNQMtZZmJ/Tafth7BCNAHcSPDSFQUVShG7a2kEdoijrnqLe
         +lpUXTAc6iK8jBglQ1YqbfIyS6oD2A5QBg0NEXjooUKmwLhN0WjMwEV8j+cN1s1RZSJp
         8rQYYwjqqc/RcJIMdtCWB/7onffM5Be0FxtJlOpn9jSD10wzST0B5bIlzsreHPvpKK6V
         vaNjDebun2eFoPmouATYyFMfr5zQz+FuvH94T3LPmWbZlAraLpT7W2JBRW0pYcVX4Miu
         T0kw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net

Hello,

Currently, there are three IDs which are being used to identify a
cgroup.

1. cgroup->id
2. cgroupfs 32bit ino
3. cgroupfs 32bit ino + 32bit gen

All three IDs are visible to userland through different interfaces.
This is very confusing and #1 can't even be resolved to cgroups from
userland.

A 64bit number is sufficient to identify a cgroup instance uniquely
and ino_t is 64bit on all archs except for alpha.  There's no reason
for three different IDs at all.  This patchset updates kernfs so that
it supports 64bit ino and associated exportfs operations and unifies
the cgroup IDs.

* On 64bit ino archs, ino is kernfs node ID which is also the cgroup
  ID.  The ino can be passed directly into open_by_handle_at(2) w/ the
  new key type FILEID_KERNFS.  Backward compatibility is maintained
  for FILEID_INO32_GEN keys.

* On 32bit ino archs, kernfs node ID is still 64bit and the cgroup ID.
  ino is the low 32bits and gen is the high 32bits.  If the high
  32bits is zero, open_by_handle_at(2) only matches the ino part of
  the ID allowing userland to resolve inos to cgroups as long as
  distinguishing recycled inos isn't necessary.

This patchset contains the following 10 patches.

 0001-kernfs-fix-ino-wrap-around-detection.patch
 0002-writeback-use-ino_t-for-inodes-in-tracepoints.patch
 0003-netprio-use-css-ID-instead-of-cgroup-ID.patch
 0004-kernfs-use-dumber-locking-for-kernfs_find_and_get_no.patch
 0005-kernfs-kernfs_find_and_get_node_by_ino-should-only-l.patch
 0006-kernfs-convert-kernfs_node-id-from-union-kernfs_node.patch
 0007-kernfs-combine-ino-id-lookup-functions-into-kernfs_f.patch
 0008-kernfs-implement-custom-exportfs-ops-and-fid-type.patch
 0009-kernfs-use-64bit-inos-if-ino_t-is-64bit.patch
 0010-cgroup-use-cgrp-kn-id-as-the-cgroup-ID.patch

0001 is a fix which should be backported through -stable.  0002 and
0003 are prep patches.  0004-0009 make kernfs_node->id a u64 and use
it as ino on 64bit ino archs.  0010 replaces cgroup->id with the
kernfs node ID.

Greg, how do you want to route the patches?  We can route 0001-0009
through your tree and the last one through cgroup after pulling in.
I'd be happy to route them all too.

This patchset is also available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-unified-cgid

diffstat follows.  Thanks.

 fs/kernfs/dir.c                  |  101 +++++++++++++++++++-------------------
 fs/kernfs/file.c                 |    4 -
 fs/kernfs/inode.c                |    4 -
 fs/kernfs/kernfs-internal.h      |    2 
 fs/kernfs/mount.c                |  102 ++++++++++++++++++++++-----------------
 include/linux/cgroup-defs.h      |   17 ------
 include/linux/cgroup.h           |   26 ++++-----
 include/linux/exportfs.h         |    5 +
 include/linux/kernfs.h           |   57 ++++++++++++++-------
 include/net/netprio_cgroup.h     |    2 
 include/trace/events/cgroup.h    |    6 +-
 include/trace/events/writeback.h |   92 +++++++++++++++++------------------
 kernel/bpf/helpers.c             |    2 
 kernel/bpf/local_storage.c       |    2 
 kernel/cgroup/cgroup.c           |   81 ++++++++++--------------------
 kernel/trace/blktrace.c          |   84 +++++++++++++++++---------------
 net/core/filter.c                |    4 -
 net/core/netprio_cgroup.c        |    8 +--
 18 files changed, 301 insertions(+), 298 deletions(-)

--
tejun

