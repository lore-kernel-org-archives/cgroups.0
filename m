From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Date: Mon, 09 Jul 2012 13:18:07 +0900
Message-ID: <4FFA5B7F.8030403@jp.fujitsu.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881562-5900-1-git-send-email-handai.szj@taobao.com> <20120708145309.GC18272@localhost> <4FFA51AB.30203@gmail.com> <20120709041437.GA10180@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120709041437.GA10180@localhost>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Sha Zhengju <handai.szj@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com, yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

(2012/07/09 13:14), Fengguang Wu wrote:
> On Mon, Jul 09, 2012 at 11:36:11AM +0800, Sha Zhengju wrote:
>> On 07/08/2012 10:53 PM, Fengguang Wu wrote:
>>>> @@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
>>>>   {
>>>>   	struct address_space *mapping = page_mapping(page);
>>>>   	int ret;
>>>> +	bool locked;
>>>> +	unsigned long flags;
>>>>
>>>> +	mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>>>>   	if (mapping) {
>>>>   		struct backing_dev_info *bdi = mapping->backing_dev_info;
>>>>   		unsigned long flags;
>>>> @@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
>>>>   	}
>>>>   	if (!ret)
>>>>   		account_page_writeback(page);
>>>> +
>>>> +	mem_cgroup_end_update_page_stat(page,&locked,&flags);
>>>>   	return ret;
>>>>
>>>>   }
>>> Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
>>>
>>
>> It's in account_page_writeback().
>>
>>   void account_page_writeback(struct page *page)
>>   {
>> +	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
>>   	inc_zone_page_state(page, NR_WRITEBACK);
>>   }
>
> I didn't find that chunk, perhaps it's lost due to rebase..
>
>> There isn't a unified interface to dec/inc writeback accounting, so
>> I just follow that.
>> Maybe we can rework account_page_writeback() to also account
>> dec in?
>
> The current seperate inc/dec paths are fine. It sounds like
> over-engineering if going any further.
>
> I'm a bit worried about some 3rd party kernel module to call
> account_page_writeback() without mem_cgroup_begin/end_update_page_stat().
> Will that lead to serious locking issues, or merely inaccurate
> accounting?
>

Ah, Hm. Maybe it's better to add some debug check in
  mem_cgroup_update_page_stat(). rcu_read_lock_held() or some.

Thanks,
-Kame



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
