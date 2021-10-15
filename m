From: Odin Hultgren van der Horst <odin-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org>
Subject: Re: [Question] io cgroup subsystem threaded support
Date: Fri, 15 Oct 2021 09:07:45 +0200
Message-ID: <20211015070745.zbzpistqrj6g4zxa@T580.localdomain>
References: <20211001110645.uzw2w5t4rknwqhma@T580.localdomain>
 <20211007133916.mgk6qb65d2r57fc2@T580.localdomain>
 <20211011153416.GB61605@blackbody.suse.cz>
 <20211015065135.5hauecjmri2lytpv@T580.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211015065135.5hauecjmri2lytpv-3Hjs5a4P6Kh82hYKe6nXyg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 14, 2021 at 11:29:38AM +0200, Michal Koutn=FD wrote:
> On Thu, Oct 14, 2021 at 10:38:30AM +0200, Odin Hultgren van der Horst <od=
in-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org> wrote:
> > On Mon, Oct 11, 2021 at 05:34:16PM +0200, Michal Koutn=FD wrote:
> > > What do you want to achieve actually?
> > If a application use a thread per client that is connected, and a client
> > decides to do a large read on a io device it will cause all other clien=
ts
> > to be starved of io. I want to avoid this.
>=20
> IIUC, the application would have to be collaborative anyway (dividing
> threads into cgroups) and given you're concered about reads,
> set_ioprio(2) might be enough for this case.
>=20
> Also, if you've seen starvation (likely depends on IO scheduler), you
> may raise this with linux-block ML.
>=20
> HTH,
> Michal

I also want to be able to limit amount of io for a given thread, just
like you could to with io.max. So a given client cant just use all my io
even though there is no competing thread.

Thanks,
Odin
