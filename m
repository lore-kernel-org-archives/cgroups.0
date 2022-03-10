From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: add next_mz back if not reclaimed yet
Date: Thu, 10 Mar 2022 09:59:30 +0100
Message-ID: <Yim98uGgFjTu2HeK@dhcp22.suse.cz>
References: <20220308012047.26638-1-richard.weiyang@gmail.com>
 <20220308012047.26638-3-richard.weiyang@gmail.com>
 <YicRNofU+L1cKIQp@dhcp22.suse.cz>
 <20220309004620.fgotfh4wsquscbfn@master>
 <YiiwPaCESiTuH22a@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646902771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2tx04p/KSEJFzMMLCMxNtcpoNboTHg9YDAAKmm2DYA=;
        b=VXIAcD8dd86ZuUY5S18Rif2jBHHChRst37CsbQWmebMzB8YUvjurTIktrQhDc3P0Sxt+t1
        IjWfmL1RSs37CJgYqBM+kctOhUC17Ds3eoPlCFKxMUtucTi04tYGW0hD/KJooRW7k/MZfn
        lxqWyCqFgd+Cop+/Ma29drhBxZ0FJCs=
Content-Disposition: inline
In-Reply-To: <YiiwPaCESiTuH22a-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Wed 09-03-22 14:48:46, Michal Hocko wrote:
> [Cc Tim - the patch is http://lkml.kernel.org/r/20220308012047.26638-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> 
> On Wed 09-03-22 00:46:20, Wei Yang wrote:
> > On Tue, Mar 08, 2022 at 09:17:58AM +0100, Michal Hocko wrote:
> > >On Tue 08-03-22 01:20:47, Wei Yang wrote:
> > >> next_mz is removed from rb_tree, let's add it back if no reclaim has
> > >> been tried.
> > >
> > >Could you elaborate more why we need/want this?
> > >
> > 
> > Per my understanding, we add back the right most node even reclaim makes no
> > progress, so it is reasonable to add back a node if we didn't get a chance to
> > do reclaim on it.
> 
> Your patch sounded familiar and I can remember now. The same fix has
> been posted by Tim last year
> https://lore.kernel.org/linux-mm/8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/

Btw. I forgot to mention yesterday. Whatever was the reason this has
slipped through cracks it would great if you could reuse the changelog
of the original patch which was more verbose and explicit about the
underlying problem. The only remaining part I would add is a description
of how serious the problem is. The removed memcg would be out of the
excess tree until further memory charges would get it back. But that can
take arbitrary amount of time. Whether that is a real problem would
depend on the workload of course but considering how coarse of a tool
the soft limit is it is possible that this is not something most users
would even notice.
-- 
Michal Hocko
SUSE Labs
