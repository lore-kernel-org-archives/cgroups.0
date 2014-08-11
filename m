From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -mm] slab: fix cpuset check in fallback_alloc
Date: Mon, 11 Aug 2014 04:37:15 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1408110433140.15519@chino.kir.corp.google.com>
References: <1407692891-24312-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.02.1408101512500.706@chino.kir.corp.google.com> <20140811071315.GA18709@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=wFYt5HPe4jslu5TVIEW5tvA2asLTDQJwHDq2Y5FUsic=;
        b=dAyhtark07RxM1+M7rGoUigGNzjaImXYmTAoEi1YEpmJImLN0R99tAQ2VqU2hbF4XV
         Ks8M/e7AC7ms1/0j39fpfc2wyMZ3FJy2y57q4iWWBLppcU+fNl9zXfFsOluwzJUrDGKL
         hONc+Y3zKsDXpld75i0bwerg6E1ohwk8gNuxzvbZhgbbohveT5JR1ZFOm23aSCw38yft
         ckk0zSjUiXvCnz6kqTU+EqiM65pyWdJuQn1vB1PpPu1DprtZ5zez2AApUGBxbzr/XZDx
         ylFoVmDhvIHgTK2Lo1p3QEivGV1DhcdYV2IVR4eQ5B3rOeHFuop1tHyfhb4bnyRXnhKe
         ed9A==
In-Reply-To: <20140811071315.GA18709@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Mon, 11 Aug 2014, Vladimir Davydov wrote:

> > diff --git a/mm/slab.c b/mm/slab.c
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3047,16 +3047,19 @@ retry:
> >  	 * from existing per node queues.
> >  	 */
> >  	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> > -		nid = zone_to_nid(zone);
> > +		struct kmem_cache_node *n;
> >  
> > -		if (cpuset_zone_allowed_hardwall(zone, flags) &&
> > -			get_node(cache, nid) &&
> > -			get_node(cache, nid)->free_objects) {
> > -				obj = ____cache_alloc_node(cache,
> > -					flags | GFP_THISNODE, nid);
> > -				if (obj)
> > -					break;
> > -		}
> > +		nid = zone_to_nid(zone);
> > +		if (!cpuset_zone_allowed(zone, flags | __GFP_HARDWALL))
> 
> We must use softwall check here, otherwise we will proceed to
> alloc_pages even if there are lots of free slabs on other nodes.
> alloc_pages, in turn, may allocate from other nodes in case
> cpuset.mem_hardwall=0, because it uses softwall check, so it may add yet
> another free slab to another node's list even if it isn't empty. As a
> result, we may get free list bloating on other nodes. I've seen a
> machine with one of its nodes almost completely filled with inactive
> slabs for buffer_heads (dozens of GBs) w/o any chance to drop them. So,
> this is a bug that must be fixed.
> 

Right, I understand, and my patch makes no attempt to fix that issue, it's 
simply collapsing the code down into a single cpuset_zone_allowed() 
function and the context for the allocation is controlled by the gfp 
flags (and hardwall is controlled by setting __GFP_HARDWALL) as it should 
be.  I understand the issue you face, but I can't combine a cleanup with a 
fix and I would prefer to have your patch keep your commit description.  

The diffstat for my proposal removes many more lines than it adds and I 
think it will avoid this type of issue in the future for new callers.  
Your patch could then be based on the single cpuset_zone_allowed() 
function where you would simply have to remove the __GFP_HARDWALL above.  
Or, your patch could be merged first and then my cleanup on top, but it 
seems like your one-liner would be more clear if it is based on mine.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
