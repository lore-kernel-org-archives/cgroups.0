From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.13-rc7
Date: Tue, 29 Aug 2017 11:09:08 -0700
Message-ID: <20170829180908.GU491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=9n7blQd8VpfmvvmzAigXToK7Hc8MS3DiYCyMYJus5/U=;
        b=T5rtnzXDITHsv4n3uJDjL1ye2SMtZ1lV//Y+atcaImpSLBqJmGyAgEu8VPWmHTbV7h
         euyYrWHZVRE9tLz4gXuC6+Kxg6RsMVZdCUSR+kFnQmyyalmWX6Y1PAoujpDLqyIdjbdF
         GpZu8CbrClB0YW2LcMq+fjPgTm4kf8aY0JfkGpP4JrHH1BMkZViKXOcuNWpR8srcsHpO
         QLPTbW2yqByL66vEluuFXvfTqz2WEw+gFea6XO1R7vcy72TcpzoeJTW5Q3gpY9HjJMXd
         +B9NKKNS70Ff3rKV0fdb3vetzjUzjVU08wUOdRqwQkBtIIMnE+TyWSgEFLniYqrw6jcL
         elMg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

Hello,

A late but obvious fix for cgroup.  I broke "cpuset.memory_pressure"
file a long time ago (v4.4) by accidentally deleting its file index,
which made it a duplicate of the "cpuset.memory_migrate" file.
Spotted and fixed by Waiman.

Thanks.

The following changes since commit 3c74541777302eec43a0d1327c4d58b8659a776b:

  cgroup: fix error return value from cgroup_subtree_control() (2017-07-23 08:15:17 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.13-fixes

for you to fetch changes up to 1c08c22c874ac88799cab1f78c40f46110274915:

  cpuset: Fix incorrect memory_pressure control file mapping (2017-08-24 09:42:28 -0700)

----------------------------------------------------------------
Waiman Long (1):
      cpuset: Fix incorrect memory_pressure control file mapping

 kernel/cgroup/cpuset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ca8376e..8362bac 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1891,6 +1891,7 @@ static struct cftype files[] = {
 	{
 		.name = "memory_pressure",
 		.read_u64 = cpuset_read_u64,
+		.private = FILE_MEMORY_PRESSURE,
 	},
 
 	{
