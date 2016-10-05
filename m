From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 5 Oct 2016 14:22:06 +0300
Message-ID: <20161005112206.GC9282@leon.nu>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 31, 2016 at 02:07:24PM +0530, Parav Pandit wrote:
> rdmacg: IB/core: rdma controller support
>
> Patch is generated and tested against below Doug's linux-rdma
> git tree.
>
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> Branch: master
>
> Patchset is also compiled and tested against below Tejun's cgroup tree
> using cgroup v2 mode.
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
> Branch: master
>
> Overview:
> Currently user space applications can easily take away all the rdma
> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications in other cgroup or kernel space ULPs may not even get chance
> to allocate any rdma resources. This results into service unavailibility.
>
> RDMA cgroup addresses this issue by allowing resource accounting,
> limit enforcement on per cgroup, per rdma device basis.
>
> RDMA uverbs layer will enforce limits on well defined RDMA verb
> resources without any HCA vendor device driver involvement.
>
> RDMA uverbs layer will not do limit enforcement of HCA hw vendor
> specific resources. Instead rdma cgroup provides set of APIs
> through which vendor specific drivers can do resource accounting
> by making use of rdma cgroup.

Hi Parav,
I want to propose an extension to the RDMA cgroup which can be done as
follow-up patches.

Let's add new global type, which will control whole HCA (for example in percentages). It will
allow natively define new objects without need to introduce them to the user.

This HCA share will be overwritten by specific UVERBS types which you
already defined.

What do you think?

Except this proposal,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Thanks.

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9OJeAAoJEORje4g2clinwwkQAMkFVwiNSyAPTQh5kESJCGrx
LeHju2XSMeqYogYI7aNvNEO3J12Vmzax7u5xPCXjD6ZpZISf/F+sBKZ99UNnw8ZS
/C4UTdYPG4L7hYMVPKJ8dYwZ2O8xuG2N5S1Xe5UrKcjFiqBo6CpUZBBhaZaKdAOf
UVRZyviy2J6pbLYSoyd06US/x8nLdgyoQzfFcQ/+r/M/WKeql3pyT7qRhowRaJ3V
3vmp2Bvp9VET5nuHPe3eJmE5g3LlqRbbSbBWFidJuIW61WyAFBISXJlcW5wbKPCo
zwp5dKeEUI8ORZwVrGWRtZTu3geTzISOo6fVLGZtVrDUnp/znCu6kon8/0UtzlJE
TsR0AiTCzRVYEL4FITl4g9aoxDZrgBPB+ZaGAyWSOZxkhekhJI3ktXYmQ1SyUp2X
ms60OUXiSTdsSTRPtd+1ACxos89rFjQzM+ReMegmWfPpEMiE9uRU/szpslN2cNCr
zRNtdJ/f/icvnNHbY0rZxRfJO+lnRTrZxTPuhiSUZrmACwk4hCQcEdaVPCzZkkyF
M18sV32TzZQDcDyLzJwrT5R/ew8wz0ICmV7huEp5IhYc9DKCrN0lZ1zZbvv3rH7x
QUwYg2KZqdiG/vt0QIUFCmDNQxR9cWFRs9RoseFwD3T800BXzXGUXsYPGHNfpmAm
jTLHuKOZ29kjWVs/HkGv
=rHQX
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
