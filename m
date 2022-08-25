From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter
 fields
Date: Wed, 24 Aug 2022 22:21:50 -0700
Message-ID: <20220824222150.61c516a83bfe0ecb6c9b5348@linux-foundation.org>
References: <20220825000506.239406-1-shakeelb@google.com>
        <20220825000506.239406-3-shakeelb@google.com>
        <20220824173330.2a15bcda24d2c3c248bc43c7@linux-foundation.org>
        <CALvZod6+Y1yvp8evMLTeEwKnQyoXJmzjO7xLN9w=EPcOUH6BHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661404912;
        bh=AnKrb1Ct86zWoZc2cR8mHfo305wchMKv2BEvmUehEfA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QundzHzoSD285RvlDevYssYd0+eBJWvLpiws5T0NJRxeZcpTf/6HAWQ6nRYpD05/L
         Jo7K04tJKiBzbEwarfN/+9T/St1bo6xkgoING+DmJ1b6qFnnXmAS6URsD+huaj8WI/
         pC9DzwN3tmyooTXX3GJR8yBcpQ0GBO+NebpLXbTY=
In-Reply-To: <CALvZod6+Y1yvp8evMLTeEwKnQyoXJmzjO7xLN9w=EPcOUH6BHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, 24 Aug 2022 21:41:42 -0700 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > Did you evaluate the effects of using a per-cpu counter of some form?
> 
> Do you mean per-cpu counter for usage or something else?

percpu_counter, perhaps.  Or some hand-rolled thing if that's more suitable.

> The usage
> needs to be compared against the limits and accumulating per-cpu is
> costly particularly on larger machines,

Well, there are tricks one can play.  For example, only run
__percpu_counter_sum() when `usage' is close to its limit.  

I'd suggest flinging together a prototype which simply uses
percpu_counter_read() all the time.  If the performance testing results
are sufficiently promising, then look into the accuracy issues.

