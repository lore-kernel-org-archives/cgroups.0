From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memory-cgroup bug
Date: Mon, 26 Nov 2012 08:57:07 +0100
Message-ID: <20121126075656.GA17860@dhcp22.suse.cz>
References: <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121126013855.AF118F5E-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Mon 26-11-12 01:38:55, azurIt wrote:
> >This is hackish but it should help you in this case. Kamezawa, what do
> >you think about that? Should we generalize this and prepare something
> >like mem_cgroup_cache_charge_locked which would add __GFP_NORETRY
> >automatically and use the function whenever we are in a locked context?
> >To be honest I do not like this very much but nothing more sensible
> >(without touching non-memcg paths) comes to my mind.
> 
> 
> I installed kernel with this patch, will report back if problem occurs
> again OR in few weeks if everything will be ok. Thank you!

Thanks!

> Btw, will this patch be backported to 3.2?

Once we agree on a proper solution it will be backported to the stable
trees.

-- 
Michal Hocko
SUSE Labs
