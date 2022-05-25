From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 01/11] mm: memcontrol: prepare objcg API for non-kmem
 usage
Date: Wed, 25 May 2022 21:08:51 +0800
Message-ID: <Yo4qYx6TZFr+jkZg@FVFYT0MHHV2J.usts.net>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-2-songmuchun@bytedance.com>
 <Yo2WKADtPy2rekRh@carbon>
 <Yo3hXe8bF3boWx5C@FVFYT0MHHV2J.usts.net>
 <Yo4jJjBksFVeJHxA@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nDxqtsfr0dKVwqZEkCAARcK1ckdc1oO5HqeANGAWehk=;
        b=BTlOkkjr47cZ9JCfyJeGWXO9DhAslHTm3aWUPVMOoy0syMYRM3O1lIx7Fhj5JhFIj/
         BCHNH5vbygawBpqwccbSGiDpUJqjmRoKB1f5k7E7jP9h4DiDDpwbHCX0vxZOHZXfp01i
         VOqg35B+4koUNfXOlszBZYSIVdJuZZoj3XLhVuJ2i3P1M2jcd1ZVN7/FFPfwNvTo8S9q
         nCs0ReL68nU+qNvBM43jdG9B9j0xcDGvFqrmDz591lh///Kfsy8i0r5xQbvoBl5bdO75
         PXdDioYydc8Vss2c+0TnSd7ygr0IlGGQYKHhONkJQhQVKH4Z5q/O2tSAzQaSp/xKXsZV
         Th5Q==
Content-Disposition: inline
In-Reply-To: <Yo4jJjBksFVeJHxA-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 25, 2022 at 08:37:58AM -0400, Johannes Weiner wrote:
> On Wed, May 25, 2022 at 03:57:17PM +0800, Muchun Song wrote:
> > On Tue, May 24, 2022 at 07:36:24PM -0700, Roman Gushchin wrote:
> > > On Tue, May 24, 2022 at 02:05:41PM +0800, Muchun Song wrote:
> > > > -	memcg_reparent_list_lrus(memcg, parent);
> > > > +	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
> > > We effectively dropped this:
> > > 	if (!parent)
> > > 		parent = root_mem_cgroup;
> > > Is it safe? (assuming v1 non-hierarchical mode, it's usually when all
> > > is getting complicated)
> 
> Yes, it's correct. But it's a quiet, incidental cleanup, so I can see
> why it's confusing. It might be better to split the dead code removal
> into a separate patch - with the following in the changelog ;):
>

Well, I can split the dead code removal into a separate patch. :-)

Thanks.
 
> > Since no-hierarchy mode is deprecated after commit bef8620cd8e0
> > ("mm: memcg: deprecate the non-hierarchical mode"), so
> > parent_mem_cgroup() cannot return a NULL except root memcg,
> > however, root memcg will not be offline, so it is safe. Right?
> 
