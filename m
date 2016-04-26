From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v4 00/21] Support fuse mounts in user namespaces
Date: Tue, 26 Apr 2016 14:36:13 -0500
Message-ID: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=3/mAjFSAe2lH5PadG2vBN0ytiD8G7J89lmBntUgpw3c=;
        b=KhINvY6sdbJacf8shDGpgzLx3fcwnGN809NKE/ZjwHiFyfZx1Qy4j78bMjZDTJr1Zt
         ko/z5J+ofjiQ+4/s4YG50u+bDvV+4gFjj7kuj/O3W6EWHA3Hgl3ONS5T/6CNTREe5Uxf
         9TqIfB3sdWKT8POphNfWLJmvFndPZKIxQqmZfSmOiM3vM1ifYohoYEGADX5fa7BC8zdz
         THJCXhbQdU8tJCEPXiN/oja42HghBTicK11gscAgd794qOI3soXH4KkInC1iFU5fBsLn
         J/eJRI0e1ruCuyiZgt3TDk/2/7y1W6vscIGyuHY8Z95QG3UIWY4sFBed+1VF6sGtuzZ5
         ruEw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi Eric,

Here's another update to my patches for mouning with fuse from
unpivileged user namespaces. The main change here is a fix for a build
failure when fuse is built as a module. As usual the series is also
available at:

 git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/linux.git fuse-userns

Changes since v3:

 * Export current_in_userns() to fix an error when fuse is built as a
   module.
 * Add comment explaining the conditions for allowing CAP_CHOWN in
   s_user_ns to change the owner or group of an inode.
 * Added acks from Serge.

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
 fs/attr.c                       | 73 ++++++++++++++++++++++++++++++++++++-----
 fs/block_dev.c                  | 18 ++++++++--
 fs/exec.c                       |  2 +-
 fs/fuse/cuse.c                  |  3 +-
 fs/fuse/dev.c                   | 26 +++++++++++----
 fs/fuse/dir.c                   | 16 ++++-----
 fs/fuse/file.c                  | 22 ++++++++++---
 fs/fuse/fuse_i.h                | 10 +++++-
 fs/fuse/inode.c                 | 40 ++++++++++++++--------
 fs/inode.c                      |  3 +-
 fs/kernfs/inode.c               |  2 ++
 fs/namei.c                      |  2 +-
 fs/namespace.c                  | 20 ++++++++---
 fs/posix_acl.c                  | 67 +++++++++++++++++++++++--------------
 fs/proc/base.c                  |  2 ++
 fs/proc/generic.c               |  3 ++
 fs/proc/proc_sysctl.c           |  2 ++
 fs/quota/quota.c                |  2 +-
 fs/super.c                      |  7 +++-
 fs/sysfs/mount.c                |  3 +-
 fs/xattr.c                      | 19 ++++++++---
 include/linux/fs.h              |  3 +-
 include/linux/mount.h           |  1 +
 include/linux/posix_acl_xattr.h | 17 +++++++---
 include/linux/uidgid.h          | 10 ++++++
 include/linux/user_namespace.h  |  6 ++--
 kernel/cgroup.c                 |  4 +--
 kernel/cred.c                   |  2 ++
 kernel/user_namespace.c         |  7 ++--
 security/commoncap.c            | 22 +++++++++----
 security/selinux/hooks.c        | 25 +++++++++++++-
 security/smack/smack_lsm.c      | 29 ++++++++++------
 35 files changed, 355 insertions(+), 119 deletions(-)
