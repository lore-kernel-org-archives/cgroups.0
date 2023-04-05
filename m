From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] memcg-v1: Enable setting memory min, low, high
Date: Wed, 5 Apr 2023 16:21:31 +0200
Message-ID: <2023040500-drinking-obvious-bd85@gregkh>
References: <20230405110107.127156-1-shaun.tancheff@gmail.com>
 <2023040529-commodore-humongous-47c3@gregkh>
 <CAJ48U8X28dhTWouqeT83Uqys__qf2+z-6NcdC1SbOr_xOzjgWg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680704494;
        bh=eyBjOtC7CJFOS5X6Sp9ly9THlOS5XlccxmCOFpUhOl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bkToI3kjLCFkg/Q9XiT8E06SrfvrJtgXoZM39QA51VeWtLgANnUBE7hJ/ogxNxeOI
         ydJTjh3bdKT69RKz8iF1i+7JV4C9BaVRxmH+dqVKXlurRTsJCPinJ1tXHUEDS8Ui6G
         Qymz+m9pc6XZp6tnGjnOumjKfK6rAeR//gpPltw8=
Content-Disposition: inline
In-Reply-To: <CAJ48U8X28dhTWouqeT83Uqys__qf2+z-6NcdC1SbOr_xOzjgWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shaun Tancheff <shaun.tancheff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 05, 2023 at 08:54:07PM +0700, Shaun Tancheff wrote:
> On Wed, Apr 5, 2023 at 6:23=E2=80=AFPM Greg KH <gregkh-hQyY1W1yCW8ekmWlsb=
khG0B+6BGkLq7r@public.gmane.org> wrote:
>=20
> > On Wed, Apr 05, 2023 at 06:01:07PM +0700, Shaun Tancheff wrote:
> > > From: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>
> > >
> > > For users that are unable to update to memcg-v2 this
> > > provides a method where memcg-v1 can more effectively
> > > apply enough memory pressure to effectively throttle
> > > filesystem I/O or otherwise minimize being memcg oom
> > > killed at the expense of reduced performance.
> > >
> > > This patch extends the memcg-v1 legacy sysfs entries
> > > with:
> > >     limit_in_bytes.min, limit_in_bytes.low and
> > >     limit_in_bytes.high
> > > Since old software will need to be updated to take
> > > advantage of the new files a secondary method
> > > of setting min, low and high based on a percentage
> > > of the limit is also provided. The percentages
> > > are determined by module parameters.
> > >
> > > The available module parameters can be set at
> > > kernel boot time, for example:
> > >    memcontrol.memcg_min=3D10
> > >    memcontrol.memcg_low=3D30
> > >    memcontrol.memcg_high=3D80
> > >
> > > Would set min to 10%, low to 30% and high to 80% of
> > > the value written to:
> > >   /sys/fs/cgroup/memory/<grp>/memory.limit_in_bytes
> > >
> > > Signed-off-by: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gman=
e.org>
> > > ---
> > > v0: Initial hard coded limits by percent.
> > > v1: Added sysfs access and module parameters for percent values to en=
able
> > > v2: Fix 32-bit, remove need for missing __udivdi3
> > >  mm/memcontrol.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++=
+-
> > >  1 file changed, 82 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 2eee092f8f11..3cf8386f4f45 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -73,6 +73,18 @@
> > >
> > >  #include <trace/events/vmscan.h>
> > >
> > > +static unsigned int memcg_v1_min_default_percent;
> > > +module_param_named(memcg_min, memcg_v1_min_default_percent, uint, 06=
00);
> > > +MODULE_PARM_DESC(memcg_min, "memcg v1 min default percent");
> > > +
> > > +static unsigned int memcg_v1_low_default_percent;
> > > +module_param_named(memcg_low, memcg_v1_low_default_percent, uint, 06=
00);
> > > +MODULE_PARM_DESC(memcg_low, "memcg v1 low default percent");
> > > +
> > > +static unsigned int memcg_v1_high_default_percent;
> > > +module_param_named(memcg_high, memcg_v1_high_default_percent, uint,
> > 0600);
> > > +MODULE_PARM_DESC(memcg_high, "memcg v1 high default percent");
> >
> > This is not the 1990's, why are you using module parameters for this?
> >
> And this isn't a module, so why use module options, how are you supposed
> > to set them?
> >
> Ah .. guess I'm a bit out of date.
> The can be set either on the kernel command line or through sysfs,
> nominally
>   /sys/module/memcontrol/parameters/memcg_high
>   /sys/module/memcontrol/parameters/memcg_low
>   /sys/module/memcontrol/parameters/memcg_min

But again, memcontrol is not a module, right?

> I will look at making these sysctl values instead.

Yeah, just stick with that please.

thanks,

greg k-h
