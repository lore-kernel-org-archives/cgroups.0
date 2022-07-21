From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4] mm: vmpressure: don't count proactive reclaim in
 vmpressure
Date: Thu, 21 Jul 2022 13:42:25 +0200
Message-ID: <Ytk7octCv1DZeelM@dhcp22.suse.cz>
References: <20220714064918.2576464-1-yosryahmed@google.com>
 <YtfJug77XJ9BPA8L@dhcp22.suse.cz>
 <CALvZod7X3PsM2+ZrWXwb75FNBBjaBGJpjd+WVmzr5hStROvW+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658403749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BkvbSMivb/aWXIlzYNPZoVB/iKbqXT76LFZqzry9Fz4=;
        b=r2465AG3bndbjlFwjkJAWIovGGRSvB4ub7P3vDo/JON7K4EOcDSeD0D4aKvmMfKaVYRcsN
        q071il98/zaQkOiititSJGsdWBY7fcTNeVkfW8TDsWHrmu1KKFWJmlRfJ6yd/MKGdXD5C2
        //MdG7ABC4+aDFuIp0M2Obnx5rxqfQY=
Content-Disposition: inline
In-Reply-To: <CALvZod7X3PsM2+ZrWXwb75FNBBjaBGJpjd+WVmzr5hStROvW+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed 20-07-22 10:49:53, Shakeel Butt wrote:
> On Wed, Jul 20, 2022 at 2:24 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> [...]
> >
> > I think what we are missing here is
> > - explain that this doesn't have any effect on existing users of
> >   vmpressure user interface because that is cgroup v1 and memory.reclaim
> >   is v2 feature. This is a trivial statement but quite useful for future
> >   readers of this commit
> > - explain the effect on the networking layer and typical usecases
> >   memory.reclaim is used for currently and ideally document that.
> 
> I agree with the above two points (Yosry, please address those) but
> the following third point is orthogonal and we don't really need to
> have an answer for this patch to be accepted.
> 
> > - how are we going to deal with users who would really want to use
> >   memory.reclaim interface as a replacement for existing hard/high
> >   memory reclaim? Is that even something that the interface is intended
> >   for?
> 
> I do agree that this question is important. Nowadays I am looking at
> this from a different perspective and use-case. More concretely how
> (and why) to replace vmpressure based network throttling for cgroup
> v2. I will start a separate thread for that discussion.

I think we should be good to document this side effect for now. If you
have a plan to change to vmpressure based throttling then only better.
But one way or the other impact of the memory.reclaim interface on
netwroking should be documented properly.

-- 
Michal Hocko
SUSE Labs
