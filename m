From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC v3 14/22] bpf/cgroup: Make cgroup_bpf_update() return an
 error code
Date: Wed, 14 Sep 2016 14:16:10 -0700
Message-ID: <20160914211608.GB57174@ast-mbp.thefacebook.com>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-15-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=BmU0Yqhg5VonzkgwA5yWgade440AA8JDJ/YxLQ6EwLs=;
        b=c8MVcKzJzcT37ccQjMeBinxYkK5OH8yjtQfd5KPGOcI3j9ag1ik3vXklbYwOaIctp9
         v8rjNPU+mqb7jcPNmvTIAFnt678n+r/aN9Lv3tvotB6uNzzWQUKlBzCxa80rqKFxl+Tq
         KKhwyBzmjsCxHM3OzMiZ34OsK9RrTQd07iH05vZpc2iM1+RxIOQjpIVjn/JereGjkxtt
         gtPFKkhHa0YkOgd1+58yp6pbB5Vrn2qCF3v6mtRgEJhl6DAZvOWA6rKxRicLo7FsxYMW
         yGACPQz8l3bPUUcFfDGaoiWuN2wjGQVZ6J1mLGYiw419mJPp5kElqB5nu0DVzPcfeGux
         6AeQ==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-15-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kern

On Wed, Sep 14, 2016 at 09:24:07AM +0200, Micka=EBl Sala=FCn wrote:
> This will be useful to support Landlock for the next commits.
>=20
> Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Daniel Mack <daniel@zonque.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Tejun Heo <tj@kernel.org>

I think this is good to do regardless. Sooner or later cgroup_bpf_update
will start rejecting the prog attach. Like we discussed to have a flag
that would dissallow processeses lower in the cgroup hierarchy to install
their own bpf programs.
It will be minimal change to bpf_prog_attach() error handling,
but will greatly help Mickael to build stuff on top.
DanielM can you refactor your patch to do that from the start ?

Thanks!

> ---
>  include/linux/bpf-cgroup.h |  4 ++--
>  kernel/bpf/cgroup.c        |  3 ++-
>  kernel/bpf/syscall.c       | 10 ++++++----
>  kernel/cgroup.c            |  6 ++++--
>  4 files changed, 14 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 2234042d7f61..6cca7924ee17 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -31,13 +31,13 @@ struct cgroup_bpf {
>  void cgroup_bpf_put(struct cgroup *cgrp);
>  void cgroup_bpf_inherit(struct cgroup *cgrp, struct cgroup *parent);
> =20
> -void __cgroup_bpf_update(struct cgroup *cgrp,
> +int __cgroup_bpf_update(struct cgroup *cgrp,
>  			 struct cgroup *parent,
>  			 struct bpf_prog *prog,
>  			 enum bpf_attach_type type);
> =20
>  /* Wrapper for __cgroup_bpf_update() protected by cgroup_mutex */
> -void cgroup_bpf_update(struct cgroup *cgrp,
> +int cgroup_bpf_update(struct cgroup *cgrp,
>  		       struct bpf_prog *prog,
>  		       enum bpf_attach_type type);
> =20
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 782878ec4f2d..7b75fa692617 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -83,7 +83,7 @@ void cgroup_bpf_inherit(struct cgroup *cgrp, struct cgr=
oup *parent)
>   *
>   * Must be called with cgroup_mutex held.
>   */
> -void __cgroup_bpf_update(struct cgroup *cgrp,
> +int __cgroup_bpf_update(struct cgroup *cgrp,
>  			 struct cgroup *parent,
>  			 struct bpf_prog *prog,
>  			 enum bpf_attach_type type)
> @@ -117,6 +117,7 @@ void __cgroup_bpf_update(struct cgroup *cgrp,
>  		bpf_prog_put(old_pinned.prog);
>  		static_branch_dec(&cgroup_bpf_enabled_key);
>  	}
> +	return 0;
>  }
> =20
>  /**
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 45a91d511119..c978f2d9a1b3 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -831,6 +831,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>  {
>  	struct bpf_prog *prog;
>  	struct cgroup *cgrp;
> +	int result;
> =20
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EPERM;
> @@ -858,10 +859,10 @@ static int bpf_prog_attach(const union bpf_attr *at=
tr)
>  		return PTR_ERR(cgrp);
>  	}
> =20
> -	cgroup_bpf_update(cgrp, prog, attr->attach_type);
> +	result =3D cgroup_bpf_update(cgrp, prog, attr->attach_type);
>  	cgroup_put(cgrp);
> =20
> -	return 0;
> +	return result;
>  }
> =20
>  #define BPF_PROG_DETACH_LAST_FIELD attach_type
> @@ -869,6 +870,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>  static int bpf_prog_detach(const union bpf_attr *attr)
>  {
>  	struct cgroup *cgrp;
> +	int result =3D 0;
> =20
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EPERM;
> @@ -883,7 +885,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>  		if (IS_ERR(cgrp))
>  			return PTR_ERR(cgrp);
> =20
> -		cgroup_bpf_update(cgrp, NULL, attr->attach_type);
> +		result =3D cgroup_bpf_update(cgrp, NULL, attr->attach_type);
>  		cgroup_put(cgrp);
>  		break;
> =20
> @@ -891,7 +893,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>  		return -EINVAL;
>  	}
> =20
> -	return 0;
> +	return result;
>  }
>  #endif /* CONFIG_CGROUP_BPF */
> =20
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 87324ce481b1..48b650a640a9 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -6450,15 +6450,17 @@ static __init int cgroup_namespaces_init(void)
>  subsys_initcall(cgroup_namespaces_init);
> =20
>  #ifdef CONFIG_CGROUP_BPF
> -void cgroup_bpf_update(struct cgroup *cgrp,
> +int cgroup_bpf_update(struct cgroup *cgrp,
>  		       struct bpf_prog *prog,
>  		       enum bpf_attach_type type)
>  {
>  	struct cgroup *parent =3D cgroup_parent(cgrp);
> +	int result;
> =20
>  	mutex_lock(&cgroup_mutex);
> -	__cgroup_bpf_update(cgrp, parent, prog, type);
> +	result =3D __cgroup_bpf_update(cgrp, parent, prog, type);
>  	mutex_unlock(&cgroup_mutex);
> +	return result;
>  }
>  #endif /* CONFIG_CGROUP_BPF */
> =20
> --=20
> 2.9.3
>=20
