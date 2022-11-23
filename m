From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Wed, 23 Nov 2022 13:00:35 -0500
Message-ID: <Y35fw2JSAeAddONg@cmpxchg.org>
References: <20221122203850.2765015-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9A8cQiLxG2eDxIN9LqbxR9kHprQzAjhFPvRfMzy2nbA=;
        b=JThIsrnalYZmSDDhQKwWGGeuUVFsTtfznTSg/LnbVkKWTcX9TtIOv42OyoGs/EtBM8
         5lKGVFslA1HnCNcURKMoM7T/K5hQwmN15JAejQfmZfRaoCm/MMDOmrdCHuzVCDcYlBOm
         3IAENmp+qd/OJOhBTPrmss/VakKTnaf6J5wSznE4djUqzpdYatYSslwQHPZmXSf277kI
         D2w+/RQ5P18zqyLmhAbeXS1zvALCeHv+RG+/JYfuS9W+4DGU4sd57x7C61z2PraoCam2
         GEGp6cj7FfpM9ECL7TpcAPgq0EZ2u8/s5TQ1PwqG5SQpnHDtFREeAmmJ6yvoVy//Qa5W
         SsjA==
Content-Disposition: inline
In-Reply-To: <20221122203850.2765015-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello Mina,

On Tue, Nov 22, 2022 at 12:38:45PM -0800, Mina Almasry wrote:
> Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> reclaim""), the proactive reclaim interface memory.reclaim does both
> reclaim and demotion. This is likely fine for us for latency critical
> jobs where we would want to disable proactive reclaim entirely, and is
> also fine for latency tolerant jobs where we would like to both
> proactively reclaim and demote.
> 
> However, for some latency tiers in the middle we would like to demote but
> not reclaim. This is because reclaim and demotion incur different latency
> costs to the jobs in the cgroup. Demoted memory would still be addressable
> by the userspace at a higher latency, but reclaimed memory would need to
> incur a pagefault.
> 
> To address this, I propose having reclaim-only and demotion-only
> mechanisms in the kernel. There are a couple possible
> interfaces to carry this out I considered:
> 
> 1. Disable demotion in the memory.reclaim interface and add a new
>    demotion interface (memory.demote).
> 2. Extend memory.reclaim with a "demote=<int>" flag to configure the demotion
>    behavior in the kernel like so:
>    	- demote=0 would disable demotion from this call.
> 	- demote=1 would allow the kernel to demote if it desires.
> 	- demote=2 would only demote if possible but not attempt any
> 	  other form of reclaim.

Unfortunately, our proactive reclaim stack currently relies on
memory.reclaim doing both. It may not stay like that, but I'm a bit
wary of changing user-visible semantics post-facto.

In patch 2, you're adding a node interface to memory.demote. Can you
add this to memory.reclaim instead? This would allow you to control
demotion and reclaim independently as you please: if you call it on a
node with demotion targets, it will demote; if you call it on a node
without one, it'll reclaim. And current users will remain unaffected.
