From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: Make mem_cgroup_id_get_many dependent on MMU and
 MEMCG_SWAP
Date: Thu, 5 Mar 2020 15:18:45 +0100
Message-ID: <20200305141845.GZ16139@dhcp22.suse.cz>
References: <20200304142348.48167-1-vincenzo.frascino@arm.com>
 <20200304165336.GO16139@dhcp22.suse.cz>
 <8c489836-b824-184e-7cfe-25e55ab73000@arm.com>
 <20200305100023.GR16139@dhcp22.suse.cz>
 <acf13158-40a3-4027-f36a-25d24efe3242@arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <acf13158-40a3-4027-f36a-25d24efe3242-5wv7dgnIgG8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu 05-03-20 10:46:21, Vincenzo Frascino wrote:
[...]
> I am aware of this. I was just exploring if there was a possibility of
> addressing the warning, since if we leave all the warnings in scenarios like
> randconfig can cause confusion in between real and non real issues.

I would very much like to address _real_ warnings. This one is just
bugus. I do not see a fix that would be sensible. Wrapping the helper
by ifdefs is just going to make the resulting code worse because there
is nothing really specific to swap there. Marking it __maybe_unused will
just paper over the report and allow the function to bitrot when it is
not used anymore.

So for now I would just live with the warning unless it is really
causing any real problems.

-- 
Michal Hocko
SUSE Labs
