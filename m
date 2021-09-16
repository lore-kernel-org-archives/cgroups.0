From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v3 2/3] misc_cgroup: remove error log to avoid log flood
Date: Thu, 16 Sep 2021 19:57:11 +0200
Message-ID: <20210916175711.GA12643@blackbody.suse.cz>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
 <a960cd793f649bd944127fe5e5e3f4d8bb9040a4.1631671936.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631815032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fbJGgwQpdImuKGYvZ0hVx47RK9ar0QLFewfGibiPGXE=;
        b=IUjJu8eXSDOvstCBzNqJfVDXURIGXW++ljRJE7t4Ed/NWRYOrUX0uf0TeY0spExSVB/OIJ
        K5+Iokl4j6nB+4uI34smI8VlI2T28kH8QyaG7RJnoTkoSGejLv/EPnIKYJRMmMZgaHxE+K
        Iyiy/HI5tEorxpOyFkuznNjT9XPUGW0=
Content-Disposition: inline
In-Reply-To: <a960cd793f649bd944127fe5e5e3f4d8bb9040a4.1631671936.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: brookxu <brookxu.cn@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, vipinsh@google.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, Sep 15, 2021 at 10:18:50AM +0800, brookxu <brookxu.cn@gmail.com> wr=
ote:
> In scenarios where containers are frequently created and deleted,
> a large number of error logs maybe generated. This log provides
> less information, we can get more detailed info from misc.events.

IIUC, the log provides equal information (with persistence), no?

> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> index 4b2b492..fe3e8a0 100644
> --- a/kernel/cgroup/misc.c
> +++ b/kernel/cgroup/misc.c
> @@ -157,13 +157,6 @@ int misc_cg_try_charge(enum misc_res_type type, stru=
ct misc_cg *cg,
>  		new_usage =3D atomic_long_add_return(amount, &res->usage);
>  		if (new_usage > READ_ONCE(res->max) ||
>  		    new_usage > READ_ONCE(misc_res_capacity[type])) {
> -			if (!res->failed) {
> -				pr_info("cgroup: charge rejected by the misc controller for %s resou=
rce in ",
> -					misc_res_name[type]);
> -				pr_cont_cgroup_path(i->css.cgroup);
> -				pr_cont("\n");
> -				res->failed =3D true;
> -			}

As I argued previously, reporting this as "in" `i` cgroup instead
of `cg` is not that useful and equivalent to the misc.events:*.max now,
so the drop is appropriate.

The change/patch is OK,
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

The commit message might be fixed (if you agree with remark).
