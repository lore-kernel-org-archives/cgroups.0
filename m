From: Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [patch 08/11] mm: memcg: remove needless !mm fixup to init_mm
 when charging
Date: Tue, 10 Jul 2012 14:54:48 +0800
Message-ID: <20120710065448.GB6096@kernel>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-9-git-send-email-hannes@cmpxchg.org>
 <20120709152058.GK4627@tiehlicka.suse.cz>
 <20120710061021.GA6096@kernel>
 <20120710062104.GA19223@tiehlicka.suse.cz>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xYze6dWg7ju2L+cXkCBwr5bJbM8TTPzH4+sXdV/l8l8=;
        b=Ke/VZYVyJW8rq8DWluM/P0Ygs/BfGnfw9exsaVytMm7QQoAp0Ysi/hly5gYcXJhMAn
         Zhv68RI8BvsTWn/pSYajfcZs5BW5QFOn/SEfU3yYJHIaYvqD9OoCrmB1xAsKDqwQj+93
         N/MhpQySMkSSlaLNVV+G4rfdOdKOQdYw3XkX83iPPFx4nbWy30ca5uh53N3o6qo4xlOa
         6Qe7/ES0i1cTf7YVdLvISwjDUEwuVWELSaMhKl4aiUZZ+pwyZNyoHRDvopJxPesqjQb+
         9QDfLJY0eFI7Q46ewaTtgnvKv4t61G9wiwBtL0It1JX7EEI2Wo0Lb8Hlzn3NUIt3RPqv
         Oojg==
Content-Disposition: inline
In-Reply-To: <20120710062104.GA19223@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

On Tue, Jul 10, 2012 at 08:21:04AM +0200, Michal Hocko wrote:
>On Tue 10-07-12 14:10:21, Wanpeng Li wrote:
>> On Mon, Jul 09, 2012 at 05:20:58PM +0200, Michal Hocko wrote:
>> >On Thu 05-07-12 02:45:00, Johannes Weiner wrote:
>> >> It does not matter to __mem_cgroup_try_charge() if the passed mm is
>> >> NULL or init_mm, it will charge the root memcg in either case.
>> 
>> You can also change the comment in __mem_cgroup_try_charge :
>> 
>> "if so charge the init_mm" => "if so charge the root memcg"
>
>This is already in place:
>"
>If mm is NULL and the caller doesn't pass a valid memcg pointer, that is
>treated as a charge to root_mem_cgroup.
>"

IIUC, if still keep comment "if so charge the init_mm" is not correct,
since pages in pagecache aren't mapped into any processes' ptes, 
so mm is NULL, and these pages which in pagecache are not belong 
to init_mm, the comment should be changed. :-)

>> 
>> >> 
>> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> >
>> >Acked-by: Michal Hocko <mhocko@suse.cz>
>> >
>> >> ---
>> >>  mm/memcontrol.c |    5 -----
>> >>  1 files changed, 0 insertions(+), 5 deletions(-)
>> >> 
>> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> >> index 418b47d..6fe4101 100644
>> >> --- a/mm/memcontrol.c
>> >> +++ b/mm/memcontrol.c
>> >> @@ -2766,8 +2766,6 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>> >>  		ret = 0;
>> >>  	return ret;
>> >>  charge_cur_mm:
>> >> -	if (unlikely(!mm))
>> >> -		mm = &init_mm;
>> >>  	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
>> >>  	if (ret == -EINTR)
>> >>  		ret = 0;
>> >> @@ -2832,9 +2830,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>> >>  	if (PageCompound(page))
>> >>  		return 0;
>> >>  
>> >> -	if (unlikely(!mm))
>> >> -		mm = &init_mm;
>> >> -
>> >>  	if (!PageSwapCache(page))
>> >>  		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
>> >>  	else { /* page is swapcache/shmem */
>> >> -- 
>> >> 1.7.7.6
>> >> 
>> >
>> >-- 
>> >Michal Hocko
>> >SUSE Labs
>> >SUSE LINUX s.r.o.
>> >Lihovarska 1060/12
>> >190 00 Praha 9    
>> >Czech Republic
>> >--
>> >To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> >the body of a message to majordomo@vger.kernel.org
>> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-- 
>Michal Hocko
>SUSE Labs
>SUSE LINUX s.r.o.
>Lihovarska 1060/12
>190 00 Praha 9    
>Czech Republic

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
