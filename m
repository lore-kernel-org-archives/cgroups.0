From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from add_to_page_cache_locked
Date: Thu, 07 Feb 2013 20:27:00 -0800
Message-ID: <xr93ip63ig6j.fsf@gthelen.mtv.corp.google.com>
References: <20121230020947.AA002F34@pobox.sk>
	<20121230110815.GA12940@dhcp22.suse.cz>
	<20130125160723.FAE73567@pobox.sk>
	<20130125163130.GF4721@dhcp22.suse.cz>
	<20130205134937.GA22804@dhcp22.suse.cz>
	<20130205154947.CD6411E2@pobox.sk>
	<20130205160934.GB22804@dhcp22.suse.cz>
	<xr93wqum4sh4.fsf@gthelen.mtv.corp.google.com>
	<20130205174651.GA3959@dhcp22.suse.cz>
	<xr93a9ri4op6.fsf@gthelen.mtv.corp.google.com>
	<20130205185953.GB3959@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        bh=eJdj6HM2C2Jhcm5hTl+jIaADBHnIcTOL5GfTHPhB10k=;
        b=WeBX76ue/sWvnLD0DAGueZ4S6kL1GRL+nkBOu5Gh8Gy4IIN8VF7OZunqoO43JqP1aC
         jbgDnpo/rh5nOspwIQJ/qFvfd+QdyjGskvo/ZFOHZKn3YIUYiVehE753ZwCCaqvZ5dUn
         mG+exXLNhV+WVyZVDlhVu3n/6eqraAoMna6F9quXciRozdRUxYfpXV0cOYGwDHmeWqZO
         6A/wXg/7sQNXm6RDBPgCK7Ffm+65qawGxuorB3W+YqEVnNNHjGV7lgIOSj0lJC8t76CH
         aG0UfxFJYb4Z3hIVhIOiQUYn/5NA4/Uriuf7xvZUX5PS77/RfXA4Xc+JttMdSm5RVlhh
         NNHQ==
In-Reply-To: <20130205185953.GB3959@dhcp22.suse.cz> (Michal Hocko's message of
	"Tue, 5 Feb 2013 19:59:53 +0100")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Tue, Feb 05 2013, Michal Hocko wrote:

> On Tue 05-02-13 10:09:57, Greg Thelen wrote:
>> On Tue, Feb 05 2013, Michal Hocko wrote:
>> 
>> > On Tue 05-02-13 08:48:23, Greg Thelen wrote:
>> >> On Tue, Feb 05 2013, Michal Hocko wrote:
>> >> 
>> >> > On Tue 05-02-13 15:49:47, azurIt wrote:
>> >> > [...]
>> >> >> Just to be sure - am i supposed to apply this two patches?
>> >> >> http://watchdog.sk/lkml/patches/
>> >> >
>> >> > 5-memcg-fix-1.patch is not complete. It doesn't contain the folloup I
>> >> > mentioned in a follow up email. Here is the full patch:
>> >> > ---
>> >> > From f2bf8437d5b9bb38a95a432bf39f32c584955171 Mon Sep 17 00:00:00 2001
>> >> > From: Michal Hocko <mhocko@suse.cz>
>> >> > Date: Mon, 26 Nov 2012 11:47:57 +0100
>> >> > Subject: [PATCH] memcg: do not trigger OOM from add_to_page_cache_locked
>> >> >
>> >> > memcg oom killer might deadlock if the process which falls down to
>> >> > mem_cgroup_handle_oom holds a lock which prevents other task to
>> >> > terminate because it is blocked on the very same lock.
>> >> > This can happen when a write system call needs to allocate a page but
>> >> > the allocation hits the memcg hard limit and there is nothing to reclaim
>> >> > (e.g. there is no swap or swap limit is hit as well and all cache pages
>> >> > have been reclaimed already) and the process selected by memcg OOM
>> >> > killer is blocked on i_mutex on the same inode (e.g. truncate it).
>> >> >
>> >> > Process A
>> >> > [<ffffffff811109b8>] do_truncate+0x58/0xa0		# takes i_mutex
>> >> > [<ffffffff81121c90>] do_last+0x250/0xa30
>> >> > [<ffffffff81122547>] path_openat+0xd7/0x440
>> >> > [<ffffffff811229c9>] do_filp_open+0x49/0xa0
>> >> > [<ffffffff8110f7d6>] do_sys_open+0x106/0x240
>> >> > [<ffffffff8110f950>] sys_open+0x20/0x30
>> >> > [<ffffffff815b5926>] system_call_fastpath+0x18/0x1d
>> >> > [<ffffffffffffffff>] 0xffffffffffffffff
>> >> >
>> >> > Process B
>> >> > [<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
>> >> > [<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0
>> >> > [<ffffffff8110c22e>] mem_cgroup_cache_charge+0xbe/0xe0
>> >> > [<ffffffff810ca28c>] add_to_page_cache_locked+0x4c/0x140
>> >> > [<ffffffff810ca3a2>] add_to_page_cache_lru+0x22/0x50
>> >> > [<ffffffff810ca45b>] grab_cache_page_write_begin+0x8b/0xe0
>> >> > [<ffffffff81193a18>] ext3_write_begin+0x88/0x270
>> >> > [<ffffffff810c8fc6>] generic_file_buffered_write+0x116/0x290
>> >> > [<ffffffff810cb3cc>] __generic_file_aio_write+0x27c/0x480
>> >> > [<ffffffff810cb646>] generic_file_aio_write+0x76/0xf0           # takes ->i_mutex
>> >> > [<ffffffff8111156a>] do_sync_write+0xea/0x130
>> >> > [<ffffffff81112183>] vfs_write+0xf3/0x1f0
>> >> > [<ffffffff81112381>] sys_write+0x51/0x90
>> >> > [<ffffffff815b5926>] system_call_fastpath+0x18/0x1d
>> >> > [<ffffffffffffffff>] 0xffffffffffffffff
>> >> 
>> >> It looks like grab_cache_page_write_begin() passes __GFP_FS into
>> >> __page_cache_alloc() and mem_cgroup_cache_charge().  Which makes me
>> >> think that this deadlock is also possible in the page allocator even
>> >> before getting to add_to_page_cache_lru.  no?
>> >
>> > I am not that familiar with VFS but i_mutex is a high level lock AFAIR
>> > and it shouldn't be called from the pageout path so __page_cache_alloc
>> > should be safe.
>> 
>> I wasn't clear, sorry.  My concern is not that pageout() grabs i_mutex.
>> My concern is that __page_cache_alloc() will invoke the oom killer and
>> select a victim which wants i_mutex.  This victim will deadlock because
>> the oom killer caller already holds i_mutex.  
>
> That would be true for the memcg oom because that one is blocking but
> the global oom just puts the allocator into sleep for a while and then
> the allocator should back off eventually (unless this is NOFAIL
> allocation). I would need to look closer whether this is really the case
> - I haven't seen that allocator code path for a while...

I think the page allocator can loop forever waiting for an oom victim to
terminate even without NOFAIL.  Especially if the oom victim wants a
resource exclusively held by the allocating thread (e.g. i_mutex).  It
looks like the same deadlock you describe is also possible (though more
rare) without memcg.

If the looping thread is an eligible oom victim (i.e. not oom disabled,
not an kernel thread, etc) then the page allocator can return NULL in so
long as NOFAIL is not used.  So any allocator which is able to call the
oom killer and is not oom disabled (kernel thread, etc) is already
exposed to the possibility of page allocator failure.  So if the page
allocator could detect the deadlock, then it could safely return NULL.
Maybe after looping N times without forward progress the page allocator
should consider failing unless NOFAIL is given.

Switching back to the memcg oom situation, can we similarly return NULL
if memcg oom kill has been tried a reasonable number of times.  Simply
failing the memcg charge with ENOMEM seems easier to support than
exceeding limit (Kame's loan patch).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
