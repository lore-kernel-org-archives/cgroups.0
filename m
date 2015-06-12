From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET block/for-4.2/writeback] cgroup, writeback: misc updates for cgroup writeback support
Date: Fri, 12 Jun 2015 16:57:31 -0500
Message-ID: <1434146254-26220-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=AtuBhSL+dzpjYDnifZkvASBTrgfoHT4roe9hDVo3NE0=;
        b=mk7i0x9Q/yo6/zwjfyyGZIONPz3mEfQ5a8eecRiwR9FXYA+6W3NbmTRsxizkcS5YU/
         vr0BZQ/m6X/v3l42yNf7l/gi6dOcZjbv8UYwHHsuDCNW1tb673xgXARlwmapUZymBp3F
         d5UCQS69Ac4POmlagcP1caUsJjifLfkMDZflgaa92zF6zjpRjFJi/8HLV/ob05Nm3oYK
         H04oyrv3rqN1YyFWl/ATErztFa3ancX1cr9JUdjqZnnltuNTm84jO7QVQdRTdF95iTsu
         +FhIgAKRs7UMRBSuA8aGUiea9SUAQbdOEXvsk7xVf88lJlLcZdvp/0n07/aeOkSSUm0/
         5J0g==
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org

Hello,

This patchset contains the following assorted updates for the cgroup
writeback support.

 0001-writeback-do-foreign-inode-detection-iff-cgroup-writ.patch
 0002-vfs-writeback-replace-FS_CGROUP_WRITEBACK-with-MS_CG.patch
 0003-writeback-blkio-add-documentation-for-cgroup-writeba.patch

0001 fixes a bug where clear FS_CGROUP_WRITEBACK flag didn't fully
disable cgroup writeback support if the filesystem code uses
wbc_init_bio() and wbc_account_io().

0002 replaces FS_CGROUP_WRITEBACK with MS_CGROUPWB so that cgroup
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
