From: William Dauchy <william-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>
Subject: Re: ps stuck on cmdline reading
Date: Thu, 5 Feb 2015 16:22:33 +0100
Message-ID: <20150205152233.GI3008@gandi.net>
References: <20150121095808.GA18656@gandi.net>
 <20150203194036.GA2490@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150203194036.GA2490-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: William Dauchy <william-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--oyqLL/JqMvClXZi1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb03 20:40, Michal Hocko wrote:
> What does /proc/<ps pid>/stack say?

Thanks for the hint.
forgot to have a look; seems to be a nfs issue:

[<ffffffff810eda29>] sleep_on_page+0x9/0x20
[<ffffffff810ee8d4>] __lock_page+0xa4/0xb0
[<ffffffff810fe38f>] truncate_inode_pages_range+0x3ef/0x6a0
[<ffffffff810fe650>] truncate_inode_pages+0x10/0x20
[<ffffffff812474b6>] nfs4_evict_inode+0x16/0x40
[<ffffffff8117359f>] evict+0xaf/0x1c0
[<ffffffff811744c2>] iput+0x102/0x1a0
[<ffffffff812178d5>] nfs_dentry_iput+0x35/0x50
[<ffffffff8116f36c>] dentry_kill+0x16c/0x290
[<ffffffff8116f9d8>] dput+0xa8/0x160
[<ffffffff8121c96b>] __put_nfs_open_context+0xbb/0x100
[<ffffffff8121d1bb>] put_nfs_open_context+0xb/0x20
[<ffffffff81229ea4>] nfs_commitdata_release+0x14/0x30
[<ffffffff81229ee7>] nfs_commit_release+0x27/0x30
[<ffffffff815d23d2>] rpc_free_task+0x32/0x80
[<ffffffff815d24a5>] rpc_final_put_task+0x85/0x90
[<ffffffff815d2505>] rpc_do_put_task+0x35/0x40
[<ffffffff815d320b>] rpc_put_task+0xb/0x20
[<ffffffff81229fd0>] nfs_initiate_commit+0xe0/0x120
[<ffffffff8122a269>] nfs_commit_list+0x69/0xb0
[<ffffffff8122a36b>] nfs_commit_inode+0x9b/0x160
[<ffffffff8121b02b>] nfs_release_page+0x7b/0xa0
[<ffffffff810f18dd>] try_to_release_page+0x3d/0x60
[<ffffffff81100b06>] shrink_page_list+0x8a6/0x9e0
[<ffffffff81101233>] shrink_inactive_list+0x183/0x420
[<ffffffff81101b45>] shrink_lruvec+0x335/0x6f0
[<ffffffff81101f66>] shrink_zone+0x66/0x1a0
[<ffffffff8110217b>] do_try_to_free_pages+0xdb/0x550
[<ffffffff81102764>] try_to_free_mem_cgroup_pages+0xa4/0xb0
[<ffffffff8114851e>] mem_cgroup_reclaim+0x4e/0xd0
[<ffffffff81148e29>] __mem_cgroup_try_charge+0x409/0xbf0
[<ffffffff81149d85>] mem_cgroup_charge_common+0x45/0xa0
[<ffffffff8114c1d6>] mem_cgroup_newpage_charge+0x26/0x30
[<ffffffff811181a8>] handle_mm_fault+0x8c8/0xcf0
[<ffffffff810342a3>] __do_page_fault+0x1b3/0x600
[<ffffffff8103472c>] do_page_fault+0xc/0x20
[<ffffffff81609572>] page_fault+0x22/0x30
[<ffffffffffffffff>] 0xffffffffffffffff
--=20
William

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTTirkACgkQ1I6eqOUidQE3FQCaAhbshNuWktlErs0v8hhMP2Pq
v4AAn05qOH8NJ2Uhzgq1erejgP+Yr94O
=z/up
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
