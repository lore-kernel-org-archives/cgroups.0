From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 20:43:16 +0300
Message-ID: <f4fd9e5f-b054-41af-e8a8-7a3074f937d8@virtuozzo.com>
References: <20211013194338.1804247-1-shakeelb@google.com>
 <YWfZNF7T7Fm69sik@dhcp22.suse.cz>
 <CALvZod4Br9iwq-qfdwj6dzgW2g1vEr2YL4=w_mQjOeWWDQzFjw@mail.gmail.com>
 <YWhLeAL5RPfLjrlO@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=eD7O+RRWLIkfKyTJ6TKMyILhSbZVJ9w0wV/dWtK5Dv0=; b=chOijwLa4Moa5XyKb
        NTr/9oJ/r8pthIDIG2J4jg3zwc7oEUg3K1Dt4kuMmIvnnpl51iX5bHSlyA5r+UStbj4vPx3i5rW5c
        VjuKA6U1viK2KmSz8Wf01Tb+ZwUo2NgiL0niYCBDTJ0/h5mPerexOJJ9uBOLSGG2iF6zgUWCtXCsc
        =;
In-Reply-To: <YWhLeAL5RPfLjrlO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 14.10.2021 18:23, Johannes Weiner wrote:
> On Thu, Oct 14, 2021 at 08:01:16AM -0700, Shakeel Butt wrote:
>> Regarding xfs_buf_alloc_pages(), it is not using __GFP_ACCOUNT
> 
> It probably should, actually. Sorry, somewhat off-topic, but we've
> seen this consume quite large amounts of memory. __GFP_ACCOUNT and
> vmstat tracking seems overdue for this one.

If this will be required, you can use
[PATCH mm v5] memcg: enable memory accounting in __alloc_pages_bulk
https://lkml.org/lkml/2021/10/14/197

As far as I understand it will not be used right now,
however I decided to submit it anyway, perhaps it may be needed later.

Thank you,
	Vasily Averin
