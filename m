From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.8-rc8
Date: Wed, 28 Sep 2016 01:34:33 +0200
Message-ID: <20160927233433.GE16429@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=crujOSlo/puuAkNv+gFaHrF4L3VXpqZlN423WHabRSk=;
        b=LgGR1sjpYCkM9QrFWFfF3DW+CzRPlPyH+y1VTyU9Y3fpFl4xoOyPyDxO3K4llTh2Py
         vY5HSZH0cmn1fJHSH3NFKVc3b1UuOfjws5pRT/oBexEa59C58X98TQTqelS8aWzCIIKU
         Vz7glL83+cwr9UCFAa62VTBSXWT8P0XtVcpLucEk4ozG8hlzAf6vhJCXmGwXgH9bqVqr
         b3i6qHJbvsueKJC+wPGphtCS2nFn5yZGhDL7iHNWnZrzLmfbLR5o8IFpMkJk+8aeeeYa
         7vLoJfNMu0TFFYZDZPIgORGjHoF/FtQqgOhuOAtNy/KMnQAUrX9xzH4jeMTwAY3OFWYm
         N7EQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

Three late fixes for cgroup.  Two cpuset ones, one trivial and the
other pretty obscure, and a cgroup core fix for a bug which impacts
cgroup v2 namespace users.

Thanks.

The following changes since commit 568ac888215c7fb2fabe8ea739b00ec3c1f5d440:

  cgroup: reduce read locked section of cgroup_threadgroup_rwsem during fork (2016-08-17 09:54:52 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.8-fixes

for you to fetch changes up to 9157056da8f8c4a6305f15619e269f164b63a6de:

  cgroup: fix invalid controller enable rejections with cgroup namespace (2016-09-23 16:55:49 -0400)

----------------------------------------------------------------
Joonwoo Park (1):
      cpuset: handle race between CPU hotplug and cpuset_hotplug_work

Tejun Heo (1):
      cgroup: fix invalid controller enable rejections with cgroup namespace

Wei Yongjun (1):
      cpuset: fix non static symbol warning

 kernel/cgroup.c | 29 +++++++++++++++++++++++++----
 kernel/cpuset.c | 19 +++++++++++++++----
 2 files changed, 40 insertions(+), 8 deletions(-)

-- 
tejun
