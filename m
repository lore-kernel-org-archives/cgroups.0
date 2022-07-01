From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Thu, 30 Jun 2022 19:42:36 -0700
Message-ID: <Yr5fHHeB9WXnIMC+@castle>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
 <YrpO9CUDt8hpUprr@castle>
 <17916824-ba97-68ba-8166-9402d5f4440c@openvz.org>
 <20220628091648.GA12249@blackbody.suse.cz>
 <YrrIWe/nn5hoVyu9@mtj.duckdns.org>
 <525a3eea-8431-64ad-e464-5503f3297722@openvz.org>
 <YrynRcW4/B2nl/kK@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656643363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pMVELDaA6mcFkDFllRvcL5kIjjxBxBLDIIVIdn97dz4=;
        b=ScqzngmdlUq8J5Kb06lReoG/MwkkI6G9TVrCHdbC9i++IBDL2+fN7P+gZPFs/0Aa3bwAEV
        9JXjkrAUBwXK9420gleAL8BwrOwUBFv/kCkXYGmdNCcrCntT4HZ4jvss0snDNRQiPEl8Nt
        sPZblsUlzi7M3IVALotR9AO/mF5Db1E=
Content-Disposition: inline
In-Reply-To: <YrynRcW4/B2nl/kK-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 30, 2022 at 04:25:57AM +0900, Tejun Heo wrote:
> On Wed, Jun 29, 2022 at 09:13:02AM +0300, Vasily Averin wrote:
> > I experimented on fedora36 node with LXC and centos stream 9 container.
> > and I did not noticed any critical systemd troubles with original -EAGAIN.
> > When cgroup's limit is reached systemd cannot start new services, 
> > for example lxc-attach generates following output:
> > 
> > [root@fc34-vvs ~]# lxc-attach c9s
> > lxc-attach: c9s: cgroups/cgfsng.c: cgroup_attach_leaf: 2084 Resource temporarily unavailable - Failed to create leaf cgroup ".lxc"
> > lxc-attach: c9s: cgroups/cgfsng.c: __cgroup_attach_many: 3517 Resource temporarily unavailable - Failed to attach to cgroup fd 11
> > lxc-attach: c9s: attach.c: lxc_attach: 1679 Resource temporarily unavailable - Failed to attach cgroup
> > lxc-attach: c9s: attach.c: do_attach: 1237 No data available - Failed to receive lsm label fd
> > lxc-attach: c9s: attach.c: do_attach: 1375 Failed to attach to container
> > 
> > I did not found any loop in userspace caused by EAGAIN.
> > Messages looks unclear, however situation with the patched kernel is not much better:
> > 
> > [root@fc34-vvs ~]# lxc-attach c9s
> > lxc-attach: c9s: cgroups/cgfsng.c: cgroup_attach_leaf: 2084 No space left on device - Failed to create leaf cgroup ".lxc"
> > lxc-attach: c9s: cgroups/cgfsng.c: __cgroup_attach_many: 3517 No space left on device - Failed to attach to cgroup fd 11
> > lxc-attach: c9s: attach.c: lxc_attach: 1679 No space left on device - Failed to attach cgroup
> > lxc-attach: c9s: attach.c: do_attach: 1237 No data available - Failed to receive lsm label fd
> > lxc-attach: c9s: attach.c: do_attach: 1375 Failed to attach to container
> 
> I'd say "resource temporarily unavailable" is better fitting than "no
> space left on device"

+1

Thanks!
