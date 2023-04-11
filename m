From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Tue, 11 Apr 2023 17:08:57 +0200
Message-ID: <wmy3re5x2olokij77xfleomlydc7p2zczas6dagtawrl2mvh5a@d3ipt4hgqgr2>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
 <3myr57cw3qepul7igpifypxx4xd2buo2y453xlqhdw4xgjokc4@vi3odjfo3ahc>
 <aa3382b4-4046-988f-42ea-8812dba7882b@bytedance.com>
 <ZDVcwuiu3rWEFiTE@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5w72e4ixd2yvjwyd"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681225739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m3tjzrn9vgH+epgdD39dTRsPzv4bId3KCAVUvytIiC0=;
        b=dADxETCkidHbUpn4IIj2ICcPpxGDuHfrP1gXYRRsuLhYsQn0UbF6NbrWWLvT/GogGsLdCz
        W7K+vzc+gH1JJ8ijeimOIV2lWQUJf521g9BxSR7iztTsrCUCzEWDS3QL9Sj6XvKHaPRI+x
        Y3khDEDd5T3Z18BbBWw7pXFl/map7EE=
Content-Disposition: inline
In-Reply-To: <ZDVcwuiu3rWEFiTE-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--5w72e4ixd2yvjwyd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2023 at 03:12:34PM +0200, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wr=
ote:
> > Oh I see, you mean scanning all processes in all cpusets and scanning
> > all processes globally are equivalent.
>=20
> Why cannot you simple select a process from the cpuset the allocating
> process belongs to? I thought the whole idea was to handle well
> partitioned workloads.

Ah, I was confused by the top_cpuset implementation.

The iteration should then start in
	nearest_hardwall_ancestor(task_cs(current)).
(in the 1st approximation).

The nodes_intersect/nodes_subset/nodes_equal/whatnot heuristics is
secondary.

HTH,
Michal

--5w72e4ixd2yvjwyd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZDV4BQAKCRAkDQmsBEOq
uWmbAP92Dw9zEkV1uoIFp/40jhHF8QWoTOvy5Wn27+Nam1QPeQD9Hd2xoA9doDrd
EPYy/DQpuuQ7H3ogRM84kLZtmuSC2Aw=
=MJ50
-----END PGP SIGNATURE-----

--5w72e4ixd2yvjwyd--
