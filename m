From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and OOM
Date: Tue, 9 Aug 2016 14:19:01 +1000
Message-ID: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=fZ0Qt/jKBDf28JNwXIBdv2KbNqPfpuahhTyVuG0BHoA=;
        b=V7z0SwXAHLppjHvCPbJitmO0QWWCPIIEtGFM5px8UOoT3Rge5uAMgoq4NxjTITw7OA
         Mr0x0c+VsEOCDyEdzSKOUlTCk7pDNN5DYEAf9PswPHU+SfwSs1IP3UgexOh7mIP+YWGj
         g5YO4uCzGd50dq+yKE3kJxBvuMrsKKpJw0+ZG7dHEIJlQuRm4FuDNzaZ0nxEmf3E8XrY
         Sg05X/jqSd5vnW48GzOBNUTsU4RSkXtx9ntYQN23ebInX6Con10I2Ex114pJXBP03cH2
         ZnK8vhuOgLMBXYBHlePWtUJFIrfbiCamgUrT1qsIENqHOg3ksvpBGpqBnrJ74hLdOnOy
         vf2A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>


cgroup_threadgroup_rwsem is acquired in read mode during process exit and fork.
It is also grabbed in write mode during __cgroups_proc_write

I've recently run into a scenario with lots of memory pressure and OOM
and I am beginning to see

systemd

 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 percpu_down_write+0x114/0x170
 __cgroup_procs_write.isra.12+0xb8/0x3c0
 cgroup_file_write+0x74/0x1a0
 kernfs_fop_write+0x188/0x200
 __vfs_write+0x6c/0xe0
 vfs_write+0xc0/0x230
 SyS_write+0x6c/0x110
 system_call+0x38/0xb4

This thread is waiting on the reader of cgroup_threadgroup_rwsem to exit.
The reader itself is under memory pressure and has gone into reclaim after
fork. There are times the reader also ends up waiting on oom_lock as well.

 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 jbd2_log_wait_commit+0xd4/0x180
 ext4_evict_inode+0x88/0x5c0
 evict+0xf8/0x2a0
 dispose_list+0x50/0x80
 prune_icache_sb+0x6c/0x90
 super_cache_scan+0x190/0x210
 shrink_slab.part.15+0x22c/0x4c0
 shrink_zone+0x288/0x3c0
 do_try_to_free_pages+0x1dc/0x590
 try_to_free_pages+0xdc/0x260
 __alloc_pages_nodemask+0x72c/0xc90
 alloc_pages_current+0xb4/0x1a0
 page_table_alloc+0xc0/0x170
 __pte_alloc+0x58/0x1f0
 copy_page_range+0x4ec/0x950
 copy_process.isra.5+0x15a0/0x1870
 _do_fork+0xa8/0x4b0
 ppc_clone+0x8/0xc

In the meanwhile, all processes exiting/forking are blocked

Samples of tasks stuck

 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 rwsem_down_read_failed+0x124/0x1b0
 percpu_down_read+0xe0/0xf0
 exit_signals+0x40/0x1b0
 do_exit+0xcc/0xc30
 do_group_exit+0x64/0x100
 get_signal+0x55c/0x7b0
 do_signal+0x54/0x2b0
 do_notify_resume+0xbc/0xd0
 ret_from_except_lite+0x64/0x68

 Call Trace:
 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 rwsem_down_read_failed+0x124/0x1b0
 percpu_down_read+0xe0/0xf0
 exit_signals+0x40/0x1b0
 do_exit+0xcc/0xc30
 do_group_exit+0x64/0x100
 get_signal+0x55c/0x7b0
 do_signal+0x54/0x2b0
 do_notify_resume+0xbc/0xd0
 ret_from_except_lite+0x64/0x68

 Call Trace:
 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 rwsem_down_read_failed+0x124/0x1b0
 percpu_down_read+0xe0/0xf0
 exit_signals+0x40/0x1b0
 do_exit+0xcc/0xc30
 do_group_exit+0x64/0x100
 get_signal+0x55c/0x7b0
 do_signal+0x54/0x2b0
 do_notify_resume+0xbc/0xd0
 ret_from_except_lite+0x64/0x68

 Call Trace:
 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 rwsem_down_read_failed+0x124/0x1b0
 percpu_down_read+0xe0/0xf0
 exit_signals+0x40/0x1b0
 do_exit+0xcc/0xc30
 do_group_exit+0x64/0x100
 get_signal+0x55c/0x7b0
 do_signal+0x54/0x2b0
 do_notify_resume+0xbc/0xd0
 ret_from_except_lite+0x64/0x68

 Call Trace:
 handle_mm_fault+0xde4/0x1980 (unreliable)
 __switch_to+0x1f8/0x350
 __schedule+0x30c/0x990
 schedule+0x48/0xc0
 rwsem_down_read_failed+0x124/0x1b0
 percpu_down_read+0xe0/0xf0
 copy_process.isra.5+0x4bc/0x1870
 _do_fork+0xa8/0x4b0
 ppc_clone+0x8/0xc

This almost stalls the system, this patch moves the threadgroup_change_begin
from before cgroup_fork() to just before cgroup_canfork(). Ideally we shouldn't
have to worry about threadgroup changes till the task is actually added to
the threadgroup. This avoids having to call reclaim with cgroup_threadgroup_rwsem
held.

There are other theoretical issues with this semaphore

systemd can do

1. cgroup_mutex (cgroup_kn_lock_live)
2. cgroup_threadgroup_rwsem (W) (__cgroup_procs_write)

and other threads can go

1. cgroup_threadgroup_rwsem (R) (copy_process)
2. mem_cgroup_iter (as a part of reclaim) (cgroup_mutex -- rcu lock or cgroup_mutex)

However, I've not examined them in too much detail or looked at lockdep
wait chains for those paths.

I am sure there is a good reason for placing cgroup_threadgroup_rwsem
where it is today and I might be missing something. I am also surprised
no-one else has run into it so far.

Comments?

Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Signed-off-by: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5c2c355..0474fa8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1406,7 +1406,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
 	p->audit_context = NULL;
-	threadgroup_change_begin(current);
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
@@ -1558,6 +1557,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
+	threadgroup_change_begin(current);
 	/*
 	 * Ensure that the cgroup subsystem policies allow the new process to be
 	 * forked. It should be noted the the new process's css_set can be changed
@@ -1658,6 +1658,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 bad_fork_cancel_cgroup:
 	cgroup_cancel_fork(p);
 bad_fork_free_pid:
+	threadgroup_change_end(current);
 	if (pid != &init_struct_pid)
 		free_pid(pid);
 bad_fork_cleanup_thread:
@@ -1690,7 +1691,6 @@ bad_fork_cleanup_policy:
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:
 #endif
-	threadgroup_change_end(current);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
-- 
2.5.5
