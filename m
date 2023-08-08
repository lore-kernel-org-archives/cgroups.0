From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add tips for kmem.slabinfo
Date: Tue, 8 Aug 2023 09:29:54 +0200
Message-ID: <ZNHu8m3h3ckn+HeI@dhcp22.suse.cz>
References: <20230808022229.1560559-1-xiongwei.song@windriver.com>
 <ZNG9vwg1K6fn1SvN@P9FQF9L96D>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691479795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lpA4KdrK70TL2Etj3PL1Cfra8aJL0LqY3fuNb0fiTvc=;
        b=mgZVAibaY3lnvIFmOTTHRMtxp3t7qQKh8BnOSevYzZfKQ9ODixCurYGn0FceCkXYyYsp0+
        RvsA+wkdqZohpaqPEn1MlNCQFu0gtGvRAx4qDNx3uVWO++I0kqwdfjEmJD+LpiPmQNnfxG
        pO3CeZANL2wZKxSHtzxRki9EQbPlmFg=
Content-Disposition: inline
In-Reply-To: <ZNG9vwg1K6fn1SvN@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 07-08-23 20:59:59, Roman Gushchin wrote:
> On Tue, Aug 08, 2023 at 10:22:29AM +0800, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> > From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > 
> > No any output from kmem.slabinfo, which is not friendly. Adding
> > tips for it.
> > 
> > Signed-off-by: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e8ca4bdcb03c..58d3bd93890b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5002,10 +5002,8 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
> >  #if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
> >  static int mem_cgroup_slab_show(struct seq_file *m, void *p)
> >  {
> > -	/*
> > -	 * Deprecated.
> > -	 * Please, take a look at tools/cgroup/memcg_slabinfo.py .
> > -	 */
> > +	seq_puts(m, "This file is deprecated.\n"
> > +		"Please use tools/cgroup/memcg_slabinfo.py, which is in kernel source.\n");
> 
> It'll break the ABI.

Agreed

> The only possible option here is to use WARN_ON_ONCE(), which will print once to dmesg.
> But honestly I'm not sure we need it.

There are systems with panic_on_warn configured. I do not think we want
those to go down just becasue some random tool tries to read this file.
-- 
Michal Hocko
SUSE Labs
