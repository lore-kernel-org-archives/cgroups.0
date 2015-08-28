From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 28 Aug 2015 19:14:38 +0200
Message-ID: <20150828171438.GD21463@dhcp22.suse.cz>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
 <20150828164918.GJ9610@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828164918.GJ9610@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 28-08-15 19:49:18, Vladimir Davydov wrote:
> On Fri, Aug 28, 2015 at 11:25:30AM -0400, Tejun Heo wrote:
> > On the default hierarchy, all memory consumption will be accounted
> > together and controlled by the same set of limits.  Always enable
> > kmemcg on the default hierarchy.
> 
> IMO we should introduce a boot time knob for disabling it, because kmem
> accounting is still not perfect, besides some users might prefer to go
> w/o it for performance reasons.

I would even argue for opt-in rather than opt-out.
-- 
Michal Hocko
SUSE Labs
