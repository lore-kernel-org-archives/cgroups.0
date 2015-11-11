From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Wed, 11 Nov 2015 09:12:12 +0100
Message-ID: <20151111081212.GA1424@dhcp22.suse.cz>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109182840.GJ31308@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 09-11-15 21:28:40, Vladimir Davydov wrote:
> On Mon, Nov 09, 2015 at 03:08:32PM +0100, Michal Hocko wrote:
[...]
> > > Vladimir Davydov (5):
> > >   Revert "kernfs: do not account ino_ida allocations to memcg"
> > >   Revert "gfp: add __GFP_NOACCOUNT"
> > 
> > The patch ordering would break the bisectability. I would simply squash
> 
> How's that? AFAICS the kernel should compile after any first N=1..5
> patches of the series applied.

Sorry, forgot to comment on this. I didn't mean it would break
compilation. It would just reintroduce the bug fixed by "kernfs: do not
account ino_ida allocations to memcg". My understanding is that the bug
is quite unlikely and it will results in a pinned memcg which is much
less serious than a crash or other misbehavior.

I will leave whether this is serious enough to you but as the revert is
basically dropping the flag which can be trivially done in the patch
which renames it and changes its semantic I do not think splitting has
any large advantage.
-- 
Michal Hocko
SUSE Labs
