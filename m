From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cpuset: Remove stale URLs in the MAINTAINERS entry
Date: Sun, 27 Dec 2020 22:01:35 -0800
Message-ID: <2822d565280536f36ea6ddd521a7716813ef85a2.camel@perches.com>
References: <42668f2c-5ea1-da38-918e-ac4c86e3f03d@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <42668f2c-5ea1-da38-918e-ac4c86e3f03d@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Steve Wahl <steve.wahl@hpe.com>

On Mon, 2020-12-28 at 11:17 +0800, Zefan Li wrote:
> Those URLs are no longer accessable.
>=20
> Reported-by: Steve Wahl <steve.wahl@hpe.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
> =A0MAINTAINERS | 2 --
> =A01 file changed, 2 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ae9b1dd748c4..2fe8eb54639e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4477,8 +4477,6 @@ CONTROL GROUP - CPUSET
> =A0M:	Li Zefan <lizefan@huawei.com>
> =A0L:	cgroups@vger.kernel.org
> =A0S:	Maintained
> -W:	http://www.bullopensource.org/cpuset/
> -W:	http://oss.sgi.com/projects/cpusets/

The general argument to avoid removal of these no longer valid links
is that they may still be available from archive.org.

For instance:

https://web.archive.org/web/20170512010721/http://oss.sgi.com/projects/cpus=
ets/

It may be appropriate to copy the content into a local Documentation
file somewhere to avoid the need to lookup old reference links.


