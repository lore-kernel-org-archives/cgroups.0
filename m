From: Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v3 0/2] refactor sqthread cpu binding logic
Date: Wed,  1 Sep 2021 18:18:31 +0800
Message-ID: <20210901101833.69535-1-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

This patchset is to enhance sqthread cpu binding logic, we didn't
consider cgroup setting before. In container environment, theoretically
sqthread is in its container's task group, it shouldn't occupy cpu out
of its container. Otherwise it may cause some problems, for example:
resource balancer may controll cpu resource allocation by a container's
current cpu usage, here sqthread should be counted in.

v1-->v2
 - add helper to do cpu in current-cpuset test

v2-->v3
 - split it to 2 patches, first as prep one, second as comsumer
 - remove warnning, since cpuset may change anytime, we cannot catch
   all cases, so make the behaviour consistent.

Hao Xu (2):
  cpuset: add a helper to check if cpu in cpuset of current task
  io_uring: consider cgroup setting when binding sqpoll cpu

 fs/io_uring.c          | 19 ++++++++++++++-----
 include/linux/cpuset.h |  7 +++++++
 kernel/cgroup/cpuset.c | 11 +++++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)

-- 
2.24.4

