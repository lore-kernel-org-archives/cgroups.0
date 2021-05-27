From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 27 May 2021 15:00:12 +1000
Message-ID: <YK8nXKAJdfT5UVEu@yekko>
References: <20210428145622.GU1370958@nvidia.com> <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com> <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com> <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com>
 <6b13399d-cf03-1e71-3624-c39d4d05e958@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0363983078241597763=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=gibson.dropbear.id.au; s=201602; t=1622099541;
 bh=Lefrtr63WtZPzxCJD/a0Dt0CwKqdjDj9tbK9ydRsQZA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fMUbeAdG8FfOw30NsEJoAerE2i88uoQM3TbXYsIqJzw49r1s6kG8D5t4trO1VCikP
 +rVJ2VxCicTOzRkJBR0xiHrYjWjJgK1YyFW/0R83MMdBht/clN1NyHUc7DS35Yjt17
 S75HTnNVpEtzMDbFQRWK1Q6j/r/BpiosihFY3ZeM=
In-Reply-To: <6b13399d-cf03-1e71-3624-c39d4d05e958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Jiang,
 Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>


--===============0363983078241597763==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Z64+IwN5nyf9pBFr"
Content-Disposition: inline


--Z64+IwN5nyf9pBFr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2021 at 02:48:03AM +0530, Kirti Wankhede wrote:
>=20
>=20
> On 5/26/2021 1:22 AM, Jason Gunthorpe wrote:
> > On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
> >=20
> > > 2. iommu backed mdev devices for SRIOV where mdev device is created p=
er
> > > VF (mdev device =3D=3D VF device) then that mdev device has same iommu
> > > protection scope as VF associated to it.
> >=20
> > This doesn't require, and certainly shouldn't create, a fake group.
> >=20
> > Only the VF's real IOMMU group should be used to model an iommu domain
> > linked to a VF. Injecting fake groups that are proxies for real groups
> > only opens the possibility of security problems like David is
> > concerned with.
> >=20
>=20
> I think this security issue should be addressed by letting mdev device
> inherit its parent's iommu_group, i.e. VF's iommu_group here.

No, that doesn't work.  AIUI part of the whole point of mdevs is to
allow chunks of a single PCI function to be handed out to different
places, because they're isolated from each other not by the system
IOMMU, but by a combination of MMU hardware in the hardware (e.g. in a
GPU card) and software in the mdev driver.  If mdevs inherited the
group of their parent device they wouldn't count as isolated from each
other, which they should.

>=20
> Kirti
>=20
> > Max's series approaches this properly by fully linking the struct
> > pci_device of the VF throughout the entire VFIO scheme, including the
> > group and container, while still allowing override of various VFIO
> > operations.
> >=20
> > Jason
> >=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Z64+IwN5nyf9pBFr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCvJ1wACgkQbDjKyiDZ
s5LA1A/9HdoNik7wBiSYXbYApT72IFI+LhekrRCOipo8yeKeq0f2VM5RS34wrfFw
1Uhvw2jZYG8HWgG6XQczVwGyXtXtKQQL/S8djvv2Nqp3xY+++sPj2HO1xy7051m6
UpAR0ILjYOHTzj4DQI4uR7iRt6JcfK6+gedGouV++4suDp95Ta4xBo5rLBkjqn8l
VrPRt6AVMCYvVRcDb6iRhofAvhFOIjGJfarivrhPS3BzDCBrk2/BXxQ61lYy1dR9
8qqb3CFFQWbyfgtaQXz8gAQLULpWX10Ob2tUaQRrWz3iZG0H/Iq5ffX3PPuQUsjg
fIs8GH7xxWe0/7tUVzS+iwhGwcS7TmA5uktxiITJHNB/aDG3yQpzLNoLGn9fQP6h
POpSLPQY1MyPvTO9ZF91celXdAZialXuchORnG+zHmzDcG0z1NPUYORzmR0G8D8V
tuCAUL/3ayA5pR6j0X4zcpWmn32CQyC6WJ113cDDQga7fFXCbyw7zilXISGRcxHY
7PA6tsnrBbVpuuYsJINgP/NM/eHgW1U07NSiNyIjj8UNPJPjGYFm/8obYwwXTIbF
Fqv0tBPGrmq9rKbfG9Xl12SVKMdmF7f1wHVNLc6SUvUiAIVswax4YPMJmiBBoSZ9
dbzfFlE13orgt8fbZ+nYuBx9L7xc2E+kNJcw/7a45nldRaqkH8U=
=yhde
-----END PGP SIGNATURE-----

--Z64+IwN5nyf9pBFr--

--===============0363983078241597763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0363983078241597763==--
