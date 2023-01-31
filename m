From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.2-rc6
Date: Tue, 31 Jan 2023 12:21:10 -1000
Message-ID: <Y9mUVtmR0AGJKWty@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hYlTCWU4D6zFu1UQJkS9/xemXij0e8AmBdRmgEzuwoo=;
        b=A57+gxlvG503jp1nTjrGMT9lh0+EOn8owntFD9UdE5J1fd2F30Ujva0Lz5SysUVETD
         atDNmEDGCctu41xqxCLpZ4UtYQbIHIvjq2L2T2Gd4P0Ds9h1lqdpY3yjvCATtCB3LwmH
         lj0c4PSH9OA1dn414ej95BXEc/B8O2lozGpmennj1ErMXSDvyQvR0ehjn1sjR/AgQRkn
         sybHt2aOTPz7UnCHwFmtf4uISgfy0BqTXOC6aEh1sYqXAsqqLCHEsHiEpVb6fOiVJCZ3
         EU74R4GZLOkrTr9bnAC6ogOsom6+Xh6URJs4d8YSiZy+QXd10wL+0hBjcDGGRZudjF8I
         0G2g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The following changes since commit 58706f7fb045b7019bada81fa17f372189315fe5:

  Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2023-01-31 11:39:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.2-fixes

for you to fetch changes up to e5ae8803847b80fe9d744a3174abe2b7bfed222a:

  cgroup/cpuset: Fix wrong check in update_parent_subparts_cpumask() (2023-01-31 12:14:02 -1000)

----------------------------------------------------------------
Cgroup fixes for v6.2-rc6

This is a very late pull request but cpuset has a bug which can cause an
oops after some configuration operations, which is introduced during the
v6.1 cycle. This pull request contains only one commit to fix the bug.

----------------------------------------------------------------
Waiman Long (1):
      cgroup/cpuset: Fix wrong check in update_parent_subparts_cpumask()

 kernel/cgroup/cpuset.c                            | 3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)
