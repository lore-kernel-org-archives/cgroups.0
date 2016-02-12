From: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [BUG] cgroup writeback crash
Date: Fri, 12 Feb 2016 11:32:22 -0800
Message-ID: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=zQ6N5hEz9ChrjiWRudB9GVrLyz0/7eQPfBwAwBgAx5A=;
        b=okMdUKhrJTQPTcHD7dRB4JqyowLdQj3zMlCfeBgo/db8QIe+p38LucPIHywGgp4QJM
         tR2BRoXtxo7Ltc8HOBDSwhilCv0rvVy4+twD7mqZahQRhLfVuk3ZGGCF+tqRfEhzLqoS
         IN5mf6AISS4zznu2PtLRjkt0RIz9IRpoO/69ozL3kL9AgDg0aExGfvMSttbgP54JfAK5
         1TiAPgvGPJsgU29hxbpvOKvztnv1zRvhb+2hkaOiRy8MiThvqkkSs+OvM9BP8hvlu/qx
         a5V7tvI/paPoH/2Ni4NLy2QqLGlSoR9JpnIv3wpcvDYZptkK8cpWLMuZ7KgVqIG3oA36
         lpIQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi,
cgroup based writeback has a race condition bug leads to a kernel crash.

When an inode's bdi_writeback is switched, an additional ref count on the inode
is acquired in inode_switch_wbs()  and the actual reassignment work is scheduled
to be executed later. If file gets deleted and fs unmounted before the work is
finished, then the last ref drop by inode_switch_wbs_work_fn() will
try to evict the
inode and so attempt to access released filesystem data.

Here is the shell script that I am using to reproduce this (not a
reliable repro):

cat > repro.sh << "EOF"
#!/bin/bash
set -e

FILE_COUNT=${1:-18}
BLK_COUNT=${2:-2}


CGROUP_ROOT=/mnt-cgroup2

mkdir -p $CGROUP_ROOT

if ! mount | grep -qw cgroup2; then
mount -t cgroup2 none $CGROUP_ROOT
fi

mkdir -p $CGROUP_ROOT/mem1
mkdir -p $CGROUP_ROOT/mem2

echo '+memory' > $CGROUP_ROOT/cgroup.subtree_control

mkdir -p /mnt/sdb

if mount | grep -qw /dev/sdb; then
umount /dev/sdb &> /dev/null || true
fi

mount /dev/sdb /mnt/sdb

FILES=$(seq 1 $FILE_COUNT)

for f in $FILES; do
rm -f /mnt/sdb/dd$f
done

# Move to mem1 cgroup
echo $$ > $CGROUP_ROOT/mem1/cgroup.procs

for i in {1..10}; do
for f in $FILES; do
dd if=/dev/urandom of=/mnt/sdb/dd$f conv=notrunc \
bs=4k count=$BLK_COUNT seek=$(($BLK_COUNT*$i)) &> /dev/null
done
sync

# After first iteration, switch to mem2 cgroup
if [[ "$i" == "1" ]]; then
echo $$ > $CGROUP_ROOT/mem2/cgroup.procs
fi
done

for f in $FILES; do
rm -f /mnt/sdb/dd$f
done

umount /mnt/sdb

EOF

[  278.498009] ------------[ cut here ]------------
[  278.502764] kernel BUG at fs/jbd2/transaction.c:319!
[  278.507652] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  278.507652] CPU: 1 PID: 29158 Comm: kworker/1:10 Not tainted 4.5.0-rc3 #51
[  278.507652] Hardware name: Google Google, BIOS Google 01/01/2011
[  278.507652] Workqueue: events inode_switch_wbs_work_fn
[  278.507652] task: ffff880213dbbd40 ti: ffff880209264000 task.ti:
ffff880209264000
[  278.507652] RIP: 0010:[<ffffffff803e6922>]  [<ffffffff803e6922>]
start_this_handle+0x382/0x3e0
[  278.507652] RSP: 0018:ffff880209267c30  EFLAGS: 00010202
[  278.507652] RAX: 0000000000000031 RBX: ffff880213fba000 RCX: 0000000000000000
[  278.507652] RDX: 0000000000000001 RSI: 00000000000001ff RDI: ffff880213fba028
[  278.507652] RBP: ffff880209267cb0 R08: 0000000000002000 R09: 00000000000000ef
[  278.507652] R10: ffff880216085750 R11: 0000000000000006 R12: ffff880213fba024
[  278.507652] R13: ffff880213fba070 R14: ffff880216085750 R15: 00000000000000ef
[  278.507652] FS:  0000000000000000(0000) GS:ffff88021ef00000(0000)
knlGS:0000000000000000
[  278.507652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  278.507652] CR2: 00007f310a2a9095 CR3: 0000000000e0a000 CR4: 00000000000406e0
[  278.507652] Stack:
[  278.507652]  000000000000000a ffff880213fba3e0 024000400000000c
ffff880209267c78
[  278.507652]  0000000000000000 0000003000000000 ffff880216085750
ffff880209267cb0
[  278.507652]  ffffffff8032d78a ffffffff803e6b69 ffff880216085720
ffff880213fba000
[  278.507652] Call Trace:
[  278.507652]  [<ffffffff8032d78a>] ? kmem_cache_alloc+0x10a/0x150
[  278.507652]  [<ffffffff803e6b69>] ? jbd2__journal_start+0x79/0x190
[  278.507652]  [<ffffffff803e6be4>] jbd2__journal_start+0xf4/0x190
[  278.507652]  [<ffffffff803cfc7e>] __ext4_journal_start_sb+0x4e/0x70
[  278.507652]  [<ffffffff803b31ec>] ext4_evict_inode+0x12c/0x3d0
[  278.507652]  [<ffffffff8035338b>] evict+0xbb/0x190
[  278.507652]  [<ffffffff80354190>] iput+0x130/0x190
[  278.507652]  [<ffffffff80360223>] inode_switch_wbs_work_fn+0x343/0x4c0
[  278.507652]  [<ffffffff80279819>] process_one_work+0x129/0x300
[  278.507652]  [<ffffffff802ab1a3>] ? try_to_del_timer_sync+0x43/0x60
[  278.507652]  [<ffffffff80279b16>] worker_thread+0x126/0x480
[  278.507652]  [<ffffffff802799f0>] ? process_one_work+0x300/0x300
[  278.507652]  [<ffffffff8027ed14>] kthread+0xc4/0xe0
[  278.507652]  [<ffffffff8027ec50>] ? __kthread_parkme+0x70/0x70
[  278.507652]  [<ffffffff809771df>] ret_from_fork+0x3f/0x70
[  278.507652]  [<ffffffff8027ec50>] ? __kthread_parkme+0x70/0x70
[  278.507652] Code: 00 00 e8 82 6d f4 ff 48 85 c0 48 89 45 a0 0f 85
28 fd ff ff 41 bf f4 ff ff ff e9 bf fe ff ff c7 45 a8 00 00 00 00 e9
b8 fc ff ff <0f> 0b 41 bf e2 ff ff ff e9 a6 fe ff ff 0f 0b 8b 4d a8 8b
55 ac
[  278.507652] RIP  [<ffffffff803e6922>] start_this_handle+0x382/0x3e0
[  278.507652]  RSP <ffff880209267c30>
[  278.775069] ---[ end trace b85bc47b5909067f ]---
[  278.779848] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  278.787306] IP: [<ffffffff8027eebb>] kthread_data+0xb/0x20
[  278.789819] PGD e0b067 PUD e0d067 PMD 0
[  278.789819] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[  278.789819] CPU: 1 PID: 29158 Comm: kworker/1:10 Tainted: G      D
       4.5.0-rc3 #51
[  278.789819] Hardware name: Google Google, BIOS Google 01/01/2011
[  278.789819] task: ffff880213dbbd40 ti: ffff880209264000 task.ti:
ffff880209264000
[  278.789819] RIP: 0010:[<ffffffff8027eebb>]  [<ffffffff8027eebb>]
kthread_data+0xb/0x20
[  278.789819] RSP: 0018:ffff880209267930  EFLAGS: 00010002
[  278.789819] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
[  278.789819] RDX: ffffffff80fbf880 RSI: 0000000000000001 RDI: ffff880213dbbd40
[  278.789819] RBP: ffff880209267930 R08: 00000040e892772b R09: 0000000000000000
[  278.789819] R10: 0000000000000000 R11: ffffea000857da00 R12: ffff880213dbc1f0
[  278.789819] R13: 0000000000013cc0 R14: 0000000000000001 R15: ffff880213dbbd40
[  278.789819] FS:  0000000000000000(0000) GS:ffff88021ef00000(0000)
knlGS:0000000000000000
[  278.789819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  278.789819] CR2: 0000000000000028 CR3: 0000000000e0a000 CR4: 00000000000406e0
[  278.789819] Stack:
[  278.789819]  ffff880209267948 ffffffff802793fc ffff88021ef13cc0
ffff880209267998
[  278.789819]  ffffffff80973ad7 ffff880213dbbd40 ffffffff802a6d22
ffff8802092679b0
[  278.789819]  ffff880209268000 ffff880213dbc0e0 ffffffff80c36d32
ffff880213dbbd40
[  278.789819] Call Trace:
[  278.789819]  [<ffffffff802793fc>] wq_worker_sleeping+0xc/0x90
[  278.789819]  [<ffffffff80973ad7>] __schedule+0x347/0x7d6
[  278.789819]  [<ffffffff802a6d22>] ? call_rcu_sched+0x12/0x20
[  278.789819]  [<ffffffff80973fc0>] schedule+0x30/0x80
[  278.789819]  [<ffffffff8026972a>] do_exit+0x5fa/0xa50
[  278.789819]  [<ffffffff80206058>] oops_end+0x68/0x90
[  278.789819]  [<ffffffff802061b6>] die+0x46/0x60
[  278.789819]  [<ffffffff802038b3>] do_trap+0xa3/0x140
[  278.789819]  [<ffffffff802039c2>] do_error_trap+0x72/0xe0
[  278.789819]  [<ffffffff803e6922>] ? start_this_handle+0x382/0x3e0
[  278.789819]  [<ffffffff80203c6b>] do_invalid_op+0x1b/0x20
[  278.789819]  [<ffffffff80978318>] invalid_op+0x18/0x20
[  278.789819]  [<ffffffff803e6922>] ? start_this_handle+0x382/0x3e0
[  278.789819]  [<ffffffff8032d78a>] ? kmem_cache_alloc+0x10a/0x150
[  278.789819]  [<ffffffff803e6b69>] ? jbd2__journal_start+0x79/0x190
[  278.789819]  [<ffffffff803e6be4>] jbd2__journal_start+0xf4/0x190
[  278.789819]  [<ffffffff803cfc7e>] __ext4_journal_start_sb+0x4e/0x70
[  278.789819]  [<ffffffff803b31ec>] ext4_evict_inode+0x12c/0x3d0
[  278.789819]  [<ffffffff8035338b>] evict+0xbb/0x190
[  278.789819]  [<ffffffff80354190>] iput+0x130/0x190
[  278.789819]  [<ffffffff80360223>] inode_switch_wbs_work_fn+0x343/0x4c0
[  278.789819]  [<ffffffff80279819>] process_one_work+0x129/0x300
[  278.789819]  [<ffffffff802ab1a3>] ? try_to_del_timer_sync+0x43/0x60
[  278.789819]  [<ffffffff80279b16>] worker_thread+0x126/0x480
[  278.789819]  [<ffffffff802799f0>] ? process_one_work+0x300/0x300
[  278.789819]  [<ffffffff8027ed14>] kthread+0xc4/0xe0
[  278.789819]  [<ffffffff8027ec50>] ? __kthread_parkme+0x70/0x70
[  278.789819]  [<ffffffff809771df>] ret_from_fork+0x3f/0x70
[  278.789819]  [<ffffffff8027ec50>] ? __kthread_parkme+0x70/0x70
[  278.789819] Code: 25 80 ac 00 00 48 8b 80 50 04 00 00 5d 48 8b 40
c8 48 d1 e8 83 e0 01 c3 0f 1f 84 00 00 00 00 00 55 48 8b 87 50 04 00
00 48 89 e5 <48> 8b 40 d8 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00
00 00
[  278.789819] RIP  [<ffffffff8027eebb>] kthread_data+0xb/0x20
[  278.789819]  RSP <ffff880209267930>
[  278.789819] CR2: ffffffffffffffd8
[  278.789819] ---[ end trace b85bc47b59090680 ]---
