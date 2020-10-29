From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: Simplify the mem_cgroup_page_lruvec
Date: Thu, 29 Oct 2020 10:08:06 +0100
Message-ID: <20201029090806.GD17500@dhcp22.suse.cz>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
 <20201028035013.99711-4-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603962487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pRfvIcEC60eWRFi87by9E7+LFhlD5mHOp4kKoOmBQUI=;
        b=jhHChYEGIqkgyrVF2bZZDAP9fShBJKnw5Z76v7XG/lfKacRenW4EL4SRGC/eZd1qasjwS2
        cXgAP3eIkMrcSCfouk1jFCJmAe+jJ4WKqCfQbzrt+J4qDoDjNaVak+cdilW0CbujdHb2DS
        S50daeUjnIvhpfapMjy5qa/SKRtIe58=
Content-Disposition: inline
In-Reply-To: <20201028035013.99711-4-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 28-10-20 11:50:13, Muchun Song wrote:
[...]
> -struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
> +static struct lruvec *
> +__mem_cgroup_node_lruvec(struct mem_cgroup *memcg, struct pglist_data *pgdat,
> +			 int nid)

I thought I have made it clear that this is not a good approach. Please
do not repost new version without that being addressed. If there are any
questions then feel free to ask for details.
-- 
Michal Hocko
SUSE Labs
