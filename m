From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memcg: Convert mc_target.page to mc_target.folio
Date: Fri, 18 Mar 2022 10:12:37 +0100
Message-ID: <YjRNBdEENrNNrUNe@dhcp22.suse.cz>
References: <YjJJIrENYb1qFHzl@casper.infradead.org>
 <YjMidqgZbieEyBuF@dhcp22.suse.cz>
 <YjQBRx1+Rq7CYC4M@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647594758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yk/mGHSn8BRwoxpYgM2QMot9CU5E0d7sStOUlUWO988=;
        b=HraKjKE4Fh3wvBHXqN+3Dkof0fl72OSnSPCpTwrGC2jGR9+4rlg/DhmiQWF0z4h7Qb6uQo
        7GUHh7LFyhWnc8lMvZTS0RJQmDgkCyGn4JAke85v4kZ1BBzBUtuMgJIRBYMV51m7U8iw9W
        Hg5SwD8L7Z2hU8GqhH2KtFlpM0A6Y+8=
Content-Disposition: inline
In-Reply-To: <YjQBRx1+Rq7CYC4M-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 18-03-22 03:49:27, Matthew Wilcox wrote:
> On Thu, Mar 17, 2022 at 12:58:46PM +0100, Michal Hocko wrote:
> > On Wed 16-03-22 20:31:30, Matthew Wilcox wrote:
> > > This is a fairly mechanical change to convert mc_target.page to
> > > mc_target.folio.  This is a prerequisite for converting
> > > find_get_incore_page() to find_get_incore_folio().  But I'm not
> > > convinced it's right, and I'm not convinced the existing code is
> > > quite right either.
> > > 
> > > In particular, the code in hunk @@ -6036,28 +6041,26 @@ needs
> > > careful review.  There are also assumptions in here that a memory
> > > allocation is never larger than a PMD, which is true today, but I've
> > > been asked about larger allocations.
> > 
> > Could you be more specific about those usecases? Are they really
> > interested in supporting larger pages for the memcg migration which is
> > v1 only feature? Or you are interested merely to have the code more
> > generic?
> 
> Ah!  I didn't realise memcg migration was a v1-only feature.  I think
> that makes all of the questions much less interesting.  I've done some
> more reading, and it seems like all of this is "best effort", so it
> doesn't really matter if some folios get skipped.

Yes.
[...]

> That makes sense.  I think the case that's currently mishandled is a
> THP in tmpfs which is misaligned when mapped to userspace.  It's
> skipped, even if the entire THP is mapped.  But maybe that simply
> doesn't matter.
> 
> I suppose the question is: Do we care if mappings of files are not
> migrated to the new memcg?  I'm getting a sense that the answer is "no",
> and if we actually ended up skipping all file mappings, it wouldn't
> matter.

Yes, I wouldn't lose sleep over that. You are not introducing a new
regression. The feature is mostly deprecated (along with the whole v1)
so we tend to prefer bug-to-bug compatibility rather than making the
code more complex to solve a theoretical problem (or at least a problem
that nobody is complaining about).

Thanks!
-- 
Michal Hocko
SUSE Labs
