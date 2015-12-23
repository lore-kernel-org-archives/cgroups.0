From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix uninitialized variable warning
Date: Wed, 23 Dec 2015 16:41:34 -0500
Message-ID: <20151223214134.GN5003@mtj.duckdns.org>
References: <1450906240-21821-1-git-send-email-ross.zwisler@linux.intel.com>
 <20151223213519.GM5003@mtj.duckdns.org>
 <20151223213813.GA21287@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GlhMHE+A4IuF98RrfL5EQ1C2tmC9eqCKu/Ld/U45iE4=;
        b=ENj6nbmDQVnHig9aV9HHLEvuI4POq6IbKNVBWQduW00wUhn0c3SVKJNZ0JJ5ujTseU
         soUqjYYap6ZQnCO688R3W7NxZGooZTLqV1kfqrlI0eHciL8cdFAoVF+TcyaXSNkhOjtJ
         GxsKrSJeclBf6xqwCNMcbP4uUxTG4v4i4sUxpTm274iB+sKzaPR/1t8a7tGJQ8YCCpbb
         EbEeQC749o9ypYSmMKVc4hKZOm+jEx5bSOBw4djUz6XYp8ZEcn/n/xTsrqG5v3zOpRAH
         nl+8ZukrOsMcUx/bOOeAheI/CrIe5n3IIJ/jmKHNL2NDSdmDfsZ6ZaVmk1ypOHtxRDmw
         kaDw==
Content-Disposition: inline
In-Reply-To: <20151223213813.GA21287-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Wed, Dec 23, 2015 at 02:38:13PM -0700, Ross Zwisler wrote:
> On Wed, Dec 23, 2015 at 04:35:19PM -0500, Tejun Heo wrote:
> > Hello, Ross.
> > 
> > On Wed, Dec 23, 2015 at 02:30:40PM -0700, Ross Zwisler wrote:
> > >  static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
> > >  {
> > >  	struct cgroup_subsys_state *css;
> > > -	struct mem_cgroup *memcg;
> > > +	struct mem_cgroup *memcg = NULL;
> > 
> > It's one thing to add spurious init to shut up gcc
> > 
> > > @@ -4805,7 +4805,7 @@ static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
> > >  		p = leader;
> > >  		memcg = mem_cgroup_from_css(css);
> > >  	}
> > > -	if (!p)
> > > +	if (!p || !memcg)
> > 
> > and to another to add an additional processing on it.
> 
> Do you believe that the additional processing is incorrect?  If somehow we
> *do* get through the above loop without setting memcg, the next deref will
> OOPs the kernel...

That'd be a a plain kernel bug and oopsing is fine.  If such
conditions are particular (more likely, more difficult to debut,
whatever), we sometimes add WARNs for them but we don't generally go
around and add spurious checks.  It actually is deterimental to
readibility as people reading the code constantly have to go "when can
p && !memcg can happen? why is this explicitly checked?".

Thanks.

-- 
tejun
