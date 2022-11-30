From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Wed, 30 Nov 2022 13:50:39 +0100
Message-ID: <Y4dRnxrVkdqLRi1v@dhcp22.suse.cz>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
 <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org>
 <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669812640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ZGYbHjMMJD2KtxpoYl71o8+mthDszQIMORViCtN+H4=;
        b=TEYdT2ejsqxumwVeGAtrs/wb5t8Z7WykQ86E9LmitKLafwNZ3z4nIFifyvnAoyM2lSntZk
        4ETEFoMHzkEz3lOxQ/oZ49G7lqHhgEx9C8HKAAVubxMqpZ9B4BG6KeTAM+reO31e5xywk0
        aevyUeC9LoRpjosj/FGvwSFKdixPZHk=
Content-Disposition: inline
In-Reply-To: <Y4ZYsrXLBFDIxuoO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 29-11-22 14:08:34, Johannes Weiner wrote:
[...]
> Short of further restricting the pages that can be moved, I don't see
> how we can get rid of the cgroup locks in rmap after all. :(

:(

> We can try limiting move candidates to present ptes. But maybe it's
> indeed time to deprecate the legacy charge moving altogether, and get
> rid of the entire complication.
> 
> Hugh, Shakeel, Michal, what do you think?

I do agree with Hugh that going part way will likely not solve the
general maintenance burden. I am OK with dropping the functionality but
we should at least add a big fat warning if anybody wants to enable
memory.move_charge_at_immigrate. If there are any workload which
absolutely depend on the feature (which would make them impossible to
migrate to v2 btw) then we want to hear about that and address in some
way.

An incremental deprecation by limiting to present ptes sounds like this
semantic change might get overlooked for an extended time.

-- 
Michal Hocko
SUSE Labs
