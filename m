From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.11-rc7
Date: Sat, 13 Feb 2021 15:03:31 -0500
Message-ID: <YCgwkyRWS5fM0Xtj@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=azyACAaeZShtsPZdyQW2VyvY2tG9ZntNC6GHA++ns2w=;
        b=OyomVyPvZfw5zGvSFus9OI5F6tzFKAtlT5VWC7UweDSxLTakygbtbFgB8nCZwaYh07
         DdITPm83zYamYoYM63myil3QkKBcMQDlClpGzDGGFDeVjxL4sH9RS8vWn9McdgTlRMDS
         Wjg3/LjCtowT/PoowJCqaUq7Ys4mtwvFaOlayHEkg4gxeolCnTdtGMISgWpgtPkqHdlb
         Je5qb7sACQXd9otY2qcpM1Y/EH0+N4A8kkFEC2s0WbEjdhyyYWqDPu9Al2CCkuH3qTxb
         l+0frEutZpH98vUNuZxFj8sJaXDaKw8JLn+5wc+2KIlkqB6/DgCsrXv2GY/D+/KT+sTZ
         S7Ig==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Two cgroup fixes: 1. Fix the NULL deref when trying to poll PSI in the root
cgroup and 2. fix confusing controller parsing corner case when mounting
cgroup v1 hierarchies. And doc / maintainer file updates.

Thanks.

The following changes since commit f4e087c666f54559cb4e530af1fbfc9967e14a15:

  Merge tag 'acpi-5.11-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2021-01-15 10:55:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.11-fixes

for you to fetch changes up to 74bdd45c85d02f695a1cd1c3dccf8b3960a86d8f:

  cgroup: update PSI file description in docs (2021-01-19 12:03:07 -0500)

----------------------------------------------------------------
Chen Zhou (1):
      cgroup-v1: add disabled controller check in cgroup1_parse_param()

Odin Ugedal (2):
      cgroup: fix psi monitor for root cgroup
      cgroup: update PSI file description in docs

Zefan Li (2):
      MAINTAINERS: Remove stale URLs for cpuset
      MAINTAINERS: Update my email address

 Documentation/admin-guide/cgroup-v2.rst | 6 +++---
 MAINTAINERS                             | 6 ++----
 kernel/cgroup/cgroup-v1.c               | 3 +++
 kernel/cgroup/cgroup.c                  | 4 +++-
 4 files changed, 11 insertions(+), 8 deletions(-)

-- 
tejun
