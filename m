From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 02/18] cgroup/misc: Add SGX EPC resource type and
 export APIs for SGX driver
Date: Wed, 13 Sep 2023 12:43:35 +0300
Message-ID: <CVHOXKY6MYEL.1CX828Z7QWIBI@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-3-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694598220;
        bh=3fH066XSUsC3DD/8dTybp4N/iAaPDru4E5Ou1axmhsg=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=Lz8WfdDvnT3BgVgUqtVkjJS5jkDZXnH7WekQBIQAG7YLj8dAxSVfTV4tqPl3xQuoo
         e2+kJN6H0iGlGvlUkvnu9T2GdoblRWFco3VHGXdd9RxpkRW0Yi1Y5xmHhFXejpi5GN
         FvkzsLNc/SDNgW7KlGIhLFpgZ7nQG+RxBzoxEGejFeRENT8qmW4NI4ig/Vi3Jnyk6z
         nGmEzM+SzfHpKhwchITjJWWJ0odRd7/71iWx7dKNUI6sp6aBxzns+4lnY/vKeQfoRX
         m8A7+YpzYTNPv/Wsyvbag/pctn2kfvl6UC5vXBsGjWtbkkr4DncGZdCKZJ14lE5OfY
         WDuCXNHC7Emng==
In-Reply-To: <20230913040635.28815-3-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> The SGX driver will need to get access to the root misc_cg object
> to do iterative walks and also determine if a charge will be
> towards the root cgroup or not.

What is "a charge" and why does SGX driver need to do iterative walks?
Neither is explained here.

> To manage the SGX EPC memory via the misc controller, the SGX
> driver will also need to be able to iterate over the misc cgroup
> hierarchy.

Ambiguous language: misc_cg vs "misc controller". Are the different
types of objects? If not, then stick to misc_cg everywhere.

> Move parent_misc() into misc_cgroup.h and make inline to make this
> function available to SGX, rename it to misc_cg_parent(), and update
> misc.c to use the new name.

net/rxrpc/misc.c?

The point being that plain "misc.c" is ambiguous.

> Add per resource type private data so that SGX can store additional
> per cgroup data with the misc_cg struct.

Yet another term "misc cg struct", and not just "misc_cg" like in the
first paragraph.

>
> Allow SGX EPC memory to be a valid resource type for the misc
> controller.
>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
> V4:
> - Moved this to the second in the series.
> ---
>  include/linux/misc_cgroup.h | 29 +++++++++++++++++++++++++++++
>  kernel/cgroup/misc.c        | 25 ++++++++++++-------------
>  2 files changed, 41 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index e1bcd176c2de..6f8330f435ba 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -17,6 +17,10 @@ enum misc_res_type {
>  	MISC_CG_RES_SEV,
>  	/* AMD SEV-ES ASIDs resource */
>  	MISC_CG_RES_SEV_ES,
> +#endif
> +#ifdef CONFIG_CGROUP_SGX_EPC
> +	/* SGX EPC memory resource */
> +	MISC_CG_RES_SGX_EPC,
>  #endif
>  	MISC_CG_RES_TYPES
>  };
> @@ -37,6 +41,7 @@ struct misc_res {
>  	u64 max;
>  	atomic64_t usage;
>  	atomic64_t events;
> +	void *priv;
> =20
>  	/* per resource callback ops */
>  	int (*misc_cg_alloc)(struct misc_cg *cg);
> @@ -59,6 +64,7 @@ struct misc_cg {
>  	struct misc_res res[MISC_CG_RES_TYPES];
>  };
> =20
> +struct misc_cg *misc_cg_root(void);
>  u64 misc_cg_res_total_usage(enum misc_res_type type);
>  int misc_cg_set_capacity(enum misc_res_type type, u64 capacity);
>  int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg, u64 =
amount);
> @@ -78,6 +84,20 @@ static inline struct misc_cg *css_misc(struct cgroup_s=
ubsys_state *css)
>  	return css ? container_of(css, struct misc_cg, css) : NULL;
>  }
> =20
> +/**
> + * misc_cg_parent() - Get the parent of the passed misc cgroup.
> + * @cgroup: cgroup whose parent needs to be fetched.
> + *
> + * Context: Any context.
> + * Return:
> + * * struct misc_cg* - Parent of the @cgroup.
> + * * %NULL - If @cgroup is null or the passed cgroup does not have a par=
ent.
> + */
> +static inline struct misc_cg *misc_cg_parent(struct misc_cg *cgroup)
> +{
> +	return cgroup ? css_misc(cgroup->css.parent) : NULL;
> +}
> +
>  /*
>   * get_current_misc_cg() - Find and get the misc cgroup of the current t=
ask.
>   *
> @@ -102,6 +122,15 @@ static inline void put_misc_cg(struct misc_cg *cg)
>  }
> =20
>  #else /* !CONFIG_CGROUP_MISC */
> +static inline struct misc_cg *misc_cg_root(void)
> +{
> +	return NULL;
> +}
> +
> +static inline struct misc_cg *misc_cg_parent(struct misc_cg *cg)
> +{
> +	return NULL;
> +}
> =20
>  static inline u64 misc_cg_res_total_usage(enum misc_res_type type)
>  {
> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> index e0092170d0dd..dbd881be773f 100644
> --- a/kernel/cgroup/misc.c
> +++ b/kernel/cgroup/misc.c
> @@ -24,6 +24,10 @@ static const char *const misc_res_name[] =3D {
>  	/* AMD SEV-ES ASIDs resource */
>  	"sev_es",
>  #endif
> +#ifdef CONFIG_CGROUP_SGX_EPC
> +	/* Intel SGX EPC memory bytes */
> +	"sgx_epc",
> +#endif
>  };
> =20
>  /* Root misc cgroup */
> @@ -40,18 +44,13 @@ static struct misc_cg root_cg;
>  static u64 misc_res_capacity[MISC_CG_RES_TYPES];
> =20
>  /**
> - * parent_misc() - Get the parent of the passed misc cgroup.
> - * @cgroup: cgroup whose parent needs to be fetched.
> - *
> - * Context: Any context.
> - * Return:
> - * * struct misc_cg* - Parent of the @cgroup.
> - * * %NULL - If @cgroup is null or the passed cgroup does not have a par=
ent.
> + * misc_cg_root() - Return the root misc cgroup.
>   */
> -static struct misc_cg *parent_misc(struct misc_cg *cgroup)
> +struct misc_cg *misc_cg_root(void)
>  {
> -	return cgroup ? css_misc(cgroup->css.parent) : NULL;
> +	return &root_cg;
>  }
> +EXPORT_SYMBOL_GPL(misc_cg_root);
> =20
>  /**
>   * valid_type() - Check if @type is valid or not.
> @@ -150,7 +149,7 @@ int misc_cg_try_charge(enum misc_res_type type, struc=
t misc_cg *cg, u64 amount)
>  	if (!amount)
>  		return 0;
> =20
> -	for (i =3D cg; i; i =3D parent_misc(i)) {
> +	for (i =3D cg; i; i =3D misc_cg_parent(i)) {
>  		res =3D &i->res[type];
> =20
>  		new_usage =3D atomic64_add_return(amount, &res->usage);
> @@ -163,12 +162,12 @@ int misc_cg_try_charge(enum misc_res_type type, str=
uct misc_cg *cg, u64 amount)
>  	return 0;
> =20
>  err_charge:
> -	for (j =3D i; j; j =3D parent_misc(j)) {
> +	for (j =3D i; j; j =3D misc_cg_parent(j)) {
>  		atomic64_inc(&j->res[type].events);
>  		cgroup_file_notify(&j->events_file);
>  	}
> =20
> -	for (j =3D cg; j !=3D i; j =3D parent_misc(j))
> +	for (j =3D cg; j !=3D i; j =3D misc_cg_parent(j))
>  		misc_cg_cancel_charge(type, j, amount);
>  	misc_cg_cancel_charge(type, i, amount);
>  	return ret;
> @@ -190,7 +189,7 @@ void misc_cg_uncharge(enum misc_res_type type, struct=
 misc_cg *cg, u64 amount)
>  	if (!(amount && valid_type(type) && cg))
>  		return;
> =20
> -	for (i =3D cg; i; i =3D parent_misc(i))
> +	for (i =3D cg; i; i =3D misc_cg_parent(i))
>  		misc_cg_cancel_charge(type, i, amount);
>  }
>  EXPORT_SYMBOL_GPL(misc_cg_uncharge);
> --=20
> 2.25.1


BR, Jarkko
