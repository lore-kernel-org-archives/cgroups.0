From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Date: Mon, 09 Jul 2012 13:22:54 +0800
Message-ID: <4FFA6AAE.8030700@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881562-5900-1-git-send-email-handai.szj@taobao.com> <20120708145309.GC18272@localhost> <4FFA51AB.30203@gmail.com> <20120709041437.GA10180@localhost> <4FFA5B7F.8030403@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=VFcG47krbdRysip1SxBAy84p9saZxxZet3LgqidzPcc=;
        b=HokNfaM/eOmH19NUmVut64DotwaERQcvpfy7yB0E0t16vPr/vPdjfGca4GtTOV4PHy
         uNrWjfVFJIruYtpdSBZpdtXRixwZVx330Rf4mFVkFm35Xs/yVEgKoZRDxD1YkAPzJ6FX
         1w74JufFHCRG/XEscFvUQ7JheFko1fephtOXpB1COESKmWwSDqP7/iVV/JbwWK7vRVHA
         YzybGtk2O1BNzQY/dbN/e/9EWJpcbRMqkHI9Bx+LAuHff7okncsgOKhfgzgqVPww3RGx
         6QygaFMk7ojdVBOyFqmF7FLIKljg1x0A9y7MWvsIx0ABcxvCc7avN2DwKmMVaZ5ASWub
         ZjkA==
In-Reply-To: <4FFA5B7F.8030403-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 07/09/2012 12:18 PM, Kamezawa Hiroyuki wrote:
> (2012/07/09 13:14), Fengguang Wu wrote:
>> On Mon, Jul 09, 2012 at 11:36:11AM +0800, Sha Zhengju wrote:
>>> On 07/08/2012 10:53 PM, Fengguang Wu wrote:
>>>>> @@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
>>>>>   {
>>>>>       struct address_space *mapping = page_mapping(page);
>>>>>       int ret;
>>>>> +    bool locked;
>>>>> +    unsigned long flags;
>>>>>
>>>>> +    mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>>>>>       if (mapping) {
>>>>>           struct backing_dev_info *bdi = mapping->backing_dev_info;
>>>>>           unsigned long flags;
>>>>> @@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
>>>>>       }
>>>>>       if (!ret)
>>>>>           account_page_writeback(page);
>>>>> +
>>>>> +    mem_cgroup_end_update_page_stat(page,&locked,&flags);
>>>>>       return ret;
>>>>>
>>>>>   }
>>>> Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
>>>>
>>>
>>> It's in account_page_writeback().
>>>
>>>   void account_page_writeback(struct page *page)
>>>   {
>>> +    mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
>>>       inc_zone_page_state(page, NR_WRITEBACK);
>>>   }
>>
>> I didn't find that chunk, perhaps it's lost due to rebase..
>>
>>> There isn't a unified interface to dec/inc writeback accounting, so
>>> I just follow that.
>>> Maybe we can rework account_page_writeback() to also account
>>> dec in?
>>
>> The current seperate inc/dec paths are fine. It sounds like
>> over-engineering if going any further.
>>
>> I'm a bit worried about some 3rd party kernel module to call
>> account_page_writeback() without 
>> mem_cgroup_begin/end_update_page_stat().
>> Will that lead to serious locking issues, or merely inaccurate
>> accounting?
>>
>
> Ah, Hm. Maybe it's better to add some debug check in
>  mem_cgroup_update_page_stat(). rcu_read_lock_held() or some.
>

This also apply to account_page_dirtied()... But as an "range" lock, I 
think it's common
in current kernel: just as set_page_dirty(), the caller should call it 
under the page lock
(in most cases) and it's his responsibility to guarantee correctness. I 
can add some
comments or debug check as reminding but I think i can only do so...


Thanks,
Sha

