From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for
 next
Date: Thu, 19 Jan 2012 12:46:56 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1945244502-1327006025=:29542"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=KrrxnTWOeCh4M+eh2zm7KjO6i/g8j/0H9XRn4rLg7HU=;
        b=KJY/4JRSrz6VHrhT2nRPVxSEZ/LD8+IWza9dKg9kM87nDvq/ovKolRoL1VrW8frwK4
         84xb3Kw7C0TKrnIeyFUrvRaFBwP0wn873QrgiOPw9HUC1OaukEtegRrQRnVmezQMlhOU
         MyKo9v2hBDqvNiBDS/Sd95HvRnHv9lkHCL3JQ=
In-Reply-To: <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1945244502-1327006025=:29542
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 19 Jan 2012, Eric Dumazet wrote:
> Le jeudi 19 janvier 2012 =C3=A0 04:28 -0800, Tejun Heo a =C3=A9crit :
> > Hello,
> >=20
> > On Wed, Jan 18, 2012 at 11:33 PM, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> > > Interesting, but should be a patch on its own.
> >=20
> > Yeap, agreed.

Okay, in that case I'd better split into three (idr, revert, remove lock).
I'll send those three in a moment.  I've also slipped an RCU comment from
idr_find into idr_get_next, and put the Acks in all three.

> >=20
> > > Maybe other idr users can benefit from your idea as well, if patch is
> > > labeled  "idr: allow idr_get_next() from rcu_read_lock" or something.=
=2E.
> > >
> > > I suggest introducing idr_get_next_rcu() helper to make the check abo=
ut
> > > rcu cleaner.
> > >
> > > idr_get_next_rcu(...)
> > > {
> > >        WARN_ON_ONCE(!rcu_read_lock_held());
> > >        return idr_get_next(...);
> > > }
> >=20
> > Hmmm... I don't know. Does having a separate set of interface help
> > much?  It's easy to avoid/miss the test by using the other one.  If we
> > really worry about it, maybe indicating which locking is to be used
> > during init is better? We can remember the lockdep map and trigger
> > WARN_ON_ONCE() if neither the lock or RCU read lock is held.
>=20
>=20
> There is a rcu_dereference_raw(ptr) in idr_get_next()
>=20
> This could be changed to rcu_dereference_check(ptr, condition) to get
> lockdep support for free :)
>=20
> [ condition would be the appropriate
> lockdep_is_held(&the_lock_protecting_my_idr) or 'I use the rcu variant'
> and I hold rcu_read_lock ]
>=20
> This would need to add a 'condition' parameter to idr_gen_next(), but we
> have very few users in kernel at this moment.

idr_get_next() was introduced for memcg, and has only one other user
user in the tree (drivers/mtd/mtdcore.c, which uses a mutex to lock it).
With the RCU fix, idr_get_next() becomes very much like idr_find().
I'll leave any fiddling with their interfaces to you guys.

Hugh
--8323584-1945244502-1327006025=:29542--
