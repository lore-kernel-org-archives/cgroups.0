From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Wed, 12 Feb 2020 12:08:26 -0500
Message-ID: <20200212170826.GC180867@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HsBl5rMluvvE/pco2RfgwIL5+jpMuMRec38m/p38OMc=;
        b=O6bqdQqB754/215opJE3M7EUYVTUIhhbCE2lNZaklstLauxL4cB6U5Lkm8nLa6ai+V
         M6T/WjrYmfRSVrpnvIulIoWhLs9eS8Y55Aariv3m4POcoSqfrPc52/AL5HHw49GU3aro
         q9emBN3umt3HPcAAZjNvc7ea18lJ/hn8Q3S4jrizD022B9CE+zN+WAsr6FS6zAPsSER0
         lkBBVZbw1FZR9AD9LiyKVVyyqDxsGlA8Ky4TnhMZQhNdW8OGVXr8cXXeIQ1SLHE1IhDD
         yb2N6V11ijw8SEjuvEiC7qqWBmpm6xRnSyJIfQPhV6KRUx6DOyATDYdS8rZ1mEZvPFQy
         lORA==
Content-Disposition: inline
In-Reply-To: <20200211164753.GQ10636-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 11, 2020 at 05:47:53PM +0100, Michal Hocko wrote:
> Unless I am missing something then I am afraid it doesn't. Say you have a
> default systemd cgroup deployment (aka deeper cgroup hierarchy with
> slices and scopes) and now you want to grant a reclaim protection on a
> leaf cgroup (or even a whole slice that is not really important). All the
> hierarchy up the tree has the protection set to 0 by default, right? You
> simply cannot get that protection. You would need to configure the
> protection up the hierarchy and that is really cumbersome.

Okay, I think I know what you mean. Let's say you have a tree like
this:

                          A
                         / \
                        B1  B2
                       / \   \
                      C1 C2   C3

and there is no actual delegation point - everything belongs to the
same user / trust domain. C1 sets memory.low to 10G, but its parents
set nothing. You're saying we should honor the 10G protection during
global and limit reclaims anywhere in the tree?

Now let's consider there is a delegation point at B1: we set up and
trust B1, but not its children. What effect would the C1 protection
have then? Would we ignore it during global and A reclaim, but honor
it when there is B1 limit reclaim?

Doing an explicit downward propagation from the root to C1 *could* be
tedious, but I can't think of a scenario where it's completely
impossible. Especially because we allow proportional distribution when
the limit is overcommitted and you don't have to be 100% accurate.

And the clarity that comes with being explicit is an asset too,
IMO. Since it has an effect at the reclaim level, it's not a bad thing
to have that effect *visible* in the settings at that level as well:
the protected memory doesn't come out of thin air, it's delegated down
from the top where memory pressure originates.

My patch is different. It allows a configuration that simply isn't
possible today: protecting C1 and C2 from C3, without having to
protect C1 and C2 from each other.

So I don't think requiring an uninterrupted, authorized chain of
protection from the top is necessarily wrong. In fact, I think it has
benefits. But requiring the protection chain to go all the way to the
leaves for it to have any effect, that is a real problem, and it can't
be worked around.
