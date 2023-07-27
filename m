From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the
 indicators of sockmem pressure
Date: Wed, 26 Jul 2023 17:19:00 -0700
Message-ID: <ZMG39B6B41yLAu9r@P9FQF9L96D>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
 <ZLsg1wklldKkVI2Z@P9FQF9L96D.corp.robot.car>
 <58e75f44-16e3-a40a-4c8a-0f61bbf393f9@bytedance.com>
 <ZMCLTQgVT68jwbVh@P9FQF9L96D>
 <29de901f-ae4c-a900-a553-17ec4f096f0e@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690417148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jizH7v8h0ocLCeBVRJsVfm8/gDMdAlThvwyLIayxfSI=;
        b=lHp8Ez0cvZftnjDrB+shn/YNJVCu9ie28cUDW6kKAWN9CYushKaLWWLFDlFpQOd9vnCkaO
        r4qTSQbFbOUgr2R2v2e9qVbliFGWAF6WcfaWgPuxoQboQjxu39lTx2LJSJKTdhv8YbLd4U
        7V/b6hzWXibp+IHendqnuPPJOMGZtJM=
Content-Disposition: inline
In-Reply-To: <29de901f-ae4c-a900-a553-17ec4f096f0e-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <alexander-uFy+/5nkmnuaMJb+Lgu22Q@public.gmane.org>, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, David Howells <dhowel>

On Wed, Jul 26, 2023 at 04:44:24PM +0800, Abel Wu wrote:
> On 7/26/23 10:56 AM, Roman Gushchin wrote:
> > On Mon, Jul 24, 2023 at 11:47:02AM +0800, Abel Wu wrote:
> > > Hi Roman, thanks for taking time to have a look!
> > > > 
> > > > > When in legacy mode aka. cgroupv1, the socket memory is charged
> > > > > into a separate counter memcg->tcpmem rather than ->memory, so
> > > > > the reclaim pressure of the memcg has nothing to do with socket's
> > > > > pressure at all.
> > > > 
> > > > But we still might set memcg->socket_pressure and propagate the pressure,
> > > > right?
> > > 
> > > Yes, but the pressure comes from memcg->socket_pressure does not mean
> > > pressure in socket memory in cgroupv1, which might lead to premature
> > > reclamation or throttling on socket memory allocation. As the following
> > > example shows:
> > > 
> > > 			->memory	->tcpmem
> > > 	limit		10G		10G
> > > 	usage		9G		4G
> > > 	pressure	true		false
> > 
> > Yes, now it makes sense to me. Thank you for the explanation.
> 
> Cheers!
> 
> > 
> > Then I'd organize the patchset in the following way:
> > 1) cgroup v1-only fix to not throttle tcpmem based on the vmpressure
> > 2) a formal code refactoring
> 
> OK, I will take a try to re-organize in next version.

Thank you!
> 
> > > > 
> > > > Overall I think it's a good idea to clean these things up and thank you
> > > > for working on this. But I wonder if we can make the next step and leave only
> > > > one mechanism for both cgroup v1 and v2 instead of having this weird setup
> > > > where memcg->socket_pressure is set differently from different paths on cgroup
> > > > v1 and v2.
> > > 
> > > There is some difficulty in unifying the mechanism for both cgroup
> > > designs. Throttling socket memory allocation when memcg is under
> > > pressure only makes sense when socket memory and other usages are
> > > sharing the same limit, which is not true for cgroupv1. Thoughts?
> > 
> > I see... Generally speaking cgroup v1 is considered frozen, so we can leave it
> > as it is, except when it creates an unnecessary complexity in the code.
> 
> Are you suggesting that the 2nd patch can be ignored and keep
> ->tcpmem_pressure as it is? Or keep the 2nd patch and add some
> explanation around as you suggested in last reply?

I suggest to split a code refactoring (which is not expected to bring any
functional changes) and an actual change of the behavior on cgroup v1.
Re the refactoring: I see a lot of value in adding comments and make the
code more readable, I don't see that much value in merging two variables.
But if it comes organically with the code simplification - nice.

> 
> > 
> > I'm curious, was your work driven by some real-world problem or a desire to clean
> > up the code? Both are valid reasons of course.
> 
> We (a cloud service provider) are migrating users to cgroupv2,
> but encountered some problems among which the socket memory
> really puts us in a difficult situation. There is no specific
> threshold for socket memory in cgroupv2 and relies largely on
> workloads doing traffic control themselves.
> 
> Say one workload behaves fine in cgroupv1 with 10G of ->memory
> and 1G of ->tcpmem, but will suck (or even be OOMed) in cgroupv2
> with 11G of ->memory due to burst memory usage on socket.
> 
> It's rational for the workloads to build some traffic control
> to better utilize the resources they bought, but from kernel's
> point of view it's also reasonable to suppress the allocation
> of socket memory once there is a shortage of free memory, given
> that performance degradation is better than failure.

Yeah, I can see it. But Idk if it's too workload-specific to have
a single-policy-fits-all-cases approach.
E.g. some workloads might prefer to have a portion of pagecache
being reclaimed.
What do you think?

> 
> Currently the mechanism of net-memcg's pressure doesn't work as
> we expected, please check the discussion in [1]. Besides this,
> we are also working on mitigating the priority inversion issue
> introduced by the net protocols' global shared thresholds [2],
> which has something to do with the net-memcg's pressure. This
> patchset and maybe some other are byproducts of the above work.
> 
> [1] https://lore.kernel.org/netdev/20230602081135.75424-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> [2] https://lore.kernel.org/netdev/20230609082712.34889-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/

Thanks for the clarification!
