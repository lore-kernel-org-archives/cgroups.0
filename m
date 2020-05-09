From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2 cgroups
Date: Sat, 9 May 2020 11:32:10 +0800
Message-ID: <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <939566f5-abe3-3526-d4ff-ec6bf8e8c138-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: yangyingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, guofan5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If systemd is configured to use hybrid mode which enables the use of
both cgroup v1 and v2, systemd will create new cgroup on both the default
root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
task to the two cgroups. If the task does some network thing then the v2
cgroup can never be freed after the session exited.

One of our machines ran into OOM due to this memory leak.

In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
and increments the cgroup refcnt, but then sock_update_netprioidx() thought
it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
cgroup refcnt will never be freed.

Currently we do the mode switch when someone writes to the ifpriomap cgroup
control file. The easiest fix is to also do the switch when a task is attached
to a new cgroup.

Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")
Reported-by: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Tested-by: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

forgot to rebase to the latest kernel.

---
 net/core/netprio_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 8881dd9..9bd4cab 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -236,6 +236,8 @@ static void net_prio_attach(struct cgroup_taskset *tset)
 	struct task_struct *p;
 	struct cgroup_subsys_state *css;
 
+	cgroup_sk_alloc_disable();
+
 	cgroup_taskset_for_each(p, css, tset) {
 		void *v = (void *)(unsigned long)css->id;
 
-- 
2.7.4
