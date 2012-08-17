From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2] memcg: execute partial memcg freeing in mem_cgroup_destroy
Date: Thu, 16 Aug 2012 23:37:20 -0700
Message-ID: <xr93a9xu9g7z.fsf@gthelen.mtv.corp.google.com>
References: <1345114903-20627-1-git-send-email-glommer@parallels.com>
	<xr93vcgiazok.fsf@gthelen.mtv.corp.google.com>
	<502DCDD0.3060502@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=jSmTMPyXQe824ES2usZLGhT0g4oSZ06j+FYCc9wU4YE=;
        b=hpXLxNaO3VykhbxKeiym7Y5bnJpD5K9dAX7+L8i2TkwT1oETp66A79IU1IBGfjaJ6Z
         AR1Jpr87PzviSHe9YtBg8E4sNbFJHla9b5NymQbrkVhRRODSMRrH4ORyJGA4xnl3CMMU
         jTVgJSYmiN64Pv80xEiFB6kDszNNuiWOk9vb5LbDps46Q+mStIp1ibo4IeoUamKK3K+A
         SWZwdVG5u6GZToDc3RUARxl8XNaGjMJohrhx0CNGyG04pzJNojrI4q6Ynrnc8KYr1lWy
         5IFaQFzG02ZXnSoW8yOXaYJJ2Wd79+Mgn2OcmWHUlGymvfoQvj1cFV6W0wYpgwG1c9Ew
         bKfg==
In-Reply-To: <502DCDD0.3060502@parallels.com> (Glauber Costa's message of
	"Fri, 17 Aug 2012 08:51:28 +0400")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

On Thu, Aug 16 2012, Glauber Costa wrote:

> On 08/17/2012 08:51 AM, Greg Thelen wrote:
>> On Thu, Aug 16 2012, Glauber Costa wrote:
>> 
>>> I consider this safe because all the page_cgroup references to user
>>> pages are reparented to the imediate parent, so late uncharges won't
>>> trigger the common uncharge paths with a destroyed memcg.
>>>
>>> Although we don't migrate kernel pages to parent, we also don't call the
>>> common uncharge paths for those pages, rather uncharging the
>>> res_counters directly. So we are safe on this side of the wall as well.
>>>
<snip>
>>>
>>> @@ -5377,6 +5375,7 @@ static void mem_cgroup_destroy(struct cgroup *cont)
>>>  
>>>  	kmem_cgroup_destroy(memcg);
>>>  
>>> +	__mem_cgroup_free(memcg);
>> 
>> I suspect that this will free the css_id before all swap entries have
>> dropped their references with mem_cgroup_uncharge_swap() ?  I think we
>> only want to call __mem_cgroup_free() once all non kernel page
>> references have been released.  This would include mem_cgroup_destroy()
>> and any pending calls to mem_cgroup_uncharge_swap().  I'm not sure, but
>> may be a second refcount or some optimization with the kmem_accounted
>> bitmask can efficiently handle this.
>> 
>
> Can we demonstrate that? I agree there might be a potential problem, and
> that is why I sent this separately. But the impression I got after
> testing and reading the code, was that the memcg information in
> pc->mem_cgroup would be updated to the parent.
>
> This means that any later call to uncharge or uncharge_swap would just
> uncharge from the parent memcg and we'd have no problem.

I am by no means a swap expert, so I may be heading in the weeds.  But I
think that a swapped out page is not necessarily in any memcg lru.  So
the mem_cgroup_pre_destroy() call to mem_cgroup_force_empty() will not
necessarily see swapped out pages.

I think this demonstrates the problem.

Start with a 500MB machine running a CONFIG_MEMCG_SWAP=y kernel.
Enable a 1G swap device
% cd /dev/cgroup/memory
% echo 1 > memory.use_hierarchy
% mkdir x

# LOOP_START

% mkdir x/y
% (echo $BASHPID > x/y/tasks && exec ~/memtoy)
memtoy>anon a 600m
memtoy>touch a write
^Z
% cat x/y/tasks > tasks
% cat x/memory.memsw.usage_in_bytes
630484992
% rmdir x/y   # this now deletes css_id

# This should free swapents and uncharge memsw res_counter.  But the
# swap ents use deleted css_id in mem_cgroup_uncharge_swap() so the
# memcg cannot be located.  So memsw.usage_in_bytes is not uncharged,
# even for surviving parent memcg (e.g. x).
% kill %1

% cat x/memory.memsw.usage_in_bytes
168202240

# for fun, goto LOOP_START here and see x/memory.memsw.usage_in_bytes
# grow due to this leak.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
