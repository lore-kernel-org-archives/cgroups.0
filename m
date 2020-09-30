From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Zero sized write should be no-op
Date: Wed, 30 Sep 2020 12:06:19 -0400
Message-ID: <20200930160619.GE4441@mtj.duckdns.org>
References: <20200928131013.3816044-1-jouni.roivas@tuxera.com>
 <20200930160357.GA25838@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g41JLhfIKA5K1F27QDDdvv1oI3KqFYKZHQkgtQyVAXo=;
        b=e1WuNmpdxD/QTKyw5jxyEPOYd107hD90v0l2i9jSavalJ6nSmBdIbYYOojNZ+OZlVJ
         W/Fa7jy8cHZbwkS6qwSZi8JEy6XFTbp2qe212vp1n9NQbIJ/NfuVusUrw+BcNmgqOHuU
         Ftc8Ek7DLuTEqbQir4OLNOajOhc2Cy6lKc2R1hg4Ru0lg1LS9NL73H0JQEJgX4mCX+ns
         hbVlNiCBdGA7VJ9T5fTT2Xd16ffiLbrCB8s4CaaMHWuNVwtGGuMQhv0b5WGqiwMZgsW+
         Jmw9OBN9QT42t4cwk9sU967SOqT6Sff6Wr4nmFm8MazL4rijQvZ8LKJ//sepOeCp4r0R
         lHCg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200930160357.GA25838-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Sep 30, 2020 at 06:03:57PM +0200, Michal Koutn=FD wrote:
> On Mon, Sep 28, 2020 at 04:10:13PM +0300, Jouni Roivas <jouni.roivas-yrGD=
UoBaLx3QT0dZR+AlfA@public.gmane.org> wrote:
> > Do not report failure on zero sized writes, and handle them as no-op.
> This is a user visible change (in the case of a single write(2)), OTOH,
> `man write` says:
> > If count is zero and fd refers to a file other than a regular file,
> > the results are not specified.

So, I'm not necessarily against the change, mostly in the spirit of "why
not?".

> > @@ -3682,6 +3700,9 @@ static ssize_t cgroup_file_write(struct kernfs_op=
en_file *of, char *buf,
> >  	struct cgroup_subsys_state *css;
> >  	int ret;
> > =20
> > +	if (!nbytes)
> > +		return 0;
> > +
> >  	/*
> >  	 * If namespaces are delegation boundaries, disallow writes to
> >  	 * files in an non-init namespace root from inside the namespace
> Shouldn't just this guard be sufficient?=20

But yeah, please do it in one spot.

Thanks.

--=20
tejun
