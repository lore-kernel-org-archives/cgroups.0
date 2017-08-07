From: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kmemleaks reports a lot of cases around memcg_create_kmem_cache
Date: Mon, 7 Aug 2017 16:37:52 -0700
Message-ID: <CANaxB-xaHyyn=c8mJ8R8=k-kFJvW1a04MAuAdmS+V4KsjU84AQ@mail.gmail.com>
References: <CANaxB-x=xgLq116VReo4Og+jFsAB+ehx3xThnXoCx8pR3YXPSA@mail.gmail.com>
 <20170702185017.ew5cn4altyw7nomi@esperanza> <20170705144743.GA19330@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2ZFK0ldIbvD4HDXZ0yRpaakPkyTBvaCKKephV/rx00U=;
        b=I9jenWOTyS3nBqDA9tcLP8fXfyOchBOrUAg+mWlzuRNJpmSQaTmYloMUN8D97SaOT3
         EAzYNmJqiYHr1DTuZvyZg/CxLfMZ5TV6PFLY2noVy0kRZI1GgGdqYbx2/fyNvQJnAjKh
         uT2rvvo0oGPtDCct133bCVMRtIcuYqokXYj2Q1qw4WAiJxwN0YlzFl1ZASsB7pUdwawA
         Ppu8UlQey3SpDXyL2ySJTbleFvNHWqE0SaAsK3LKudjq8h7vJQG61nJ/MtqPqKvuaJ09
         m386f7RMM4f3DqpEU3+tw99Th5/shTBunD3VJDUYMrZVgy6IErWEU7qO2h8qoSHbSbN6
         vyxA==
In-Reply-To: <20170705144743.GA19330-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello Vladimir and Tejun,

This patch isn't in the Linus' tree. Could you do something to push it
into the upstream tree.

Thanks,
Andrei

On Wed, Jul 5, 2017 at 7:47 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sun, Jul 02, 2017 at 09:50:17PM +0300, Vladimir Davydov wrote:
>> From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Subject: [PATCH] slub: fix per memcg cache leak on css offline
>>
>> To avoid a possible deadlock, sysfs_slab_remove() schedules an
>> asynchronous work to delete sysfs entries corresponding to the kmem
>> cache. To ensure the cache isn't freed before the work function is
>> called, it takes a reference to the cache kobject. The reference is
>> supposed to be released by the work function. However, the work function
>> (sysfs_slab_remove_workfn()) does nothing in case the cache sysfs entry
>> has already been deleted, leaking the kobject and the corresponding
>> cache. This may happen on a per memcg cache destruction, because sysfs
>> entries of a per memcg cache are deleted on memcg offline if the cache
>> is empty (see __kmemcg_cache_deactivate()).
> ...
>> Reported-by: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Fixes: 3b7b314053d02 ("slub: make sysfs file removal asynchronous")
>
> Oops,
>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>
> --
> tejun
