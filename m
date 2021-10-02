From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Fri, 1 Oct 2021 21:54:14 -0400
Message-ID: <6296d44d-a728-973a-0fc3-b5e30a09f920@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-2-longman@redhat.com>
 <YVefHLo1+6lgw3aB@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633139659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0xoezi4Z/qOe9rLHxMxM8UOrRHkvWYCakknTRmKZYE=;
        b=L4OzxGCMpLspgfnkHdx/rKaUYqyDQLMoFZfS7wTquXSiK7k6Fz6Ttz9Olbgs9JH4+P6rXf
        kCvXVL5/ylpP2WL7YfqfwkzB5GM1m0p7/P38qf1Z7SFe0muyCsbZWQ0DcSVO7W4HXdN1oD
        AXoEC3Af8b6zrzej85x7SsvW/34S1Tk=
In-Reply-To: <YVefHLo1+6lgw3aB-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On 10/1/21 7:51 PM, Roman Gushchin wrote:
> On Fri, Oct 01, 2021 at 03:09:36PM -0400, Waiman Long wrote:
>> When freeing a page associated with an offlined memcg, refill_stock()
>> will put it into local stock delaying its demise until another memcg
>> comes in to take its place in the stock. To avoid that, we now check
>> for offlined memcg and go directly in this case to the slowpath for
>> the uncharge via the repurposed cancel_charge() function.
> Hi Waiman!
>
> I'm afraid it can make a cleanup of a dying cgroup slower: for every
> released page we'll potentially traverse the whole cgroup tree and
> decrease atomic page counters.
>
> I'm not sure I understand the benefits we get from this change which
> do justify the slowdown on the cleanup path.

I am debugging a problem where some dying memcgs somehow stay around for 
a long time leading to gradual increase in memory consumption over time. 
I see the per-cpu stock as one of the places where a reference to a 
dying memcg may be present. Anyway, I agree that it may not help much. I 
am going to drop it if you think it is not a good idea.

Cheers,
Longman

