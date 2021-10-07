From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memcg memory accounting in vmalloc is broken
Date: Thu, 7 Oct 2021 16:02:49 +0200
Message-ID: <d6c04044-71f9-cbeb-b311-edc3999e3641@suse.cz>
References: <b3c232ff-d9dc-4304-629f-22cc95df1e2e@virtuozzo.com>
 <YV6sIz5UjfbhRyHN@dhcp22.suse.cz> <YV6s+ze8LzuxfvOM@dhcp22.suse.cz>
 <953ef8e2-1221-a12c-8f71-e34e477a52e8@virtuozzo.com>
 <20211007102044.GR3959@techsingularity.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633615369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1I72EYHnG0Ll/HtrsN+KFVKnf7WVgvBWjvAI6syAjqc=;
        b=0uOaaQ3swvj/d6JA0JLHXjhrMnICVVihcAMhbNoESIBzDXF7wGhBdCOiw2egny1Mj9RA1t
        d5Igur3Ir+M8wsPuOoU7YQ/HWPev32nCQhlHzHuUyo2qBfYTss6q8Qt9+WWXhFn4dakcLn
        CSli04vid3caxE0XpC0Dug0onC0vq5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633615369;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1I72EYHnG0Ll/HtrsN+KFVKnf7WVgvBWjvAI6syAjqc=;
        b=Oircnie37Y2Jpq7n+YZeuPH8FCaUWZ0KaH3snZf+FZ6algRf7L9cQlHyTUzi9iCx1AIydy
        kD9P/UVCr4ES+JDQ==
Content-Language: en-US
In-Reply-To: <20211007102044.GR3959-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 10/7/21 12:20, Mel Gorman wrote:
> On Thu, Oct 07, 2021 at 11:50:44AM +0300, Vasily Averin wrote:
>> On 10/7/21 11:16 AM, Michal Hocko wrote:
>> > Cc Mel and Uladzislau
>> > 
>> > On Thu 07-10-21 10:13:23, Michal Hocko wrote:
>> >> On Thu 07-10-21 11:04:40, Vasily Averin wrote:
>> >>> vmalloc was switched to __alloc_pages_bulk but it does not account the memory to memcg.
>> >>>
>> >>> Is it known issue perhaps?
>> >>
>> >> No, I think this was just overlooked. Definitely doesn't look
>> >> intentional to me.
>> 
>> I use following patch as a quick fix,
>> it helps though it is far from ideal and can be optimized.
> 
> Thanks Vasily.
> 
> This papers over the problem but it could certainly be optimized. At
> minimum;
> 
> 1. Test (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT)) in the
>    function preamble and store the result in a bool

memcg_kmem_enabled() is a static key based check so caching that defeats its
purpose and changes it to a normal branch. That leaves gfp & __GFP_ACCOUNT,
which may perhaps still benefit from such caching.

> 2. Avoid the temptation to batch the accounting because if the
>    accounting fails, there is no information on how many pages could be
>    allocated before the limits were hit. I guess you could pre-charge the
>    pages and uncharging the number of pages that failed to be allocated
>    but it should be a separate patch.
> 3. If an allocation fails due to memcg accounting, break
>    out of the loop because all remaining bulk allocations are
>    also likely to fail.
> 
> As it's not vmalloc's fault, I would suggest the patch
> have
> Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> and
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> 
> Note the Cc should just be in the patch and not mailed directly to
> stable@ as it'll simply trigger a form letter about the patch having to
> be merged to mainline first.
> 

