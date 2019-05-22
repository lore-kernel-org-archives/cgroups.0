From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: add auto-detach test
Date: Wed, 22 May 2019 23:19:59 +0000
Message-ID: <20190522231954.GB20167@tower.DHCP.thefacebook.com>
References: <20190522212932.2646247-1-guro@fb.com>
 <20190522212932.2646247-5-guro@fb.com> <20190522222438.GB3032@mini-arch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=neuB7kOtjPjVNsQiYpjxhh4qw6MP1AxSqcWVcBpfwiI=;
 b=mtXW+JcNh2NX0GnCTMJofk/Y3w91D9GsJdd8aQZVl4NO19SrVFSl5myiNTbBWc/n4qq4
 40n7g6AEakParC2VkpG6lkDc3VXXf/tA4PMRlmC582hA73RCcy7SyGVP3bxCTt5Xk93p
 vseqUC5O7NmRNGEpXpc2zoOGNonuMbSE300= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neuB7kOtjPjVNsQiYpjxhh4qw6MP1AxSqcWVcBpfwiI=;
 b=Q8qBK66gzprMTHerkNx2TZAop3X7fHpJY+1CCOh22T+ZYadlW/WmN/IS9xiWtw1JvLGFyTmBfzGmcBqkTlAFRKsyPiyFTAsn2i1gHCQQRzwc5H6gZmWHeOAl0Qu1OwGxIDF/ktU0A+aWcycYbKIBMZfpOT4A99sXTnVHop0eAYQ=
In-Reply-To: <20190522222438.GB3032@mini-arch>
Content-Language: en-US
Content-ID: <EE6BDDC0F0D64B4B934848EF010D42BF@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, May 22, 2019 at 03:24:38PM -0700, Stanislav Fomichev wrote:
> On 05/22, Roman Gushchin wrote:
> > Add a kselftest to cover bpf auto-detachment functionality.
> > The test creates a cgroup, associates some resources with it,
> > attaches a couple of bpf programs and deletes the cgroup.
> >=20
> > Then it checks that bpf programs are going away in 5 seconds.
> >=20
> > Expected output:
> >   $ ./test_cgroup_attach
> >   #override:PASS
> >   #multi:PASS
> >   #autodetach:PASS
> >   test_cgroup_attach:PASS
> >=20
> > On a kernel without auto-detaching:
> >   $ ./test_cgroup_attach
> >   #override:PASS
> >   #multi:PASS
> >   #autodetach:FAIL
> >   test_cgroup_attach:FAIL
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  .../selftests/bpf/test_cgroup_attach.c        | 108 +++++++++++++++++-
> >  1 file changed, 107 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/bpf/test_cgroup_attach.c b/tools/t=
esting/selftests/bpf/test_cgroup_attach.c
> > index 93d4fe295e7d..36441fd0f392 100644
> > --- a/tools/testing/selftests/bpf/test_cgroup_attach.c
> > +++ b/tools/testing/selftests/bpf/test_cgroup_attach.c
> > @@ -456,9 +456,115 @@ static int test_multiprog(void)
> >  	return rc;
> >  }
> > =20
> > +static int test_autodetach(void)
> > +{
> > +	__u32 prog_cnt =3D 4, attach_flags;
> > +	int allow_prog[2] =3D {0};
> > +	__u32 prog_ids[2] =3D {0};
> > +	int cg =3D 0, i, rc =3D -1;
> > +	void *ptr =3D NULL;
> > +	int attempts;
> > +
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(allow_prog); i++) {
> > +		allow_prog[i] =3D prog_load_cnt(1, 1 << i);
> > +		if (!allow_prog[i])
> > +			goto err;
> > +	}
> > +
> > +	if (setup_cgroup_environment())
> > +		goto err;
> > +
> > +	/* create a cgroup, attach two programs and remember their ids */
> > +	cg =3D create_and_get_cgroup("/cg_autodetach");
> > +	if (cg < 0)
> > +		goto err;
> > +
> > +	if (join_cgroup("/cg_autodetach"))
> > +		goto err;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(allow_prog); i++) {
> > +		if (bpf_prog_attach(allow_prog[i], cg, BPF_CGROUP_INET_EGRESS,
> > +				    BPF_F_ALLOW_MULTI)) {
> > +			log_err("Attaching prog[%d] to cg:egress", i);
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	/* make sure that programs are attached and run some traffic */
> > +	assert(bpf_prog_query(cg, BPF_CGROUP_INET_EGRESS, 0, &attach_flags,
> > +			      prog_ids, &prog_cnt) =3D=3D 0);
> > +	assert(system(PING_CMD) =3D=3D 0);
> > +
> > +	/* allocate some memory (4Mb) to pin the original cgroup */
> > +	ptr =3D malloc(4 * (1 << 20));
> > +	if (!ptr)
> > +		goto err;
> > +
> > +	/* close programs and cgroup fd */
> > +	for (i =3D 0; i < ARRAY_SIZE(allow_prog); i++) {
> > +		close(allow_prog[i]);
> > +		allow_prog[i] =3D 0;
> > +	}
> > +
> > +	close(cg);
> > +	cg =3D 0;
> > +
> > +	/* leave the cgroup and remove it. don't detach programs */
> > +	cleanup_cgroup_environment();
> > +
>=20
> [..]
> > +	/* programs must stay pinned by the allocated memory */
> > +	for (i =3D 0; i < ARRAY_SIZE(prog_ids); i++) {
> > +		int fd =3D bpf_prog_get_fd_by_id(prog_ids[i]);
> > +
> > +		if (fd < 0)
> > +			goto err;
> > +		close(fd);
> > +	}
> This looks a bit flaky. It's essentially the same check you later
> do in a for loop. I guess there is a chance that async auto-detach
> might happen right after cleanup_cgroup_environment and before this for l=
oop?

Ah, this section remained from an earlier version which had another step.
I'll remove it completely, it's totally useless now.

Thanks!
