From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 1/8] bpf: Fix missed rcu read lock in bpf_task_under_cgroup()
Date: Fri, 22 Sep 2023 11:28:39 +0000
Message-ID: <20230922112846.4265-2-laoar.shao@gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695382144; x=1695986944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USRE5PGcnQJpJZpU1UfktdJjqpIxT9YBbxxOLiuroxw=;
        b=IpOrMyR/Q/r9XweAd5rXeWWU4hwbb03t6BOYBiC5IKpOxaEKa2DUdGMWg9oYOkvd6a
         fCrJxOpB4jy1FEimsNy5T1AErXLLHm6hGdSu5PdOmT8CiOkmMrqaA6CMUgURwY1DFfzl
         ylz6p0DChRRWQeTbtpqO06lyj4XxMmMdtI8figm2i7Z6ztgmo8j2Wq5fLSwIS/rwZ9pE
         DqpvmSOQUJA7899rM9w7VxHiouyissll53dJowRGy8bklVLTMxDd7+DeCbjPjrg6+CSF
         nZFoJ0CUGMD9G5+MwKqrTmLr8kxZJNwxWfwhMXeGS4P6jRbnC6eMDpxYfDfJk61Zfhw/
         J29A==
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Feng Zhou <zhoufeng.zf-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

When employed within a sleepable program not under RCU protection, the use
of 'bpf_task_under_cgroup()' may trigger a warning in the kernel log,
particularly when CONFIG_PROVE_RCU is enabled.

[ 1259.662354] =============================
[ 1259.662357] WARNING: suspicious RCU usage
[ 1259.662358] 6.5.0+ #33 Not tainted
[ 1259.662360] -----------------------------
[ 1259.662361] include/linux/cgroup.h:423 suspicious rcu_dereference_check() usage!
[ 1259.662364]
other info that might help us debug this:

[ 1259.662366]
rcu_scheduler_active = 2, debug_locks = 1
[ 1259.662368] 1 lock held by trace/72954:
[ 1259.662369]  #0: ffffffffb5e3eda0 (rcu_read_lock_trace){....}-{0:0}, at: __bpf_prog_enter_sleepable+0x0/0xb0
[ 1259.662383]
stack backtrace:
[ 1259.662385] CPU: 50 PID: 72954 Comm: trace Kdump: loaded Not tainted 6.5.0+ #33
[ 1259.662391] Call Trace:
[ 1259.662393]  <TASK>
[ 1259.662395]  dump_stack_lvl+0x6e/0x90
[ 1259.662401]  dump_stack+0x10/0x20
[ 1259.662404]  lockdep_rcu_suspicious+0x163/0x1b0
[ 1259.662412]  task_css_set.part.0+0x23/0x30
[ 1259.662417]  bpf_task_under_cgroup+0xe7/0xf0
[ 1259.662422]  bpf_prog_7fffba481a3bcf88_lsm_run+0x5c/0x93
[ 1259.662431]  bpf_trampoline_6442505574+0x60/0x1000
[ 1259.662439]  bpf_lsm_bpf+0x5/0x20
[ 1259.662443]  ? security_bpf+0x32/0x50
[ 1259.662452]  __sys_bpf+0xe6/0xdd0
[ 1259.662463]  __x64_sys_bpf+0x1a/0x30
[ 1259.662467]  do_syscall_64+0x38/0x90
[ 1259.662472]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[ 1259.662479] RIP: 0033:0x7f487baf8e29
...
[ 1259.662504]  </TASK>

This issue can be reproduced by executing a straightforward program, as
demonstrated below:

SEC("lsm.s/bpf")
int BPF_PROG(lsm_run, int cmd, union bpf_attr *attr, unsigned int size)
{
        struct cgroup *cgrp = NULL;
        struct task_struct *task;
        int ret = 0;

        if (cmd != BPF_LINK_CREATE)
                return 0;

        // The cgroup2 should be mounted first
        cgrp = bpf_cgroup_from_id(1);
        if (!cgrp)
                goto out;
        task = bpf_get_current_task_btf();
        if (bpf_task_under_cgroup(task, cgrp))
                ret = -1;
        bpf_cgroup_release(cgrp);

out:
        return ret;
}

After running the program, if you subsequently execute another BPF program,
you will encounter the warning. It's worth noting that
task_under_cgroup_hierarchy() is also utilized by
bpf_current_task_under_cgroup(). However, bpf_current_task_under_cgroup()
doesn't exhibit this issue because it cannot be used in non-sleepable BPF
programs.

Fixes: b5ad4cdc46c7 ("bpf: Add bpf_task_under_cgroup() kfunc")
Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Feng Zhou <zhoufeng.zf-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/bpf/helpers.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index dd1c69ee3375..bb521b181cc3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2212,7 +2212,12 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 __bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
 				       struct cgroup *ancestor)
 {
-	return task_under_cgroup_hierarchy(task, ancestor);
+	long ret;
+
+	rcu_read_lock();
+	ret = task_under_cgroup_hierarchy(task, ancestor);
+	rcu_read_unlock();
+	return ret;
 }
 #endif /* CONFIG_CGROUPS */
 
-- 
2.30.1 (Apple Git-130)

