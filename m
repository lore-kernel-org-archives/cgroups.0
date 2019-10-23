From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/8] mm: vmscan: naming fixes: global_reclaim() and
 sane_reclaim()
Date: Wed, 23 Oct 2019 11:56:43 -0400
Message-ID: <20191023155643.GB366316@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-5-hannes@cmpxchg.org>
 <20191023141436.GE17610@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qCDfb7NBt3k96Z3LHT9+wyaPinygdsUVG4eMjwQIig0=;
        b=gzPtJc9UG7/c3nCw1QDLmDFrPZ2p/5hVgwAWj5fxU7jOZw+4M6LELBbAGYk+6wbln3
         f8ief24ppj67ptUxcdk4CzpF1yUiOP/2cRcPsqUBcFvNqdvDdfh1GrdDRfcdT6jSga8O
         lCUDrd5RQn/iYeUN5F8eMCJalFsQlOXYkpMo6RwW+lAx6M9sN67Bw/rIRZs76wUfN5ST
         3CmZcNDi0/pmB0JWE+/PHNP2bwbar9mrnhDdr4HqOzD/LbibMVqfVF5SBw424VYUqiAQ
         ZP48m8ZlTKx6J90KvpquV6g52d05IyK6VPpkmJ5aUaOaY30+/V/qPLq6e17IUoCMFz2f
         +SgA==
Content-Disposition: inline
In-Reply-To: <20191023141436.GE17610@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Oct 23, 2019 at 04:14:36PM +0200, Michal Hocko wrote:
> On Tue 22-10-19 10:47:59, Johannes Weiner wrote:
> > Seven years after introducing the global_reclaim() function, I still
> > have to double take when reading a callsite. I don't know how others
> > do it, this is a terrible name.
> 
> I somehow never had problem with that but ...
> > 
> > Invert the meaning and rename it to cgroup_reclaim().
> > 
> > [ After all, "global reclaim" is just regular reclaim invoked from the
> >   page allocator. It's reclaim on behalf of a cgroup limit that is a
> >   special case of reclaim, and should be explicit - not the reverse. ]
> 
> ... this is a valid point.
> 
> > sane_reclaim() isn't very descriptive either: it tests whether we can
> > use the regular writeback throttling - available during regular page
> > reclaim or cgroup2 limit reclaim - or need to use the broken
> > wait_on_page_writeback() method. Use "writeback_throttling_sane()".
> 
> I do have a stronger opinion on this one. sane_reclaim is really a
> terrible name. As you say the only thing this should really tell is
> whether writeback throttling is available so I would rather go with
> has_writeback_throttling() or writeba_throttling_{eabled,available}
> If you insist on having sane in the name then I won't object but it just
> raises a question whether we have some levels of throttling with a
> different level of sanity.

I mean, cgroup1 *does* have a method to not OOM due to pages under
writeback: wait_on_page_writeback() on each wb page on the LRU.

It's terrible, but it's a form of writeback throttling. That's what
the sane vs insane distinction is about, I guess: we do in fact have
throttling implementations with different levels of sanity.

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
