From: Chris Frey <cdfrey-4/nNOD19pEMY+eTVAdjFZg@public.gmane.org>
Subject: Re: an argument for keeping oom_control in cgroups v2
Date: Wed, 24 Aug 2022 05:30:23 -0400
Message-ID: <20220824093023.GA29770@foursquare.net>
References: <20220822120402.GA20333@foursquare.net>
 <YwRIDTmZJflhKP2n@slm.duckdns.org>
 <YwRgOcfagx4FfQcY@dhcp22.suse.cz>
 <YwT7/VFUTNmjarTh@P9FQF9L96D>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YwT7/VFUTNmjarTh@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Aug 23, 2022 at 09:10:37AM -0700, Roman Gushchin wrote:
> Btw, it's fairly easy to emulate the oom_control behaviour using cgroups v2:
> a userspace agent can listen to memory.high/max events and use the cgroup v2
> freezer to stop the workload and handle the oom in v1 oom_control style.
> An agent can have a high/real-time priority, so I guess the behavior will be
> actually quite close to the v1 experience. Much safer though.

Thanks to everyone who responded.  Looks like the same functionality,
slightly different, is still available through different means,
so my query has been satisfied.

- Chris

