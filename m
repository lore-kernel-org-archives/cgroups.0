From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: enable all available cgroup
 v2 controllers
Date: Wed, 22 May 2019 23:16:20 +0000
Message-ID: <20190522231613.GA20167@tower.DHCP.thefacebook.com>
References: <20190522212932.2646247-1-guro@fb.com>
 <20190522212932.2646247-4-guro@fb.com> <20190522221843.GA3032@mini-arch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i1feLUhwGMQVGZL9+X7Ze3YL3PYK8dLOen4Caa/0J0U=;
 b=OWp98crVwHBBgbwapMKdWSEEZNbF4N/kDbJp47sjVwcz1+d+t3fsaMVUSS/tvLnq6aB5
 o39mg6/Kn4w4ftiVmKK8z/qCfCMKm9lj1jYyD6Dj4IrM8OuES/i3ZyIPP1e1Nyu0rY9h
 QH5L1tSL7PAI2w6yvBJhhsQoIQEHjQJXwDs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1feLUhwGMQVGZL9+X7Ze3YL3PYK8dLOen4Caa/0J0U=;
 b=e9u1LePRwc9N4pN6zpw/O7w/dBn3S0ptxA28LNXHvR5QToS1yjttCbNn9OulPHvSa8lSMNRI4JJkbCsocX2jXptH5yDQRrPAappydXiCVI/l2eB1pXt1KSi1My3B2HW1yd1SL5KEAT2YiKPpLfYbcSTEv1eI/bP3rRhPG2+7P9o=
In-Reply-To: <20190522221843.GA3032@mini-arch>
Content-Language: en-US
Content-ID: <FA7BB09FF47CAE4A81E46F24346899CE@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, May 22, 2019 at 03:18:43PM -0700, Stanislav Fomichev wrote:
> On 05/22, Roman Gushchin wrote:
> > Enable all available cgroup v2 controllers when setting up
> > the environment for the bpf kselftests. It's required to properly test
> > the bpf prog auto-detach feature. Also it will generally increase
> > the code coverage.
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  tools/testing/selftests/bpf/cgroup_helpers.c | 58 ++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> >=20
> > diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testi=
ng/selftests/bpf/cgroup_helpers.c
> > index 6692a40a6979..4533839c0ce0 100644
> > --- a/tools/testing/selftests/bpf/cgroup_helpers.c
> > +++ b/tools/testing/selftests/bpf/cgroup_helpers.c
> > @@ -33,6 +33,61 @@
> >  	snprintf(buf, sizeof(buf), "%s%s%s", CGROUP_MOUNT_PATH, \
> >  		 CGROUP_WORK_DIR, path)
> > =20
> > +/**
> > + * enable_all_controllers() - Enable all available cgroup v2 controlle=
rs
> > + *
> > + * Enable all available cgroup v2 controllers in order to increase
> > + * the code coverage.
> > + *
> > + * If successful, 0 is returned.
> > + */
> > +int enable_all_controllers(char *cgroup_path)
> > +{
> > +	char path[PATH_MAX + 1];
> > +	char buf[PATH_MAX];
> > +	char *c, *c2;
> > +	int fd, cfd;
> > +	size_t len;
> > +
> > +	snprintf(path, sizeof(path), "%s/cgroup.controllers", cgroup_path);
> > +	fd =3D open(path, O_RDONLY);
> > +	if (fd < 0) {
> > +		log_err("Opening cgroup.controllers: %s", path);
> > +		return -1;
> > +	}
> > +
> > +	len =3D read(fd, buf, sizeof(buf) - 1);
> > +	if (len < 0) {
> > +		close(fd);
> > +		log_err("Reading cgroup.controllers: %s", path);
> > +		return -1;
> > +	}
> > +
> > +	close(fd);
> > +
> > +	/* No controllers available? We're probably on cgroup v1. */
> > +	if (len =3D=3D 0)
> > +		return 0;
> > +
> > +	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", cgroup_path=
);
> > +	cfd =3D open(path, O_RDWR);
> > +	if (cfd < 0) {
> > +		log_err("Opening cgroup.subtree_control: %s", path);
> > +		return -1;
> > +	}
> > +
>=20
> [..]
> > +	buf[len] =3D 0;
> nit: move this up a bit? Right after:

Ok, np. Thanks!
