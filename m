From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: add per cgroup dirty pages accounting
Date: Fri, 22 Jun 2012 08:09:12 +0900
Message-ID: <4FE3A998.3000606@jp.fujitsu.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com> <1339761717-29070-1-git-send-email-handai.szj@taobao.com> <xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com> <4FDC28F0.8050805@jp.fujitsu.com> <CAFj3OHXuX7tpDe4famK3fFMZBcj2w-9mDs9mD9P_-SwaRKx8tg@mail.gmail.com> <4FE2D2F4.2020202@jp.fujitsu.com> <xr938vfgmz4y.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr938vfgmz4y.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2012/06/22 1:02), Greg Thelen wrote:
> On Thu, Jun 21 2012, Kamezawa Hiroyuki wrote:
>
>> (2012/06/19 23:31), Sha Zhengju wrote:
>>> On Sat, Jun 16, 2012 at 2:34 PM, Kamezawa Hiroyuki
>>> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>   wrote:
>>>> (2012/06/16 0:32), Greg Thelen wrote:
>>>>>
>>>>> On Fri, Jun 15 2012, Sha Zhengju wrote:
>>>>>
>>>>>> This patch adds memcg routines to count dirty pages. I notice th=
at
>>>>>> the list has talked about per-cgroup dirty page limiting
>>>>>> (http://lwn.net/Articles/455341/) before, but it did not get mer=
ged.
>>>>>
>>>>>
>>>>> Good timing, I was just about to make another effort to get some =
of
>>>>> these patches upstream.  Like you, I was going to start with some=
 basic
>>>>> counters.
>>>>>
>>>>> Your approach is similar to what I have in mind.  While it is goo=
d to
>>>>> use the existing PageDirty flag, rather than introducing a new
>>>>> page_cgroup flag, there are locking complications (see below) to =
handle
>>>>> races between moving pages between memcg and the pages being {un}=
marked
>>>>> dirty.
>>>>>
>>>>>> I've no idea how is this going now, but maybe we can add per cgr=
oup
>>>>>> dirty pages accounting first. This allows the memory controller =
to
>>>>>> maintain an accurate view of the amount of its memory that is di=
rty
>>>>>> and can provide some infomation while group's direct reclaim is =
working.
>>>>>>
>>>>>> After commit 89c06bd5 (memcg: use new logic for page stat accoun=
ting),
>>>>>> we do not need per page_cgroup flag anymore and can directly use
>>>>>> struct page flag.
>>>>>>
>>>>>>
>>>>>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>>>>> ---
>>>>>>    include/linux/memcontrol.h |    1 +
>>>>>>    mm/filemap.c               |    1 +
>>>>>>    mm/memcontrol.c            |   32 +++++++++++++++++++++++++--=
-----
>>>>>>    mm/page-writeback.c        |    2 ++
>>>>>>    mm/truncate.c              |    1 +
>>>>>>    5 files changed, 30 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontr=
ol.h
>>>>>> index a337c2e..8154ade 100644
>>>>>> --- a/include/linux/memcontrol.h
>>>>>> +++ b/include/linux/memcontrol.h
>>>>>> @@ -39,6 +39,7 @@ enum mem_cgroup_stat_index {
>>>>>>          MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as =
file rss */
>>>>>>          MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>>>>>>          MEM_CGROUP_STAT_DATA, /* end of data requires synchroni=
zation */
>>>>>> +       MEM_CGROUP_STAT_FILE_DIRTY,  /* # of dirty pages in page=
 cache */
>>>>>>          MEM_CGROUP_STAT_NSTATS,
>>>>>>    };
>>>>>>
>>>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>>>> index 79c4b2b..5b5c121 100644
>>>>>> --- a/mm/filemap.c
>>>>>> +++ b/mm/filemap.c
>>>>>> @@ -141,6 +141,7 @@ void __delete_from_page_cache(struct page *p=
age)
>>>>>>           * having removed the page entirely.
>>>>>>           */
>>>>>>          if (PageDirty(page)&&     mapping_cap_account_dirty(map=
ping)) {
>>>>>> +               mem_cgroup_dec_page_stat(page,
>>>>>> MEM_CGROUP_STAT_FILE_DIRTY);
>>>>>
>>>>>
>>>>> You need to use mem_cgroup_{begin,end}_update_page_stat around cr=
itical
>>>>> sections that:
>>>>> 1) check PageDirty
>>>>> 2) update MEM_CGROUP_STAT_FILE_DIRTY counter
>>>>>
>>>>> This protects against the page from being moved between memcg whi=
le
>>>>> accounting.  Same comment applies to all of your new calls to
>>>>> mem_cgroup_{dec,inc}_page_stat.  For usage pattern, see
>>>>> page_add_file_rmap.
>>>>>
>>>>
>>>> If you feel some difficulty with mem_cgroup_{begin,end}_update_pag=
e_stat(),
>>>> please let me know...I hope they should work enough....
>>>>
>>>
>>> Hi, Kame
>>>
>>> While digging into the bigger lock of mem_cgroup_{begin,end}_update=
_page_stat(),
>>> I find the reality is more complex than I thought. Simply stated,
>>> modifying page info
>>> and update page stat may be wide apart and in different level (eg.
>>> mm&fs), so if we
>>> use the big lock it may lead to scalability and maintainability iss=
ues.
>>>
>>> For example:
>>>        mem_cgroup_begin_update_page_stat()
>>>        modify page information                 =3D>   TestSetPageDi=
rty in=E3=80=80ceph_set_page_dirty() (fs/ceph/addr.c)
>>>        XXXXXX                                  =3D>   other fs oper=
ations
>>>        mem_cgroup_update_page_stat()   =3D>   account_page_dirtied(=
) in=E3=80=80mm/page-writeback.c
>>>        mem_cgroup_end_update_page_stat().
>>>
>>> We can choose to get lock in higher level meaning vfs set_page_dirt=
y()
>>> but this may span
>>> too much and can also have some missing cases.
>>> What's your opinion of this problem?
>>>
>>
>> yes, that's sad....If set_page_dirty() is always called under lock_p=
age(), the
>> story will be easier (we'll take lock_page() in move side.)
>> but the comment on set_page_dirty() says it's not true.....Now, I ha=
ven't found a magical
>> way for avoiding the race.
>> (*) If holding lock_page() in move_account() can be a generic soluti=
on, it will be good.
>>      A proposal from me is a small-start. You can start from adding =
hooks to a
>> generic
>> functions as set_page_dirty() and __set_page_dirty_nobuffers(), clea=
r_page_dirty_for_io().
>>
>> And see what happens. I guess we can add WARN_ONCE() against callers=
 of update_page_stat()
>> who don't take mem_cgroup_begin/end_update_page_stat()
>> (by some new check, for example, checking !rcu_read_lock_held() in u=
pdate_stat())
>>
>> I think we can make TODO list and catch up remaining things one by o=
ne.
>>
>> Thanks,
>> -Kame
>
> This might be a crazy idea.  Synchronization of PageDirty with the
> page->memcg->nr_dirty counter is a challenge because page->memcg can =
be
> reassigned due to inter-memcg page moving.

Yes. That's the heart of the problem.

> Could we avoid moving dirty pages between memcg?

How to detect it is the proebm here....

> Specifically, could we make them clean before moving.

I considered that but a case

		CPU-A				CPU-B
	wait_for_page_cleaned
	.....					SetPageDirty()
	account-memcg-nr_dirty

is problematic. _If_

		CPU-A		=09
	lock_page()
	move_page_for_accounting()
	unlock_page()

can help 99% of cases, I think this is a choice. But I haven't investig=
ated
how many callers of set_page_dirty() holds locks....
(I guess CleraPageDirty() callers are under lock_page() always...by qui=
ck look.)

If most of callers calls lock_page() or mem_cgroup_begin/end_update....=
I think
adding WARNING(!page_locked(page) || !rcu_read_locked()) to update_stat=
() will
be a proof of concept and automatically shows what we should do more...

> This problem feels similar to page migration.  This would slow
> down inter-memcg page movement, because it would require writeback.  =
But
> I'm suspect that this is an infrequent operation.

I agree. But, IIUC, the reason page-migration waits for the end of I/O =
is that migrating
pages under I/O (in being copied by devices) seems crazy. So, just lock=
_page()
will be an enough help....

Thanks,
-Kame





