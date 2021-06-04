From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: periodically flush the memcg stats
Date: Fri, 4 Jun 2021 08:45:19 -0400
Message-ID: <YLogX+4YSMacgbGH@slm.duckdns.org>
References: <20210604015640.2586269-1-shakeelb@google.com>
 <20210604061816.3110-1-hdanton@sina.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nx4sy3vKThPKrptN4SMiBtntPC6yuGT09cDORxlv+yc=;
        b=QOs7/5IzXSeBRJVY8zaGVanRYpvfw+wNNeX6TADPr1JFXUcUSD5iD0dAZI2adwPip3
         +qO2zMkh9wMFvUo+egv7LH5RPSTZ11HVCcMh0cMsVN/yDUqdfp7rMRpWmvksZVmvRAB+
         8bW8EJ461T0mcIzy/gDkyRL1xDGsmPa93cHTr4qBaNv5yIXecqsbYZKSdiIkl5j3ssM4
         E4o76gBHi1BEKYJjwM+XASMdkUZVHKSO7ZKuV6d6SLljBD+wwUYyTb2xLmMqbmMiRtRW
         z52UFs0wlzbp+zBcmKQ8/+C8x0akJCFCU4MV2OuVKTpKhvI3ODu9mL15KUZNKGTqdKua
         yjOA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210604061816.3110-1-hdanton-k+cT0dCbe1g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 04, 2021 at 02:18:16PM +0800, Hillf Danton wrote:
> On Thu,  3 Jun 2021 18:56:40 -0700 Shakeel Butt wrote:
> >  
> > +static void flush_memcg_stats(struct work_struct *w)
> > +{
> > +	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> > +	schedule_delayed_work(&stats_flush, round_jiffies(2UL*HZ));
> > +}
> 
> Given flush may block, the unbound wq is what you need.
>
> 	queue_delayed_work(system_unbound_wq, &stats_flush, 2 * HZ);

Default per-cpu workqueue can block just fine. I don't see a strong reason
why this would need to be unbound.

-- 
tejun
