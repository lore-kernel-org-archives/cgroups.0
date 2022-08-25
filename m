From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes #2 for v6.0-rc2
Date: Thu, 25 Aug 2022 07:43:27 -1000
Message-ID: <Ywe0v0YWJSVAs5FT@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc;
        bh=2Q9sxu1HRBMxvkcK86QE22Ms07BjEIEOP4ZDQ3uVSzc=;
        b=FCXHKofw5D2STaFKgE47setXTxKBRs80FRNxxPkumH4L1qjSM5ciq8KO4NAysGvJuD
         wr80KVTFsGVBIOgkAQqhEf8h4/r2Scasna7nu5ebGaoteIadBcXH9IJaAK0/262G0/LD
         dFd0+Rtvb+tXtPz9XcAmqH/2Xr6NacQC9VJJuJ5Y0scTs5HbQ5EMrwTZIZgbyK508Jpy
         2BIdgqsFs5pFwkCgbpFWmXsmo+RQ6CZR5yTLqRiAzcdsq65OfeFKrf4xjDyrAjPzTtFK
         s7+0vfpVVdMUMc0aCVA10L/ZtXWrC6HSvXJE9eKqNgqvnpn0Rmu+lZ2Qp6S5yLnbroYg
         NGBQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>

The following changes since commit 763f4fb76e24959c370cdaa889b2492ba6175580:

  cgroup: Fix race condition at rebind_subsystems() (2022-08-23 08:11:06 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.0-rc2-fixes-2

for you to fetch changes up to 43626dade36fa74d3329046f4ae2d7fdefe401c6:

  cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all() (2022-08-25 07:36:30 -1000)

----------------------------------------------------------------
4f7e7236435ca0ab ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock()
deadlock") in the previous fix pull required cgroup core to grab
cpus_read_lock() before invoking ->attach(). Unfortunately, it missed adding
cpus_read_lock() in cgroup_attach_task_all(). Fix it.

----------------------------------------------------------------
Tetsuo Handa (1):
      cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

 kernel/cgroup/cgroup-v1.c | 2 ++
 1 file changed, 2 insertions(+)
