From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] more cgroup changes for v4.8-rc1
Date: Fri, 29 Jul 2016 14:46:14 -0400
Message-ID: <20160729184614.GY2542@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=r2um4OZ3CgqP52oRqSPlvLuuOzDP0wt3303KUSD6Z7M=;
        b=lsUHxTMKvVGHxrMP683zopbzXCn3Y6DX4YwDAkykDIw9kq26CjL20UXcAtbf/Npuyh
         csRduQqhuG2mfJUUDIpqJ347OxG+xczwi41WB7aPWg3oOA6NYlSOPuM4sJF/e/sQ8mYf
         0kd6MNf3+OlgHlgy/nDb9ugM7UQyjhwijmyxipbmMZ+8cWeosLtePtYNzceBBEvYkVKz
         i+JA47JBtoluod1PLAb34R2pBdK3xIANRDMfUa9kklV+0L5ysGRyZ1hZqVGMw26lq6xK
         Jr+XHZWXyPZFK1B+jlbaTol8I/aL5sikB7st0ov7u3KNYWgRxt5prUJkiYuWf/gR9Z2H
         zBMQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

Hello, Linus.

I forgot to include the patches which got applied to for-4.7-fixes
late during last cycle.  Eric's three patches fix bugs introduced with
the namespace support.

Thanks.

The following changes since commit 82d6489d0fed2ec8a8c48c19e8d8a04ac8e5bb26:

  cgroup: Disable IRQs while holding css_set_lock (2016-06-23 17:23:12 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.7-fixes

for you to fetch changes up to 726a4994b05ff5b6f83d64b5b43c3251217366ce:

  cgroupns: Only allow creation of hierarchies in the initial cgroup namespace (2016-07-15 08:04:27 -0400)

----------------------------------------------------------------
Eric W. Biederman (3):
      cgroupns: Fix the locking in copy_cgroup_ns
      cgroupns: Close race between cgroup_post_fork and copy_cgroup_ns
      cgroupns: Only allow creation of hierarchies in the initial cgroup namespace

 kernel/cgroup.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

-- 
tejun
