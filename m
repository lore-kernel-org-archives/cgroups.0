From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
Date: Mon, 24 Sep 2012 10:43:46 -0700
Message-ID: <20120924174346.GB7694@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-16-git-send-email-glommer@parallels.com>
 <20120921204035.GQ7264@google.com>
 <506018DC.2020907@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4/MkZY1VwVl4T+if5deNwDE3zsY53YCXNzQHn3VWy24=;
        b=Ntmwy/xgEq3ukLEJohHlRs+ZMq4+8zFmiuYnBHMlvg65kxhX/InFhfIt8OQvCTabuK
         r1iCsly3txJryrohVrqHL8fvx7SWrDLagnPvCWpBr85wHl6+pZO+BVgg/s4Civz05aM0
         D2bERXQjhaoIdfovERPGX3tn1SqmSctahgn+q0Y9OAAxARYOHeB+pD0+5OIXm6qndSqg
         anATMV5/A1TJHV7OkBPgtfdvGHyThnFOJS2/q9lETYNz7dzQgk75NEQb2T16CiE7irbL
         eHNiVD90WzrfJAr4ABNAFqMokrhJGbmJ68BQ6d5xuhElqqxgqly9gwPa1+E7OzC3WqiL
         UKVQ==
Content-Disposition: inline
In-Reply-To: <506018DC.2020907-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Mon, Sep 24, 2012 at 12:25:00PM +0400, Glauber Costa wrote:
> > This is kinda nasty.  Do we really need to do this?  How long would a
> > dead cache stick around?
> 
> Without targeted shrinking, until all objects are manually freed, which
> may need to wait global reclaim to kick in.
> 
> In general, if we agree with duplicating the caches, the problem that
> they may stick around for some time will not be avoidable. If you have
> any suggestions about alternative ways for it, I'm all ears.

I don't have much problem with caches sticking around waiting to be
reaped.  I'm just wondering whether renaming trick is really
necessary.

> > Reaping dead caches doesn't exactly sound like a high priority thing
> > and adding a branch to hot path for that might not be the best way to
> > do it.  Why not schedule an extremely lazy deferrable delayed_work
> > which polls for emptiness, say, every miniute or whatever?
> > 
> 
> Because this branch is marked as unlikely, I would expect it not to be a
> big problem. It will be not taken most of the time, and becomes a very
> cheap branch. I considered this to be simpler than a deferred work
> mechanism.
> 
> If even then, you guys believe this is still too high, I can resort to that.

It's still an otherwise unnecessary branch on a very hot path.  If you
can remove it, there's no reason not to.

Thanks.

-- 
tejun
