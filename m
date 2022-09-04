From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v12 09/10] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Sun, 4 Sep 2022 15:20:27 +0700
Message-ID: <YxRfy/SaKkJSm5jY@debian.me>
References: <20220901205745.323326-1-longman@redhat.com>
 <20220901205745.323326-10-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oIHDfZi7tkZKklmK"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=zfiWejN/Bz3YBQupNom1bcY/9klYVsjCN66XEd476z0=;
        b=SBEuv7blCe057KcuIJdNRyj3g2VOPTQq1llrfLNFf289npI8wf/m4D6m8V6XY3lUXp
         Re5/g1GMCzHeowzixKLlyMxv657lA13nPeZhWWJ2OC266RIOX72T1P7U1QIAkGITZTkZ
         OhFiv4GP/cj1MqfFk/e6TYkNwyKqbZZknzVH95RjMeoEs2gWuzEfbEQyCHG1wbtuLJHO
         pjSg3+fSIKJmTcugr2ndTCmihpEGjkt8TbVpopZ7zzVFWdZ8gYe+YJI8gXqyPjNVYdVK
         Rz3pc71J6gK/cLFZWzrR+DMSWgYikjoU/F8/eqeKn7KVfwAFofKX6tJeywPhCEF2HQqP
         7Blw==
Content-Disposition: inline
In-Reply-To: <20220901205745.323326-10-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>


--oIHDfZi7tkZKklmK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01, 2022 at 04:57:44PM -0400, Waiman Long wrote:
>  	It accepts only the following input values when written to.
> =20
>  	  =3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -	  "root"	a partition root
> -	  "member"	a non-root member of a partition
> +	  "member"	Non-root member of a partition
> +	  "root"	Partition root
> +	  "isolated"	Partition root without load balancing
>  	  =3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
><snipped>
> +	On read, the "cpuset.cpus.partition" file can show the following
> +	values.
> +
> +	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +	  "member"			Non-root member of a partition
> +	  "root"			Partition root
> +	  "isolated"			Partition root without load balancing
> +	  "root invalid (<reason>)"	Invalid partition root
> +	  "isolated invalid (<reason>)"	Invalid isolated partition root
> +	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +

These tables above produced htmldocs warnings:

Documentation/admin-guide/cgroup-v2.rst:2191: WARNING: Malformed table.
Text in column margin in table line 4.

=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"member"      Non-root member of a partition
"root"        Partition root
"isolated"    Partition root without load balancing
=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Documentation/admin-guide/cgroup-v2.rst:2229: WARNING: Malformed table.
Text in column margin in table line 5.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D        =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
"member"                      Non-root member of a partition
"root"                        Partition root
"isolated"                    Partition root without load balancing
"root invalid (<reason>)"     Invalid partition root
"isolated invalid (<reason>)" Invalid isolated partition root
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D        =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

I have applied the fixup:

---- >8 ----

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-=
guide/cgroup-v2.rst
index 76b3ea9fd5c560..77b6faecf066cb 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2185,11 +2185,11 @@ Cpuset Interface Files
=20
 	It accepts only the following input values when written to.
=20
-	  =3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 	  "member"	Non-root member of a partition
 	  "root"	Partition root
 	  "isolated"	Partition root without load balancing
-	  =3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 	The root cgroup is always a partition root and its state
 	cannot be changed.  All other non-root cgroups start out as
@@ -2222,13 +2222,13 @@ Cpuset Interface Files
 	On read, the "cpuset.cpus.partition" file can show the following
 	values.
=20
-	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 	  "member"			Non-root member of a partition
 	  "root"			Partition root
 	  "isolated"			Partition root without load balancing
 	  "root invalid (<reason>)"	Invalid partition root
 	  "isolated invalid (<reason>)"	Invalid isolated partition root
-	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 	In the case of an invalid partition root, a descriptive string on
 	why the partition is invalid is included within parentheses.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--oIHDfZi7tkZKklmK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYxRfxAAKCRD2uYlJVVFO
o3SHAQClBqZgslhw004gM4yBhkfde6wdEJ2nw/MXorNJ8fTClQD+JtUvFXJzGoUu
rSAT7jqqrPGSs2nO4gsLQKWjeu/V6gQ=
=Tjsc
-----END PGP SIGNATURE-----

--oIHDfZi7tkZKklmK--
