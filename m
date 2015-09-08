From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Tue, 8 Sep 2015 12:59:53 -0400
Message-ID: <20150908165953.GG13749@mtj.duckdns.org>
References: <20150828220158.GD11089@htj.dyndns.org>
 <20150828220237.GE11089@htj.dyndns.org>
 <20150904210011.GH25329@mtj.duckdns.org>
 <20150907092346.GC6022@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=whbf5e8qBb3X3fL7eHgzzYmLx2zWfzuGnClGMd/JVS0=;
        b=0xkBkZk8pl2K/ynelt6RUzUyxtcjo2/BrbA4/urIhb0f4XBilmECOdPV9qZg06Qls2
         C1K1luDx9uprcz8sBSQ/g7gXE6MGD84Su9g8U+CbmBzgBFszM3hXUY4/m/wWTTIpt5dg
         OnFKVlTDV7V3eRnpe/eX8slNqMghfTW3tXCoCvryEEMnzMRxIvoczMfK1zr5WwN1OHcn
         uMIi7n4QRWV31pgEH6ileLoJXPrUlGiZXffJ61cnJVe3+fB3oRj9nsd3QlocXwkP7qct
         7eF1++nCz+hPnAnylUP0qDPwBcWlrcy3bHauF6mM8cBC5PjBgpsadrIwCYCENrR4G797
         f5vg==
Content-Disposition: inline
In-Reply-To: <20150907092346.GC6022-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Michal.

On Mon, Sep 07, 2015 at 11:23:46AM +0200, Michal Hocko wrote:
> > As long as kernel doesn't have a run-away allocation spree, this
> > should provide enough protection while making kmemcg behave more
> > consistently.
> 
> I would also point out that this approach allows for a better reclaim
> opportunities for GFP_NOFS charges which are quite common with kmem
> enabled.

Will update the description.

> > v2: - Switched to reclaiming only the overage caused by current rather
> >       than the difference between usage and high as suggested by
> >       Michal.
> >     - Don't record the memcg which went over high limit.  This makes
> >       exit path handling unnecessary.  Dropped.
> 
> Hmm, this allows to leave a memcg in a high limit excess. I guess
> you are right that this is not that likely to lose sleep over
> it. Nevertheless, a nasty user could move away from within signal
> handler context which runs before. This looks like a potential runaway
> but the migration outside of the restricted hierarchy is a problem in
> itself so I wouldn't consider this a problem.

Yeah, it's difficult to say that there isn't an exploitable sequence
which allows userland to breach high limit from an exiting task.  That
said, I think it'd be pretty difficult to make it large enough to
matter given that the exiting task is losing whatever it's pinning
anyway and the overage it can leave behind is confined by what it
allocates in the kernel execution leading to the exit.  The only
reason I added the exit handling is to put the memcg ref in the first
place.

> > +void mem_cgroup_handle_over_high(void)
> > +{
> > +	unsigned int nr_pages = current->memcg_nr_pages_over_high;
> > +	struct mem_cgroup *memcg, *pos;
> > +
> > +	if (likely(!nr_pages))
> > +		return;
> 
> This is hooking into a hot path so I guess it would be better to make
> this part inline and the rest can go via function call.

Thought about that but it's already guarded by TIF_NOTIFY_RESUME.  It
shouldn't be a hot path.

> > @@ -2082,17 +2108,22 @@ done_restock:
> 
> JFYI you can get rid of labels in the patch format by
> [diff "default"]
>         xfuncname = "^[[:alpha:]$_].*[^:]$"

Heh, I had that in my config but apparently lost it while migrating to
a new machine.  Reinstating...

Thanks.

-- 
tejun
