From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/5] mm/memcg: Reduce kmemcache memory accounting
 overhead
Date: Thu, 15 Apr 2021 13:41:07 -0400
Message-ID: <15cf3cfa-c221-9e84-9f5b-80082207efd3@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210415171035.GB2531743@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618508471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTimRIr0YgBuVLpWvKPM6c0MAPH0f+KQspjahIIUAlU=;
        b=cPDV7WzTQ9rHwfUAQ/ac8bvWdvjyTkXGWriMaF++nEkSbJ+qL0n8Miec9j2pcwCP3jD+sH
        R6TckrEa6JX8ZyygS7AnxLHcSdnNw7s2A6J/GQ6S4KME/FKCJ9tWSLOBsC0ts8eb/9IbGh
        oJuCPBuWTEs8RtOWTWoY/1i4yja7kqQ=
In-Reply-To: <20210415171035.GB2531743-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.x>

On 4/15/21 1:10 PM, Matthew Wilcox wrote:
> On Tue, Apr 13, 2021 at 09:20:22PM -0400, Waiman Long wrote:
>> With memory accounting disable, the run time was 2.848s. With memory
>> accounting enabled, the run times with the application of various
>> patches in the patchset were:
>>
>>    Applied patches   Run time   Accounting overhead   Overhead %age
>>    ---------------   --------   -------------------   -------------
>>         None          10.800s         7.952s              100.0%
>>          1-2           9.140s         6.292s               79.1%
>>          1-3           7.641s         4.793s               60.3%
>>          1-5           6.801s         3.953s               49.7%
> I think this is a misleading way to report the overhead.  I would have said:
>
> 			10.800s		7.952s		279.2%
> 			 9.140s		6.292s		220.9%
> 			 7.641s		4.793s		168.3%
> 			 6.801s		3.953s		138.8%
>
What I want to emphasize is the reduction in the accounting overhead 
part of execution time. Your percentage used the accounting disable time 
as the denominator. I think both are valid, I will be more clear about 
that in my version of the patch.

Thanks,
Longman

