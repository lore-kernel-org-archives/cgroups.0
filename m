From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 6/9] kselftests: cgroup: add freezer controller
 self-tests
Date: Thu, 18 Jul 2019 18:19:10 +0000
Message-ID: <20190718181904.GD6139@castle.dhcp.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-7-guro@fb.com>
 <CA+G9fYvz6MA0N8GgwY5QNdWBAw+XT9QcmwnABsSpjLnwz_jLzA@mail.gmail.com>
 <20190717004904.GA32357@castle.dhcp.thefacebook.com>
 <CA+G9fYt+UmakwaZAM4gR-B+V8kZUJVNh8gFBcXa4zU2j0Cz0ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=khrjtnpG6kKmS72BYUdVyVePYfUYDGHmwtuP+Bs8IBc=;
 b=fxUxvHzLdeROapSBHpgMgZNL+xAIrcS2uq/RJXN+s6QzjM9Z70Vzg9DXbk6i+uOFwqbe
 G0RxqQK137+w7YZtAPxxIvcfUcCOhbggD5hUuyUFFMMPeBt1iacvOKsfYyg0I/U2UuX8
 zSW+CtN5XhiNAdGH9pUUrH6fvalXQWQotJ8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khrjtnpG6kKmS72BYUdVyVePYfUYDGHmwtuP+Bs8IBc=;
 b=cfRFJZkfRCiXyMmVC0sKdplm8EYjowAel6I7DaQFLlXE7kalDdZxyULBRbOkI/cqqOVtUOSvdb2KVh7aVAUUGEQKleXAHWw618S4EbgejMqCsT8rCKV93sRJYy8jDYg4OS9oBb8z8BPPLpwcTXeMyEKc4XvQ5LdCY6CjvY9WPgI=
In-Reply-To: <CA+G9fYt+UmakwaZAM4gR-B+V8kZUJVNh8gFBcXa4zU2j0Cz0ZQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <67975A3D2650094AB9D000C513E0331B@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Shuah Khan <shuah@kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>

On Wed, Jul 17, 2019 at 02:26:49PM +0530, Naresh Kamboju wrote:
> Hi Roman,
>=20
> > The interaction between ptrace and freezer is complicated
> > (as ptrace in general),so there are known cases when spurious
> > cgroup transitions (frozen <-> non frozen <-> frozen ) can happen.
>=20
> When test ran for 8 times it got failed 5 times.
> I have noticed intermittent failure on x86_64, arm64 hikey device and
> qemu_arm64.

Oh, it wasn't nearly as bad when I ran it. I'll take a look.

>=20
> >
> > Does it create any difficulties? If so, I'll send a diff to ignore
> > the result of this test for now.
>=20
> No difficulties. I will mark this test case as known failure.

Sure.

Thanks!
