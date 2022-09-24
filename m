From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.0-rc6
Date: Fri, 23 Sep 2022 17:53:21 -1000
Message-ID: <Yy5/MV8BvP+M5Fmi@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date;
        bh=GMNz+KftYl/1qv6accKhoJLywxcAkp1GcqyaX1lVIew=;
        b=o0Zhm6dDb/qeEMXfT0OwKU1LAp+DgG9yxDdKvk0cR7JGneV6IS8BVRD93zzAOXvmvH
         QsRFkXnTVNbzGqUkMpzy/l9T0h2rls9tj4HO1IjxUcHH89LI8f9EwzXhr72zC5RJen8g
         N5UvLYhLNTT2nHjNWhTdh+11x9pmIfhMpg7sSFX2MPeoDXApLbXwQK5EzeNYcN18fsqH
         3lO7TfJkBnTSEQAC9fIqCnIpgf9gYd+rLJoJ4IBroo04bfLjm7YUqviHX0LwlC6dslmz
         qfLZYf968yqnh+oMF9n6FgQ/kucyn8vbTT8ykOmAWisGDEtBFKxvONeAdfYJI5r7CZaG
         AMLQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The following changes since commit 5995497296ade7716c8e70899e02235f2b6d9f5d:

  Merge tag 'powerpc-6.0-4' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2022-09-04 11:33:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.0-rc6-fixes

for you to fetch changes up to df02452f3df069a59bc9e69c84435bf115cb6e37:

  cgroup: cgroup_get_from_id() must check the looked-up kn is a directory (2022-09-23 07:18:45 -1000)

----------------------------------------------------------------
Cgroup fixes for v6.0-rc6

* Add Waiman Long as a cpuset maintainer.

* cgroup_get_from_id() could be fed a kernfs ID which doesn't point to a
  cgroup directory but a knob file and then crash. Error out if the lookup
  kernfs_node isn't a directory.

----------------------------------------------------------------
Ming Lei (1):
      cgroup: cgroup_get_from_id() must check the looked-up kn is a directory

Tejun Heo (1):
      cpuset: Add Waiman Long as a cpuset maintainer

 MAINTAINERS            | 1 +
 kernel/cgroup/cgroup.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
tejun
