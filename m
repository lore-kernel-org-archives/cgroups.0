From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/5] mm/memcg: Move mod_objcg_state() to memcontrol.c
Date: Mon, 19 Apr 2021 17:24:20 -0400
Message-ID: <18fc7f4c-d44e-8651-6593-a3e89147e230@redhat.com>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-2-longman@redhat.com> <YH2eT+JCII48hX80@cmpxchg.org>
 <ffb5705e-8629-808d-9d09-0c9c7f509326@redhat.com>
 <140444ea-14e7-b305-910f-f23fafe45488@redhat.com>
 <YH26RrMBOxLaMg4l@cmpxchg.org>
 <b7c8e209-3311-609b-9b61-5602a89a8313@redhat.com>
 <d1c36f26-b958-49e0-ae44-1cf6334fa4c5@redhat.com>
 <YH3yCZn9EeSPKKGY@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618867465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wmgc0BS4/Q3289dtVfzWyet+zhdbOakz2oUo7zL63L8=;
        b=dhFcRLXV2tXDrv2zLjNLZw4Y1P79aL4shmksee6prNMqIt4sQhOp1zTfDSXPaEdM83mdlD
        /nxW/cpmcyrvKF+hKM3/Bh/4tAAcFfAmxCQIJyYSJ4iD83+qPkzRf9/eQM/vPLECAmpV9L
        2+Rph6tzZFPjVeA19GkhzZ+Z+yrq4o8=
In-Reply-To: <YH3yCZn9EeSPKKGY-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <>

On 4/19/21 5:11 PM, Johannes Weiner wrote:
>
>> BTW, have you ever thought of moving the cgroup-v1 specific functions out
>> into a separate memcontrol-v1.c file just like kernel/cgroup/cgroup-v1.c?
>>
>> I thought of that before, but memcontrol.c is a frequently changed file and
>> so a bit hard to do.
> I haven't looked too deeply at it so far, but I think it would make
> sense to try.
>
> There are indeed many of the entry paths from the MM code that are
> shared between cgroup1 and cgroup2, with smaller branches here and
> there to adjust behavior. Those would throw conflicts, but those we
> should probably keep in the main memcontrol.c for readability anyway.
>
> But there is also plenty of code that is exclusively about cgroup1,
> and which actually doesn't change much in a long time. Moving that
> elsewhere shouldn't create difficult conflicts - maybe a few line
> offset warnings or fuzz-- Rafael
>
>
>   in the diff context of unrelated changes:
>
> - the soft limit tree and soft limit reclaim
>
> - the threshold and oom event notification stuff
>
> - the charge moving code
>
> - remaining v1 interface files, as well as their helper functions
>
>  From a quick scan, this adds up to ~2,500 lines of old code with no
> actual dependencies from the common code or from v2, and which could
> be moved out of the way without disrupting ongoing development much.
>
Right.

Currently memcontrol.c has over 7000 lines of code and keep growing. 
That makes it harder to read, navigate and update. If we can cut out 
2000 lines or more from memcontrol.c, it will make it more manageable.

Cheers,
Longman

