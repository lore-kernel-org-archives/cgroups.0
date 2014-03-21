From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] Per cgroup swap file support
Date: Fri, 21 Mar 2014 15:50:31 -0700
Message-ID: <1395442234-7493-1-git-send-email-yuzhao@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=Wmd8Rxyqha3SZqwW0tpHpzuaa0kX/Rti0klms+K6f1k=;
        b=VimRcTzrKB9itJ0E1oNXw5MZ9zDIbJqXVU+ufIzTl0gx2u66pGrvsEsjr+lnKQMUD9
         0Ay8i2ZyU2SxQzFLRa9SH4k5AGHvW9aqkWIqSM/+naUI5/Ruo2eNv/lYP/BmVyYfzSUV
         ixmwS/RxyzhWvmKPQZqAnblgrhgBaxhMyVl7jNgEhExLQyeoIvho8znovx5YfpbE1Gof
         qMNSOZXdITCEgbi4vWD4WZ2Z+5v0NhfFhjaoPCM21e7zkQ2xsaJKupXPV6eLMC1pNrrA
         IwplkaNgtSt0f44zjpSyOO7WmB2aZRm1DMwpdr5PS4BLVI0aTKLX6ah9FpoXhdEAtKue
         qrtg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jamieliu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This series of patches adds support to configure a cgroup to swap to a
particular file by using control file memory.swapfile.

A value of "default" in memory.swapfile indicates that this cgroup should
use the default, system-wide, swap files. A value of "none" indicates that
this cgroup should never swap. Other values are interpreted as the path
to a private swap file that can only be used by the owner (and its children).

The swap file has to be created and swapon() has to be done on it with
SWAP_FLAG_PRIVATE, before it can be used. This flag ensures that the swap
file is private and does not get used by others.

Jamie Liu (1):
  swap: do not store private swap files on swap_list

Suleiman Souhlal (2):
  mm/swap: support per memory cgroup swapfiles
  swap: Increase the maximum number of swap files to 8192.

 Documentation/cgroups/memory.txt  |  15 ++
 arch/x86/include/asm/pgtable_64.h |  63 ++++++--
 include/linux/memcontrol.h        |   2 +
 include/linux/swap.h              |  45 +++---
 mm/memcontrol.c                   |  76 ++++++++++
 mm/memory.c                       |   3 +-
 mm/shmem.c                        |   2 +-
 mm/swap_state.c                   |   2 +-
 mm/swapfile.c                     | 307 +++++++++++++++++++++++++++++++-------
 mm/vmscan.c                       |   2 +-
 10 files changed, 423 insertions(+), 94 deletions(-)

-- 
1.9.1.423.g4596e3a
