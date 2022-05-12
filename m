From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Thu, 12 May 2022 19:27:38 +0200
Message-ID: <20220512172738.GB16096@blackbody.suse.cz>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
 <20220427140928.GD9823@blackbody.suse.cz>
 <20220429010333.5rt2jwpiumnbuapf@dev0025.ash9.facebook.com>
 <20220429092620.GA23621@blackbody.suse.cz>
 <20220506164015.fsdsuv226nhllos5@dev0025.ash9.facebook.com>
 <Ynkum8DeJIAtGi9y@cmpxchg.org>
 <20220509174424.e43e695ffe0f7333c187fba8@linux-foundation.org>
 <20220510174341.GC24172@blackbody.suse.cz>
 <Ynv4AdjeVjptnjrH@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652376459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XEGm/1PGoEXcO1HFP5KFYVz2HoDo+VVY6EzV48qjEY=;
        b=FzNR/9sgSrYP2DPIDbJYhi2A7TQZTkeEClVE8X88trBQ+zDeTp6YXcGexdIzHN9WVt1CXT
        6ppZ2fr+wNOvNGpQiGz6QiiimHTY0fyVoPFyBeCsw0Wxl9Pe77+R+JdNfKLcpjL+emZ331
        gZhmVXUA0C5FWdFhgV4XQ8ieop+pvys=
Content-Disposition: inline
In-Reply-To: <Ynv4AdjeVjptnjrH-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Wed, May 11, 2022 at 01:53:05PM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Can you indeed elaborate on the problem you see with low events?

My mistake. I realized I was testing on a system without
memory_recursiveprot enabled. Therefore I saw no events in children with
memory.low=0.

However, it also means that my previous evaluation of the "simple" fix
(dropping the SWAP_CLUSTER_MAX rounding) was incorrect and it actually
doesn't resolve the problem of two differently active siblings I posted
earlier.

> So your proposed patch looks like the right thing to do to me. And I
> would ack it, but please do explain your concerns around low event
> reporting after it.

I retract it (at least for now), it doesn't really help. It can be seen
(after application) [1] that once (low) protected memory is opened for
reclaim, the sibling proportions change suddenly (neither sibling is
protected during sc->memcg_low_reclaim, however, the formerly protected
suddenly provides good supply of reclaimable pages).

OTOH, without memory_recursiveprot [2], the elow growth of the victim
sibling is absent and situation stabilizes with only partial reclaim
from the (explicitly) protected sibling. 

In both variants (recursive/non-recursive) the parent ends up with same
amount of unreclaimed memory, however, the gradual tranfer of elow with
the recursive protection is undesired. (I'm only thinking how to solve
it simply.)

Michal

[1] https://bugzilla.suse.com/attachment.cgi?id=858869
[2] https://bugzilla.suse.com/attachment.cgi?id=858870

