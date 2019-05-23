From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add auto-detach test
Date: Thu, 23 May 2019 23:43:00 +0000
Message-ID: <20190523234254.GA17907@tower.DHCP.thefacebook.com>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190523194532.2376233-5-guro@fb.com>
 <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f056jcvQEMd8XhBuxKG3eAcSjUdhkSgLRalk/El0N+A=;
 b=F4T0GEL1HOFBoMyaZLkCnbWi57oAi5qJzhOOsf+TsXSqgM2aUV5isfi1KP99pIko6SRg
 GnH1oE8bl4iP/CD5aJi525wNhogjZS6ZE8HMgdHXuLtzt7sgKE8eO1eIvew0otokB7P1
 PqM4MiBv5w0dCMgWmX0pfBZ/vk4irk1qbIA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f056jcvQEMd8XhBuxKG3eAcSjUdhkSgLRalk/El0N+A=;
 b=GiO2qQwpaobSq+eJipapKcGrkwbwGvuBZ2A7X+ocKiXnnGTH35BEct8xvFDZCUmYv6mqKC4A1AEz7hQIgv8/6LBrucAHtqtaIuNDvgAMvqWt+Ngiz0vSo2iZUL8wJdfL7623/ulDzwCCOsViIUFlrbmWTFtaG82/bc1RpBxg9+A=
In-Reply-To: <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
Content-Language: en-US
Content-ID: <939DF126ABA27447928EED9237DE1734@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, May 23, 2019 at 04:09:30PM -0700, Yonghong Song wrote:
>=20
>=20
> On 5/23/19 12:45 PM, Roman Gushchin wrote:
> > Add a kselftest to cover bpf auto-detachment functionality.
> > The test creates a cgroup, associates some resources with it,
> > attaches a couple of bpf programs and deletes the cgroup.
> >=20
> > Then it checks that bpf programs are going away in 5 seconds.
> >=20
> > Expected output:
> >    $ ./test_cgroup_attach
> >    #override:PASS
> >    #multi:PASS
> >    #autodetach:PASS
> >    test_cgroup_attach:PASS
> >=20
> > On a kernel without auto-detaching:
> >    $ ./test_cgroup_attach
> >    #override:PASS
> >    #multi:PASS
> >    #autodetach:FAIL
> >    test_cgroup_attach:FAIL
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
>=20
> Looks good to me. It will be good if you can add test_cgroup_attach
> to .gitignore to avoid it shows up in `git status`. With that,

I don't think it deserves a new version, I'll prepare a separate patch
for it.

>=20
> Acked-by: Yonghong Song <yhs@fb.com>

Thank you for the review!
