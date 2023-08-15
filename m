From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Tue, 15 Aug 2023 11:44:42 -0400
Message-ID: <54e8c38d-c805-2666-b559-ce785ba24b67@redhat.com>
References: <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz>
 <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org>
 <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692114299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TawkjbN36L2tJSa3Vtp7sv1FkX0qieEa0khYy9fqi68=;
        b=Osvw/9nj7kfiCa4t1hvz3aW8EiIvZKfT0BHoCK2LB27YIzbTbYAULaIBMsvQjqmIWFr77L
        9rbzGEhhLE9qAceX9hvm2XDiNVpUsjiyqCC30rgiQjNI+t7affQMD89Bu2LK28EPpgw1sw
        Y9swAo2Dj6FaAWJN3mvc0d7enruqh/0=
Content-Language: en-US
In-Reply-To: <ZNrITZVTf2EILRJq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 8/14/23 20:35, Tejun Heo wrote:
> Hello,
>
> On Mon, Aug 14, 2023 at 05:28:22PM -0700, Yosry Ahmed wrote:
>>> So, the original design used mutex for synchronize flushing with the idea
>>> being that updates are high freq but reads are low freq and can be
>>> relatively slow. Using rstats for mm internal operations changed this
>>> assumption quite a bit and we ended up switching that mutex with a lock.
>> Naive question, do mutexes handle thundering herd problems better than
>> spinlocks? I would assume so but I am not sure.
> I don't know. We can ask Waiman if that becomes a problem.

We had essentially solved the thundering herd problems for both 
spinlocks and mutexes. Both types of lock waiters will spin in their own 
cachelines (in the OSP wait queue in the case of mutex) except one that 
is at the head of the queue. So there should be minimal cacheline 
bouncing. One should certainly uses mutexes in sleep-able context or 
when the critical section is long.

Cheers,
Longman

