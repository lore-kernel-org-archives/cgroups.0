From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Tue, 14 Mar 2023 23:33:07 -0400
Message-ID: <84d8fd38-f05c-73f5-ef50-fcac524097f3@redhat.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
 <61e8e6d3-697e-f9a5-a1fb-45a3448ee5db@redhat.com>
 <CAJD7tkYm25ohS_P1Q6mzZMHJp4Hjwr3LqLaiPA3NFpa1gfOdJw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678851211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TbwJgOTQEBOTQga1KdTR+fInJ3Zcev0Mf+xVWLD7VKE=;
        b=f0Y1t+3jDcA8DyeYVPhn8326NLBqqEKnq6R1QJI2d1usr765vbF8Cv9VY9tmQmcj8JPMBE
        FJ7nBEfFQk58x4Ptww7tXE0mGVc6KMM6J3WTTSCdh58R63o/fdl2UDVFaF/yNLAZAm/A62
        cP3jN0QIYhZDOsDmFLOPEBwkOnuQ0Og=
Content-Language: en-US
In-Reply-To: <CAJD7tkYm25ohS_P1Q6mzZMHJp4Hjwr3LqLaiPA3NFpa1gfOdJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 3/14/23 23:10, Yosry Ahmed wrote:
>>> The only other user today is print_page_owner_memcg(). I am not sure
>>> if it's doing the right thing by explicitly reading page->memcg_data,
>>> but it is already excluding pages that have page->memcg_data == 0,
>>> which should be the case for tail pages.
>> It is reading memcg_data directly to see if it is slab cache page. It is
>> currently skipping page that does not have memcg_data set.
> IIUC this skips tail pages, because they should always have
> page->memcg_data == 0, even if they are charged to a memcg. To
> correctly get their memcg we should read it from the
> compound_head()/page_folio().
The purpose of that function is mainly to report pages that have a 
reference to a memcg, especially the dead one. So by counting the 
occurrence of a particular cgroup name, we can have a rough idea of 
that. So only head page has relevance here and we can skip the tail pages.
>
> My 2c, we can check PageSlab() to print the extra message for slab
> pages, instead of reading memcg_data directly, which kinda breaks the
> abstraction created by the various helpers for reading a page memcg.
> Someone can easily change something in how memcg_data is interpreted
> in those helpers without realizing that page_owner is also reading it.

You are right. We should be using a helper if available. I will send a 
patch to fix that.

Thanks,
Longman

