From: Roman Gushchin <guro@fb.com>
Subject: Re: Cgroup v2 thread mode oddity: "domain invalid" cgroup with
 threaded controller enabled
Date: Thu, 4 Oct 2018 19:49:22 +0000
Message-ID: <20181004194915.GA12862@castle.DHCP.thefacebook.com>
References: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=w1FAm/64X/oIZPYp+iDdFLbKzbg3dd1/1gN3e557Z18=;
 b=PNSnQdEzrhbWoIlGkVt+ARqVebC252Noezk9WEhVduLPKfcn1LBTzZ/mFoC+6UEdLI8H
 2sqC5CfOkhbuHlSVpmzszACEL2kMGPVHx+M7cV4CFwGcC40OOAuiYbqRp7RYilfMZH+4
 Zz+xqVIpowvFJ+oHzmarLXEiwISgiOyeZ6o= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1FAm/64X/oIZPYp+iDdFLbKzbg3dd1/1gN3e557Z18=;
 b=gaF6LXvrwy6qYtwW14HW1dUbk9kcnem9ggR4X5yRkNDznV8AtQZq4+A3xsTqWkzEBrDm4TV0TCtXUnoDlWsf1h39DlZ6bhl8R7zS1MYi+sESIY8BMk4blfsU3Do3exWep9ns8eHhwOS8gncV1NUyOYycAIB3Qf4YTr+hZB2Ckm0=
In-Reply-To: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Content-Language: en-US
Content-ID: <81F87F41AC7086478B93F04956517F7C@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Oct 04, 2018 at 09:40:57PM +0200, Michael Kerrisk (man-pages) wrote=
:
> Hello Tejun,
>=20
> Suppose we have the following scenario:
>=20
> x [d]    (pids)
>     y [dt]    (pids)
>         p [t]
>         q [t]
>         r [t]
>     z [d]
>=20
> Here, x/y is a "domain threaded root" with a threaded controller
> (the 'pids' controller) enabled. (In this scenario, there are no
> member processes in any of the cgroups.)
>=20
> Suppose we now convert x/z to "threaded" type:
>=20
>      # echo threaded > x/z/cgroup.type
>=20
> Now we end up in the following state:
>=20
> x [dt]    (pids)
>     y [inv]    (pids)
>         p [t]
>         q [t]
>         r [t]
>     z [t]
>=20
> This seems odd. x/y is now of "domain invalid" type with a controller
> enabled! This feels like a violation of the rules, since we can't
> in other circumstances do anything with a "domain invalid" cgroup
> except convert it to "threaded". In particular, we can't create
> child cgroups under a "domain invalid" cgroup, or add member processes
> to the cgroup, or *enable controllers in the cgroup*. In fact, when
> doing the=20
>=20
>     # echo threaded > x/z/cgroup.type
>=20
> I had expected a write(2) error because the state of x/y should
> (I thought) not be permitted.
>=20
> Your thoughts?

Just a note: there are now some cgroup core kernel selftests in
tools/testing/selftests/cgroup/test_core.c . It's fairly easy to add new
tests to cover tricky cases like this one. It always nice to have more test=
s,
and also easier to show and reproduce a problem.

Thanks!
