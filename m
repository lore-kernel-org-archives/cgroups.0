From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V5 5/8] memcg: add per cgroup writeback pages accounting
Date: Sat, 3 Aug 2013 17:25:01 +0800
Message-ID: <CAFj3OHV-VCKJfe6bv4UMvv+uj4LELDXsieRZFJD06Yrdyy=XxA@mail.gmail.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
	<1375358051-10306-1-git-send-email-handai.szj@taobao.com>
	<20130801145302.GJ5198@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=/XAdOM7FbtB0Z5JUumFUXbGVA62X9VK6VAbmhWX01To=;
        b=hApmkgBz959e4fomIykX5s5hbZXwSJcxWXqDO/f7NwXWrXDKveIGEOrDSSv8F5rzY0
         BW2C3zBz2MB8HvGH9aX20w8DFBqVR6hx2Dut2GJmxXCpMHBd8wAcDDnX54DVHemqMogq
         NvnPvlLMiKq2mpOt7IDCPCMCEhRsXme2z+fRhieHIlnYRbKxwfwXMf0O8sbHIsF9GKwI
         TFEEr0PXN5xjzy97SZxH7T87QjO2Is69bYf1V1D/73cPhG45B1A3OeO/QPIOhESAKk68
         d5IcDF9CqU4E0cHCS3RegKisxJys0b2sawd/NUb1h+42zLdry06RXqUXNSw4v1RdAOoj
         d8Dw==
In-Reply-To: <20130801145302.GJ5198-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 1, 2013 at 10:53 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Thu 01-08-13 19:54:11, Sha Zhengju wrote:
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
>> Lock order:
>>       --> memcg->move_lock
>>         --> mapping->tree_lock
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> Looks good to me. Maybe I would suggest moving this patch up the stack
> so that it might get merged earlier as it is simpler than dirty pages
> accounting. Unless you insist on having the full series merged at once.

I think the following three patches can be merged earlier:
      1/8 memcg: remove MEMCG_NR_FILE_MAPPED
      3/8 memcg: check for proper lock held in mem_cgroup_update_page_stat
      5/8 memcg: add per cgroup writeback pages accounting

Do I need to resent them again for you or they're enough?

One more word, since dirty accounting is essential to future memcg
dirty page throttling and it is not an optional feature now, I suspect
whether we can merge the following two as well and leave the overhead
optimization a separate series.  :p
      4/5 memcg: add per cgroup dirty pages accounting
      8/8 memcg: Document cgroup dirty/writeback memory statistics

The 2/8 ceph one still need more improvement, I'll separate it next version.

>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thank you.

>
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
>> index 8f3e514..6c18a6d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -91,6 +91,7 @@ static const char * const mem_cgroup_stat_names[] = {
>>       "rss_huge",
>>       "mapped_file",
>>       "dirty",
>> +     "writeback",
>>       "swap",
>>  };
>>
>> @@ -3812,6 +3813,10 @@ static int mem_cgroup_move_account(struct page *page,
>>               mem_cgroup_move_account_page_stat(from, to, nr_pages,
>>                       MEM_CGROUP_STAT_FILE_DIRTY);
>>
>> +     if (PageWriteback(page))
>> +             mem_cgroup_move_account_page_stat(from, to, nr_pages,
>> +                     MEM_CGROUP_STAT_WRITEBACK);
>> +
>>       mem_cgroup_charge_statistics(from, page, anon, -nr_pages);
>>
>>       /* caller should have done css_get */
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index a09f518..2fa6a52 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -2008,11 +2008,17 @@ EXPORT_SYMBOL(account_page_dirtied);
>>
>>  /*
>>   * Helper function for set_page_writeback family.
>> + *
>> + * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
>> + * while calling this function.
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
>> @@ -2243,7 +2249,10 @@ int test_clear_page_writeback(struct page *page)
>>  {
>>       struct address_space *mapping = page_mapping(page);
>>       int ret;
>> +     bool locked;
>> +     unsigned long memcg_flags;
>>
>> +     mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
>>       if (mapping) {
>>               struct backing_dev_info *bdi = mapping->backing_dev_info;
>>               unsigned long flags;
>> @@ -2264,9 +2273,11 @@ int test_clear_page_writeback(struct page *page)
>>               ret = TestClearPageWriteback(page);
>>       }
>>       if (ret) {
>> +             mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
>>               dec_zone_page_state(page, NR_WRITEBACK);
>>               inc_zone_page_state(page, NR_WRITTEN);
>>       }
>> +     mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
>>       return ret;
>>  }
>>
>> @@ -2274,7 +2285,10 @@ int test_set_page_writeback(struct page *page)
>>  {
>>       struct address_space *mapping = page_mapping(page);
>>       int ret;
>> +     bool locked;
>> +     unsigned long flags;
>>
>> +     mem_cgroup_begin_update_page_stat(page, &locked, &flags);
>>       if (mapping) {
>>               struct backing_dev_info *bdi = mapping->backing_dev_info;
>>               unsigned long flags;
>> @@ -2301,6 +2315,7 @@ int test_set_page_writeback(struct page *page)
>>       }
>>       if (!ret)
>>               account_page_writeback(page);
>> +     mem_cgroup_end_update_page_stat(page, &locked, &flags);
>>       return ret;
>>
>>  }
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Michal Hocko
> SUSE Labs



-- 
Thanks,
Sha
