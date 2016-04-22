From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 00/21] Support fuse mounts in user namespaces
Date: Fri, 22 Apr 2016 10:38:17 -0500
Message-ID: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=OitbAS7liE/fLDcTSjzZr+VdKgu3LjLkQPklP0nXkcE=;
        b=P+WNBgU525Lk99/+EI55T5lWH4Bz5D+L9HkTSuKfqtVfP6BTNXKbJ8fWaQP1CVDITV
         kJN0hL5dnI0jk3/B+C4UmipxaOq+ewLwvcjxgTkGolAwxaPdeC71phxOSyVMWBEBH6kg
         ygO/7AZePss79nu1dDMDdp5XKBp7bMNv5HBgpH2gPPpEN0JLejh/0NRMnR1bV4SMRV3H
         axB4Gqap5V5WpBJ4xRr5K09xWDbme3UdMiSk6WddUoGkHZDUhGjITFR+nracNAjotpjr
         A8/fJBbottbGvvyvAG0tnfJgigp9H//ZFNlWfA6upUL2s0ODoUgaHdHpVHcifD6shrUO
         wWYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

Hi Eric,

Sorry that it's taken a while to get this update sent out. In part
that's because of a few problems I found, which resulted in some new
patches.

I wanted to point out one problem in particular because I'm not fully
settled on the solution. It turns out that for the sysfs and cgroup
filesystems we already have use cases where a super block is mounted
from multiple user namespaces. With sysfs this is done when criu is used
to snapshot a container; it will mount sysfs in the container's network
namespace but the host's user namespace. cgroup fs uses the same super
block for all mounts of a given hierarchy, and the addition of cgroup
namespaces makes this possible from within non-init user namepsaces. So
the check in sget_userns() which forbids mounting an existing super
block in a different user namespace causes regressions, and really it's
not necessary for these filesystems since ids in the inodes aren't
subect to translation relative to s_user_ns.

I've tried several ways to fix this. The one I'm sending here is to
exempt these filesystems from this requirement, which is the simplest
solution. The down side is that I couldn't find any existing property of
these file systems to use for excluding them, so I'm using a new file
system flag. My second-best option was to change kernfs_test_super() to
return false if the existing super block is in a different user
namespace. This is also pretty simple and works fine for sysfs, but
cgroups require some updating in order to get its internal reference
counting to work out.

These patches are based on the for-testing branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
with everything rebased onto 4.6-rc4. I've also pushed everything to:

 git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/linux.git fuse-userns

Changes since v2:

 - Add patch from Pavel Tikhomirov to fix a potential memory leak in
   sget_userns().
 - Add a patch to fix a bug in the fs_fully_visible() MNT_LOCK_NODEV
   handling which was introduced by "userns: Simpilify MNT_NODEV
   handling."
 - Drop patch to make root in s_user_ns capable towards that superblock
   and replace it with a patch to allow root in s_user_ns to change
   ownership of inodes with invalid ids.
 - Use make_k[ug]id() in fuse_fillattr() instead of copying ids from
   inode.
 - Remove unnecessary initialization of user_id and group_id in fuse
   mount options.
 - Add a comment to get_file_caps() to indicate that the duplicate
   in_userns() check is intentional.
 - Fix incorrect statements in commit message of "fuse: Add support for
   pid namespaces"
 - Added acks.

Thanks,
Seth

---

Andy Lutomirski (1):
  fs: Treat foreign mounts as nosuid

Pavel Tikhomirov (1):
  fs: fix a posible leak of allocated superblock

Seth Forshee (19):
  fs: Remove check of s_user_ns for existing mounts in
    fs_fully_visible()
  fs: Allow sysfs and cgroupfs to share super blocks between user
    namespaces
  block_dev: Support checking inode permissions in lookup_bdev()
  block_dev: Check permissions towards block device inode when mounting
  selinux: Add support for unprivileged mounts from user namespaces
  userns: Replace in_userns with current_in_userns
  Smack: Handle labels consistently in untrusted mounts
  fs: Check for invalid i_uid in may_follow_link()
  cred: Reject inodes with invalid ids in set_create_file_as()
  fs: Refuse uid/gid changes which don't map into s_user_ns
  fs: Update posix_acl support to handle user namespace mounts
  fs: Allow superblock owner to change ownership of inodes with
    unmappable ids
  fs: Don't remove suid for CAP_FSETID in s_user_ns
  fs: Allow superblock owner to access do_remount_sb()
  capabilities: Allow privileged user in s_user_ns to set security.*
    xattrs
  fuse: Add support for pid namespaces
  fuse: Support fuse filesystems outside of init_user_ns
  fuse: Restrict allow_other to the superblock's namespace or a
    descendant
  fuse: Allow user namespace mounts

 drivers/md/bcache/super.c       |  2 +-
 drivers/md/dm-table.c           |  2 +-
 drivers/mtd/mtdsuper.c          |  2 +-
 fs/attr.c                       | 58 ++++++++++++++++++++++++++++++-----
 fs/block_dev.c                  | 18 +++++++++--
 fs/exec.c                       |  2 +-
 fs/fuse/cuse.c                  |  3 +-
 fs/fuse/dev.c                   | 26 ++++++++++++----
 fs/fuse/dir.c                   | 16 +++++-----
 fs/fuse/file.c                  | 22 +++++++++++---
 fs/fuse/fuse_i.h                | 10 +++++-
 fs/fuse/inode.c                 | 40 +++++++++++++++---------
 fs/inode.c                      |  3 +-
 fs/kernfs/inode.c               |  2 ++
 fs/namei.c                      |  2 +-
 fs/namespace.c                  | 20 +++++++++---
 fs/posix_acl.c                  | 67 ++++++++++++++++++++++++++---------------
 fs/proc/base.c                  |  2 ++
 fs/proc/generic.c               |  3 ++
 fs/proc/proc_sysctl.c           |  2 ++
 fs/quota/quota.c                |  2 +-
 fs/super.c                      |  7 ++++-
 fs/sysfs/mount.c                |  3 +-
 fs/xattr.c                      | 19 +++++++++---
 include/linux/fs.h              |  3 +-
 include/linux/mount.h           |  1 +
 include/linux/posix_acl_xattr.h | 17 ++++++++---
 include/linux/uidgid.h          | 10 ++++++
 include/linux/user_namespace.h  |  6 ++--
 kernel/cgroup.c                 |  4 +--
 kernel/cred.c                   |  2 ++
 kernel/user_namespace.c         |  6 ++--
 security/commoncap.c            | 22 ++++++++++----
 security/selinux/hooks.c        | 25 ++++++++++++++-
 security/smack/smack_lsm.c      | 29 ++++++++++++------
 35 files changed, 339 insertions(+), 119 deletions(-)

