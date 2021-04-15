From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/5] mm/memcg: Introduce
 obj_cgroup_uncharge_mod_state()
Date: Thu, 15 Apr 2021 12:35:45 -0400
Message-ID: <1c85e8f6-e8b9-33e1-e29b-81fbadff959f@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-3-longman@redhat.com> <YHhqPYcajI9JgXk/@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618504549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s47wUvhDxo7f8LaX+UuV/f8OqzaAqCVXK0vtBt6gLnc=;
        b=c/OSYHYhaOiH4fd4gO9bUOMnYHa0BctwWZ9rTgb6cT0+9A/err5J76HUQrZ39/XvxRG/5m
        2aUUgFRnkBbUYr3+nxzxD9N+ycRbh1EUf7MeFl9EjcD7Zt1yA7fhRt2voHcQky6i9WIGPd
        qSSFdCYNDXkXSMTm9W2MYWxMarDXQuE=
In-Reply-To: <YHhqPYcajI9JgXk/@cmpxchg.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/15/21 12:30 PM, Johannes Weiner wrote:
> On Tue, Apr 13, 2021 at 09:20:24PM -0400, Waiman Long wrote:
>> In memcg_slab_free_hook()/pcpu_memcg_free_hook(), obj_cgroup_uncharge()
>> is followed by mod_objcg_state()/mod_memcg_state(). Each of these
>> function call goes through a separate irq_save/irq_restore cycle. That
>> is inefficient.  Introduce a new function obj_cgroup_uncharge_mod_state()
>> that combines them with a single irq_save/irq_restore cycle.
>>
>> @@ -3292,6 +3296,25 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>>   	refill_obj_stock(objcg, size);
>>   }
>>   
>> +void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
>> +				   struct pglist_data *pgdat, int idx)
> The optimization makes sense.
>
> But please don't combine independent operations like this into a
> single function. It makes for an unclear parameter list, it's a pain
> in the behind to change the constituent operations later on, and it
> has a habit of attracting more random bools over time. E.g. what if
> the caller already has irqs disabled? What if it KNOWS that irqs are
> enabled and it could use local_irq_disable() instead of save?
>
> Just provide an __obj_cgroup_uncharge() that assumes irqs are
> disabled, combine with the existing __mod_memcg_lruvec_state(), and
> bubble the irq handling up to those callsites which know better.
>
That will also work. However, the reason I did that was because of patch 
5 in the series. I could put the get_obj_stock() and put_obj_stock() 
code in slab.h and allowed them to be used directly in various places, 
but hiding in one function is easier.

Anyway, I can change the patch if you think that is the right way.

Cheers,
Longman

