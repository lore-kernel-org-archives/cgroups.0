From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] kernfs, cgroup: reimplement "cgroup.procs" reading for v2
Date: Tue, 20 Dec 2016 11:10:48 -0500
Message-ID: <20161220161053.14994-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=GqCq6bGOY3+z9hVrYy27xQv5aH8iB3qpmlXzIhF1fnM=;
        b=jh8hLJ0Bf1BdJg6xqU9E7EYCGbW4lXc9/uP2LWn2lN9ZWpmyC3tTjumqvE/7trXkiz
         IpwszwPmTZ5HjowW0+pv9xIhB4lFuuNBozmNaWEPcf1Q4Pnh2qQMasb2GtJsdU74aSxi
         mOhrnRrR70aiB49bZaF64unLfz9uZX15N7Tr2LSdL9bkePPEo9AJYhAI5clvwxO4cgBO
         k2wCkuOiViOLL2BS6K+w/iILRs3Goff8ydpDpIOMT8W6Zp7Y5q6s2nyFRd50Rps5LqX+
         YAzO3cTXF2lnM7sUmejAgFB6/iSsKbSbk03sctTugIQyrD2YIb8nLSAHrB9xkTJCsrPU
         7Ubw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com

On cgroup v1, the pid listings in "cgroup.procs" and "tasks" are
sorted which adds a lot of complications and overhead.  v2 doesn't
have such requirement and has been intentionally using a modified
sorting order so that the output doesn't look sorted to users.

This patchset re-implements "cgroup.procs" reading for v2 which simply
keeps a css_task_iter open while the file is being read.  Keeping the
iterator open makes it unnecessary to skip to the right position on
each read segment and associated errors - e.g. incorrectly skipping
over pids because earlier pids disappeared between the reads.

Using persistent iterator across multiple read calls requires
->release() callback to clean it up.  kernfs operations
->open/release() are added and piped through cftype.

This patchset contains the following five patches.

 0001-kernfs-make-kernfs_open_file-mmapped-a-bitfield.patch
 0002-kernfs-add-kernfs_ops-open-release-callbacks.patch
 0003-cgroup-add-cftype-open-release-callbacks.patch
 0004-cgroup-reimplement-reading-cgroup.procs-on-cgroup-v2.patch
 0005-cgroup-remove-cgroup_pid_fry-and-friends.patch

0001 is a misc kernfs patch and 0002 adds ->open/release() to kernfs.
0003 pipes ->open/release() through cftype.  0004 implements the new
cgroup.procs for v2 and 0005 removes the now unused sort order frying
logic.

Greg, would it be okay to route the kernfs patches through
cgroup/for-4.11?

The patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-procs

diffstat follows.  Thanks.

 fs/kernfs/dir.c             |    2 
 fs/kernfs/file.c            |   53 +++++++++++++++--
 fs/kernfs/kernfs-internal.h |    2 
 include/linux/cgroup-defs.h |    3 +
 include/linux/kernfs.h      |   12 +++-
 kernel/cgroup.c             |  130 +++++++++++++++++++++++++++++---------------
 6 files changed, 148 insertions(+), 54 deletions(-)

--
tejun
