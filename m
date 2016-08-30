From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.8-rc4
Date: Tue, 30 Aug 2016 11:57:42 -0400
Message-ID: <20160830155742.GA12660@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=plc/nfqJuQbUIkp7LR+F9KmxK9txt5jMRAZh8K9G4DA=;
        b=AlXiLdQ5EffXEG6DfHCP+q79VW9dM4D1v8E/rTwv8ZK8/j9LZ1Ix/VhMYX6d/OZH9g
         oUd2oUzV8P5B0r8zyy8uXvNHNtnBuwfRvU9nkg3kkWMEenepjQIjfyf/mi/BGz0poI1h
         hxMSeixUGoW1j+Lihq0vcvEMR4Zjh9gHEuSPlHg2MvCyfofA8cmHHfWaiBBIfuoAz1V8
         FJmOXdjnJwTZNMmC+5wA2rNkZN/N2DfURw2H1NDRvyJ7P57VRty8xZcdP8Fr3+e85oUi
         i8AiD/e8GHcjwe0JpIUQGNoLDdaPWDjh9wEiweRU+7sQ8Oa43OUDzRw6xdoxoCh3Uea+
         950A==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Linus.

Two fixes for cgroup.

* There still was a hole in enforcing cpuset rules, fixed by Li.

* Recent switch to global percpu_rwseom for threadgroup locking
  revealed a couple issues in how percpu_rwsem is implemented and used
  by cgroup.  Balbir found that the read locking section was too wide
  unnecessarily including operations which can often depend on IOs.
  With percpu_rwsem updates (coming through a different tree) and
  reduction of read locking section, all the reported locking latency
  issues, including the android one, are resolved.

  It looks like we can keep global percpu_rwsem locking for now.  If
  there actually are cases which can't be resolved, we can go back to
  more complex per-signal_struct locking.

Thanks.

The following changes since commit 29b4817d4018df78086157ea3a55c1d9424a7cfc:

  Linux 4.8-rc1 (2016-08-07 18:18:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.8-fixes

for you to fetch changes up to 568ac888215c7fb2fabe8ea739b00ec3c1f5d440:

  cgroup: reduce read locked section of cgroup_threadgroup_rwsem during fork (2016-08-17 09:54:52 -0400)

----------------------------------------------------------------
Balbir Singh (1):
      cgroup: reduce read locked section of cgroup_threadgroup_rwsem during fork

Zefan Li (1):
      cpuset: make sure new tasks conform to the current config of the cpuset

 kernel/cpuset.c | 15 +++++++++++++++
 kernel/fork.c   |  4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
tejun
