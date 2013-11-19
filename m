From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Mon, 18 Nov 2013 17:19:00 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311181717500.4292@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118125240.GC32623@dhcp22.suse.cz> <20131118125507.GD32623@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=UZbLDZeQ/cKvvDiayQYm2Yn1OYp0byPfBdojL4G+HOs=;
        b=kPBJnmFKpCy91kIwuxECmAacHrLJd3+iZOJ4fLC6rdBzYw3TlLT8+hbEFSqrJ80n2n
         Ima6pyL5QrZwi5wqkBi5GwW3dloLD3AskwUYuurPxE6t+rTFqVVNxKh/yS3jWrkJwf7t
         pyyUfmwRgq0xzkErQyfoDuO/hFNjgXYVO1ayboGLpW40tc0Z5fzC3hLW8+Seu8vBe3FV
         ixFKbouzGZ77s/nBKaHZP4+QvPchrMOdaRkxJBxXwbliV4WjdKp48s/O2hP/nv9KH8br
         UyRwNbGwxs0mHjlD8r+F8gupENhDcfCdd0mZWpoBqbTRcKVGU6ObUEtr8eTLRKlxkFo3
         Lv6Q==
In-Reply-To: <20131118125507.GD32623@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Mon, 18 Nov 2013, Michal Hocko wrote:

> > > When current has a pending SIGKILL or is already in the exit path, it
> > > only needs access to memory reserves to fully exit.  In that sense, the
> > > memcg is not actually oom for current, it simply needs to bypass memory
> > > charges to exit and free its memory, which is guarantee itself that
> > > memory will be freed.
> > > 
> > > We only want to notify userspace for actionable oom conditions where
> > > something needs to be done (and all oom handling can already be deferred
> > > to userspace through this method by disabling the memcg oom killer with
> > > memory.oom_control), not simply when a memcg has reached its limit, which
> > > would actually have to happen before memcg reclaim actually frees memory
> > > for charges.
> > 
> > I believe this also fixes the issue reported by Eric
> > (https://lkml.org/lkml/2013/7/28/74). I had a patch for this
> > https://lkml.org/lkml/2013/7/31/94 but the code changed since then and
> > this should be equivalent.
> >  
> > > Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Anyway, the patch looks good to me but please mention the above bug in
> the changelog.
> 

The patch is in -mm, so perhaps we can change the changelog if/when Eric 
confirms it fixes his issue.

> Acked-by: Michal Hocko <mhocko@suse.cz>
> 

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
