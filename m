From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] cgroup,bpf: Add access check for cgroup_get_from_fd()
Date: Mon, 19 Sep 2016 17:30:08 -0700
Message-ID: <20160920003007.GB91808@ast-mbp.thefacebook.com>
References: <20160919224913.24808-1-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=HF/M2tFXrXTa++xF5gMW1v2e9n3K5sJguBht9O6zUXM=;
        b=MfCtyDOPFafGrG9hSbbgFzvuAEECk/LiDeNfvCsmDmn8W6alyriBirbOmniJW3vABm
         aBsQDfrFO5Uypn7NrPImuLY4qxrzhg3hAuVs5EaFB/qUgQeR7QxcuZfodw1S5T6Hoefu
         tTp83wDBVQeG/M0B/PLMCkIJ+YaT6MGIN14m5q9PQmmaAtSAkkAKlrG6xZmNPs5IhE7X
         8ObsfJfTeMB+zPEMHAYFOtcBWqqXfy30XotwG+YSXBwFDCMrnvQVC8Ph25vy8eXRP63Q
         J0b1lB0w19yfoFLrsZQfEDHFzuVWYGKwwRPauk6A/j+HQ4BZ+v2BkLic/OqcvgmVFOoc
         KL/w==
Content-Disposition: inline
In-Reply-To: <20160919224913.24808-1-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 20, 2016 at 12:49:13AM +0200, Micka=EBl Sala=FCn wrote:
> Add security access check for cgroup backed FD. The "cgroup.procs" file
> of the corresponding cgroup should be readable to identify the cgroup,
> and writable to prove that the current process can manage this cgroup
> (e.g. through delegation). This is similar to the check done by
> cgroup_procs_write_permission().
>=20
> Fixes: 4ed8ec521ed5 ("cgroup: bpf: Add BPF_MAP_TYPE_CGROUP_ARRAY")

I don't understand what 'fixes' is about.
Looks like new feature or tightening?
Since cgroup was opened by the process and it got an fd,
it had an access, so extra check here looks unnecessary.

> -struct cgroup *cgroup_get_from_fd(int fd)
> +struct cgroup *cgroup_get_from_fd(int fd, int access_mask)
>  {
>  	struct cgroup_subsys_state *css;
>  	struct cgroup *cgrp;
>  	struct file *f;
> +	struct inode *inode;
> +	int ret;
> =20
>  	f =3D fget_raw(fd);
>  	if (!f)
>  		return ERR_PTR(-EBADF);
> =20
>  	css =3D css_tryget_online_from_dir(f->f_path.dentry, NULL);
> -	fput(f);

why move it down?

> -	if (IS_ERR(css))
> -		return ERR_CAST(css);
> +	if (IS_ERR(css)) {
> +		ret =3D PTR_ERR(css);
> +		goto put_f;
> +	}
> =20
>  	cgrp =3D css->cgroup;
>  	if (!cgroup_on_dfl(cgrp)) {
> -		cgroup_put(cgrp);
> -		return ERR_PTR(-EBADF);
> +		ret =3D -EBADF;
> +		goto put_cgrp;
> +	}
> +
> +	ret =3D -ENOMEM;
> +	inode =3D kernfs_get_inode(f->f_path.dentry->d_sb, cgrp->procs_file.kn);
> +	if (inode) {
> +		ret =3D inode_permission(inode, access_mask);
> +		iput(inode);
>  	}
> +	if (ret)
> +		goto put_cgrp;
> =20
> +	fput(f);
>  	return cgrp;
> +
> +put_cgrp:
> +	cgroup_put(cgrp);
> +put_f:
> +	fput(f);
> +	return ERR_PTR(ret);
>  }
>  EXPORT_SYMBOL_GPL(cgroup_get_from_fd);
> =20
> --=20
> 2.9.3
>=20
