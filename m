From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 2/7] memcg,list_lru: duplicate LRUs upon kmemcg creation
Date: Tue, 19 Feb 2013 23:46:41 -0800
Message-ID: <xr93fw0r8m1q.fsf@gthelen.mtv.corp.google.com>
References: <1360328857-28070-1-git-send-email-glommer@parallels.com>
	<1360328857-28070-3-git-send-email-glommer@parallels.com>
	<xr934nhenz18.fsf@gthelen.mtv.corp.google.com>
	<511E13FF.8020803@parallels.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        bh=PxWaLTsBx5NTOf4xd6aWBnt4vrEWzusWpJiRtQj45XA=;
        b=ljvTM4jGNPh7wcBAKgUDPbrfnWZRB3mQ3vGeReRt7dQi2floAJBNgQ6jqNwsaIpI4D
         CFz5DixQcfazK5NRf1kVd000csIbDgphrJ+LA1LoaVcXt9GOlzeegAYLHU/14Sl2iGRB
         xhj97RbC+pCb3RTc6POUc39m9iOpPc8cuqSFdx2X920jdzmrGqn5xf/W7CqAc6LT1UwN
         d3qGgdaDN9PUm31weBKvholWAGY9wYxqBood3i3KUeAnwtWyTUoPXLBN2FKMXSEmwIOs
         llmLrrf2nel9tGAMU1wMhBKwmlzvNvLXP12hNmCJR+c4TrF88PKX0e+4om/pR2AmYW4+
         D/5Q==
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Dave Shrinnker <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>

On Fri, Feb 15 2013, Glauber Costa wrote:

>>> +struct mem_cgroup;
>>> +#ifdef CONFIG_MEMCG_KMEM
>>> +/*
>>> + * We will reuse the last bit of the pointer to tell the lru subsystem that
>>> + * this particular lru should be replicated when a memcg comes in.
>>> + */
>> 
>> From this patch it seems like 0x1 is a magic value rather than bit 0
>> being special.  memcg_lrus is either 0x1 or a pointer to an array of
>> struct list_lru_array.  The array is indexed by memcg_kmem_id.
>> 
>
> Well, I thought in terms of "set the last bit". To be honest, when I
> first designed this, I figured it could possibly be useful to keep the
> bit set at all times, and that is why I used the LSB. Since I turned out
> not using it, maybe we could actually resort to a fully fledged magical
> to avoid the confusion?

To avoid confusion, I'd prefer a magic value.  This allows callers to
not worrying about having to strip off the low order bit, if it's later
always set for some reason.  But I'm not even sure we need a magic value
or magic bit (see below).

>>> +static inline void lru_memcg_enable(struct list_lru *lru)
>>> +/*
>>> + * This will return true if we have already allocated and assignment a memcg
>>> + * pointer set to the LRU. Therefore, we need to mask the first bit out
>>> + */
>>> +static inline bool lru_memcg_is_assigned(struct list_lru *lru)
>>> +{
>>> +	return (unsigned long)lru->memcg_lrus & ~0x1ULL;
>> 
>> Is this equivalent to?
>> 	return lru->memcg_lrus != NULL && lru->memcg_lrus != 0x1
>> 
> yes. What I've explained above should help clarifying why I wrote it
> this way. But if we use an actual magical (0x1 is a bad magical, IMHO),
> the intentions become a lot clearer.

Does the following work and yield simpler code?
1. add a 'bool memcg_enabled' parameter to list_lru_init()
2. rename all_lrus to all_memcg_lrus
3. only add lru to all_memcg_lrus if memcg_enabled is set
4. delete lru_memcg_enable()
5. redefine lru_memcg_is_assigned() to just test (lru->memcg_lrus == NULL)

Then we don't need a magic valid (or LSB) to identify memcg enabled
lrus.  Any lru in the all_memcg_lrus list is memcg enabled.
