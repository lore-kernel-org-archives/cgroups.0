From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Tue, 7 Feb 2023 11:54:55 -0500
Message-ID: <Y+KCX6XHj/lv9ul3@cmpxchg.org>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
 <CAJD7tkaCpD0LpzdA+NsZj2WK=iQCLn7RS9qc7K53Qonxhp4TgA@mail.gmail.com>
 <20230206161843.GD21332@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gzBHkLfEnVFDEK+KjgVtsPAXlm9EVCQtMhAcZQTuuh0=;
        b=3R5dDZ6GGGovkkLkQKUaYxu0foL+1lSJ8IYIIwmffq4aZeogM3A10O2HibgSIDGKm6
         P7pHWBdcrdY/tHJxBL8olfaSswF+l0AOUBQwRFILopVOkqOWeq+fkuGRn/KV2miGfB3R
         u2vfrnTiS6VZZdXL1OihlaQjXHY5+EQIfDuv8ApYEIwNiQ+tgj6bt1TEcvup3q5bEnCV
         6X8WgXeM41DC7cVzX/pLIbQCt5v/NoP7/Xe8rOEgPF+0w6pktkLf4mXIh6XVxykeW53+
         OoHO/9ALa/Yjs0ssGNlGiW1Gqwin4AsAZ9YzG1koYj2hrBCPfTY81/kOEme7WiTmWusk
         n0gg==
Content-Disposition: inline
In-Reply-To: <20230206161843.GD21332-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Feb 06, 2023 at 05:18:43PM +0100, Michal Koutn=FD wrote:
> On Thu, Feb 02, 2023 at 10:30:40AM -0800, Yosry Ahmed <yosryahmed-hpIqsD4=
AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > b) Only count cgroup swap events when they are actually due to a
> > >    cgroup's own limit. Exclude failures that are due to physical swap
> > >    shortage or other system-level conditions (like !THP_SWAP). Also
> > >    count them at the level where the limit is configured, which may be
> > >    above the local cgroup that holds the page-to-be-swapped.
> > >
> > >    This is in line with how memory.swap.high, memory.high and
> > >    memory.max events are counted.
> > >
> > >    However, it's a change in documented behavior.
> >=20
> > This option makes sense to me, but I can't speak to the change of
> > documented behavior. However, looking at the code, it seems like if we =
do this
> > the "max" & "fail" counters become effectively the same. "fail" would
> > not provide much value then.
> >=20
> > I wonder if it makes sense to have both, and clarify that "fail" -
> > "max" would be non-limit based failures (e.g. ran out of swap space),
> > or would this cause confusion as to whether those non-limit failures
> > were transient (THP fallback) or eventual?
>=20
> I somewhat second this.
>=20
> Perhaps, could the patch (and arguments) be split in two:
> 1) count .max events on respective limit's level (other limits consistenc=
y),

Okay, I'll split this one out. It's good to have regardless of what we
do with the fail counter.

Thanks
