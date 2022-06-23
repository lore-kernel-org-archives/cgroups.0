From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [syzbot] WARNING in folio_lruvec_lock_irqsave
Date: Wed, 22 Jun 2022 19:52:21 -0700
Message-ID: <YrPVZUXPD7L85mYp@castle>
References: <0000000000004b03c805e2099bf0@google.com>
 <YrM2XCwzu65cb81r@FVFYT0MHHV2J.googleapis.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655952751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ef3A1jFIk2ghqaCFE7HOz1021sh7n1eb4f8YSnsvNOY=;
        b=ViJppFGoJrwP5h680sfYXw1Y9s8cIL0aKAFEl4ZiYQmr6iSkfPVYxsUcUNGXKZIiTskxQU
        vmVaYfTWetOSQCr9u8cv9FiHmJy6qauUqIRPKcmypu9C/UxZtdgNyFLNfUl6Mh2NEklMIR
        +cRZGMjxvfj5QKmWeBjqr3rN77zYeqI=
Content-Disposition: inline
In-Reply-To: <YrM2XCwzu65cb81r-t1y1lxtqHnkkxugUQmjJ3WroNbXEc4rFQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: syzbot <syzbot+ec972d37869318fc3ffb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On Wed, Jun 22, 2022 at 11:33:48PM +0800, Muchun Song wrote:
> On Wed, Jun 22, 2022 at 06:49:31AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    ac0ba5454ca8 Add linux-next specific files for 20220622
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14354c18080000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=12809dacb9e7c5e0
> > dashboard link: https://syzkaller.appspot.com/bug?extid=ec972d37869318fc3ffb
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+ec972d37869318fc3ffb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> > 
> >  folio_put include/linux/mm.h:1227 [inline]
> >  put_page+0x217/0x280 include/linux/mm.h:1279
> >  unmap_and_move_huge_page mm/migrate.c:1343 [inline]
> >  migrate_pages+0x3dc3/0x5a10 mm/migrate.c:1440
> >  do_mbind mm/mempolicy.c:1332 [inline]
> >  kernel_mbind+0x4d7/0x7d0 mm/mempolicy.c:1479
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > page has been migrated, last migrate reason: mempolicy_mbind
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 18925 at include/linux/memcontrol.h:800 folio_lruvec include/linux/memcontrol.h:800 [inline]
> 
> The warning here is "VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled(), folio)",
> the memcg returned by folio_memcg() seems to be NULL which has 2 possibility, one is
> that objcg returned by folio_objcg() is NULL, another is that obj_cgroup_memcg(objcg)
> returns NULL. However, obj_cgroup_memcg() always returns a valid memcg. So Most likely
> objcg is NULL meaning this page is not charged to memcg. Is this possible for LRU pages?
> 
> I am not sure if this issue is caused by my commit cca700a8e695 ("mm: lru: use lruvec
> lock to serialize memcg changes") since I have removed folio_test_clear_lru() check
> from folio_batch_move_lru(). We know that a non-lru page may be not charged to memcg.
> But is it possible for a non-lru page to be passed to folio_batch_move_lru()? Seems
> impossible. Right? I am not very confident about this commit, hopefully, someone can
> review it.

How about to temporarily drop it?

I was about to suggest it anyway during the review: it's a standalone
optimization and the main patchset is already quite big and complex,
so probably easier to validate it separately.

Thanks!
