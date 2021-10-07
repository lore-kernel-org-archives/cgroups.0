From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: memcg memory accounting in vmalloc is broken
Date: Thu, 7 Oct 2021 22:33:11 +0300
Message-ID: <6411d3f7-b3a4-23a8-14fc-fcf6b9c5b73a@virtuozzo.com>
References: <b3c232ff-d9dc-4304-629f-22cc95df1e2e@virtuozzo.com>
 <YV6sIz5UjfbhRyHN@dhcp22.suse.cz> <YV6s+ze8LzuxfvOM@dhcp22.suse.cz>
 <953ef8e2-1221-a12c-8f71-e34e477a52e8@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=iLAgLMIgIu6s+lIkoBmy5XcX4KfLYvL6O9nfNN3jV64=; b=aMkBwiES/T2hlPt0t
        Hwki2r6+LXmyvssXQnK4+v4GEIseke75eVEpYisHkaVzo+ZSbY0LR/lRmqEC2ti1rysQ1BwRFX7Of
        SfBZoTcxZZCqaHjEM0UKYQy1mR9CW0XWiVCp2sInnxKRBMypWx1YzXWW4Yhq+WaE2apHhmDDXYOdE
        =;
In-Reply-To: <953ef8e2-1221-a12c-8f71-e34e477a52e8-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 10/7/21 11:50 AM, Vasily Averin wrote:
> On 10/7/21 11:16 AM, Michal Hocko wrote:
>> Cc Mel and Uladzislau
>>
>> On Thu 07-10-21 10:13:23, Michal Hocko wrote:
>>> On Thu 07-10-21 11:04:40, Vasily Averin wrote:
>>>> vmalloc was switched to __alloc_pages_bulk but it does not account the memory to memcg.
>>>>
>>>> Is it known issue perhaps?
>>>
>>> No, I think this was just overlooked. Definitely doesn't look
>>> intentional to me.
> 
> I use following patch as a quick fix,
> it helps though it is far from ideal and can be optimized.

Dear all,
thanks a lot for your comments and suggestions!

Unfortunately current patch version does not work properly.
We cannot charge each page in this cycle, with taken pagesets spinlock,
lockdep reports about possible deadlock.
Trying to use pre-charge, as suggested by Mel Gorman.
 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b37435c274cf..e6abe2cac159 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5290,6 +5290,12 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  
>  		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
>  								pcp, pcp_list);
> +
> +		if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT) && page &&
> +		    unlikely(__memcg_kmem_charge_page(page, gfp, 0) != 0)) {
> +			__free_pages(page, 0);
> +			page = NULL;
> +		}
>  		if (unlikely(!page)) {
>  			/* Try and get at least one page */
>  			if (!nr_populated)
> 

