From: Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH 0/2] help configure some cgroup limits (v2)
Date: Sun, 17 Jul 2016 23:03:36 +0300
Message-ID: <1468785820-3960-1-git-send-email-toiwoton@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=1DD/i0ORS8HGsy0R7rihALjYpTcXMcEpCDza0f3B0Ls=;
        b=Jt1U0zKvICkxvM9wvjZeU+kGP7d0faNJz+R5pLF79+P/4MvzDzbBeAtxQLyKeih0Lv
         N5zDWsvI0tMiVEPy208GbQ9mo9X1ftEpRCLgsHBm4RtJRjNujW0ShNNroH9U94A+eDSp
         edOCgrwCaUHxz7mUnXwNMKWET/y/c9KXO6PFJPPlNp/HdGrNEGpPFHKFvA6U5YRLtiMg
         ASdDVn44v8pbYPAv3t5qaznoy9HPsQAHPPr9uiGNasWkwmrXoMqrIhESSvnNIaad2aLU
         Jm3H2XyikCfjUuk5SL1Z5E3e823Ra9X7g+EoBHwfhc+d+qu7WoGwZrcU4Edk2QQJgK2H
         0rHw==
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Topi Miettinen <toiwoton@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>

Hello,

There are many basic ways to control processes, including capabilities,
cgroups and resource limits. However, there are far fewer ways to find out
useful values for the limits, except blind trial and error.

This patch series attempts to fix that by giving at least a nice starting
point for configuration of PID and device cgroups.

Thanks to the commenters for the previous version.

-Topi

Topi Miettinen (2):
  cgroup_pids: track highwater mark of pids
  device_cgroup: track and present accessed devices

 kernel/cgroup_pids.c     | 51 ++++++++++++++++++++++++++--
 security/device_cgroup.c | 86 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 117 insertions(+), 20 deletions(-)

-- 
2.8.1

