From: Vern Hao <haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: add THP swap out info for anonymous reclaim
Date: Tue, 12 Sep 2023 09:49:04 +0800
Message-ID: <6b0447d0-30c7-4432-a4f3-97e2d27e9e3b@gmail.com>
References: <20230909155242.22767-1-vernhao@tencent.com>
 <20230911160824.GB103342@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694483352; x=1695088152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4C6fCAbfQ04p8mFbrpL2ZAAFU2CUe5VETqkFVwtItV8=;
        b=mQgVeNINuE+EX8YyL7/+XZvVpEbnTI6QKJZVbshrNIr330wsnRKU0p+iMqcdprnJCb
         gcaznEY8HYc1K6p97adQXiTMuZhHSVm73GsfHqaoLfU1r2keKhOOjZeSYa2KJifevH8V
         cCiWRJ/W4kURpU6TUoDCah2re1zYZkSxZHKQORcXWMJfOMg1XPSu1I8n9Kf4TjCeohkM
         zFCiI8UvaIztZpX42dY1swbmoI1OJ51NA4PHkz65F1NP6WpPZhObwUXe3Ik5frnptnHY
         Fh7mLNv38fUZolPANf7OUpWr89lyKImnyruYj0KgmoVQ0bVWrqKfxaKtFxZmuYbfXeL+
         tEQg==
In-Reply-To: <20230911160824.GB103342-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


在 2023/9/12 00:08, Johannes Weiner 写道:
> On Sat, Sep 09, 2023 at 11:52:41PM +0800, Xin Hao wrote:
>> At present, we support per-memcg reclaim strategy, however we do not
>> know the number of transparent huge pages being reclaimed, as we know
>> the transparent huge pages need to be splited before reclaim them, and
>> they will bring some performance bottleneck effect. for example, when
>> two memcg (A & B) are doing reclaim for anonymous pages at same time,
>> and 'A' memcg is reclaiming a large number of transparent huge pages, we
>> can better analyze that the performance bottleneck will be caused by 'A'
>> memcg.  therefore, in order to better analyze such problems, there add
>> THP swap out info for per-memcg.
>>
>> Signed-off-by: Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> That sounds reasonable. A few comments below:
>
>> @@ -4131,6 +4133,10 @@ static const unsigned int memcg1_events[] = {
>>   	PGPGOUT,
>>   	PGFAULT,
>>   	PGMAJFAULT,
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +	THP_SWPOUT,
>> +	THP_SWPOUT_FALLBACK,
>> +#endif
>>   };
> Cgroup1 is maintenance-only, please drop this hunk.
Will remove it next version thanks.
>
>>   static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>> diff --git a/mm/page_io.c b/mm/page_io.c
>> index fe4c21af23f2..008ada2e024a 100644
>> --- a/mm/page_io.c
>> +++ b/mm/page_io.c
>> @@ -208,8 +208,10 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>>   static inline void count_swpout_vm_event(struct folio *folio)
>>   {
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	if (unlikely(folio_test_pmd_mappable(folio)))
>> +	if (unlikely(folio_test_pmd_mappable(folio))) {
>> +		count_memcg_events(folio_memcg(folio), THP_SWPOUT, 1);
> count_memcg_folio_events()
Done.
>
>>   		count_vm_event(THP_SWPOUT);
>> +	}
>>   #endif
>>   	count_vm_events(PSWPOUT, folio_nr_pages(folio));
>>   }
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index ea57a43ebd6b..29a82b72345a 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1928,6 +1928,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>   								folio_list))
>>   						goto activate_locked;
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +					count_memcg_events(folio_memcg(folio),
>> +							   THP_SWPOUT_FALLBACK, 1);
> count_memcg_folio_events()

Done.

thanks.

