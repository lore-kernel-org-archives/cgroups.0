From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add auto-detach test
Date: Thu, 23 May 2019 23:49:10 +0000
Message-ID: <20190523234904.GA18995@tower.DHCP.thefacebook.com>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190523194532.2376233-5-guro@fb.com>
 <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=anCZnXPpuXMoJ38NqQSh+Qtwb41WA2uoelsm1QZ8uEE=;
 b=VHUCEEc6N5HIwlXBknPvEPi3Jsm2MBaeZgi9nfO+FBSYI0OQxt85T0fIfO+FMHoO1VSf
 YLq84Mjy0/FerjN4zsd8XljFSO2t4DXU+1+M09CInEc7n5Li4FNvIsfZ3BjlbaH/VW2e
 PeX8QRDu1raN2uvduHq9HHRIfJMb/K5Q+nk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anCZnXPpuXMoJ38NqQSh+Qtwb41WA2uoelsm1QZ8uEE=;
 b=hp7xUepN5hpeij2BdcGbiIqJDT5nqzyJesPxioEAs+JS0ok2j0/Z/s2/LIVmNimxELhvG5RVaukfUhLrbg1edRpyzVQHCz5JY4Gl+3YNwH5qkejR2gOwFPAjP9o5Pzdxuz/LJ2BImc+HDZIPN1IKqmWA3NyB8RSRrW3oD58JI3c=
In-Reply-To: <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
Content-Language: en-US
Content-ID: <0AC895CF89FF2D42A731CD648CA32C9B@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
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
>

Here it is!

Thanks!

---

From 150fb4db7ab37f0e8b6482386e8830f3d11b64e1 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Thu, 23 May 2019 16:46:58 -0700
Subject: [PATCH bpf-next] selftests/bpf: add test_cgroup_attach to .gitigno=
re

Add test_cgroup_attach binary to .gitignore.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 tools/testing/selftests/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftes=
ts/bpf/.gitignore
index dd5d69529382..86a546e5e4db 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -22,6 +22,7 @@ test_lirc_mode2_user
 get_cgroup_id_user
 test_skb_cgroup_id_user
 test_socket_cookie
+test_cgroup_attach
 test_cgroup_storage
 test_select_reuseport
 test_flow_dissector
--=20
2.20.1

