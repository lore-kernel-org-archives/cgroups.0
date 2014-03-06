From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 04/11] mm, memcg: add tunable for oom reserves
Date: Wed, 5 Mar 2014 18:53:23 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403051853010.30075@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com> <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com> <20140305131757.ad538637c096266664c45f04@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=KstFvd+jrCBf3Lbt4HUKQrmrIc0pksX2pxbDeqQeRwo=;
        b=FKttOPFxoEd+YwFX2QHcBb5lkwc1WN3hCqZ4JfxjzpD4R6LwZ7WsaICejA0S3yJ2Nj
         a5KwWn2oglMZVQctUm6UmmtxXgwfXZH1JmizNIqdqjWXENsw/W6WKMmevwXzW9IQr29N
         3owZrghloFefFIuHmCYjLBG0Sj6pETsaiWyKvpXy7bb76F16KPF723nENp9jgCMK1CE1
         jRcTdhZR4Su18QHxzqSKBGcAouS3kHz1WLvCwGAIZAMzFgg64gMZ0AxXbYymgWNVAbpo
         8cXPcT+tKm1CPtCNMxWqADOwYjo6GEmWkfG2+zkk79jURGOiDhL4QAgz+fgjnTP5GeOm
         PSmA==
In-Reply-To: <20140305131757.ad538637c096266664c45f04@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, 5 Mar 2014, Andrew Morton wrote:

> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -315,6 +315,9 @@ struct mem_cgroup {
> >  	/* OOM-Killer disable */
> >  	int		oom_kill_disable;
> >  
> > +	/* reserves for handling oom conditions, protected by res.lock */
> > +	unsigned long long	oom_reserve;
> 
> Units?  bytes, I assume.
> 

Yes, fixed.

> >  	/* set when res.limit == memsw.limit */
> >  	bool		memsw_is_minimum;
> >  
> > @@ -5936,6 +5939,51 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
> >  	return 0;
> >  }
> >  
> > +static int mem_cgroup_resize_oom_reserve(struct mem_cgroup *memcg,
> > +					 unsigned long long new_limit)
> > +{
> > +	struct res_counter *res = &memcg->res;
> > +	u64 limit, usage;
> > +	int ret = 0;
> 
> The code mixes u64's and unsigned long longs in inexplicable ways. 
> Suggest using u64 throughout.
> 

Ok!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
