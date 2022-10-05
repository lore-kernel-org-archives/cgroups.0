From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Reorganize css_set_lock and kernfs path
 processing
Date: Wed, 5 Oct 2022 06:47:31 -1000
Message-ID: <Yz21I9UpXafWMU0K@slm.duckdns.org>
References: <20220905170944.23071-1-mkoutny@suse.com>
 <Yxd/sUQ/NB3NlC6f@slm.duckdns.org>
 <YzQw/EvH9Sb58Au2@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ia5DV0kmXQ4W+QZoJTRIPPIOgQcIdbHe/HPFhl2BDnY=;
        b=ks9cRP9wbCsBLQ96ncXMLBVGQ4M/qtxeyVrB8bpTTHWKQ9HRtbBJyWXEtz6wSqcSs3
         cSG28f0WA6XQB1HTFnLyKoTwrU5x8E7zQNRqjRxgDKnWnpAdtX9U/Llx1n6T3PrHBE4O
         QAXOQ+PJJD/4a4vI6OmZFFQDNK24GoWc3xWbHB0eO0vdAJj12UjHfz1rxu6A9DGc1QFM
         z2b1bZgndjJMspxfyWEXrSI7nE0A4ei6Xjgzjoj2ZSCH+m5CAQUqhSIz7F9gCAQRY1M4
         xB6/gE+33rH1Uls6YaDyc+YP6nFoEpnTyoFQOoGK1KDEu63LqpFR8KtnGIoL721WQaMW
         mUmw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YzQw/EvH9Sb58Au2@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Sep 28, 2022 at 01:33:16PM +0200, Michal Koutn=FD wrote:
...
> I realized the pinning with reference taking won't really work
> generally. The code would get the reference within RCU read section, so
> it'd have to be cgroup_get_live() and if that fails there's not much to
> do.

Hmm... isn't current's root cgrp guaranteed to be alive? How would
cgroup_get_live() fail? Also, shouldn't cgroup_get() enough for path
walking?

> @@ -6673,8 +6678,8 @@ struct cgroup *cgroup_get_from_path(const char *pat=
h)
> =20
>  	spin_lock_irq(&css_set_lock);
>  	root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
> -	kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
>  	spin_unlock_irq(&css_set_lock);
> +	kn =3D kernfs_walk_and_get(root_cgrp->kn, path);

If you really wanna do it this way, can you please add a detailed comment
here why this is safe? But I'd prefer just doing a strightforward ref
inc/dec around it.

Thanks.

--=20
tejun
