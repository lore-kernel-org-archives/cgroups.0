From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 29 Aug 2023 09:27:41 +0200
Message-ID: <ZO2d7dT8gulMyb8g@dhcp22.suse.cz>
References: <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz>
 <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
 <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
 <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693294061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dQVt7ZAS3h7P9TWs6MRywImntPzLi7vWjCeWqczW/dg=;
        b=vRtPLaqq11XecAmTHq2dlcBEu/g6yqdBioRszoAaLNULFSMb19oU7qqGZT+5RLT0dTCl/s
        lSFUCG69b9+dF7PAvMR/seI8n+VXJUKB8Ske1TiNs6BC6TJryS8nzrbdYPEonTxhj3cNZ0
        ragBTYGG3uSYLX6fMD7g+XhiJe7VIdI=
Content-Disposition: inline
In-Reply-To: <599b167c-deaf-4b92-aa8b-5767b8608483-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-08-23 13:27:23, Waiman Long wrote:
> 
> On 8/28/23 13:07, Yosry Ahmed wrote:
> > 
> > > Here I agree with you. Let's go with the approach which is easy to
> > > undo for now. Though I prefer the new explicit interface for flushing,
> > > that step would be very hard to undo. Let's reevaluate if the proposed
> > > approach shows negative impact on production traffic and I think
> > > Cloudflare folks can give us the results soon.
> > Do you prefer we also switch to using a mutex (with preemption
> > disabled) to avoid the scenario Michal described where flushers give
> > up the lock and sleep resulting in an unbounded wait time in the worst
> > case?
> 
> Locking with mutex with preemption disabled is an oxymoron.

I believe Yosry wanted to disable preemption _after_ the lock is taken
to reduce the time spent while it is held. The idea to use the mutex is
to reduce spinning and more importantly to get rid of lock dropping
part. It is not really clear (but unlikely) we can drop it while
preserving the spinlock as the thing scales with O(#cgroups x #cpus)
in the worst case.

-- 
Michal Hocko
SUSE Labs
