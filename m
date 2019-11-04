From: Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v2 0/2] cgroup: Sync cgroup id and inode number
Date: Mon,  4 Nov 2019 17:45:18 +0900
Message-ID: <20191104084520.398584-1-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AVaAlCmATHFlK0dvHAUG3sEgiLEXR+TZQcbKSHfoP5E=;
        b=pk7TC0AuOrnyj0hssYvxFezLODw9dYB7tlcSqN78c+2bGPNGjIm4a1xAZOvqz8ydCI
         A4oH+d8e9TMEgiNbl8fjHysdrbKu7WCM+KnvVUoagwf+kR/S31oOQMstUfY38oYzLAr2
         hab8x5YKREAW5cdrJiXjekOxZaDP6K45crQiGUeDvcPtVErX2KxxHTvNry3Cu6dB684n
         3yayEw5+Mhn7JpXl36K6T30x2GckJLTGmlxvD5ocRrIKGU1SIGNc6mGdO9RnHgDg9TgD
         OIOW4Q14mhR8lboh+AM4PGS4j3AvAJ92ETsfIVWLILR6dSYtxQICKviCW6ekwpOJ4vvT
         oteg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Song Liu <liu.song.a23@gmail.com>, cgroups@vger.kernel.org

Hello,

This patchset changes cgroup inode number and id management to be in
sync with kernfs.  The cgroup inode number is managed by kernfs but
cgroup id is allocated by a separate idr.  The idea is to have a
single id for internal usage, inode number and file handle which can
be accessed from userspace.  Actually this work is from Tejun who also
provided the idea.  I just took over the work and fixed some errors
and finally was able to run perf for testing.

The background of this work is that I want to add cgroup sampling
feature in the perf event subsystem.  As Tejun mentioned that using
cgroup id is not enough and it'd better using file handle instead.
But getting file handle in perf NMI handler is not possible so I want
to get the info from a cgroup node.

The first patch converted kernfs id into a single 64bit number and in
the second patch cgroup uses the kernfs id as cgroup id.

The patches are based on the for-next branch in Tejun's cgroup tree.
Tested with tools/testing/selftests/cgroup/test_stress.sh.

Thanks
Namhyung


Tejun Heo (2):
      kernfs: Convert to u64 id
      cgroup: Use 64bit id from kernfs

 fs/kernfs/dir.c                  | 36 +++++++++++++++++++------------
 fs/kernfs/file.c                 |  4 ++--
 fs/kernfs/inode.c                |  4 ++--
 fs/kernfs/kernfs-internal.h      |  2 --
 fs/kernfs/mount.c                | 92 +++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 include/linux/cgroup-defs.h      | 18 ++++------------
 include/linux/cgroup.h           | 17 +++++++--------
 include/linux/exportfs.h         |  5 +++++
 include/linux/kernfs.h           | 47 +++++++++++++++++++++++++----------------
 include/net/netprio_cgroup.h     |  8 +++----
 include/trace/events/writeback.h | 92 ++++++++++++++++++++++++++++++++++++++++----------------------------------------
 kernel/bpf/helpers.c             |  2 +-
 kernel/cgroup/cgroup.c           | 68 +++++++++++++++++++----------------------------------------
 kernel/trace/blktrace.c          | 66 +++++++++++++++++++++++++++------------------------------
 net/core/filter.c                |  4 ++--
 net/core/netprio_cgroup.c        |  4 ++--
 16 files changed, 236 insertions(+), 233 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

