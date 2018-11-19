From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 7/7] cgroup: document cgroup v2 freezer interface
Date: Mon, 19 Nov 2018 17:42:48 +0000
Message-ID: <20181119174241.GA7273@tower.DHCP.thefacebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-8-guro@fb.com> <20181117080227.GA22672@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0GH69XRohz9tDKf3ZKzTGh11HkwB0aZ27psb4gvcZD8=;
 b=ZHp0VNAqUARrnkgKqV1Bbgpx+3UPxw4oDDq76mQvL6LHpbHjSOS4xNfvbFw34/p4Yyjt
 JMZjF9RkfE4W0jClhZI72lM5iTmq6mWX5p/mfYUTS6zRyKv4gpt99NJ3dCyRrig53IdC
 cauounKoscAbUYYlX/UFoYJ8QMAXfTkBVKo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GH69XRohz9tDKf3ZKzTGh11HkwB0aZ27psb4gvcZD8=;
 b=Mav3XKjrZa4nDgjupgahMoRFnACn43LCyEt3yDQpynoDTR7zn3wKhyhKTWlzoNVeQLXsUkidFef+3F8uDECayC9YVpiqk1Z3gl3NuElkJcx9T/av0gtf01Old5O/isEwVrCJ3Rb8a8IraWaYUHPo1iZeE05dn2EfG8wKqiD7+mc=
In-Reply-To: <20181117080227.GA22672@rapoport-lnx>
Content-Language: en-US
Content-ID: <1E0C6B5BD81F3242BFB23BFB36F079BD@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>

On Sat, Nov 17, 2018 at 12:02:28AM -0800, Mike Rapoport wrote:
> Hi,
>=20
> On Fri, Nov 16, 2018 at 04:38:30PM -0800, Roman Gushchin wrote:
> > Describe cgroup v2 freezer interface in the cgroup v2 admin guide.
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: linux-doc@vger.kernel.org
> > Cc: kernel-team@fb.com
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 26 +++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >=20
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 184193bcb262..a065c0bed88c 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -862,6 +862,8 @@ All cgroup core files are prefixed with "cgroup."
> >  	  populated
> >  		1 if the cgroup or its descendants contains any live
> >  		processes; otherwise, 0.
> > +	  frozen
> > +		1 if the cgroup is frozen; otherwise, 0.
> >=20
> >    cgroup.max.descendants
> >  	A read-write single value files.  The default is "max".
> > @@ -895,6 +897,30 @@ All cgroup core files are prefixed with "cgroup."
> >  		A dying cgroup can consume system resources not exceeding
> >  		limits, which were active at the moment of cgroup deletion.
> >=20
> > +  cgroup.freeze
> > +	A read-write single value file which exists on non-root cgroups.
> > +	Allowed values are "0" and "1". The default is "0".
> > +
> > +	Writing "1" to the file causes freezing of the cgroup and all
> > +	descendant cgroups. This means that all belonging processes will
> > +	be stopped and will not run until the cgroup will be explicitly
> > +	unfrozen. Freezing of the cgroup may take some time; when the process
>=20
> "when the process is complete" sounds somewhat ambiguous, it's unclear
> whether freezing is complete or the process that's being frozen is
> complete.
>=20
> Maybe "when this action is completed"?
>=20
> > +	is complete, the "frozen" value in the cgroup.events control file
> > +	will be updated and the corresponding notification will be issued.
>=20
> Can you please clarify how exactly cgroup.events would be updated?
>=20
> > +	Cgroup can be frozen either by its own settings, either by settings
>=20
>       ^ A cgroup ... and maybe there are more "a" and "the" that should b=
e
> fixed, it's hard for me to tell.
>=20
> Also, I believe "either ..., or ..." sounds better than "either ...,
> either ..."
>=20
> > +	of any ancestor cgroups. If any of ancestor cgroups is frozen, the
> > +	cgroup will remain frozen.
> > +
> > +	Processes in the frozen cgroup can be killed by a fatal signal.
> > +	They also can enter and leave a frozen cgroup: either by an explicit
> > +	move by a user, either if freezing of the cgroup races with fork().
>=20
> ditto
>=20
> > +	If a cgroup is moved to a frozen cgroup, it stops. If a process is
>=20
>             ^ process?
>=20
> > +	moving out of a frozen cgroup, it becomes running.
>=20
>        ^ moved

Hello, Mike!

Thanks for the review! I agree with all comments above; fixes queued for v4=
.

>=20
> > +	Frozen status of a cgroup doesn't affect any cgroup tree operations:
> > +	it's possible to delete a frozen (and empty) cgroup, as well as
> > +	create new sub-cgroups.
>=20
> Maybe it's also worth adding that freezing a process has no effect on its
> memory consumption, at least directly.

Hm, isn't it the expected behavior?

In any case, I assume that cgroup.freeze knob description is not the best p=
lace
for a such explanations. Maybe it's better to add a standalone paragraph wi=
th
the description of the frozen process state, what's expected to work, what'=
s
not, etc. I'd return to this question a bit later, when we'll agree on the =
user
interface and the implementation.

Thanks!
