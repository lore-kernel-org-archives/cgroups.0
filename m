From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v3 0/9] memcg: accounting for objects allocated by
 mkdir cgroup
Date: Wed, 1 Jun 2022 17:24:06 +0200
Message-ID: <YpeElmN07SU9wcca@dhcp22.suse.cz>
References: <YpSwvii5etfnOYC9@dhcp22.suse.cz>
 <ef9f7516-853d-ffe4-9a7a-5e87556bdbbe@openvz.org>
 <YpTTL3Ys35kgYyAW@dhcp22.suse.cz>
 <3a1d8554-755f-7976-1e00-a0e7fb62c86e@openvz.org>
 <YpXA35F33hvrxNLf@dhcp22.suse.cz>
 <118bcb39-1281-0d1d-b163-3f6bcc99c3e2@openvz.org>
 <20220601091543.GA21320@blackbody.suse.cz>
 <YpcyKdZkdkwUOzuy@dhcp22.suse.cz>
 <YpdkHrbT/xkdx+Qb@dhcp22.suse.cz>
 <Ypd2DW7id4M3KJJW@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654097047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXHVZxPrCb1BC4QlFo14+VbIvXvZSlCAD3WV4pOVYmw=;
        b=T922d8GC3bWNBspwD1NiXwCVli/WrJ0y2/jgveZXBNXPO7O3yjF0tFdgjr+1964bwIrTht
        lGTss9VOc+v0i3QXzuRV0PR6KVNbLsEyx3g6iGuAJC4CA4ofjdFZabdwmryfiMjhH8Nmz4
        e2Wd+pHLq9B9M2wntZflyZkR+kIrBeU=
Content-Disposition: inline
In-Reply-To: <Ypd2DW7id4M3KJJW@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 01-06-22 07:22:05, Roman Gushchin wrote:
> On Wed, Jun 01, 2022 at 03:05:34PM +0200, Michal Hocko wrote:
> > On Wed 01-06-22 11:32:26, Michal Hocko wrote:
> > > On Wed 01-06-22 11:15:43, Michal Koutny wrote:
> > > > On Wed, Jun 01, 2022 at 06:43:27AM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> > > > > CT-901 /# cat /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> > > > > 512
> > > > > CT-901 /# echo 3333 > /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> > > > > -bash: echo: write error: Operation not permitted
> > > > > CT-901 /# echo 333 > /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> > > > > -bash: echo: write error: Operation not permitted
> > > > > 
> > > > > I doubt this way can be accepted in upstream, however for OpenVz
> > > > > something like this it is mandatory because it much better
> > > > > than nothing.
> > > > 
> > > > Is this customization of yours something like cgroup.max.descendants on
> > > > the unified (v2) hierarchy? (Just curious.)
> > > > 
> > > > (It can be made inaccessible from within the subtree either with cgroup
> > > > ns or good old FS permissions.)
> > > 
> > > So we already do have a limit to prevent somebody from running away with
> > > the number of cgroups. Nice!
> 
> Yes, we do!
> 
> > > I was not aware of that and I guess this
> > > looks like the right thing to do. So do we need more control and
> > > accounting that this?
> > 
> > I have checked the actual implementation and noticed that cgroups are
> > uncharged when offlined (rmdir-ed) which means that an adversary could
> > still trick the limit and runaway while still consuming resources.
> > 
> > Roman, I guess the reason for this implementation was to avoid limit to
> > trigger on setups with memcgs which can take quite some time to die?
> > Would it make sense to make the implementation more strict to really act
> > as gate against potential cgroups count runways?
> 
> The reasoning was that in many cases a user can't do much about dying cgroups,
> so it's not clear how they should/would handle getting -EAGAIN on creating a
> new cgroup (retrying will not help, obviously). Live cgroups can be easily
> deleted, dying cgroups - not always.
> 
> I'm not sure about switching the semantics. I'd wait till Muchun's lru page
> reparenting will be landed (could be within 1-2 releases, I guess) and then we
> can check whether the whole problem is mostly gone. Honestly, I think we might
> need to fix few another things, but it might be not that hard (in comparison
> to what we already did).

OK, thanks for the confirmation! Say we end up mitigating the
too-easy-to-linger memcgs long standing issue. Do we still need an
extended cgroup data structure accounting?

-- 
Michal Hocko
SUSE Labs
