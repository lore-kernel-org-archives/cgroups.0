From: "Jarkko Sakkinen" <jarkko@kernel.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 18:55:32 +0000
Message-ID: <CU4OCLEHU1S5.359W394902648@seitikki>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689620137;
        bh=dAk9sfbRYrdRyd3dNaLS8GFgLcv5I6arjL3f8km5V5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XuCqiqls/Fm9xg6gYy+ypyUZCJ/ubP1HJ+L1r0B+2EnftbpsJJWVarWcsGMPFm6md
         zVfOA1I69nFIzJJ36tlFfR+EI+8Gu0d7H2A7PW0waVt+zHPc+dMH9JFvQFtC8lEs0t
         znlKD55FBALVISOxK7TEwn7LMzd6y1nB5fkLAk5PyfDUQN2935bl2xB4OlT16Iz2eA
         sh+qKf5tTChVS7rPafUEd/X3KUj67uFsUBgKGYB3UtwggYwFBzClzKGnyHYhB5rIR4
         1Z+q2SUmQ+JWiLtH8EUeXFHBXHEZu17uUqnpIxIZk1StD9FTh49FIxbYWFaW7/62fz
         RH/gGkI6km7qw==
In-Reply-To: <20230717184719.85523-1-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang@linux.intel.com>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: vipinsh@google.com, kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com

On Mon Jul 17, 2023 at 6:47 PM UTC, Haitao Huang wrote:
> The variable 'new_usage' in misc_cg_try_charge() may overflow if it
> becomes above INT_MAX. This was observed when I implement the new SGX
> EPC cgroup[1] as a misc cgroup and test on a platform with large SGX EPC
> sizes.
>
> Change type of new_usage to long from int and check overflow.
>
> Fixes: a72232eabdfcf ("cgroup: Add misc cgroup controller")
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>
> [1] https://lore.kernel.org/linux-sgx/20230712230202.47929-1-haitao.huang=
@linux.intel.com/
> ---
>  kernel/cgroup/misc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> index fe3e8a0eb7ed..ff9f900981a3 100644
> --- a/kernel/cgroup/misc.c
> +++ b/kernel/cgroup/misc.c
> @@ -143,7 +143,7 @@ int misc_cg_try_charge(enum misc_res_type type, struc=
t misc_cg *cg,
>  	struct misc_cg *i, *j;
>  	int ret;
>  	struct misc_res *res;
> -	int new_usage;
> +	long new_usage;
> =20
>  	if (!(valid_type(type) && cg && READ_ONCE(misc_res_capacity[type])))
>  		return -EINVAL;
> @@ -153,10 +153,10 @@ int misc_cg_try_charge(enum misc_res_type type, str=
uct misc_cg *cg,
> =20
>  	for (i =3D cg; i; i =3D parent_misc(i)) {
>  		res =3D &i->res[type];
> -

This is extra noise in the patch, please remove the change.

>  		new_usage =3D atomic_long_add_return(amount, &res->usage);
>  		if (new_usage > READ_ONCE(res->max) ||
> -		    new_usage > READ_ONCE(misc_res_capacity[type])) {
> +		    new_usage > READ_ONCE(misc_res_capacity[type]) ||
> +		    new_usage < 0) {
>  			ret =3D -EBUSY;
>  			goto err_charge;
>  		}
> --=20
> 2.25.1

BR, Jarkko
