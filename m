From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Wed, 22 Apr 2020 17:43:18 +0200
Message-ID: <20200422154318.GK30312@dhcp22.suse.cz>
References: <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
 <20200422141514.GA362484@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200422141514.GA362484-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 22-04-20 10:15:14, Johannes Weiner wrote:
> On Wed, Apr 22, 2020 at 03:26:32PM +0200, Michal Hocko wrote:
> > That being said I believe our discussion is missing an important part.
> > There is no description of the swap.high semantic. What can user expect
> > when using it?
> 
> Good point, we should include that in cgroup-v2.rst. How about this?
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index bcc80269bb6a..49e8733a9d8a 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1370,6 +1370,17 @@ PAGE_SIZE multiple when read back.
>  	The total amount of swap currently being used by the cgroup
>  	and its descendants.
>  
> +  memory.swap.high
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "max".
> +
> +	Swap usage throttle limit.  If a cgroup's swap usage exceeds
> +	this limit, allocations inside the cgroup will be throttled.

Hm, so this doesn't talk about which allocatios are affected. This is
good for potential future changes but I am not sure this is useful to
make any educated guess about the actual effects. One could expect that
only those allocations which could contribute to future memory.swap
usage. I fully realize that we do not want to be very specific but we
want to provide something useful I believe. I am sorry but I do not have
a good suggestion on how to make this better. Mostly because I still
struggle on how this should behave to be sane.

I am also missing some information about what the user can actually do
about this situation and call out explicitly that the throttling is
not going away until the swap usage is shrunk and the kernel is not
capable of doing that on its own without a help from the userspace. This
is really different from memory.high which has means to deal with the
excess and shrink it down in most cases. The following would clarify it
for me
	"Once the limit is exceeded it is expected that the userspace
	 is going to act and either free up the swapped out space
	 or tune the limit based on needs. The kernel itself is not
	 able to do that on its own.
	"

> +
> +	This slows down expansion of the group's memory footprint as
> +	it runs out of assigned swap space. Compare to memory.swap.max,
> +	which stops swapping abruptly and can provoke kernel OOM kills.
> +
>    memory.swap.max
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default is "max".

-- 
Michal Hocko
SUSE Labs
