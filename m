From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup: Fixes for v6.4-rc7
Date: Wed, 21 Jun 2023 12:05:53 -1000
Message-ID: <ZJN0Qa--_aBSJ_K3@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687385156; x=1689977156;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=1hF4dAVFDAMGVp+Y09Z0Lab7Zc0WkcRinzpiiIGzUs8=;
        b=RZdjBlnOJEvcG/Y3K8ZI01UT3N8hTQc0Aji+3t3Grs+Dsmzfht3GhgkQlFcD8jfsam
         AisAu6MjUUbU3jpCdeVAauA08WKcAcUV7p6EFewLB2//fOPqs+/Z/YUtljoYjjIIiQAw
         +1rGGe623UT6BFJ+1a7YHmiq/aKiGjOA39T99EViEOCZFstoq4P2px4wRV+c3tz3FxUH
         0pHH8v2tqL5gCM2c2wcQginKgPGEZrSqS+dGyOrMsg8c12ZHEZOI6UBsNWtDsZshr11u
         zo17IG7VjsfNtmdng/OrwsFaXGG89YiZ8d4VwHgekk2faJbd2xRi/L7K7qQRGeN/WEEy
         o3qA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 5647e53f7856bb39dae781fe26aa65a699e2fc9f:

  cgroup: Documentation: Clarify usage of memory limits (2023-06-05 14:08:12 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ cgroup-for-6.4-rc7-fixes

for you to fetch changes up to 6f363f5aa845561f7ea496d8b1175e3204470486:

  cgroup: Do not corrupt task iteration when rebinding subsystem (2023-06-12 07:21:57 -1000)

----------------------------------------------------------------
cgroup: Fixes for v6.4-rc7

It's late but here are two bug fixes. Both fix problems which can be severe
but are very confined in scope. The risk to most use cases should be
minimal.

* Fix for an old bug which triggers if a cgroup subsystem is remounted to a
  different hierarchy while someone is reading its cgroup.procs/tasks file.
  The risk is pretty low given how seldom cgroup subsystems are moved across
  hierarchies.

* We moved cpus_read_lock() outside of cgroup internal locks a while ago but
  forgot to update the legacy_freezer leading to lockdep triggers. Fixed.

----------------------------------------------------------------
Tetsuo Handa (1):
      cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex in freezer_css_{online,offline}()

Xiu Jianfeng (1):
      cgroup: Do not corrupt task iteration when rebinding subsystem

 kernel/cgroup/cgroup.c         | 20 +++++++++++++++++---
 kernel/cgroup/legacy_freezer.c |  8 ++++++--
 2 files changed, 23 insertions(+), 5 deletions(-)

-- 
tejun
