From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH] memcg: Free spare array to avoid memory leak
Date: Fri, 9 Mar 2012 11:38:37 +0200
Message-ID: <20120309093837.GA16348@shutemov.name>
References: <1331036004-7550-1-git-send-email-handai.szj@taobao.com>
 <20120309124021.810f5267.kamezawa.hiroyu@jp.fujitsu.com>
 <4F598204.9030504@gmail.com>
 <20120309132016.e372a2ef.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120309132016.e372a2ef.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, Mar 09, 2012 at 01:20:16PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 09 Mar 2012 12:07:32 +0800
> Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > On 03/09/2012 11:40 AM, KAMEZAWA Hiroyuki wrote:
> > > On Tue,  6 Mar 2012 20:13:24 +0800
> > > Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
> > >
> > >> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> > >>
> > >> When the last event is unregistered, there is no need to keep th=
e spare
> > >> array anymore. So free it to avoid memory leak.
> > >>
> > >> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> > >>
> > >> ---
> > >>   mm/memcontrol.c |    6 ++++++
> > >>   1 files changed, 6 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > >> index 22d94f5..3c09a84 100644
> > >> --- a/mm/memcontrol.c
> > >> +++ b/mm/memcontrol.c
> > >> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_e=
vent(struct cgroup *cgrp,
> > >>   swap_buffers:
> > >>   	/* Swap primary and spare array */
> > >>   	thresholds->spare =3D thresholds->primary;
> > >> +	/* If all events are unregistered, free the spare array */
> > >> +	if (!new) {
> > >> +		kfree(thresholds->spare);
> > >> +		thresholds->spare =3D NULL;
> > >> +	}
> > >> +
> > > Could you clear thresholds->primary ? I don't like a pointer poin=
ts to freed memory.
> > Do you meaning I should set =E2=80=98thresholds->primary =3D NULL=E2=
=80=98 =EF=BC=9F
> > But the following rcu_assign_pointer will do this :
> >=20
> > +	/* If all events are unregistered, free the spare array */
> > +	if (!new) {
> > +		kfree(thresholds->spare);
> > +		thresholds->spare =3D NULL;
> > +	}
> > +
> >   	rcu_assign_pointer(thresholds->primary, new);<---------*HERE*
> >=20
>=20
> Hm, ok.
>=20
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>=20
>=20
> BTW, can memory cgroup be destroyed while there are registered events=
 ?

Yes, it can. All eventfds will be closed first. See cgroup_rmdir().

And here's possibility of leak. If we have an eventfd with >1 threashol=
ds
attached to it, mem_cgroup_usage_unregister_event() will leave spare
not freed. And then we destroy cgroup...

Reviewed-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

--=20
 Kirill A. Shutemov
