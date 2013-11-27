From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Wed, 27 Nov 2013 13:38:59 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=AnJKm2kJpNd6SlBropuZrf/T/dDKtmEdpI1FZwhZV2A=;
        b=iuHdqa7dNW8C5tXCoW7Qm0qFtgCh3Cz8XPzE7Vr7vtLNVkpKHWstNnembCF5RiL9D8
         vOfIwW304scgMAjbw1Tv3qSiCetR4Yfppbiu9+qx16q8wfKlMRVZw8z7gtIiKYQQ1e5E
         U8Rip0BGyBe29BOcBecOcvj6yzri/voRVZ+AmAza50xF6qvcyztIMBmOQeVvxvrt6y9H
         VrMl6HSVnUY3X8wvqIwNchXHe3Us6vhAsw6eWMGLdi0qKT5bKH71VCI/8+2NWmrippyy
         u/a8sn/XfEOBEbvdHFBMUQLCtZkt58niGKhr3gF/cJk1oZVxYSIdtku40rsnYyZMonWR
         RJUg==
In-Reply-To: <20131127163916.GB3556-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> > Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
> > bypass") which just bypasses all of these allocations and charges the root 
> > memcg.  So if allocations want to bypass memcg isolation they just have to 
> > be __GFP_NOFAIL?
> 
> I don't think we have another option.
> 

We don't give __GFP_NOFAIL allocations access to memory reserves in the 
page allocator and we do call the oom killer for them so that a process is 
killed so that memory is freed.  Why do we have a different policy for 
memcg?
