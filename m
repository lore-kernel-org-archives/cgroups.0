From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Fri, 25 Jun 2021 16:47:37 +0200
Message-ID: <YNXsid0Wg5X9/hAC@blackbook>
References: <20210610173944.1203706-1-schatzberg.dan@gmail.com>
 <20210610173944.1203706-3-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="U5WOJVgZJrEeE8ml"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624632459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3p/On6fxHbGfSoHEo45QdpoOPSq8wVMdaUq/e8JoVzM=;
        b=V6ru4Mh7I4N9RUtnfdD/F1oqSMcxR0NwfguTHDRgm7jLX1iGu9ywsAgYmLHMaX0ue7CM2h
        HsotDztIV9C6/zeL6JPC5htFaQThnNqOThsBU4wSJg3zshzFPFLkBEHa7OD92x+a+LVuqs
        7uvRx1Tho+a9wZ/F9qQQKbqhSaCDv6c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624632459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3p/On6fxHbGfSoHEo45QdpoOPSq8wVMdaUq/e8JoVzM=;
        b=V6ru4Mh7I4N9RUtnfdD/F1oqSMcxR0NwfguTHDRgm7jLX1iGu9ywsAgYmLHMaX0ue7CM2h
        HsotDztIV9C6/zeL6JPC5htFaQThnNqOThsBU4wSJg3zshzFPFLkBEHa7OD92x+a+LVuqs
        7uvRx1Tho+a9wZ/F9qQQKbqhSaCDv6c=
Content-Disposition: inline
In-Reply-To: <20210610173944.1203706-3-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Jens Axboe <axboe@kernel.dk>, Shakeel Butt <shakeelb@google.com>


--U5WOJVgZJrEeE8ml
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 10, 2021 at 10:39:43AM -0700, Dan Schatzberg <schatzberg.dan@gm=
ail.com> wrote:
> @@ -926,8 +937,17 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_=
struct *mm)
>  	 * counting is disabled on the root level in the
>  	 * cgroup core. See CSS_NO_REF.
>  	 */
> -	if (unlikely(!mm))
> -		return root_mem_cgroup;
> +	if (unlikely(!mm)) {
> +		memcg =3D active_memcg();
> +		if (unlikely(memcg)) {
> +			/* remote memcg must hold a ref */
> +			css_get(&memcg->css);
> +			return memcg;
> +		}
> +		mm =3D current->mm;
> +		if (unlikely(!mm))
> +			return root_mem_cgroup;
> +	}

With the change in __add_to_page_cache_locked() all page cache charges
will supply null mm, so the first !mm unlikely hint may not be warranted
anymore. Just an interesting point, generally, I'm adding

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--U5WOJVgZJrEeE8ml
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDV7IUACgkQia1+riC5
qSirkA/7BTqxM98NGuM6kg3YoDN9bafGVLtaEZ2J3nRIXBJpWkyGxDpmaRsEAq8B
SDejdzmPaIsNlgn3+POS5ozNnhqVXh0/oZ/09Cs68TCGNQk/pZaZeyBitqhP+1MW
MoNiFqifltGHeyfr6EupwmYp1qsvQHCeiIwrEZ1TJjxG9WZd0xPcVv3dtdFZ2euW
3p303SgVvQ3TytBvDQ5ORpTmFKQO/td1khxtFv7XcTXyMoaTu9EbBVFCxIb16oCk
xaGLmQuCMyv6m2uZONDq/WhMKHUQOVEooBz4pZg/sR2T3swSYVj6q+x/NbbNk/MP
nXZ8TN8IgedfvKKyBPwn4JxOU2zxgoaa07fHvhYdHBHY+PhB0rLuQ/XLoJm8RozE
3DpSSSi0x5I+2jXajeJ9vfjjKj+B1sq66tST5N9ZJ1NfCr7JAtTgwv3F7sR90cIJ
W9d+ZqvtVuAsbU0aQA0Tqexvu+IlERRij4dXzrk5ewOz8CDxcdoyPXnANVLniSAc
rXir95NJNIksHOpXyCyF9qOY5nqdIJeYpG9bZYqWojnVhkDJfj0K7O4HZ79EtxLY
U/I5+MvvhY6unE8O9Jc6F+/ctC0IY26boMzT14nSepJOcqtBLmX0v5VTRNgwK4PT
ZiDOTsKgnEn6o/A0O203BEcvuzl2t2WMFam+1lkHLS5ZtZMNOuY=
=EYsZ
-----END PGP SIGNATURE-----

--U5WOJVgZJrEeE8ml--
