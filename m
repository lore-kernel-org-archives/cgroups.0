From: Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Tue, 16 May 2023 13:46:55 +0800
Message-ID: <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684216031; x=1715752031;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JGRSnyaOzF7kv0KcVT1yNJLFVyV6CwuI4uFF6+Zjk4c=;
  b=D2MJ3DGMJ4/ERxGA7yzVmMfiPAZF9QVtzdzaJreCXQ2jYUAa6buDrl5n
   PhV2Qv1i6W9LYL12FjQ7E3XDJZ3ClPikVEAUrrntvsUsLfO59v9a/Hv3V
   JpzrgMC4DjZbNmmtETlYZje2eHVlBwhYyfdpoMgWfSu8Ho26pqSn2aIPU
   StFxlbD0SS7TZxAxjr+lWYRGTqzgGDZ1at4zxm4EzYq+PL5N/EWxAK7Ig
   613XHsiUi761/Bg8xqELlvrQR+MC+TkWCqFcH3Y2YUadXd9jXBIq22Bww
   O7GSAYC+OT4coONTKGzAm2zXGRUQOGPTYQqGbfcNNXS91FNYJjetIKTS6
   g==;
Content-Disposition: inline
In-Reply-To: <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yin Fengwei <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

hi Shakeel,

On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> +Feng, Yin and Oliver
> 
> >
> > > Thanks a lot Cathy for testing. Do you see any performance improvement for
> > > the memcached benchmark with the patch?
> >
> > Yep, absolutely :- ) RPS (with/without patch) = +1.74
> 
> Thanks a lot Cathy.
> 
> Feng/Yin/Oliver, can you please test the patch at [1] with other
> workloads used by the test robot? Basically I wanted to know if it has
> any positive or negative impact on other perf benchmarks.

is it possible for you to resend patch with Signed-off-by?
without it, test robot will regard the patch as informal, then it cannot feed
into auto test process.
and could you tell us the base of this patch? it will help us apply it
correctly.

on the other hand, due to resource restraint, we normally cannot support
this type of on-demand test upon a single patch, patch set, or a branch.
instead, we try to merge them into so-called hourly-kernels, then distribute
tests and auto-bisects to various platforms.
after we applying your patch and merging it to hourly-kernels sccussfully,
if it really causes some performance changes, the test robot could spot out
this patch as 'fbc' and we will send report to you. this could happen within
several weeks after applying.
but due to the complexity of whole process (also limited resourse, such like
we cannot run all tests on all platforms), we cannot guanrantee capture all
possible performance impacts of this patch. and it's hard for us to provide
a big picture like what's the general performance impact of this patch.
this maybe is not exactly what you want. is it ok for you?


> 
> [1] https://lore.kernel.org/all/20230512171702.923725-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> 
> Thanks in advance.
