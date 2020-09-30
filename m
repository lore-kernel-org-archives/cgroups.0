From: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Zero sized write should be no-op
Date: Wed, 30 Sep 2020 19:34:35 +0300
Message-ID: <20200930163435.GB304403@tuxera.com>
References: <20200928131013.3816044-1-jouni.roivas@tuxera.com>
 <20200930160357.GA25838@blackbody.suse.cz>
 <20200930160619.GE4441@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200930160619.GE4441-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

thanks for the feedback.

The 09/30/2020 12:06, Tejun Heo wrote:
> On Wed, Sep 30, 2020 at 06:03:57PM +0200, Michal Koutn=C3=BD wrote:
> > On Mon, Sep 28, 2020 at 04:10:13PM +0300, Jouni Roivas <jouni.roivas-yr=
GDUoBaLx3QT0dZR+AlfA@public.gmane.org> wrote:
> > > Do not report failure on zero sized writes, and handle them as no-op.
> > This is a user visible change (in the case of a single write(2)), OTOH,
> > `man write` says:
> > > If count is zero and fd refers to a file other than a regular file,
> > > the results are not specified.
>=20
> So, I'm not necessarily against the change, mostly in the spirit of "why
> not?".

There's actual user space application failing because of this. Of course
can to fix the app, but think it's better to fix kernel as well. At
least prevents possible similar failures in future.

> > > @@ -3682,6 +3700,9 @@ static ssize_t cgroup_file_write(struct kernfs_=
open_file *of, char *buf,
> > >  	struct cgroup_subsys_state *css;
> > >  	int ret;
> > > =20
> > > +	if (!nbytes)
> > > +		return 0;
> > > +
> > >  	/*
> > >  	 * If namespaces are delegation boundaries, disallow writes to
> > >  	 * files in an non-init namespace root from inside the namespace
> > Shouldn't just this guard be sufficient?=20
>=20
> But yeah, please do it in one spot.

Thought it would be good to add everywhere, but will clean up the patch
and resubmit.
