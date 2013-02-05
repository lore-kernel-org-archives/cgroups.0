From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Tue, 5 Feb 2013 17:31:06 +0100
Message-ID: <20130205163106.GC22804@dhcp22.suse.cz>
References: <20121218152223.6912832C@pobox.sk>
 <20121218152004.GA25208@dhcp22.suse.cz>
 <20121224142526.020165D3@pobox.sk>
 <20121228162209.GA1455@dhcp22.suse.cz>
 <20121230020947.AA002F34@pobox.sk>
 <20121230110815.GA12940@dhcp22.suse.cz>
 <20130125160723.FAE73567@pobox.sk>
 <20130125163130.GF4721@dhcp22.suse.cz>
 <20130205134937.GA22804@dhcp22.suse.cz>
 <20130205154947.CD6411E2@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130205154947.CD6411E2-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue 05-02-13 15:49:47, azurIt wrote:
[...]
> I have another old problem which is maybe also related to this. I
> wasn't connecting it with this before but now i'm not sure. Two of our
> servers, which are affected by this cgroup problem, are also randomly
> freezing completely (few times per month). These are the symptoms:
>  - servers are answering to ping
>  - it is possible to connect via SSH but connection is freezed after
>  sending the password
>  - it is possible to login via console but it is freezed after typeing
>  the login
> These symptoms are very similar to HDD problems or HDD overload (but
> there is no overload for sure). The only way to fix it is, probably,
> hard rebooting the server (didn't find any other way). What do you
> think? Can this be related?

This is hard to tell without further information.

> Maybe HDDs are locked in the similar way the cgroups are - we already
> found out that cgroup freezeing is related also to HDD activity. Maybe
> there is a little chance that the whole HDD subsystem ends in
> deadlock?

"HDD subsystem" whatever that means cannot be blocked by memcg being
stuck. Certain access to soem files might be an issue because those
could have locks held but I do not see other relations.

I would start by checking the HW, trying to focus on reducing elements
that could contribute - aka try to nail down to the minimum set which
reproduces the issue. I cannot help you much with that I am afraid.
-- 
Michal Hocko
SUSE Labs
