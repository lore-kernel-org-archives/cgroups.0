From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC v4 11/16] drm, cgroup: Add per cgroup bw measure and
 control
Date: Tue, 1 Oct 2019 16:30:47 +0200
Message-ID: <20191001143046.GA4311@blackbody.suse.cz>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-12-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0773210037=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190829060533.32315-12-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Cc: daniel-/w4YWyX8dFk@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org


--===============0773210037==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi.

On Thu, Aug 29, 2019 at 02:05:28AM -0400, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> wrote:
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -1256,6 +1257,12 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
> [...]
> +		move_delay /= 2000; /* check every half period in ms*/
> [...]
> diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
> [...]
> @@ -382,6 +548,25 @@ static ssize_t drmcg_limit_write(struct kernfs_open_file *of, char *buf,
> [...]
> +			if (rc || val < 2000) {
This just caught my eye and it may be simply caused by RFC-ness of the
series but I'd suggest turning this into a constant with descriptive
name.

My 2 cents,
Michal

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl2TYxYACgkQia1+riC5
qSiZeg//bj2A/ClcMhpwuE0J8gvyfDQynY9eDJlRse6YteLmIg1WwJdh0j8IJDJX
BC0/pMubCU/sbHw5rscCCgQ9ecft1517aCah6uOvJo3LeLS0LrYDRuu++3T60MLQ
DTLJxuMHyAjJSdthOfeRxoHupvHh7/XxfcZxJ20PPu/G3v5f0vvIrfj8eADD19J/
jRyqyF14ytWvYkfnofwIuX9EuKesjGFMPTp6kpDq24PqzNwZma68/456oReb1TRF
t6u3vBFOdieLwhjt0FYY9ZL/6DlHnYou9nElamjm1igLOLCVp0dvIHDLrWYO2WY3
uJg5jq1Dgs0kGNZVY9L5JdB/K+hoVuhN975CiNqF9zz8h9HRNmeSeQwPi+0MgSJj
m430HsChdstWsCh28n1LOnIprYdR+oGngXyJrnWaevjvxUMQS0Ia+6qkbxmtq3tG
0M8PeanLOnbV+9oELF7fxfN1L4FDGDdQ7kT5cTX2ZCMHQU5fZSGcpNr8s9yysRT4
McBDchQJ/3O9E+8yDNt70v3OssutbhHNOal9RP1Y31p4zDxxS2bt3mRIZwqfBH2A
30oui6xyYsatphBiRfonOXaQYDsyrki3phwGogCchm3EbjeW3/TWgxOWlipAtefr
GsMF0wZubmtd3966lx/fnR2j9yEnTQ+jjUiuIdlGXwsXHneSztU=
=Yn1L
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--

--===============0773210037==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4

--===============0773210037==--
