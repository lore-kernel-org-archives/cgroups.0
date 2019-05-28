From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v5 6/7] mm: reparent slab memory on cgroup removal
Date: Tue, 28 May 2019 18:16:14 -0400
Message-ID: <20190528221614.GD26614@cmpxchg.org>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-7-guro@fb.com>
 <20190528183302.zv75bsxxblc6v4dt@esperanza>
 <20190528195808.GA27847@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SLwBA8MbvD2QC0ep8E6TWiO4osZD4fu2h/9Z2V53XVU=;
        b=1U+7o4fD7tmYoGz+yUlK3xEC1BolyoWKEYDkAchX/oKTIdCJ03mkyuokQEfbvRSu2J
         aGd9YozwjkbKIRGDOUx6V5TNQV10fBydRP3/Rref/HmapwqQZiV9R4GRFjbMDQgluno+
         0zHhUoORAlPNG66tv0aBbi6J1l5JMOKKBFrNXSeq1LkzuGBuaLOfIVr2A802gf+RC1pL
         +oa0FYRQhTCfhF5qx4XRkKaaxYuVA6TXhvlkdl7eTRQtFWHk8AIvAGmY8XmG0Lr5F0w0
         2GAmIemcB/o8diV8Hr/dq8X+6wB9bHxgvYLAnWqThhUoTxyo31DHn2/FkNsat0MFD2go
         3t4A==
Content-Disposition: inline
In-Reply-To: <20190528195808.GA27847@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Tue, May 28, 2019 at 07:58:17PM +0000, Roman Gushchin wrote:
> On Tue, May 28, 2019 at 09:33:02PM +0300, Vladimir Davydov wrote:
> > On Tue, May 21, 2019 at 01:07:34PM -0700, Roman Gushchin wrote:
> > > Let's reparent memcg slab memory on memcg offlining. This allows us
> > > to release the memory cgroup without waiting for the last outstanding
> > > kernel object (e.g. dentry used by another application).
> > > 
> > > So instead of reparenting all accounted slab pages, let's do reparent
> > > a relatively small amount of kmem_caches. Reparenting is performed as
> > > a part of the deactivation process.
> > > 
> > > Since the parent cgroup is already charged, everything we need to do
> > > is to splice the list of kmem_caches to the parent's kmem_caches list,
> > > swap the memcg pointer and drop the css refcounter for each kmem_cache
> > > and adjust the parent's css refcounter. Quite simple.
> > > 
> > > Please, note that kmem_cache->memcg_params.memcg isn't a stable
> > > pointer anymore. It's safe to read it under rcu_read_lock() or
> > > with slab_mutex held.
> > > 
> > > We can race with the slab allocation and deallocation paths. It's not
> > > a big problem: parent's charge and slab global stats are always
> > > correct, and we don't care anymore about the child usage and global
> > > stats. The child cgroup is already offline, so we don't use or show it
> > > anywhere.
> > > 
> > > Local slab stats (NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE)
> > > aren't used anywhere except count_shadow_nodes(). But even there it
> > > won't break anything: after reparenting "nodes" will be 0 on child
> > > level (because we're already reparenting shrinker lists), and on
> > > parent level page stats always were 0, and this patch won't change
> > > anything.
> > > 
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > 
> > This one looks good to me. I can't see why anything could possibly go
> > wrong after this change.
> 
> Hi Vladimir!
> 
> Thank you for looking into the series. Really appreciate it!
> 
> It looks like outstanding questions are:
> 1) synchronization around the dying flag
> 2) removing CONFIG_SLOB in 2/7
> 3) early sysfs_slab_remove()
> 4) mem_cgroup_from_kmem in 7/7
> 
> Please, let me know if I missed anything.
> 
> I'm waiting now for Johanness's review, so I'll address these issues
> in background and post the next (and hopefully) final version.

The todo items here aside, the series looks good to me - although I'm
glad that Vladimir gave it a much more informed review than I could.
