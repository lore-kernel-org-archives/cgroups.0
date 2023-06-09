From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.4-rc5
Date: Thu, 8 Jun 2023 15:01:18 -1000
Message-ID: <ZIJ53jQAPxEXF-iu@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686272479; x=1688864479;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=7GcNSL4DrLjjHO/zit5UTBbLm7yHWLP5ztae1gnlGWI=;
        b=sAbLNpHAex02mYVvqOt0plUdK9fvvXTixE5yY+9UVIKnYDA4KyfHRNzYP5e51ZXjpD
         IRajIjbDtwqdwuejkKxnKBQi5WTnYesmsuuwqL7Wxz3ZNYw+t005Z7pRGnKYeAMzDUDI
         yDkUtMbboAGfgcL58wyahkFax3e1p+cqMwbfCgn0vRzT9BLmmo8fyniuvX1OUwSPgyUy
         1EhlzRhHSUJwImMdOImUMDLW2WaEqWreK2/GDZIoaN64FL/cExhsveE1joZuN+8P9V5w
         Viwzcmm7FaP0z0pKfZPWkf4lHe9ZLTx98CKiSr+D99SFflxRhpgHv5DTAgc2433ibv6+
         FjTw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 44c026a73be8038f03dbdeef028b642880cf1511:

  Linux 6.4-rc3 (2023-05-21 14:05:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.4-rc5-fixes

for you to fetch changes up to 5647e53f7856bb39dae781fe26aa65a699e2fc9f:

  cgroup: Documentation: Clarify usage of memory limits (2023-06-05 14:08:12 -1000)

----------------------------------------------------------------
cgroup: Fixes for v6.4-rc5

* Fix css_set reference leaks on fork failures.

* Fix CPU hotplug locking in cgroup_transfer_tasks() which is used by
  cgroup1 cpuset.

* Doc update.

----------------------------------------------------------------
Dan Schatzberg (1):
      cgroup: Documentation: Clarify usage of memory limits

John Sperbeck (1):
      cgroup: always put cset in cgroup_css_set_put_fork

Qi Zheng (1):
      cgroup: fix missing cpus_read_{lock,unlock}() in cgroup_transfer_tasks()

 Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++++------------
 kernel/cgroup/cgroup-v1.c               |  4 ++--
 kernel/cgroup/cgroup.c                  | 17 ++++++++---------
 3 files changed, 20 insertions(+), 23 deletions(-)
