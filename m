From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Wed, 31 May 2023 19:45:20 +0000
Message-ID: <20230531194520.qhvibyyaqg7vwi6s@google.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020> <20230517162447.dztfzmx3hhetfs2q@google.com>
 <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685562323; x=1688154323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PpDJlNrnAO4fvUz0RfTCu45Wzom8uht2t6b0Eby6tSU=;
        b=CvwTOcZ+TPBW93dVo+GG+czxQgBJ4WRtQUZ1hKODLz7NuLQPGgy7BYqE7Y9Tdkzjs2
         y9tozNN7oF4sU7BsyHzJbWPgNPvoSqYlMRj7uvKxy2fkxrWhoH/SmrTTamAvlmKzi73n
         W8mGe+0pczU1OXBLkd9m6kH3YhP81peoXSGI7ypFYEQjAIAOGwvke5aVDbsNuxKBxx3g
         MOnvBekiaK0TO9D2/JhS+c/l+b0tzOEqCm96tealv8uLdXS4aRGyO8bnFdb0QJST5yjO
         WtjQXe1h3uwVrRpHfxidaBd5zAxB8fKm6q3xgsTzuj02HlikkhGtotuFCckThw1vLK4o
         eh0Q==
In-Reply-To: <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Zhang Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yin Fengwei <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Brandeburg Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Suresh <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chen Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, You Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Hi Oliver,

On Wed, May 31, 2023 at 04:46:08PM +0800, Oliver Sang wrote:
[...]
> 
> we applied below patch upon v6.4-rc2, so far, we didn't spot out performance
> impacts of it to other tests.
> 
> but we found -7.6% regression of netperf.Throughput_Mbps
> 

Thanks, this is what I was looking for. I will dig deeper and decide how
to proceed (i.e. improve this patch or work on long term approach).

