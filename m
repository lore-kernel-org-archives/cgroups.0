From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 4/6] memcg: add per cgroup writeback pages accounting
Date: Fri, 12 Jul 2013 00:56:31 +0800
Message-ID: <CAFj3OHXSFWW2oXRu2t+oiKWo2Nw8eLyxsPi0MprrEzJSMcefaQ@mail.gmail.com>
References: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
	<1373045577-27671-1-git-send-email-handai.szj@taobao.com>
	<20130711144003.GJ21667@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=kyogiSk3VYmIyMyVkHY1MuC1i6lPVuwFdXcRSYRHr78=;
        b=hf49+t/LtGT51vEO0jXbQgCJ6VtUMzWqmrEPgt8JDO2MW7FWLqiprbPTRymC7aVauu
         TXcuRtpZ54Tqnw8fCJm50F2mCqZm3e/hxVdLink8cYdhSLeUi1QTH7j5U1RxJ6uEX5jb
         rZjYfbbl9Ke5mWlyClDHnvUHODgzu4gZDzYULb6mYJ+Xi9NbLUK9tMLfZOPtypcU8Cwn
         fdYcS3pHipakNqbFiqCyVdlWhS72NViRPP2esepAMGTSlWmTlAXBWjoLUuEe8lWDc1Ic
         nroU8fdZ5gbSBFEggFSizyoVhN8gaFUdXdsKNrwLLjHfRt49DndZmsCEgGWxnYfDNIkt
         o0Bg==
In-Reply-To: <20130711144003.GJ21667-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, Jul 11, 2013 at 10:40 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Sat 06-07-13 01:32:57, Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
>> rule still is:
>>         mem_cgroup_begin_update_page_stat()
>>         modify page WRITEBACK stat
>>         mem_cgroup_update_page_stat()
>>         mem_cgroup_end_update_page_stat()
>>
>> There're two writeback interfaces to modify: test_{clear/set}_page_writeback().
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>  include/linux/memcontrol.h |    1 +
>>  mm/memcontrol.c            |    5 +++++
>>  mm/page-writeback.c        |   15 +++++++++++++++
>>  3 files changed, 21 insertions(+)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index f952be6..ccd35d8 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -43,6 +43,7 @@ enum mem_cgroup_stat_index {
>>       MEM_CGROUP_STAT_RSS_HUGE,       /* # of pages charged as anon huge */
>>       MEM_CGROUP_STAT_FILE_MAPPED,    /* # of pages charged as file rss */
>>       MEM_CGROUP_STAT_FILE_DIRTY,     /* # of dirty pages in page cache */
>> +     MEM_CGROUP_STAT_WRITEBACK,      /* # of pages under writeback */
>>       MEM_CGROUP_STAT_SWAP,           /* # of pages, swapped out */
>>       MEM_CGROUP_STAT_NSTATS,
>>  };
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1d31851..9126abc 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -92,6 +92,7 @@ static const char * const mem_cgroup_stat_names[] = {
>>       "mapped_file",
>>       "swap",
>>       "dirty",
>> +     "writeback",
>
> Ordering issue again (see mem_cgroup_stat_index)

Yes, you're right.

>
>>  };
>>
>>  enum mem_cgroup_events_index {
> [...]
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 3900e62..85de9a0 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -2008,11 +2008,17 @@ EXPORT_SYMBOL(account_page_dirtied);
>>
>>  /*
>>   * Helper function for set_page_writeback family.
>> + *
>> + * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
>> + * while modifying struct page state and accounting writeback pages.
>
> I guess "while calling this function" would be sufficient

Thanks for the advice.

>
>> + * See test_set_page_writeback for example.
>> + *
>>   * NOTE: Unlike account_page_dirtied this does not rely on being atomic
>>   * wrt interrupts.
>>   */
>>  void account_page_writeback(struct page *page)
>>  {
>> +     mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
>>       inc_zone_page_state(page, NR_WRITEBACK);
>>  }
>>  EXPORT_SYMBOL(account_page_writeback);
> [...]
> --
> Michal Hocko
> SUSE Labs



--
Thanks,
Sha
