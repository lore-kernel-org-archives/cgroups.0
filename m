From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.15-rc8
Date: Fri, 19 Jan 2018 09:12:14 -0800
Message-ID: <20180119171214.GC3460072@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0PoCCrKXuKcaAHf/r3DjALA7qO+Dqpn0c0Y0qEyHS2Y=;
        b=RaB6s5V7B/zZwIXeJcWYf3PHYV9j1GLrrwl12i7oEZ7WHFwEkWWFDMBX/xOwmutxx7
         bXxIL685FKVeNQyifdQ14m2x2QD1jEeguY6JTCde/hVHljlqqoriIE3mfUVpx9Ul9Sx2
         6+iNBtGa9EfveRECwZP03WpSgP+sWqvroChGWKa2907BJRVkZeV5/1EQaq1dQkxA3abp
         pASjvN13WJ47P3xujvMzmRKRDWSUwAH6RfpUrnZyWr3F0yEVaNYrIR9YxEshYzx645HC
         6B7jc5tjz8lW9nKGLZfA0z+rRBVTVgh3Xq5b9XjmFLp77seCVh0gbIu4H0azP87qu/pJ
         ZVSQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Linus.

cgroup.threads should be delegatable (ie. a container should be able
to write to it from inside) but was missing the flag.  The change is
very low risk.

Thanks.

The following changes since commit 74d0833c659a8a54735e5efdd44f4b225af68586:

  cgroup: fix css_task_iter crash on CSS_TASK_ITER_PROC (2017-12-20 07:09:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.15-fixes

for you to fetch changes up to 4f58424da3deead2605e39a9df65f5f06107a3cb:

  cgroup: make cgroup.threads delegatable (2018-01-10 09:42:32 -0800)

----------------------------------------------------------------
Roman Gushchin (1):
      cgroup: make cgroup.threads delegatable

 kernel/cgroup/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2cf06c2..7e4c445 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4447,6 +4447,7 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "cgroup.threads",
+		.flags = CFTYPE_NS_DELEGATABLE,
 		.release = cgroup_procs_release,
 		.seq_start = cgroup_threads_start,
 		.seq_next = cgroup_procs_next,

-- 
tejun
