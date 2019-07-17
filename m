From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 6/9] kselftests: cgroup: add freezer controller
 self-tests
Date: Wed, 17 Jul 2019 00:49:09 +0000
Message-ID: <20190717004904.GA32357@castle.dhcp.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-7-guro@fb.com>
 <CA+G9fYvz6MA0N8GgwY5QNdWBAw+XT9QcmwnABsSpjLnwz_jLzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2ku0EgpNaitFugfFNzpgMALweDBXYpV13ha37sxxzNA=;
 b=QbEAEUBUPn6VLAN/vtr8FYloi3NRkRU78Lid6weyNKNF6L82MGcl+6UiYtwu/HtfzBR0
 EolJ1gPXAo3+Nvzc1PYi4BpeXYkxkWF7nyumlcrCV+32S6pFZKuOlaR6HTrUeIL3zbf9
 jcN/aHGVue8l3K+rGa8291gDfwSyul+ph9w= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ku0EgpNaitFugfFNzpgMALweDBXYpV13ha37sxxzNA=;
 b=JlAW30qUeCKMtzBUftDIY+1IqJLiUTJTnRHfxw27GvjfOrYfylUKjU/tV3sajtOlbzuaAcC496xUmjcS6kDVwowioP0VmO8ya1ZvWZPld6wy0rFrEzSmvkgJHuqsk9ro4tlc7ZAZtlgv1EikMp2fhJFGjcwiAJpENYxYC2hNnqg=
In-Reply-To: <CA+G9fYvz6MA0N8GgwY5QNdWBAw+XT9QcmwnABsSpjLnwz_jLzA@mail.gmail.com>
Content-Language: en-US
Content-ID: <6615751279655F448AC550872ECF4FCD@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Shuah Khan <shuah@kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>

On Tue, Jul 16, 2019 at 08:18:39PM +0530, Naresh Kamboju wrote:
> Hi Roman,
>=20
> Just want to share information here on what we notice on running this tes=
t case,

Hi Naresh!

Thank you for the report!

The interaction between ptrace and freezer is complicated
(as ptrace in general),so there are known cases when spurious
cgroup transitions (frozen <-> non frozen <-> frozen ) can happen.

Does it create any difficulties? If so, I'll send a diff to ignore
the result of this test for now.

Thank you!

>=20
> On Fri, 5 Apr 2019 at 23:17, Roman Gushchin <guroan@gmail.com> wrote:
> >
> > This patch implements 9 tests for the freezer controller for
> > cgroup v2:
> ...
> > 6) ptrace test: the test checks that it's possible to attach to
> > a process in a frozen cgroup, get some information and detach, and
> > the cgroup will remain frozen.
>=20
> selftests cgroup test_freezer failed because of the sys entry path not fo=
und.

Can you, please, elaborate on this?

>  Cgroup /sys/fs/cgroup/unified/cg_test_ptrace isn't frozen
> /sys/fs/cgroup/unified/cg_test_ptrace: isn't_frozen #
> # not ok 6 test_cgfreezer_ptrace
>=20
> This test case fails intermittently.

Thank you!
