From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.12-rc4
Date: Mon, 5 Jun 2017 16:30:22 -0400
Message-ID: <20170605203022.GD9399@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=rxcDjzi1NDhg7TrbsQ6uueXmQBTlBfEBsL0EY5SSQok=;
        b=gLHF5DUISQW0f+NP5VSY+pOdeXxPQyB/4QmslHYN9IxkwUP1svMW/lKmW/mM8UNMkK
         zoyIkRjNhDne3hPqbPm9qEGnvtXTiOuopWRmzJq6ZKkbzw2bFSlfAQpLUtdZEThy6u9G
         dp1n8CX2inWgvQu7aShv3wWrcv0fKg2GAePCHKSFmgJrixuzokSPOr81GTf3NJ5qgBil
         QvbSs787fuZ90F8nEkw0pzdtGQEjM55azfIDKviTRgT1E0v4o9+tB+iXbxKVjNWLKO3n
         0pTAsIZRg+0li3i9JRvXRBYEzX+hUypiejOdIRHC1g4+sJapzfzjRBGDX2HIcBAejpmE
         uG8w==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Two cgroup fixes.  One to address RCU delay of cpuset removal
affecting userland visible behaviors.  The other fixes a race
condition between controller disable and cgroup removal.

Thanks.

The following changes since commit 2ea659a9ef488125eb46da6eb571de5eae5c43f6:

  Linux 4.12-rc1 (2017-05-13 13:19:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.12-fixes

for you to fetch changes up to 41c25707d21716826e3c1f60967f5550610ec1c9:

  cpuset: consider dying css as offline (2017-05-24 12:43:30 -0400)

----------------------------------------------------------------
Tejun Heo (1):
      cpuset: consider dying css as offline

Waiman Long (1):
      cgroup: Prevent kill_css() from being called more than once

 include/linux/cgroup-defs.h |  1 +
 include/linux/cgroup.h      | 20 ++++++++++++++++++++
 kernel/cgroup/cgroup.c      |  5 +++++
 kernel/cgroup/cpuset.c      |  4 ++--
 4 files changed, 28 insertions(+), 2 deletions(-)

-- 
tejun
