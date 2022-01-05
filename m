From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v4 23/32] mm/memcg: Convert slab objcgs from struct page
 to struct slab
Date: Tue, 4 Jan 2022 18:55:11 -0800
Message-ID: <YdUIj9chzbeOFpIJ@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-24-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=maK8sIYCrJV1weWYvOBPXD6pF0RnAd+Y0RAPQ6xmjiQ=;
 b=ol2Mnc0vKYX+tylIfHRtrT4wOcDrBtqLhfdlWgXIxMDZstu3UgSKnKjHnd42j2lrEei7
 qR111S3DYxdAKa3USBeP4OqjZGa/Q7AOXo9+sCdG7aWilJE0GxoYjRpBTTHSz2gdSury
 VQJyDpY+iuiIiC43duYWyFbLMBc4ujhl5B4= 
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-24-vbabka-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 04, 2022 at 01:10:37AM +0100, Vlastimil Babka wrote:
> page->memcg_data is used with MEMCG_DATA_OBJCGS flag only for slab pages
> so convert all the related infrastructure to struct slab. Also use
> struct folio instead of struct page when resolving object pointers.
> 
> This is not just mechanistic changing of types and names. Now in
> mem_cgroup_from_obj() we use folio_test_slab() to decide if we interpret
> the folio as a real slab instead of a large kmalloc, instead of relying
> on MEMCG_DATA_OBJCGS bit that used to be checked in page_objcgs_check().
> Similarly in memcg_slab_free_hook() where we can encounter
> kmalloc_large() pages (here the folio slab flag check is implied by
> virt_to_slab()). As a result, page_objcgs_check() can be dropped instead
> of converted.

Btw, it seems that with some minimal changes we can drop the whole thing
with the changing of the lower bit and rely on the slab page flag.
I'll prepare a patch on top of your series.

Thanks!
