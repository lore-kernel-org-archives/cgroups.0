From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 2/4] mm: memcontrol: re-use global VM event enum
Date: Thu, 6 Apr 2017 11:49:24 +0300
Message-ID: <20170406084923.GB2268@esperanza>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
 <20170404220148.28338-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aGPcsHJbHA1uulfn69xWrdT/zB/MwImUEkjGQnI/x5Q=;
        b=NhOZLHwJPwJ5hK73uWREd78Fau9i4PFioj3wU/i8+OCZLhN8DySekoE4bRVQ2Htmtc
         yvK+GAY82G4orOEtOlb0RFlF9qzzKDdQtDc/T3fya1ugS6SFmqDxSWtaLqOgDJe3ch+N
         FzmkUNoMB6+0QXqPOHADLLvQx+ook5X/brvYaTgtf2leLHM0H4nEHb75Pozzzs9QuBu3
         ULl+wgU4lbDJkC5XnXgpmPmtghiUbHD66nx7ggzcZMa3c0DZUp/jR0c8KVsf0gNN9I6R
         LzhPwbd9GFlI/vYp4dBBXgXTwrZraCeSWUqeR2/ottofjts50yVBR+kaH8q6/Xcc1Dna
         l3jA==
Content-Disposition: inline
In-Reply-To: <20170404220148.28338-2-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Apr 04, 2017 at 06:01:46PM -0400, Johannes Weiner wrote:
> The current duplication is a high-maintenance mess, and it's painful
> to add new items.
> 
> This increases the size of the event array, but we'll eventually want
> most of the VM events tracked on a per-cgroup basis anyway.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Although the increase in the mem_cgroup struct introduced by this patch
looks scary, I agree this is a reasonable step toward unification of
vmstat, as most vm_even_item entries do make sense to be accounted per
cgroup as well.

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

> @@ -608,9 +601,9 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
>  
>  	/* pagein of a big page is an event. So, ignore page size */
>  	if (nr_pages > 0)
> -		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
> +		__this_cpu_inc(memcg->stat->events[PGPGIN]);
>  	else {
> -		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
> +		__this_cpu_inc(memcg->stat->events[PGPGOUT]);
>  		nr_pages = -nr_pages; /* for event */
>  	}

AFAIR this doesn't exactly match system-wide PGPGIN/PGPGOUT: they are
supposed to account only paging events involving IO while currently they
include faulting in zero pages and zapping a process address space.
Probably, this should be revised before rolling out to cgroup v2.
