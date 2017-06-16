From: Alice Ferrazzi <alicef-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: [RFC] ubsan: signed integer overflow in mem_cgroup_event_ratelimit
Date: Fri, 16 Jun 2017 21:26:53 +0900
Message-ID: <20170616122653.GF20222@alitoo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jkO+KyKz7TfD21mV"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--jkO+KyKz7TfD21mV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

a user reported a UBSAN signed integer overflow in memcontrol.c
Shall we change something in mem_cgroup_event_ratelimit()?

================================================================================
kernel: UBSAN: Undefined behaviour in mm/memcontrol.c:661:17
kernel: signed integer overflow:
kernel: -2147483644 - 2147483525 cannot be represented in type 'long
int'
kernel: CPU: 1 PID: 11758 Comm: mybibtex2filena Tainted: P           O
4.9.25-gentoo #4
kernel: Hardware name: XXXXXX, BIOS YYYYYY
kernel: e9a3bd64 d1f444f2 00000007 e9a3bd94 7fffff85 e9a3bd74 d1fc8ffe
e9a3bd74
kernel: d2b4ef1c e9a3bdf8 d1fc934b d28b15c0 e9a3bd98 0000002d e9a3bdc0
d2b4ef1c
kernel: 0000002d 00000002 3431322d 33383437 00343436 d1700ca2 00000000
ecb4effc
kernel: Call Trace:
kernel: [<d1f444f2>] dump_stack+0x59/0x87
kernel: [<d1fc8ffe>] ubsan_epilogue+0xe/0x40
kernel: [<d1fc934b>] handle_overflow+0xbb/0xf0
kernel: [<d1700ca2>] ? update_curr+0xe2/0x500
kernel: [<d1fc93b2>] __ubsan_handle_sub_overflow+0x12/0x20
kernel: [<d196a553>] memcg_check_events.isra.36+0x223/0x360
kernel: [<d1f44281>] ? cpumask_any_but+0x31/0x60
kernel: [<d19709c5>] mem_cgroup_commit_charge+0x55/0x140
kernel: [<d1925b42>] ? ptep_clear_flush+0x72/0xb0
kernel: [<d19017de>] wp_page_copy+0x34e/0xb80
kernel: [<d19037a6>] do_wp_page+0x1e6/0x1300
kernel: [<d16f0350>] ? check_preempt_curr+0x110/0x230
kernel: [<d1695de6>] ? kmap_atomic_prot+0x126/0x210
kernel: [<d1909b3b>] handle_mm_fault+0x88b/0x1990
kernel: [<d16a1905>] ? _do_fork+0x155/0x5b0
kernel: [<d1689e3e>] __do_page_fault+0x2de/0x8a0
kernel: [<d16a1e27>] ? SyS_clone+0x27/0x30
kernel: [<d168a400>] ? __do_page_fault+0x8a0/0x8a0
kernel: [<d168a41a>] do_page_fault+0x1a/0x20
kernel: [<d265a35b>] error_code+0x67/0x6c
kernel:
================================================================================

Thanks,
Alice'

--jkO+KyKz7TfD21mV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEELk4IVkYcBYUTNvSWViGmsoY4eBoFAllDzmwACgkQViGmsoY4
eBrq3g//YmzS4vfXDoASyBQlICFQxFCZUkKvYjUsJhZUR4Qn7AvibklaBro1o+dR
BCzv4f7IswkXN/RJOfN0nTaBvjAnhrI9BO2nhpU7A7pBAGVjs3Nz0jnXPJZwyzZK
LETLxVZx2c4N84Jt4YOANB7Ie2ajTnLHnw8j4FJ4Up/78E5ovlO41VvJkmwonbSi
dJ4OnNa55qSYN11kvD+UJJtYp3u3N0l4+g/GaHXMZfNyQrBz+W93r+5WFJ+h4Omj
M4rkdamP3waX15Xr/tOhJbJQJv7wIps1SR0NNXo8RsBxgzGDNO7jE2zRc8TfZO3a
gRvDvO2tHcRGsjrRGNZtGKtazANvNWTI5hOYYMBsUHvhaMpeIcpPVfPGQ+4s3g7Q
yYdrJ5c22PaMGwX+u6tjyJYsc965ZmHGFuwzehiDtW8JMMgSaq1fG31pjHIy3YrN
2KafEyaBCAr5fJyLFSzC4JHfQdTcxACUyJ517x2oouWxG45GYCySAMX/LcEfuZt4
Tk9uS9hHza1vgx5n3qGF9GKVFiwHhR9b1W16v1i3IaFG2IORl3tBRojP5StzFZfY
2n7xl6JqEsluRseA6tM+x5GaKxc1of0MsEFNQqnIn6EWR9kWIm8o25ux5/f72fRy
XwKGSGX5lLY74JiJAaMBM9dXFzT+RBVmWYERWBi8cyiefKRtzQU=
=DWiB
-----END PGP SIGNATURE-----

--jkO+KyKz7TfD21mV--
