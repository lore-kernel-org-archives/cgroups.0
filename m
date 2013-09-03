From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Race condition between "read CFQ stats" and "block device shutdown"
Date: Tue, 3 Sep 2013 13:14:07 -0700
Message-ID: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=h9i8xud/NxxsofTAnsTXmXNNEqMrlvv4dbkWSUcNGts=;
        b=xRQL+LZ8v35aRvc+IYnH4qSnbvPG7b30MK1tzc5Hjema2UzwrB7mkm5kDJgdGTS1dm
         7w4wa8imYNRwSkaVU1hrE2e5BggGHDIWqSUoHBWNypi358J+e6wC3PFO8tujZDtVZpo+
         cdiXakCf9e05I/Togw7xXWv79VF6jSFqeFtzvDMAxAGsXda+t/YM7lUQLrUZvbBc53bH
         mVBJvALws5ieemxJxUDmBJfvVcTE9GFjN8e8UoFJRJ3xduCV+pBdl/V1phCgxD4167Kh
         rxjeX3s6gKwf6ICkN7KO+6XNrYvJcw81/mVjSYNHH+9KcYXs6W+6o0qO4khwPYfM6Qk5
         p0Qw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hi,

I am running a program that checkes "read CFQ stat files" for race
conditions with other evens (e.g. device shutdown).

And I discovered an interesting bug. Here is the "double_unlock" crash for it


print_unlock_imbalance_bug.isra.23+0x4/0x10
[ 261.453775] [<ffffffff810f7c65>] lock_release_non_nested.isra.39+0x2f5/0x300
[ 261.460900] [<ffffffff810f7cfe>] lock_release+0x8e/0x1f0
[ 261.466293] [<ffffffff81339030>] ? cfqg_prfill_service_level+0x60/0x60
[ 261.472894] [<ffffffff81005be3>] _raw_spin_unlock_irq+0x23/0x50
[ 261.478894] [<ffffffff8133559f>] blkcg_print_blkgs+0x8f/0x140
[ 261.484724] [<ffffffff81335515>] ? blkcg_print_blkgs+0x5/0x140
[ 261.490631] [<ffffffff81338a7f>] cfqg_print_weighted_queue_time+0x2f/0x40
[ 261.497489] [<ffffffff8110b793>] cgroup_seqfile_show+0x53/0x60
[ 261.503398] [<ffffffff811f1fe4>] seq_read+0x124/0x3a0
[ 261.508529] [<ffffffff811ce39d>] vfs_read+0xad/0x180
[ 261.513576] [<ffffffff811ce625>] SyS_read+0x55/0xa0
[ 261.518538] [<ffffffff81609f66>] cstar_dispatch+0x7/0x1f

blkcg_print_blkgs fails with double unlock? Hmm, I checked
cfqg_prfill_service_level and I did not find any places where unlock
can happen.

After some debugging I found that in blkcg_print_blkgs() spinlock
passed to spin_lock_irq() function differs from the object passed to
spin_unlock_irq just a few lines below. It means
request_queue->queue_lock spinlock has changed under the function feet
while it was executing!!!

To make sure I added

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -465,10 +465,16 @@ void blkcg_print_blkgs(struct seq_file *sf,
struct blkcg *blkcg,

        rcu_read_lock();
        hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
-               spin_lock_irq(blkg->q->queue_lock);
+               spinlock_t *lock = blkg->q->queue_lock;
+               spinlock_t *new_lock;
+               spin_lock_irq(lock);
                if (blkcg_policy_enabled(blkg->q, pol))
                        total += prfill(sf, blkg->pd[pol->plid], data);
-               spin_unlock_irq(blkg->q->queue_lock);
+               new_lock = blkg->q->queue_lock;
+               if (lock != new_lock) {
+                       pr_err("old lock %p %s  new lock %p %s\n",
lock, lock->dep_map.name, new_lock, new_lock->dep_map.name);
+               }
+               spin_unlock_irq(lock);
        }
        rcu_read_unlock();



And indeed it shows locks are different.


It comes from this change 777eb1bf1 "block: Free queue resources at
blk_release_queue()" that changes lock when devices is shutting down.

What would be the best fix for the issue?
