From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 03/11] mm: memcontrol: prepare objcg API for non-kmem
 usage
Date: Wed, 1 Jun 2022 11:33:46 -0700
Message-ID: <YpexCpVBW76GCN2X@carbon>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-4-songmuchun@bytedance.com>
 <20220601173434.GB16134@blackbody.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654108434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3KXe7JyS/4SiYSTcpgOTrPkJ9VUQGQph5wJDhLq1PkU=;
        b=DQ8Mzwg5sWQebSxothCauYo0hX22gELn6PYnLRWohwSwso3mkoAi+6Eqf8yU60WzZIvpoq
        7JA+jXgqBdR5ChOWnOD2G77XAHvgdMXfyGAwWd/TCPcZPqYQAecPj9aDhzScPFSGKTzNWd
        YgHzVCljqv4x3G7uwNjg9P/3YjJOfNs=
Content-Disposition: inline
In-Reply-To: <20220601173434.GB16134-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, Jun 01, 2022 at 07:34:34PM +0200, Michal Koutny wrote:
> Hello.
> 
> On Mon, May 30, 2022 at 03:49:11PM +0800, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > So we also allocate an object cgroup for the root_mem_cgroup.
> 
> This change made me wary that this patch also kmem charging in the
> root_mem_cgroup. Fortunately, get_obj_cgroup_from_current won't return
> this objcg so all is fine.

Yes, I had the same experience here :)

Overall I feel like the handling of the root memcg and objcg are begging
for a cleanup, but it's really far from being trivial.

Maybe starting with documenting how it works now is a good idea...
