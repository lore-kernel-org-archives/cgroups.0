From: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 7 Jan 2022 13:36:12 -0800
Message-ID: <20220107213612.GQ4202@paulmck-ThinkPad-P17-Gen-1>
References: <20211210083143.3181535-1-yukuai3@huawei.com>
 <20211210083143.3181535-3-yukuai3@huawei.com>
 <20220107150519.GA26824@blackbody.suse.cz>
 <YdiuN9kv5OvE/Rtf@slm.duckdns.org>
Reply-To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641591373;
        bh=j5HsOLNVGqvbLwGLGzH8tyxrFSkvHryzBUNEAa7ADyk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=In9yUjCOAz4yBAFFwZiTIGL9H8CrbBUhXsbbAFgLnV9HfbQpjtzPVEuavbStBXlug
         AiDMsvd9ZuyXr6Wnabxhz1DwlZZ/rznzTjgegpXW8diQtA8TavGKIRDOO8Ic8BI5pe
         UM4Lx4PRk05o4MDn2Ac2UkKcWX6ajl+yuZnjmQ6C9F3VXd/lVQnyu9GoBIkT5/S15b
         EK1Tl51s0s8CqcaQ4cCk8vELSVvNCSICkYlhW4llbBHKKiJM5V3GZG4pftfdZw9diU
         ov+XUmhk5mo4GtoTnm/8QNVS21+GVLD+EmHmNp11Nsa8K8oNe3Lc0QCJ3U3f+Mut1D
         RzBzUe5F38UeA==
Content-Disposition: inline
In-Reply-To: <YdiuN9kv5OvE/Rtf-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jan 07, 2022 at 11:18:47AM -1000, Tejun Heo wrote:
> Hello,
>=20
> On Fri, Jan 07, 2022 at 04:05:19PM +0100, Michal Koutn=FD wrote:
> > On Fri, Dec 10, 2021 at 04:31:43PM +0800, Yu Kuai <yukuai3-hv44wF8Li93Q=
T0dZR+AlfA@public.gmane.org> wrote:
> > > +	 * queue_lock is held, rcu lock is not needed here.
> > > +	 */
> > > +	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
> > > +		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
> >=20
> > FTR, I acknowledge this can work due to RCU peculiarities, however, I
> > don't understand why is it preferred against more robust explict
> > rcu_read_lock().
> >=20
> > (All in all, this isn't a deal breaker and I'm not confident evaluating
> > the rest of the patch.)
>=20
> Cc'ing Paul for RCU. Paul, this nit is around whether or not to use
> rcu_read_lock() in an irq disabled section. I can see both sides of the
> arguments - it's weird to put in an extra rcu_read_lock() when technically
> unnecessary but it's also nice to have something explicit and structured =
to
> mark parts which require RCU protection. Putting in a comment is okay but
> consistency is difficult to achieve that way.
>=20
> Maybe all these are unnecessary as lockdep would be able to catch them
> anyway, or maybe we'd want something to explicitly mark RCU protected
> sections. I don't know but whichever way, I think we need to establish a
> convention.

The easiest thing to do is to use rcu_dereference_sched() instead of
rcu_dereference().  This will cause lockdep to insist on preemption
(for example, interrupts) being disabled.

Or is this a case where a function containing rcu_dereference() is invoked
with interrupts disabled from some call sites and under rcu_read_lock()
protection from other call sites?  In this case, it is usually best to
include that redundant rcu_read_lock() [1].

							Thanx, Paul

[1]	If you are a glutton for punishment, or if you would otherwise
	have to add a cubic goatskin of rcu_read_lock() calls, you
	could instead write this priceless gem in place of the calls to
	rcu_dereference() in that common function:

	p =3D rcu_dereference_check(ptr, rcu_read_lock_sched_held());

	This would cause lockdep to be happy with either rcu_read_lock()
	or preemption being disabled.

	This is more precise, and would be preferable in some cases,
	for example, if there were lots of hotpath callsites with
	interrupts disabled.  "Do we add 25 pairs of rcu_read_lock()
	and rcu_read_unlock()?	Or do we add just the one ugly
	rcu_dereference_check()?"
