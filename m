From: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] cgroup writeback list corruption
Date: Wed, 9 Mar 2016 08:12:47 -0800
Message-ID: <CAAeU0aPANgyD0dpQYwnuLioEymUzPgfU5JNG_QBz0fy_fn06ng@mail.gmail.com>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=mC7MgaZ26ngcFM53JBPmmMC3COtR/otOgo2qSbs7bY8=;
        b=Xx50cQf55tdxJMj8NfMIIrjaLj3IehFZ9bHunxy2xtIEGW/q9uWSBAyAzHQW71vwya
         Qiy5O6EVwq1IPAsvVlzkBG9I8cH8hskriXAbSLRyxUK1cPfl0pQijqD1Kwdfll38+cwE
         LNOjTEGAgQeuzxbAwBwc0h3KGyWiwKcvC8rtmGjwKKAMLELdy4rl44LkszVA2G1lxDbS
         6x/FxsRealOkBhzdzaY7obeARY3of+kE3dCc5l2wt6fTi4ZD1/4PK4YZHTu6K8xqKQBd
         SRJZzy32I67tisf7z7C+NdGw//6fjKbw/GgDnDkQXRFgAQpcYlNh7U+Rwg5V5E9JZUcB
         tTow==
In-Reply-To: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Ping...

On Wed, Mar 2, 2016 at 2:26 PM, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> cgroup based writeback sometimes appears to manipulate inode->i_io_list
> while holding the lock on the wrong bdi_writeback object.
>
> Following is a crash I was able to produce by adding extra delays in
> between list
> pointer updates (repro patch attached).
>
> [  116.595958] ------------[ cut here ]------------
> [  116.596508] kernel BUG at lib/list_debug.c:74!
> [  116.597000] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  116.597654] CPU: 3 PID: 940 Comm: kworker/u8:6 Not tainted 4.5.0-rc6+ #39
> [  116.598397] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS Bochs 01/01/2011
> [  116.599290] Workqueue: writeback wb_workfn (flush-8:16)
> [  116.599895] task: ffff88007c213700 ti: ffff88007c714000 task.ti:
> ffff88007c714000
> [  116.600006] RIP: 0010:[<ffffffff805a3393>]  [<ffffffff805a3393>]
> __list_del_entry+0x53/0x60
> [  116.600006] RSP: 0018:ffff88007c717c50  EFLAGS: 00010206
> [  116.600006] RAX: dead000000000200 RBX: ffff88007c284818 RCX: ffff88007c717db0
> [  116.600006] RDX: ffff8800765bbdd8 RSI: ffff88007c717c90 RDI: ffff8800768595d8
> [  116.600006] RBP: ffff88007c717c60 R08: ffff8800768591d8 R09: 0000000000000000
> [  116.600006] R10: 0000000000000004 R11: 0000000000000001 R12: ffff88007c284818
> [  116.600006] R13: ffff88007c717c90 R14: ffff88007c284818 R15: ffff88007c717d28
> [  116.600006] FS:  0000000000000000(0000) GS:ffff88007f980000(0000)
> knlGS:0000000000000000
> [  116.600006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  116.600006] CR2: 00007fff5822ff40 CR3: 0000000000e0a000 CR4: 00000000000006e0
> [  116.600006] Stack:
> [  116.600006]  ffff8800768595d8 ffff88007c46f000 ffff88007c717cc8
> ffffffff8035e37f
> [  116.600006]  ffff88007c284828 0000000000000082 000000000000026a
> ffff88007c717cc0
> [  116.600006]  ffff8800768111d8 ffff880076a309d8 ffff88007c284800
> ffff88007c284828
> [  116.600006] Call Trace:
> [  116.600006]  [<ffffffff8035e37f>] move_expired_inodes+0x4f/0x180
> [  116.600006]  [<ffffffff8035f0a1>] queue_io+0x61/0xb0
> [  116.600006]  [<ffffffff80360813>] wb_writeback+0x1a3/0x1e0
> [  116.600006]  [<ffffffff803609db>] wb_workfn+0x18b/0x280
> [  116.600006]  [<ffffffff802795a8>] process_one_work+0x128/0x300
> [  116.600006]  [<ffffffff802798a0>] worker_thread+0x120/0x480
> [  116.600006]  [<ffffffff80279780>] ? process_one_work+0x300/0x300
> [  116.600006]  [<ffffffff8027ea64>] kthread+0xc4/0xe0
> [  116.600006]  [<ffffffff8032d1e8>] ? kfree+0xc8/0x100
> [  116.600006]  [<ffffffff8027e9a0>] ? __kthread_parkme+0x70/0x70
> [  116.600006]  [<ffffffff80970bdf>] ret_from_fork+0x3f/0x70
> [  116.600006]  [<ffffffff8027e9a0>] ? __kthread_parkme+0x70/0x70
> [  116.600006] Code: 39 c3 74 29 48 3b 3b 75 22 49 3b 7c 24 08 75 19
> 49 89 5c 24 08 e8 fe fd ff ff 4c 89 23 e8 f6 fd ff ff 5b 41 5c 5d c3
> 0f 0b 0f 0b <0f> 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48
> 89 fb
> [  116.600006] RIP  [<ffffffff805a3393>] __list_del_entry+0x53/0x60
> [  116.600006]  RSP <ffff88007c717c50>
> [  116.623099] ---[ end trace ff07596b6e4f4928 ]---
>
>
>
> I see a few places where a wrong bdi_writeback object may be locked while
> manipulating inode->i_io_list links.
>
> The first one is in writeback_single_inode():
>
> 1353        spin_lock(&wb->list_lock);
> 1354        spin_lock(&inode->i_lock);
> 1355        /*
> 1356         * If inode is clean, remove it from writeback lists.
> Otherwise don't
> 1357         * touch it. See comment above for explanation.
> 1358         */
> 1359        if (!(inode->i_state & I_DIRTY_ALL))
> 1360                inode_io_list_del_locked(inode, wb);
> 1361        spin_unlock(&wb->list_lock);
>
> The locked wb is passed in as a parameter and equals to inode_to_bdi(inode)->wb.
> But this may not actually match inode->i_wb.
>
>
> The second one  is in writeback_sb_inodes():
>
> 1499                __writeback_single_inode(inode, &wbc);
> 1500
> 1501                wbc_detach_inode(&wbc);
> 1502                work->nr_pages -= write_chunk - wbc.nr_to_write;
> 1503                wrote += write_chunk - wbc.nr_to_write;
> 1504
> 1505                if (need_resched()) {
> 1506                        /*
> 1507                         * We're trying to balance between
> building up a nice
> 1508                         * long list of IOs to improve our merge rate, and
> 1509                         * getting those IOs out quickly for
> anyone throttling
> 1510                         * in balance_dirty_pages().  cond_resched() doesn't
> 1511                         * unplug, so get our IOs out the door before we
> 1512                         * give up the CPU.
> 1513                         */
> 1514                        blk_flush_plug(current);
> 1515                        cond_resched();
> 1516                }
> 1517
> 1518
> 1519                spin_lock(&wb->list_lock);
> 1520                spin_lock(&inode->i_lock);
> 1521                if (!(inode->i_state & I_DIRTY_ALL))
> 1522                        wrote++;
> 1523                requeue_inode(inode, wb, &wbc);
>
> After wbc_detach_inode() is called, inode's i_wb could have changed. So locking
> the original wb seems wrong. The same issue exists in writeback_single_inode().
>
>
> Repro patch:
>
> ---
>  fs/fs-writeback.c    |  4 ++++
>  include/linux/list.h |  6 ++++++
>  lib/list_debug.c     | 29 ++++++++++++++++-------------
>  repro.sh             | 31 +++++++++++++++++++++++++++++++
>  4 files changed, 57 insertions(+), 13 deletions(-)
>  create mode 100755 repro.sh
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 1f76d89..bd1bd75 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1301,6 +1301,8 @@ __writeback_single_inode(struct inode *inode,
> struct writeback_control *wbc)
>   return ret;
>  }
>
> +atomic_t slow_down = ATOMIC_INIT(0);
> +
>  /*
>   * Write out an inode's dirty pages. Either the caller has an active reference
>   * on the inode or the inode has I_WILL_FREE set.
> @@ -1315,6 +1317,7 @@ writeback_single_inode(struct inode *inode,
> struct bdi_writeback *wb,
>  {
>   int ret = 0;
>
> + atomic_inc(&slow_down);
>   spin_lock(&inode->i_lock);
>   if (!atomic_read(&inode->i_count))
>   WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
> @@ -1362,6 +1365,7 @@ writeback_single_inode(struct inode *inode,
> struct bdi_writeback *wb,
>   inode_sync_complete(inode);
>  out:
>   spin_unlock(&inode->i_lock);
> + atomic_dec(&slow_down);
>   return ret;
>  }
>
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 30cf420..e3b032b 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -6,6 +6,8 @@
>  #include <linux/poison.h>
>  #include <linux/const.h>
>  #include <linux/kernel.h>
> +#include <asm/atomic.h>
> +#include <asm/processor.h>
>
>  /*
>   * Simple doubly linked list implementation.
> @@ -77,6 +79,8 @@ static inline void list_add_tail(struct list_head
> *new, struct list_head *head)
>   __list_add(new, head->prev, head);
>  }
>
> +void do_delay(void);
> +
>  /*
>   * Delete a list entry by making the prev/next entries
>   * point to each other.
> @@ -87,7 +91,9 @@ static inline void list_add_tail(struct list_head
> *new, struct list_head *head)
>  static inline void __list_del(struct list_head * prev, struct list_head * next)
>  {
>   next->prev = prev;
> + do_delay();
>   WRITE_ONCE(prev->next, next);
> + do_delay();
>  }
>
>  /**
> diff --git a/lib/list_debug.c b/lib/list_debug.c
> index 3345a08..7195c4f 100644
> --- a/lib/list_debug.c
> +++ b/lib/list_debug.c
> @@ -19,6 +19,14 @@ void list_force_poison(struct list_head *entry)
>   entry->prev = &force_poison;
>  }
>
> +extern atomic_t slow_down;
> +
> +void do_delay() {
> + int i;
> + for (i=0; atomic_read(&slow_down) && i<100000; i++)
> + cpu_relax();
> +}
> +
>  /*
>   * Insert a new entry between two known consecutive entries.
>   *
> @@ -44,9 +52,13 @@ void __list_add(struct list_head *new,
>       "list_add double add: new=%p, prev=%p, next=%p.\n",
>       new, prev, next);
>   next->prev = new;
> + do_delay();
>   new->next = next;
> + do_delay();
>   new->prev = prev;
> + do_delay();
>   WRITE_ONCE(prev->next, new);
> + do_delay();
>  }
>  EXPORT_SYMBOL(__list_add);
>
> @@ -57,19 +69,10 @@ void __list_del_entry(struct list_head *entry)
>   prev = entry->prev;
>   next = entry->next;
>
> - if (WARN(next == LIST_POISON1,
> - "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
> - entry, LIST_POISON1) ||
> -    WARN(prev == LIST_POISON2,
> - "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
> - entry, LIST_POISON2) ||
> -    WARN(prev->next != entry,
> - "list_del corruption. prev->next should be %p, "
> - "but was %p\n", entry, prev->next) ||
> -    WARN(next->prev != entry,
> - "list_del corruption. next->prev should be %p, "
> - "but was %p\n", entry, next->prev))
> - return;
> + BUG_ON(next == LIST_POISON1);
> + BUG_ON(prev == LIST_POISON2);
> + BUG_ON(prev->next != entry);
> + BUG_ON(next->prev != entry);
>
>   __list_del(prev, next);
>  }
> diff --git a/repro.sh b/repro.sh
> new file mode 100755
> index 0000000..05de4c7
> --- /dev/null
> +++ b/repro.sh
> @@ -0,0 +1,31 @@
> +#!/bin/bash
> +
> +CGROUP_ROOT=/mnt-cgroup2
> +
> +mkdir -p $CGROUP_ROOT
> +
> +if ! mount | grep -qw cgroup2; then
> +  mount -t cgroup2 none $CGROUP_ROOT
> +fi
> +
> +mkdir -p $CGROUP_ROOT/mem1
> +
> +echo '+memory' > $CGROUP_ROOT/cgroup.subtree_control
> +
> +echo $$ > $CGROUP_ROOT/mem1/cgroup.procs
> +
> +if dumpe2fs -h /dev/sdb |grep -q 'Journal size'; then
> +  echo 'This repro requires ext4 without journaling'
> +  exit 1
> +fi
> +
> +if ! mount | grep -qw /dev/sdb; then
> +  mount /dev/sdb /mnt/sdb
> +fi
> +
> +(for i in {1..10000}; do dd if=/dev/urandom of=/mnt/sdb/fsync1
> bs=4096 count=1 conv=notrunc,fsync &> /dev/null; done)&
> +
> +(for i in {1..10000};do dd if=/dev/urandom of=/mnt/sdb/mark_dirty$i
> bs=4096 count=1 conv=notrunc &> /dev/null;done)&
> +
> +wait
> +
> --
> 2.7.0.rc3.207.g0ac5344
