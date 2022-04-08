From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Fri, 8 Apr 2022 16:11:05 +0200
Message-ID: <YlBCeadBqbeVvALK@dhcp22.suse.cz>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com>
 <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649427069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gNPsT3NKhlXnfi2F2vg55Kv/xhOi4VGOL+j6MMtTFeQ=;
        b=cfXqbCqyXyBa9orgccUoy4424ix9hLjiTcErReYj3EGVeVskbNNPsd6jezIUyblN1T6VI/
        /PKqJNKcV+Av8NjuXjYKDNOPjnnWzy0/mCCms8pAaSht4wSV42B5hoL2fPkU54vQzpRJeZ
        ikVj76De+BwGGpCsVa7bGeTVBr4jiS0=
Content-Disposition: inline
In-Reply-To: <YlA754XNFAmWQcm6-fkkBeQb8ge2DK6JXYb2XlJM2KBzDZLgSYRRNvcr/Vuo4Aut8bSbYrdcQFCl+OI4i@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, l

On Fri 08-04-22 09:43:03, Dan Schatzberg wrote:
> On Fri, Apr 08, 2022 at 04:57:40AM +0000, Yosry Ahmed wrote:
> > +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> > +			      size_t nbytes, loff_t off)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > +	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> > +	unsigned long nr_to_reclaim, nr_reclaimed = 0;
> > +	int err;
> > +
> > +	buf = strstrip(buf);
> > +	err = page_counter_memparse(buf, "", &nr_to_reclaim);
> 
> Is there a reason not to support "max"? Empty string seems odd to me
> here.

I have to say I have missed the special meaning of the empty string here
and I agree this would indeed really weird. Does cgroup core even call
here? cgroup_file_write seems to drop !nbytes input.

Regarding "max" as a possible input. I am not really sure to be honest.
I can imagine that it could be legit to simply reclaim all the charges
(e.g. before removing the memcg) which should be achieveable by
reclaiming the reported consumption. Or what exactly should be the
semantic?
-- 
Michal Hocko
SUSE Labs
