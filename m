From: Xiubo Li <xiubli@redhat.com>
Subject: cgroup: deadlock between cpu_hotplug_lock and freezer_mutex
Date: Wed, 15 Feb 2023 10:07:23 +0800
Message-ID: <768be93b-a401-deab-600c-f946e0bd27fa@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676426852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RMCmkhFCPXrDhMTsi/I6uPUq167ZjtWxYObHzGUXvz8=;
        b=MXxk8CVHXS8rLWknElHMhZCDQ+Ah+VYYLfSAsKjtO5/6c7Dy7WKHefw1BrpvxsHDEyY6iJ
        dGRRpLuKMbCCKmPKrXc7nmuf9tXbs/n4MLf7mmH5rK6NoF3jNEqfUYsc359VUYwQAQBfaj
        PFAg+5SOqCA0ZJzFM+buzwR0HB/RS98=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Hi

Recently when running some test cases for ceph we hit the following 
deadlock issue in cgroup code. Has this been fixed ? I have checked the 
latest code and it seems no any commit is fixing this.

This call trace could also be found in 
https://tracker.ceph.com/issues/58564#note-4, which is more friendly to 
read.

  ======================================================
  WARNING: possible circular locking dependency detected
  6.1.0-rc5-ceph-gc90f64b588ff #1 Tainted: G S
  ------------------------------------------------------
  runc/90769 is trying to acquire lock:
  ffffffff82664cb0 (cpu_hotplug_lock){++++}-{0:0}, at: 
static_key_slow_inc+0xe/0x20
  #012but task is already holding lock:
  ffffffff8276e468 (freezer_mutex){+.+.}-{3:3}, at: freezer_write+0x89/0x530
  #012which lock already depends on the new lock.
  #012the existing dependency chain (in reverse order) is:
  #012-> #2 (freezer_mutex){+.+.}-{3:3}:
        __mutex_lock+0x9c/0xf20
        freezer_attach+0x2c/0xf0
        cgroup_migrate_execute+0x3f3/0x4c0
        cgroup_attach_task+0x22e/0x3e0
        __cgroup1_procs_write.constprop.12+0xfb/0x140
        cgroup_file_write+0x91/0x230
        kernfs_fop_write_iter+0x137/0x1d0
        vfs_write+0x344/0x4d0
        ksys_write+0x5c/0xd0
        do_syscall_64+0x34/0x80
        entry_SYSCALL_64_after_hwframe+0x63/0xcd
  #012-> #1 (cgroup_threadgroup_rwsem){++++}-{0:0}:
        percpu_down_write+0x45/0x2c0
        cgroup_procs_write_start+0x84/0x270
        __cgroup1_procs_write.constprop.12+0x57/0x140
        cgroup_file_write+0x91/0x230
        kernfs_fop_write_iter+0x137/0x1d0
        vfs_write+0x344/0x4d0
        ksys_write+0x5c/0xd0
        do_syscall_64+0x34/0x80
        entry_SYSCALL_64_after_hwframe+0x63/0xcd
  #012-> #0 (cpu_hotplug_lock){++++}-{0:0}:
        __lock_acquire+0x103f/0x1de0
        lock_acquire+0xd4/0x2f0
        cpus_read_lock+0x3c/0xd0
        static_key_slow_inc+0xe/0x20
        freezer_apply_state+0x98/0xb0
        freezer_write+0x307/0x530
        cgroup_file_write+0x91/0x230
        kernfs_fop_write_iter+0x137/0x1d0
        vfs_write+0x344/0x4d0
        ksys_write+0x5c/0xd0
        do_syscall_64+0x34/0x80
        entry_SYSCALL_64_after_hwframe+0x63/0xcd
  #012other info that might help us debug this:
  Chain exists of:#012  cpu_hotplug_lock --> cgroup_threadgroup_rwsem 
--> freezer_mutex
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(freezer_mutex);
                                lock(cgroup_threadgroup_rwsem);
                                lock(freezer_mutex);
   lock(cpu_hotplug_lock);
  #012 *** DEADLOCK ***
  5 locks held by runc/90769:
  #0: ffff88810bd064e8 (&f->f_pos_lock){+.+.}-{3:3}, at: 
__fdget_pos+0x44/0x50
  #1: ffff88817f828448 (sb_writers#6){.+.+}-{0:0}, at: ksys_write+0x5c/0xd0
  #2: ffff888104cf5688 (&of->mutex){+.+.}-{3:3}, at: 
kernfs_fop_write_iter+0x104/0x1d0
  #3: ffff888107f885f0 (kn->active#170){.+.+}-{0:0}, at: 
kernfs_fop_write_iter+0x10d/0x1d0
  #4: ffffffff8276e468 (freezer_mutex){+.+.}-{3:3}, at: 
freezer_write+0x89/0x530
  #012stack backtrace:
  CPU: 3 PID: 90769 Comm: runc Tainted: G S 6.1.0-rc5-ceph-gc90f64b588ff #1
  Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
  Call Trace:
  <TASK>
  dump_stack_lvl+0x55/0x6d
  check_noncircular+0xfe/0x110
  ? __lock_acquire+0xec6/0x1de0
  __lock_acquire+0x103f/0x1de0
  lock_acquire+0xd4/0x2f0
  ? static_key_slow_inc+0xe/0x20
  ? freezer_write+0x1c6/0x530
  cpus_read_lock+0x3c/0xd0
  ? static_key_slow_inc+0xe/0x20
  static_key_slow_inc+0xe/0x20
  freezer_apply_state+0x98/0xb0
  freezer_write+0x307/0x530
  cgroup_file_write+0x91/0x230
  kernfs_fop_write_iter+0x137/0x1d0
  vfs_write+0x344/0x4d0
  ksys_write+0x5c/0xd0
  do_syscall_64+0x34/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x558e89efab9b
  Code: e8 8a 2e fb ff eb 88 cc cc cc cc cc cc cc cc e8 7b 74 fb ff 48 
8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 
01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
  RSP: 002b:000000c00019c010 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000c000031000 RCX: 0000558e89efab9b
  RDX: 0000000000000006 RSI: 000000c00019c1c8 RDI: 000000000000000d
  RBP: 000000c00019c060 R08: 0000000000000001 R09: 000000c00028ed20
  R10: 0000000000000006 R11: 0000000000000202 R12: 000000c00019c0f0
  R13: 0000000000000000 R14: 000000c0000001a0 R15: 00007f38d2e1476c
  </TASK>

Thanks

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

