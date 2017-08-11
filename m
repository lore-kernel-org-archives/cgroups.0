From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: kmemleaks reports a lot of cases around memcg_create_kmem_cache
Date: Fri, 11 Aug 2017 10:30:40 -0700
Message-ID: <20170811173040.GB3005423@devbig577.frc2.facebook.com>
References: <CANaxB-x=xgLq116VReo4Og+jFsAB+ehx3xThnXoCx8pR3YXPSA@mail.gmail.com>
 <20170702185017.ew5cn4altyw7nomi@esperanza>
 <20170705144743.GA19330@htj.duckdns.org>
 <CANaxB-xaHyyn=c8mJ8R8=k-kFJvW1a04MAuAdmS+V4KsjU84AQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nhhCgfZj/v+7+Q74xVoA77hKt/dIkP+y8mUMHf9qtK0=;
        b=jNqXtWSOyfZgrL1WrJvAa0VbqV7QxD8AJ90vqxsw5nLTJn5qWNu0eXzdrKEYW5z0H+
         RR4up1eMEC8wtTP1o9jL6vtuwk7Ev3UQ6BMSE0KF9jJLFfSyydJIMvnLbhdWUt8KMR84
         s4c9pBHx4sXph3Zkp6uZtqojYWLpOJoTMDRYy1LZn8ZVEqqgU/xWLkO8PPMg6UPF0kfd
         hThsmKr68ed+oP86jSH0NaTiCzIMmr0sT/6WLT17UMOuWwk9lITH1lja9/MJm1ml3prw
         RbOdcoM+LMR9F/U5C3sR+kmu/BcU7jVhQ4gAFP7Gc7om7uLRZhJ8HZ7QCmLY9EnQFQ9y
         NSHw==
Content-Disposition: inline
In-Reply-To: <CANaxB-xaHyyn=c8mJ8R8=k-kFJvW1a04MAuAdmS+V4KsjU84AQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Aug 07, 2017 at 04:37:52PM -0700, Andrei Vagin wrote:
> Hello Vladimir and Tejun,
> 
> This patch isn't in the Linus' tree. Could you do something to push it
> into the upstream tree.

Vladimir, can you please resend the patch to Andrew Morton?

Thanks!

-- 
tejun
