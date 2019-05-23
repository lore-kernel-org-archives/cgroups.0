From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Date: Thu, 23 May 2019 17:58:40 +0000
Message-ID: <20190523175833.GA7107@tower.DHCP.thefacebook.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-5-guro@fb.com>
 <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=de5HqLKENBOTVi8j+LLu18Z4hDZQ4TJG+nR63K2QNnU=;
 b=SYh8wN7cBRfARZ96o+K0g8DPHAEfFVd3a6Xoj6if2T1hIVlWPWw49/TXS+uNFN2zI2ni
 VWFenwmaTyEcPqQmepfB+F6TnK16T7k4tgcZkT5TmgTB/qP1a5VMQXxVt/JsP4efNidX
 KJLI5aQkdlPLsmQ+84gqYELfSky9YyyZ5rk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=de5HqLKENBOTVi8j+LLu18Z4hDZQ4TJG+nR63K2QNnU=;
 b=KKCMBLAFDGuJ2QdvTNQQSCezO6w07szUZUlCew8tG/VETktDdGAxaFR9A4VydPJRuUPwqLpvX6ogWWQ7Q53SmkCDoFkGF4hVgqHBjORgprszp2SWvGh7ZJsIJ7CbegAmbzj0wicyCzCr4Y27pyjFMY4QPo67GMVM/ELVbZaXh2s=
In-Reply-To: <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
Content-Language: en-US
Content-ID: <0C59FFFCC474F14F9CA30C7EDE14439D@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, May 22, 2019 at 10:47:24PM -0700, Yonghong Song wrote:
>=20
>=20
> On 5/22/19 4:20 PM, Roman Gushchin wrote:
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
>=20
> I ran this problem without both old and new kernels and
> both get all PASSes. My testing environment is a VM.
> Could you specify how to trigger the above failure?

Most likely you're running cgroup v1, so the memory controller
is not enabled on unified hierarchy. You need to pass
"cgroup_no_v1=3Dall systemd.unified_cgroup_hierarchy=3D1"
as boot time options to run fully on cgroup v2.

But generally speaking, the lifecycle of a dying cgroup is
completely implementation-defined. No guarantees are provided.
So false positives are fine here, and shouldn't be considered as
something bad.

At the end all we want it to detach programs in a reasonable time
after rmdir.

Btw, thank you for the careful review of the patchset. I'll
address your comments, add acks and will send out v3.

Thanks!
