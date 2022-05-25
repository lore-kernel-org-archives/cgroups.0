From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 01/11] mm: memcontrol: prepare objcg API for non-kmem
 usage
Date: Wed, 25 May 2022 08:37:58 -0400
Message-ID: <Yo4jJjBksFVeJHxA@cmpxchg.org>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-2-songmuchun@bytedance.com>
 <Yo2WKADtPy2rekRh@carbon>
 <Yo3hXe8bF3boWx5C@FVFYT0MHHV2J.usts.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6TZc5omLz/Jq7pdQu2KMjXRAJ+8quAYgmF0qQ6A24hk=;
        b=QY59JJr7TItWYVE8/m9ruAVMHFqijACLGhysmIiQ0darsQg/VQAoJB8gF2m9BF41wz
         /Rd0O1W076eZNqnGHu+DAxpqOcIiVcSLvKUEJhqY5OvDGbpFy0ESGC/p0jK+bP/sZRHW
         YNyl6oYfbkJuFFI6vKpdAcbbhDbc+4NhyBATsREKtv7w8AFx45S9N8cPppNXnNRlDe2Y
         ne1zDiEaRvCpbvIraoD3UJZCi+i5D7sCQ1Fx97kmRCaKSd2nKy8uX0l6sSmwKWrK8mEJ
         OJtY07A4EPFFeowbysgfs+AsI1e7SZbI3MrQiHJ9fZAJee4hJExZh8khNM6L17ZOG7ue
         zwdw==
Content-Disposition: inline
In-Reply-To: <Yo3hXe8bF3boWx5C-t1y1lxtqHnnw2QbUemf3bixXY32XiHfO@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 25, 2022 at 03:57:17PM +0800, Muchun Song wrote:
> On Tue, May 24, 2022 at 07:36:24PM -0700, Roman Gushchin wrote:
> > On Tue, May 24, 2022 at 02:05:41PM +0800, Muchun Song wrote:
> > > -	memcg_reparent_list_lrus(memcg, parent);
> > > +	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
> > We effectively dropped this:
> > 	if (!parent)
> > 		parent = root_mem_cgroup;
> > Is it safe? (assuming v1 non-hierarchical mode, it's usually when all
> > is getting complicated)

Yes, it's correct. But it's a quiet, incidental cleanup, so I can see
why it's confusing. It might be better to split the dead code removal
into a separate patch - with the following in the changelog ;):

> Since no-hierarchy mode is deprecated after commit bef8620cd8e0
> ("mm: memcg: deprecate the non-hierarchical mode"), so
> parent_mem_cgroup() cannot return a NULL except root memcg,
> however, root memcg will not be offline, so it is safe. Right?
