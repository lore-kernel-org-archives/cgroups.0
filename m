From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup writeback list corruption
Date: Wed, 16 Mar 2016 15:10:15 -0700
Message-ID: <20160316221015.GL21104@mtj.duckdns.org>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TiOIfCqOXxH3ImOOagLe3xyvI8PrY3V8zfoXeYbBQbM=;
        b=izqLrf5pdSGt1LhnfJ7SyBDzea5gGKMYfQxkp/KslGeycFqXrzCZruRhR/LZ7/VEbK
         DqqKxyg6hgcSD4QyyzXMXtcZiJERMa5dCQ86KC1C/2SV54KvRGabr+qs/y2nlHnh/wGo
         gsWkqUZK3Oz9H+ViPJS+qs1iCeHlPbQFyyPkIBL/kCfI0zho++KHctXnEmgbyKl/Agqv
         F3ILM1OkG9DVsddxJftSlDJ2gmALoLO0szFg3ay84q6A5qr3mWYPJGx6Lx4be8W1CB5E
         bqpYK+Yp+zNop4S26vAj/ylGwIPgTCky2RCbRDJLo9b5/cfmi/s0NRuaqgwrWm9NYFMB
         Xg+g==
Content-Disposition: inline
In-Reply-To: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Tahsin.

On Wed, Mar 02, 2016 at 02:26:45PM -0800, Tahsin Erdogan wrote:
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

Oops, yeah, that's a stupid bug.  Thanks for spotting it.  We probably
should drop @wb parameter from the function and grab the associated wb
there.

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

Yes, I'll add a helper to grab the current wb and convert these sites
to use it.  Thanks a lot for spotting these!

-- 
tejun
