From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH] cgroup: fix seq_show_option merge with legacy_name
Date: Thu, 24 Sep 2015 19:33:28 +0100
Message-ID: <20150924183328.GA2163@charon>
References: <20150908183043.GA23974@www.outflux.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908183043.GA23974@www.outflux.net>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, stable@vger.kernel.org

On Tue, Sep 08, 2015 at 11:30:43AM -0700, Kees Cook wrote:
> When seq_show_option (068acf2ee776) was merged, it did not correctly
> collide with cgroup's addition of legacy_name (3e1d2eed39d8) changes.=
 This
> fixes the reported name.
>

Since a068acf2ee77 ("fs: create and use seq_show_option for escaping")
has been CC'ed to stable, shouldn't this be tagged to stable too?

(This is upstream commit 61e57c0c3a37 "cgroup: fix seq_show_option
merge with legacy_name".)

Cheers,
--
Lu=EDs

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a8538e443784..2cf0f79f1fc9 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1342,7 +1342,7 @@ static int cgroup_show_options(struct seq_file =
*seq,
>  	if (root !=3D &cgrp_dfl_root)
>  		for_each_subsys(ss, ssid)
>  			if (root->subsys_mask & (1 << ssid))
> -				seq_show_option(seq, ss->name, NULL);
> +				seq_show_option(seq, ss->legacy_name, NULL);
>  	if (root->flags & CGRP_ROOT_NOPREFIX)
>  		seq_puts(seq, ",noprefix");
>  	if (root->flags & CGRP_ROOT_XATTR)
> --=20
> 1.9.1
>=20
>=20
> --=20
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
