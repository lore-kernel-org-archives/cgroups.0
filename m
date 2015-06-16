From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET v2 block/for-4.2/writeback] cgroup, writeback: misc updates for cgroup writeback support
Date: Tue, 16 Jun 2015 18:48:29 -0400
Message-ID: <1434494912-31043-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=K6rV/KOzdKxKH6SiNpz9mYRU8mBsjbdL3/eSlCp/7CM=;
        b=eWAc40BMW14eqiJwRPqsCY36FwWVdM90qTGzzE/d+U/Ny7/rtLHyA36bYJS8qe9GOK
         t+mzHURkv1RIIn2/PD+/eqVA1fMVTk2X5NYU33txJySBZWKzJdShxrSOlg7eOl8LEmiG
         owqHIuCu4mL6ubd8ozFK8rE1v4kMTn9SpEJdlh1vhVWuTsae6GQhqPBHWfeLerJxHMS6
         vD/T6JTjYMjpBlwLwDMKOeaAZ8CvAJYUpf6KVUseVg8THc0+by8Op6wmxx7cyLlWsaa0
         HLWJmKpJ2GDmoHd/hksVZaODf4tpr15FM/JIZ/x7y21wQ1l6RU9hz59nHy0n4q5fjPWv
         9jJQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This is v2.  The only change from the last take[L] is

* super_block->s_iflags added and MS_CGROUPWB replaced with
  SB_I_CGROUPWB as suggested by Christoph and Jan.

This patchset contains the following assorted updates for the cgroup
writeback support.

 0001-writeback-do-foreign-inode-detection-iff-cgroup-writ.patch
 0002-vfs-writeback-replace-FS_CGROUP_WRITEBACK-with-SB_I_.patch
 0003-writeback-blkio-add-documentation-for-cgroup-writeba.patch

0001 fixes a bug where clear FS_CGROUP_WRITEBACK flag didn't fully
disable cgroup writeback support if the filesystem code uses
wbc_init_bio() and wbc_account_io().

0002 replaces FS_CGROUP_WRITEBACK with SB_I_CGROUPWB so that cgroup
writeback support can be enabled / disabled per superblock rather than
filesystem type.

0003 updates blkio documentation with information on cgroup writeback
support.

This patchset is on top of block/for-4.2/writeback and available in
the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-updates

diffstat follows.  Thanks.

 Documentation/cgroups/blkio-controller.txt |   83 +++++++++++++++++++++++++++--
 fs/ext2/super.c                            |    4 -
 fs/fs-writeback.c                          |   16 ++++-
 fs/namespace.c                             |    2 
 include/linux/backing-dev.h                |    2 
 include/linux/fs.h                         |    1 
 include/uapi/linux/fs.h                    |    1 
 7 files changed, 96 insertions(+), 13 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1434146254-26220-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
