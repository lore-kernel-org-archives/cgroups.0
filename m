From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 21 Feb 2020 18:12:56 +0100
Message-ID: <20200221171256.GB23476@blackbody.suse.cz>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20191219200718.15696-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Dec 19, 2019 at 03:07:18PM -0500, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Unfortunately, this limitation makes it impossible to protect an
> entire subtree from another without forcing the user to make explicit
> protection allocations all the way to the leaf cgroups - something
> that is highly undesirable in real life scenarios.
I see that the jobs in descedant cgroups don't know (or care) what
protection is above them and hence the implicit distribution is sensible
here.

However, the protection your case requires can already be reached thanks
to the the hierachical capping and overcommit normalization -- you can
set memory.low to "max" at all the non-caring descendants.
IIUC, that is the same as setting zeroes (after your patch) and relying
on the recursive distribution of unused protection -- or is there a
mistake in my reasoning?

So in my view, the recursive distribution doesn't bring anything new,
however, its new semantics of memory.low doesn't allow turning the
protection off in a protected subtree (delegating the decision to
distribute protection within parent bounds is IMO a valid use case).

Regards,
Michal
