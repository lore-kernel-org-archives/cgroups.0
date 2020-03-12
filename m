From: Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH v3 0/4] Support user xattrs in cgroupfs
Date: Thu, 12 Mar 2020 13:03:13 -0700
Message-ID: <20200312200317.31736-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=kNlnuwMcimuimNS6Jo1KZfG1Ry
        Ya0T1T2FyiTi3yhps=; b=szEVJrm30FaD/kg1b6gDlqEtraYtSwmmiY99s5I0da
        DGUOk1qh1OTE09WdC6mLCLKvnwvNQut4O/x60UwuZF4IDFwe3jmdgt/8LA9PYTGD
        kxwzKXmI4aT5CzKTneRyiWrqeXubeJinvsZrpuZfntHWrYr8PYuAYUvRyrYxDEr2
        hhTTUQGpHFh8T6sX9+fBSSVQVA8nMYCrDcR6kubfb7RsvM+WNwrxjfI1xVdgcrea
        U3YW+agBt8/SnuDAR2xYvx0GQ09XxKv0GYhAD5BuiVr/B71wLCwZn6X/lTYjTLAf
        +BhqrA2wa3KYPCHTzrzURJ4oSKGowhYTKTJf3UaEne6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kNlnuwMcimuimNS6J
        o1KZfG1RyYa0T1T2FyiTi3yhps=; b=Jq26f0WXtdpISQKByHKqy5pAnBoRJ3Gq2
        TLHcfPYJ0vOXBN+fiXG7IZoDj1nizaIeL6OzZ78ov0gLRplTCraQjqZm5Q+zS/dK
        KZ5oMk2HpTRhEdRi+51+VcCtOwBGJC+3YlCVg0OYmynLAskLqJ5O9IicBq6/znfS
        ByaiitijbhLihNKL29Z2wghfO88KgV2dES7tzhiZ6Ul8q+ZZDbdyQxhDoKrgGV8J
        o3rNJJYkWvbdsD8SWkFJ+a3YVW0j81ireEdTP+u/AIFSEWTV5Y8iPQOzSwflsZOP
        JCIz4ODcvsP9CLJtcLMhFJjDKa2CmR3v7rtCpsIcsbeQAAmeSSMaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, viro@zeniv.linux.org.uk
Cc: Daniel Xu <dxu@dxuuu.xyz>, shakeelb@google.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

User extended attributes are useful as metadata storage for kernfs
consumers like cgroups. Especially in the case of cgroups, it is useful
to have a central metadata store that multiple processes/services can
use to coordinate actions.

A concrete example is for userspace out of memory killers. We want to
let delegated cgroup subtree owners (running as non-root) to be able to
say "please avoid killing this cgroup". This is especially important for
desktop linux as delegated subtrees owners are less likely to run as
root.

The first two commits set up some stuff for the third commit which
intro introduce a new flag, KERNFS_ROOT_SUPPORT_USER_XATTR,
that lets kernfs consumers enable user xattr support. The final commit
turns on user xattr support for cgroupfs.

Changes from v2:
- Rephrased commit message for "kernfs: kvmalloc xattr value instead of
  kmalloc"

Changes from v1:
- use kvmalloc for xattr values
- modify simple_xattr_set to return removed size
- add accounting for total user xattr size per cgroup

Daniel Xu (4):
  kernfs: kvmalloc xattr value instead of kmalloc
  kernfs: Add removed_size out param for simple_xattr_set
  kernfs: Add option to enable user xattrs
  cgroupfs: Support user xattrs

Daniel Xu (4):
  kernfs: kvmalloc xattr value instead of kmalloc
  kernfs: Add removed_size out param for simple_xattr_set
  kernfs: Add option to enable user xattrs
  cgroupfs: Support user xattrs

 fs/kernfs/inode.c           | 91 ++++++++++++++++++++++++++++++++++++-
 fs/kernfs/kernfs-internal.h |  2 +
 fs/xattr.c                  | 17 +++++--
 include/linux/kernfs.h      | 11 ++++-
 include/linux/xattr.h       |  3 +-
 kernel/cgroup/cgroup.c      |  3 +-
 mm/shmem.c                  |  2 +-
 7 files changed, 119 insertions(+), 10 deletions(-)

-- 
2.21.1

