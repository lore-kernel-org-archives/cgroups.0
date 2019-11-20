From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v4 1/9] mm/swap: fix uninitialized compiler warning
Date: Wed, 20 Nov 2019 19:42:46 +0800
Message-ID: <919a5a57-1b7a-b109-491f-2b8b099390fe@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-2-git-send-email-alex.shi@linux.alibaba.com>
 <20191119154138.GB382712@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191119154138.GB382712@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com



在 2019/11/19 下午11:41, Johannes Weiner 写道:
> On Tue, Nov 19, 2019 at 08:23:15PM +0800, Alex Shi wrote:
>>   ../mm/swap.c: In function ‘__page_cache_release’:
>>   ../mm/swap.c:67:10: warning: ‘flags’ may be used uninitialized in this
>>   function [-Wmaybe-uninitialized]
>>        lruvec = lock_page_lruvec_irqsave(page, pgdat, flags);
>>        ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> At this point in the series, there is no lock_page_lruvec_irqsave()
> yet, so this patch is out of order. Please don't do that. It's very
> hard to review patches that depend on later changes to make sense.
> 

Sorry, I will be more careful on this.

>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  mm/swap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 5341ae93861f..c36a10244d07 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -62,7 +62,7 @@ static void __page_cache_release(struct page *page)
>>  	if (PageLRU(page)) {
>>  		pg_data_t *pgdat = page_pgdat(page);
>>  		struct lruvec *lruvec;
>> -		unsigned long flags;
>> +		unsigned long flags = 0;
> Use unintialized_var() for these cases to make the intent clear.

Thanks for suggestion!
