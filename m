From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 04/10] memcg: Introduce __GFP_NOACCOUNT.
Date: Thu, 1 Mar 2012 09:10:44 +0900
Message-ID: <20120301091044.1a62d42c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-5-git-send-email-ssouhlal@FreeBSD.org>
	<20120229150041.62c1feeb.kamezawa.hiroyu@jp.fujitsu.com>
	<CABCjUKBHjLHKUmW6_r0SOyw42WfV0zNO7Kd7FhhRQTT6jZdyeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKBHjLHKUmW6_r0SOyw42WfV0zNO7Kd7FhhRQTT6jZdyeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, 29 Feb 2012 11:09:50 -0800
Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Feb 28, 2012 at 10:00 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> > On Mon, 27 Feb 2012 14:58:47 -0800
> > Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org> wrote:
> >
> >> This is used to indicate that we don't want an allocation to be ac=
counted
> >> to the current cgroup.
> >>
> >> Signed-off-by: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > I don't like this.
> >
> > Please add
> >
> > ___GFP_ACCOUNT =C2=A0"account this allocation to memcg"
> >
> > Or make this as slab's flag if this work is for slab allocation.
>=20
> We would like to account for all the slab allocations that happen in
> process context.
>=20
> Manually marking every single allocation or kmem_cache with a GFP fla=
g
> really doesn't seem like the right thing to do..
>=20
> Can you explain why you don't like this flag?
>=20

=46or example, tcp buffer limiting has another logic for buffer size co=
ntroling.
_AND_, most of kernel pages are not reclaimable at all.
I think you should start from reclaimable caches as dcache, icache etc.

If you want to use this wider, you can discuss

+ #define GFP_KERNEL	(.....| ___GFP_ACCOUNT)

in future. I'd like to see small start because memory allocation failur=
e
is always terrible and make the system unstable. Even if you notify
"Ah, kernel memory allocation failed because of memory.limit? and
 many unreclaimable memory usage. Please tweak the limitation or kill t=
asks!!"

The user can't do anything because he can't create any new task because=
 of OOM.

The system will be being unstable until an admin, who is not under any =
limit,
tweaks something or reboot the system.

Please do small start until you provide Eco-System to avoid a case that
the admin cannot login and what he can do was only reboot.

Thanks,
-Kame
