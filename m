From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: use kstrtobool for swapaccount param
 parsing
Date: Fri, 9 Sep 2022 09:37:28 +0200
Message-ID: <YxrtODqHhdEkW2Lx@dhcp22.suse.cz>
References: <20220908083452.2844125-1-liushixin2@huawei.com>
 <20220908150248.85fff32bf275844f0927a856@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662709049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXTY9+MF108rC5N0qRIMHJTyEWfCXxraJ9r3p5CaavA=;
        b=PAsRjY//6ci6tMdc1AbSkVT1/NENOZTJAYbDmM/NGwbPB9Ex8BRJjtAD3qTEQgwNmwS7Sp
        85xLjm5S2Qb4Z+PRXwoYxHh3r/+n8crnkzaGqIGc0GZBNa68JFMKROU+hfksQTD0opQHMq
        YMn/VvNQEOBRlZW1X6lJKPVJc1wShuE=
Content-Disposition: inline
In-Reply-To: <20220908150248.85fff32bf275844f0927a856-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu 08-09-22 15:02:48, Andrew Morton wrote:
> On Thu, 8 Sep 2022 16:34:52 +0800 Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> 
> > --- a/mm/swap_cgroup.c
> > +++ b/mm/swap_cgroup.c
> > @@ -194,7 +194,7 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
> >  	return 0;
> >  nomem:
> >  	pr_info("couldn't allocate enough memory for swap_cgroup\n");
> > -	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
> > +	pr_info("swap_cgroup can be disabled by swapaccount=[oO][Ff]/N/n/0 boot option\n");
> 
> I'm not sure this really needed changing.  "=0" was OK and the message
> now looks rather silly.

Agreed. While swapaccount=0 is clear the extended form, even if correct,
might just confuse some admins.

-- 
Michal Hocko
SUSE Labs
