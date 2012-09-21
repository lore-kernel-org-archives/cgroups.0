From: JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
Date: Fri, 21 Sep 2012 18:28:02 +0900
Message-ID: <CAAmzW4PRPBgySUpNsj=RP6VR3KLcVWv3G7rRtX=r+wiWUTDchw@mail.gmail.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-16-git-send-email-glommer@parallels.com>
	<CAAmzW4NyK6gqqXHttUE35=-=h0Eve-smiYJCj3i+mHFFysQE4A@mail.gmail.com>
	<505C27E4.90509@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=dC7N3MIal+c9ux09QdA/c8SUBqQ/8rkcYyi5tgncOoo=;
        b=WHdzk2i29tOC/46avn58sFzrTuQ4QL9cDZ/eCE//6WpwBBZ2R69fZSrJzgGtuVlqS4
         kSc0FFZBsUTGOKF5haphsBcFNMJl1Sq0+eu/z3xZ+sl4aOge+21Bx1Wh8ZUJvoK5WHDS
         xGVYL+EzrY8VngaV5U90aCJnIkH/+wK/GO5eSTfVglXDP/Hu5phZWkYmSXmtX5RHzIwM
         hOu5q4TDSjPcXQkOzN+qLTGS/t3KC9HVRCJEsAn9G3Em4HHEY242pY2me4w2aySAXi59
         56AS54PBz+267ouHCugFzv6AIw+5zDx08oxgfrXgbeoPYwOCl6VkNTVWvOzLTqLLdvdQ
         M/DA==
In-Reply-To: <505C27E4.90509@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

Hi, Glauber.

>> 2012/9/18 Glauber Costa <glommer@parallels.com>:
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index 0b68d15..9d79216 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -2602,6 +2602,7 @@ redo:
>>>         } else
>>>                 __slab_free(s, page, x, addr);
>>>
>>> +       kmem_cache_verify_dead(s);
>>>  }
>>
>> As far as u know, I am not a expert and don't know anything about memcg.
>> IMHO, this implementation may hurt system performance in some case.
>>
>> In case of memcg is destoried, remained kmem_cache is marked "dead".
>> After it is marked,
>> every free operation to this "dead" kmem_cache call
>> kmem_cache_verify_dead() and finally call kmem_cache_shrink().
>
> As long as it is restricted to that cache, this is a non issue.
> dead caches are exactly what they name imply: dead.
>
> Means that we actively want them to go away, and just don't kill them
> right away because they have some inflight objects - which we expect not
> to be too much.

Hmm.. I don't think so.
We can destroy memcg whenever we want, is it right?
If it is right, there is many inflight objects when we destory memcg.
If there is so many inflight objects, performance of these processes
can be hurt too much.

>> And, I found one case that destroying memcg's kmem_cache don't works properly.
>> If we destroy memcg after all object is freed, current implementation
>> doesn't destroy kmem_cache.
>> kmem_cache_destroy_work_func() check "cachep->memcg_params.nr_pages == 0",
>> but in this case, it return false, because kmem_cache may have
>> cpu_slab, and cpu_partials_slabs.
>> As we already free all objects, kmem_cache_verify_dead() is not invoked forever.
>> I think that we need another kmem_cache_shrink() in
>> kmem_cache_destroy_work_func().
>
> I'll take a look here. What you describe makes sense, and can
> potentially happen. I tried to handle this case with care in
> destroy_all_caches, but I may have always made a mistake...
>
> Did you see this actively happening, or are you just assuming this can
> happen from your read of the code?

Just read of the code.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
