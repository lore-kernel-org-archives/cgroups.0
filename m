From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: Proportional memory.{low,min} reclaim
Date: Tue, 16 Jul 2019 13:24:59 -0400
Message-ID: <20190716172459.GB16575@cmpxchg.org>
References: <20190124014455.GA6396@chrisdown.name>
 <20190128210031.GA31446@castle.DHCP.thefacebook.com>
 <20190128214213.GB15349@chrisdown.name>
 <20190128215230.GA32069@castle.DHCP.thefacebook.com>
 <20190715153527.86a3f6e65ecf5d501252dbf1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jmmNrLz05OQxiUsEmtCkS8mBmrl8vj668vZ/xiMeIrY=;
        b=phx1Mq5J6p2gfPq049fRU4kJqr233RVvBA6UMs66Fh5VPoHy5KsLA3yLW7b00Y3rb8
         GTdFxxgsB1P4yFAdo2Qi0lgz4B0At2EUVu95fRfY8Bd7hU1ELdLrEB76Wv/eTo0O/IHK
         cBHGKVh+C260gNquMCThFTjxvff5UR0XDGNu4y01LXooRqWSmV8nFoJlX5Ux8Oc0p4YR
         Ffk+3gQEUfcv+lzY/PFoTBxKXktxFJtv2i/1ZrJEAx+OqMpmcJgHGEZrhE7dlAGzP7Ne
         tVCLPB+rZn10vOY9YPlc33YLioHP5gwh7muhEqrhXj+c2blGXe3qtkyX7eg0lodMWVNf
         3yiA==
Content-Disposition: inline
In-Reply-To: <20190715153527.86a3f6e65ecf5d501252dbf1@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Jul 15, 2019 at 03:35:27PM -0700, Andrew Morton wrote:
> On Mon, 28 Jan 2019 21:52:40 +0000 Roman Gushchin <guro@fb.com> wrote:
> 
> > > Hmm, this isn't really a common situation that I'd thought about, but it
> > > seems reasonable to make the boundaries when in low reclaim to be between
> > > min and low, rather than 0 and low. I'll add another patch with that. Thanks
> >
> > It's not a stopper, so I'm perfectly fine with a follow-up patch.
> 
> Did this happen?
> 
> I'm still trying to get this five month old patchset unstuck :(.  The
> review status is: 
> 
> [1/3] mm, memcg: proportional memory.{low,min} reclaim
> Acked-by: Johannes
> Reviewed-by: Roman
> 
> [2/3] mm, memcg: make memory.emin the baseline for utilisation determination
> Acked-by: Johannes
> 
> [3/3] mm, memcg: make scan aggression always exclude protection
> Reviewed-by: Roman

I forgot to send out the actual ack-tag on #, so I just did. I was
involved in the discussions that led to that patch, the code looks
good to me, and it's what we've been using internally for a while
without any hiccups.

> I do have a note here that mhocko intended to take a closer look but I
> don't recall whether that happened.

Michal acked #3 in 20190530065111.GC6703@dhcp22.suse.cz. Afaik not the
others, but #3 also doesn't make a whole lot of sense without #1...

> a) say what the hell and merge them or
> b) sit on them for another cycle or
> c) drop them and ask Chris for a resend so we can start again.

Michal, would you have time to take another look this week? Otherwise,
I think everyone who would review them has done so.
