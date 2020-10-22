From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Thu, 22 Oct 2020 14:29:34 -0400
Message-ID: <20201022182934.GA494712@cmpxchg.org>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
 <db4f86f30726a1a33c868155b4c681ac25569179.camel@fb.com>
 <004fe66ee1d111ec006dd065b9bed5fdcfdaad01.camel@surriel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aYlAeZhqKaRNyS3SekTyRKmiadvhR+J+xxu+zks2yzM=;
        b=SGBkvSKMMmJQMrZ01OSTFiEhpJ02DhOZA+Ue6BRyeAU09VrB/HGHe2qWivLDSvMnKf
         dpwvedVTZ8ugXE+Sxk+vXxXvpKgzliUd80cAArsrOhvQ/6GSTxG+sgnWD2rZkCq7iIoU
         LrihMPSo1xbc5+uZTVnJW+1Q+t4BXRyudrCuXtJSwxZpOKgNiPisU2lmU0R4YeLtsNvd
         bbX+c4K3VaqR/UkS8VW4xEmz1S1or0Nh50wv4Jwzpp8QLrWZwna/rO0KXRNQZOG44SfH
         LL+mNNZu3YUsMmHWQEUBSHXIs6tsId+QRKjF1U3qfgOMe/LfTc8NdjV5muvaqO9ovvZJ
         DaFA==
Content-Disposition: inline
In-Reply-To: <004fe66ee1d111ec006dd065b9bed5fdcfdaad01.camel@surriel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Oct 22, 2020 at 12:57:55PM -0400, Rik van Riel wrote:
> On Thu, 2020-10-22 at 12:49 -0400, Rik van Riel wrote:
> > On Thu, 2020-10-22 at 11:18 -0400, Johannes Weiner wrote:
> > 
> > > index e80aa9d2db68..334ce608735c 100644
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -204,9 +204,9 @@ static void unaccount_page_cache_page(struct
> > > address_space *mapping,
> > >  	if (PageSwapBacked(page)) {
> > >  		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
> > >  		if (PageTransHuge(page))
> > > -			__dec_node_page_state(page, NR_SHMEM_THPS);
> > > +			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
> > >  	} else if (PageTransHuge(page)) {
> > > -		__dec_node_page_state(page, NR_FILE_THPS);
> > > +		__dec_lruvec_page_state(page, NR_FILE_THPS);
> > >  		filemap_nr_thps_dec(mapping);
> > >  	}
> > 
> > This may be a dumb question, but does that mean the
> > NR_FILE_THPS number will no longer be visible in
> > /proc/vmstat or is there some magic I overlooked in
> > a cursory look of the code?
> 
> Never mind, I found it a few levels deep in
> __dec_lruvec_page_state.

No worries, it's a legit question.

lruvec is at the intersection of node and memcg, so I'm just moving
the accounting to a higher-granularity function that updates all
layers, including the node.

> Reviewed-by: Rik van Riel <riel@surriel.com>

Thanks!
