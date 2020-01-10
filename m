From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-5.2-fixes] cgroup: Include dying leaders
 with live threads in PROCS iterations
Date: Sat, 11 Jan 2020 00:16:24 +0100
Message-ID: <20200110231624.GA6557@blackbook>
References: <87zhn6923n.fsf@xmission.com>
 <e407a8e7-7780-f08f-320a-a0f2c954d253@gmail.com>
 <20190529003601.GN374014@devbig004.ftw2.facebook.com>
 <e45d974b-5eff-f781-291f-ddf5e9679e4c@gmail.com>
 <20190530183556.GR374014@devbig004.ftw2.facebook.com>
 <20190530183637.GS374014@devbig004.ftw2.facebook.com>
 <20190530183700.GT374014@devbig004.ftw2.facebook.com>
 <20190607170952.GE30727@blackbody.suse.cz>
 <20190611185742.GH3341036@devbig004.ftw2.facebook.com>
 <CAJuCfpGkAsmp5B=fNz38fLE8pYaMCG=uLDSSBFByNOtWD20zVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpGkAsmp5B=fNz38fLE8pYaMCG=uLDSSBFByNOtWD20zVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, security-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, Security Officers <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, james.hsu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Suren.

On Fri, Jan 10, 2020 at 01:47:19PM -0800, Suren Baghdasaryan <surenb@google=
=2Ecom> wrote:
> > On Fri, Jun 07, 2019 at 07:09:53PM +0200, Michal Koutn=FD wrote:
> > > Wouldn't it make more sense to call
> > >       css_set_move_task(tsk, cset, NULL, false);
> > > in cgroup_release instead of cgroup_exit then?
> > >
> > > css_set_move_task triggers the cgroup emptiness notification so if we
> > > list group leaders with running siblings as members of the cgroup (IMO
> > > correct), is it consistent to deliver the (un)populated event
> > > that early?
> > > By moving to cgroup_release we would also make this notification
> > > analogous to SIGCHLD delivery.
> >
> > So, the current behavior is mostly historical and I don't think this
> > is a better behavior.  That said, I'm not sure about the cost benefit
> > ratio of changing the behavior at this point given how long the code
> > has been this way.  Another aspect is that it'd expose zombie tasks
> > and possibly migrations of them to each controller.
>=20
> Sorry for reviving an old discussion
Since you reply to my remark, I have to share that I found myself wrong
later wrt the emptiness notifications. Moving the task in cgroup_exit
doesn't matter if thread group contains other live tasks, the unpopulated
notification will be raised when the last task of thread group calls
group_exit, i.e. it is similar to SIGHLD.

Now to your issue.

> but I got a bug report from a customer about Android=20
What kernel version is that? Can be it considered equal to the current
Linux?

> In my testing I was able to reproduce the failure in
> which case rmdir() fails with EBUSY from cgroup_destroy_locked()
> because cgroup_is_populated() returns true.
That'd mean that not all tasks in the cgroup did exit() (cgroup_exit()),
i.e. they're still running. Can you see them in cgroup.threads/tasks?

> cgroup_is_populated() depends on cgrp->nr_populated_xxx counters which
> IIUC will not be updated until cgroup_update_populated() is called
> from cgroup_exit() and that might get delayed...
Why do you think it's delayed?

> So from user space's point of view the cgroup is empty and can be
> removed but rmdir() fails to do so.
As Tejun says, cgroup with only dead _tasks_ should be removable (and if
I'm not mistaken it is in the current kernel). Unless you do individual
threads migration when a thread would be separated from its (dead)
leader. Does your case include such migrations?

Michal

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl4ZBb8ACgkQia1+riC5
qSglKA/7BJoYDX9r50pa/XZfZI2JNZttiGfKqjgPyFCavP/qX63tAz1OmZU2eEOZ
yIELdeSzucbiv72mTWdwXRiM+NZ8Rzae1ggDS7KXpRdIaUqeb9JYc/ncfB7WWL9a
uMNO0JhT+C8VXDit8DgXI4Fm3eGKzEygmipYP3V3/2+f+QukUOVQzvbW/QVulckw
00GC3ooZ9/FqOdMYnrQ6kDlcGhutk7L7KOvbXA2sEl7sP4uFJ+DdqwyEoJnCkEBT
JR1cAyQeBYTO61QHNxrJPst7HFtFf0oMXAgtwa+nJvWWY8ks31OvDWyPwqPSD6dt
sgF1trGbROo3yemzvYYJDNwZPIThCyPdufsng8kgNtVLRCIO8zzI0FVgQIBGAan4
L32hi3lg0iBYmW3juqaMr5/w+GfPEcGjXiReiW5mN095QxnVfV2VH+YtnGBjjVEO
P4+SmXsvhVRflPAiKpMPy6u8MWJpB7ueL8JjaIRkmmdRsvnbMWMYCqujWJGWXhf/
2D/uvVP5U2qqWObz6BZ0ZvKZV4nVkwRJYmPPA0nV2KaDxj9dFFY/x90iqrxU9efp
jgr2RIqcMVRTcmLbHwz+WQNC5nm5Sv8cK9RhfLAmAr8BbXmsLZi9asgy/gWMl1iI
XbLCsgytbfye9oYrd8lublcLvN9+bc1wbAbNUbz+CfIFLhODAwg=
=2gY/
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
