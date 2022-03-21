From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Mon, 21 Mar 2022 18:45:30 +0100
Message-ID: <20220321174530.GB9640@blackbody.suse.cz>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-6-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647884732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=peglqrh0TeDc2F8OaZcmUkLDagjJhol7WzzofXyyxO4=;
        b=PnmDb1Bn2lmsEUIPSG3oXSY46IqI6iAnrhkUOd3imYGHhzUBGrywA4Q9uGXh7c/svUPKw5
        ngHuZu78cVggAJKMr47ybLtd326kLSE1NoNSHr9Gfg480gkY2G8m9HV1lQGRPPiKOrSgdz
        U10jIZn2E3ClJ36uP4+4GnMAPYs5WBQ=
Content-Disposition: inline
In-Reply-To: <20220309165222.2843651-6-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laur

Hello.

On Wed, Mar 09, 2022 at 04:52:15PM +0000, "T.J. Mercier" <tjmercier-hpIqsD4=
AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> +int dma_buf_charge_transfer(struct dma_buf *dmabuf, struct gpucg *gpucg)
> +{
> +#ifdef CONFIG_CGROUP_GPU
> +	struct gpucg *current_gpucg;
> +	int ret =3D 0;
> +
> +	/*
> +	 * Verify that the cgroup of the process requesting the transfer is the
> +	 * same as the one the buffer is currently charged to.
> +	 */
> +	current_gpucg =3D gpucg_get(current);
> +	mutex_lock(&dmabuf->lock);
> +	if (current_gpucg !=3D dmabuf->gpucg) {
> +		ret =3D -EPERM;
> +		goto err;
> +	}

Add a shortcut for gpucg =3D=3D current_gpucg?

> +
> +	ret =3D gpucg_try_charge(gpucg, dmabuf->gpucg_dev, dmabuf->size);
> +	if (ret)
> +		goto err;
> +
> +	dmabuf->gpucg =3D gpucg;
> +
> +	/* uncharge the buffer from the cgroup it's currently charged to. */
> +	gpucg_uncharge(current_gpucg, dmabuf->gpucg_dev, dmabuf->size);

I think gpucg_* API would need to cater for such transfers too since
possibly transitional breach of a limit during the transfer may
unnecessarily fail the operation.

My 0.02=E2=82=AC,
Michal
