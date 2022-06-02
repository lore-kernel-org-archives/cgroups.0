From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 03/11] mm: memcontrol: prepare objcg API for non-kmem
 usage
Date: Thu, 2 Jun 2022 18:48:41 +0800
Message-ID: <YpiVibVoQizVDzOO@FVFYT0MHHV2J.googleapis.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-4-songmuchun@bytedance.com>
 <20220601173434.GB16134@blackbody.suse.cz>
 <YpexCpVBW76GCN2X@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mFpX60Bpgj1CZ/r9BaiZqjht5lWPMONlADO9gEwg/QM=;
        b=SwX3dVy3jXK2i5Z7uMI0MgELLNVc2oWbF7lRdRfsT9EqfOJ3hICdbNbgMYcXkoVooC
         MlgCxTXNf14Vl4M1M0BwPslA6dKzAvnrC5y8gpZ8KnUTdXkrj4uIpoCzfUwXG4KImXXC
         NzUsT2IT1TEgI1ZrOK8up2DZ0I7c9OpMbD2tFlQgWa/9mr9adaLsjb4YApgZvWlBZWa1
         A6XaWRRCvcyCJT3zVWP4dYdYmYDcvN6KarzhSqkqS9tDFBh/KH4E3wEXilxg55OSCP8l
         cHTB6ytf08StwYuny4TYXUFaKL5qINmBT6/7EIo1wJYpEKwD8VEP0w7/zSs/Q5iCESf/
         uTTQ==
Content-Disposition: inline
In-Reply-To: <YpexCpVBW76GCN2X@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, Jun 01, 2022 at 11:33:46AM -0700, Roman Gushchin wrote:
> On Wed, Jun 01, 2022 at 07:34:34PM +0200, Michal Koutny wrote:
> > Hello.
> > 
> > On Mon, May 30, 2022 at 03:49:11PM +0800, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > > So we also allocate an object cgroup for the root_mem_cgroup.
> > 
> > This change made me wary that this patch also kmem charging in the
> > root_mem_cgroup. Fortunately, get_obj_cgroup_from_current won't return
> > this objcg so all is fine.
> 
> Yes, I had the same experience here :)
>

Sorry for the confusing.
 
> Overall I feel like the handling of the root memcg and objcg are begging
> for a cleanup, but it's really far from being trivial.
> 
> Maybe starting with documenting how it works now is a good idea...
> 

You mean add more comments into the commit log to explain the
usage of root memcg and root objcg?

Thanks.
