From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 09:48:55 -1000
Message-ID: <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
References: <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org>
 <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683143337; x=1685735337;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X0rUD0Br2hVe3zymEpoVc3T4TI1iG6AHKLcBxAchx6c=;
        b=WRBBKM6Ry5r7jdgtwiYn+VkQZ8oJVQRWR7eY6Q4gywAy/AIvKMLTc5lvr+I7cWBcM8
         TVhHYYvOx67ydwBdoukq9sxuHpDbTIx22fG3/FumxSshOm9pmxX92bnYtvASSZ4zbmzc
         16xIn+Y67YCqR06ozsQt3kblulDkmNtdmkspoxukxm7NEnp7dppq9zXv9usUpK/QejVj
         uG3paayH7MDDf0m/MWp/ZvWKY2r+v95ayLq3zeaaad/ime6aEDAhxIb3bCUzDcMlE+HN
         t35RGIt3UP+SFV37LJD1LcRWQFcEBQWiLoyXLJmQezSeP5APJKrU5xq4XYO73ImZOIXL
         Vu0w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello,

On Wed, May 03, 2023 at 12:41:08PM -0700, Suren Baghdasaryan wrote:
> On Wed, May 3, 2023 at 12:09=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROf=
E0A@public.gmane.org> wrote:
> >
> > On Wed, May 03, 2023 at 08:58:51AM -1000, Tejun Heo wrote:
> > > On Wed, May 03, 2023 at 02:56:44PM -0400, Kent Overstreet wrote:
> > > > On Wed, May 03, 2023 at 08:40:07AM -1000, Tejun Heo wrote:
> > > > > > Yeah, easy / default visibility argument does make sense to me.
> > > > >
> > > > > So, a bit of addition here. If this is the thrust, the debugfs pa=
rt seems
> > > > > rather redundant, right? That's trivially obtainable with tracing=
 / bpf and
> > > > > in a more flexible and performant manner. Also, are we happy with=
 recording
> > > > > just single depth for persistent tracking?
>=20
> IIUC, by single depth you mean no call stack capturing?

Yes.

> If so, that's the idea behind the context capture feature so that we
> can enable it on specific allocations only after we determine there is
> something interesting there. So, with low-cost persistent tracking we
> can determine the suspects and then pay some more to investigate those
> suspects in more detail.

Yeah, I was wondering whether it'd be useful to have that configurable so
that it'd be possible for a user to say "I'm okay with the cost, please
track more context per allocation". Given that tracking the immediate caller
is already a huge improvement and narrowing it down from there using
existing tools shouldn't be that difficult, I don't think this is a blocker
in any way. It just bothers me a bit that the code is structured so that
source line is the main abstraction.

> > > > Not sure what you're envisioning?
> > > >
> > > > I'd consider the debugfs interface pretty integral; it's much more
> > > > discoverable for users, and it's hardly any code out of the whole
> > > > patchset.
> > >
> > > You can do the same thing with a bpftrace one liner tho. That's rather
> > > difficult to beat.
>=20
> debugfs seemed like a natural choice for such information. If another
> interface is more appropriate I'm happy to explore that.
>=20
> >
> > Ah, shit, I'm an idiot. Sorry. I thought allocations was under /proc and
> > allocations.ctx under debugfs. I meant allocations.ctx is redundant.
>=20
> Do you mean that we could display allocation context in
> debugfs/allocations file (for the allocations which we explicitly
> enabled context capturing)?

Sorry about the fumbled communication. Here's what I mean:

* Improving memory allocation visibility makes sense to me. To me, a more
  natural place for that feels like /proc/allocations next to other memory
  info files rather than under debugfs.

* The default visibility provided by "allocations" provides something which
  is more difficult or at least cumbersome to obtain using existing tracing
  tools. However, what's provided by "allocations.ctx" can be trivially
  obtained using kprobe and BPF and seems redundant.

Thanks.

--=20
tejun
