From: Qian Cai <cai@lca.pw>
Subject: ptrace warning due to "cgroup: get rid of
 cgroup_freezer_frozen_exit()"
Date: Tue, 07 May 2019 16:04:22 -0400
Message-ID: <1557259462.6132.20.camel@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=jOz25/N6iIBGpoDYghLukWmlA3AuvITwq8GHAzb9s00=;
        b=KU3Fd0/zdKEr+7NlBmuDBdwyrN9QgGp0aNtQ+K4xqQNqQz7mpUK0sSnLgIv4rwYHdb
         CxxORtHiyOcmJ05W4D/RcZrH0SmgaSdZY+oEZPH7PneZ4u+g2Y74LvYYhsZiNt1LPJ4W
         5adDQLDn7JZ1j2qRR2z7nfdKdO9o8G1qYRWl5GDlJ52vORR/ag8dY9WUp6YyMf/ROxrf
         pvKnt2vTvpaPIJ6SCNmF6QKxWUERUQVcFvKYzLt2Qb5+1Pd2wwTpGK2r3bqVDd0LTjOa
         5s30upag0zgfdDn1eF2n3DqOl1mGvoYJqFR8iD1c0SmUK2YclTz8PaD4UCgB/5p0vLTj
         eNtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: guro@fb.com
Cc: oleg@redhat.com, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

LTP ptrace01 test case triggers a warning below. Looks at ptrace_stop() calls
cgroup_enter_frozen() there in the cgroup v2 freezer.

[ 8373.336330] WARNING: CPU: 56 PID: 67026 at kernel/cgroup/cgroup.c:6008
cgroup_exit+0x2a9/0x2f0
[ 8373.345001] Modules linked in: brd ext4 crc16 mbcache jbd2 overlay loop
nls_iso8859_1 nls_cp437 vfat fat kvm_amd kvm ses enclosure dax_pmem irqbypass
dax_pmem_core efivars ip_tables x_tables xfs sd_mod smartpqi scsi_transport_sas
tg3 mlx5_core libphy firmware_class dm_mirror dm_region_hash dm_log dm_mod
efivarfs [last unloaded: dummy_del_mod]
[ 8373.375561] CPU: 56 PID: 67026 Comm: ptrace01 Tainted:
G           O      5.1.0-next-20190507+ #25
[ 8373.384579] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10,
BIOS A40 01/25/2019
[ 8373.393164] RIP: 0010:cgroup_exit+0x2a9/0x2f0
[ 8373.397556] Code: 0d ff ff ff 4c 89 f7 e8 75 4b 1b 00 4c 8b ab 20 0f 00 00 49
8d 7d 50 e8 65 4b 1b 00 49 8b 7d 50 e8 4c 56 00 00 e9 db fe ff ff <0f> 0b e9 3a
fe ff ff 48 01 f1 0f 82 3b ff ff ff 48 c7 c7 40 83 5b
[ 8373.416443] RSP: 0018:ffff888bdc9ef9b8 EFLAGS: 00010002
[ 8373.421709] RAX: 0000000000000000 RBX: ffff888e5cfcc040 RCX: ffffffffab3a8e7d
[ 8373.428897] RDX: 1ffff111cb9f9875 RSI: dffffc0000000000 RDI: ffff888e5cfcc3a8
[ 8373.436080] RBP: ffff888bdc9efa50 R08: ffffed117b93df25 R09: ffffed117b93df24
[ 8373.443266] R10: ffffed117b93df24 R11: 0000000000000003 R12: ffff888bdc9efa28
[ 8373.450451] R13: ffff888f4c2346c8 R14: ffff888e5cfccf60 R15: ffff888e5cfccf68
[ 8373.457637] FS:  00007ff1e2e3d5c0(0000) GS:ffff88902f800000(0000)
knlGS:0000000000000000
[ 8373.465781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8373.471569] CR2: 00007ff1e286fe8a CR3: 000000092c412000 CR4: 00000000001406a0
[ 8373.478750] Call Trace:
[ 8373.481219]  ? cgroup_post_fork+0x350/0x350
[ 8373.485435]  ? fpu__drop+0x5e/0x230
[ 8373.488951]  ? exit_thread+0x10c/0x160
[ 8373.492736]  do_exit+0x5cb/0x1740
[ 8373.496083]  ? check_chain_key+0x142/0x200
[ 8373.500210]  ? mm_update_next_owner+0x360/0x360
[ 8373.504775]  ? map_id_up+0x14c/0x1f0
[ 8373.508380]  ? check_chain_key+0x142/0x200
[ 8373.512512]  ? get_signal+0x5f1/0xde0
[ 8373.516206]  ? lock_downgrade+0x300/0x300
[ 8373.520246]  ? lock_downgrade+0x300/0x300
[ 8373.524287]  do_group_exit+0x78/0x160
[ 8373.527978]  get_signal+0x1e8/0xde0
[ 8373.531498]  do_signal+0x9c/0x9d0
[ 8373.534841]  ? check_chain_key+0x142/0x200
[ 8373.538970]  ? setup_sigcontext+0x280/0x280
[ 8373.543185]  ? lock_downgrade+0x300/0x300
[ 8373.547228]  ? kill_pid_info+0x2e/0xd0
[ 8373.551006]  ? kill_pid_info+0xa4/0xd0
[ 8373.554788]  ? __x64_sys_kill+0x262/0x350
[ 8373.558830]  exit_to_usermode_loop+0x9d/0xc0
[ 8373.563131]  do_syscall_64+0x470/0x5d8
[ 8373.566910]  ? syscall_return_slowpath+0xf0/0xf0
[ 8373.571565]  ? __do_page_fault+0x44d/0x5b0
[ 8373.575698]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8373.580789] RIP: 0033:0x7ff1e2893c3b
[ 8373.584402] Code: Bad RIP value.
[ 8373.587653] RSP: 002b:00007ffd8e5efe78 EFLAGS: 00000206 ORIG_RAX:
000000000000003e
[ 8373.595276] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007ff1e2893c3b
[ 8373.602461] RDX: 0000000000000000 RSI: 000000000000000c RDI: 00000000000105d2
[ 8373.609642] RBP: 0000000000000000 R08: 00000000ffffffff R09: 00007ff1e2e3d5c0
[ 8373.616824] R10: fffffffffffff768 R11: 0000000000000206 R12: 00007ffd8e5efe98
[ 8373.624005] R13: 00007ffd8e5f00c0 R14: 0000000000000000 R15: 0000000000000000
[ 8373.631190] ---[ end trace a7169f3366f1d100 ]---
