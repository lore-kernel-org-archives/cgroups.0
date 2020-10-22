From: Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Thu, 22 Oct 2020 12:57:55 -0400
Message-ID: <004fe66ee1d111ec006dd065b9bed5fdcfdaad01.camel@surriel.com>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
         <db4f86f30726a1a33c868155b4c681ac25569179.camel@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-q/yjJ9zoR2cgocIosU9b"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db4f86f30726a1a33c868155b4c681ac25569179.camel@fb.com>
Sender: riel@shelob.surriel.com
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com


--=-q/yjJ9zoR2cgocIosU9b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-10-22 at 12:49 -0400, Rik van Riel wrote:
> On Thu, 2020-10-22 at 11:18 -0400, Johannes Weiner wrote:
>=20
> > index e80aa9d2db68..334ce608735c 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -204,9 +204,9 @@ static void unaccount_page_cache_page(struct
> > address_space *mapping,
> >  	if (PageSwapBacked(page)) {
> >  		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
> >  		if (PageTransHuge(page))
> > -			__dec_node_page_state(page, NR_SHMEM_THPS);
> > +			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
> >  	} else if (PageTransHuge(page)) {
> > -		__dec_node_page_state(page, NR_FILE_THPS);
> > +		__dec_lruvec_page_state(page, NR_FILE_THPS);
> >  		filemap_nr_thps_dec(mapping);
> >  	}
>=20
> This may be a dumb question, but does that mean the
> NR_FILE_THPS number will no longer be visible in
> /proc/vmstat or is there some magic I overlooked in
> a cursory look of the code?

Never mind, I found it a few levels deep in
__dec_lruvec_page_state.

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

--=-q/yjJ9zoR2cgocIosU9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAl+RuhQACgkQznnekoTE
3oNrzwf9GSWmH30yYW4VoJhqcAiuVzpHRu/K7HGUTezlWzZgMV+ef6NYaUk0NItK
sIgNpwCkeBZXg99ZG6y7o/yBiMLB7LR9E5PdREv+7CQrgZ8dvTbu0OhsmhOvo8TL
+ufRBaAt4aK1Melt27dbnooHH43PVqRODDI9nkp4NU/aSIGami/KCAIGf3JfMEyR
mK7THczWyFCknk1LWfPIbhYb3cneiwM62w07Xn3Fs4ord5612IvbW3iULFEMQwAO
FUQ8DZycLWEIJL9DDa/eYeNH9c0cq0tzdiRBsaESVnT4q/I0gapNN4eLora3VCzi
xqEBWQ22PQDOuUdJ0Lc7fyrhnplMWA==
=/3Jx
-----END PGP SIGNATURE-----

--=-q/yjJ9zoR2cgocIosU9b--

