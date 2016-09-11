From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 11 Sep 2016 17:35:22 +0300
Message-ID: <20160911143522.GL6415@leon.nu>
References: <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
 <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org>
 <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OGW1Z2JKiS9bXo17"
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160911133421.GA23384@lst.de>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Matan Barak <matanb@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org


--OGW1Z2JKiS9bXo17
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 11, 2016 at 03:34:21PM +0200, Christoph Hellwig wrote:
> On Sat, Sep 10, 2016 at 11:01:51AM -0600, Jason Gunthorpe wrote:
> > Sadly, it isn't a step backwards, it is status quo - at least as far
> > as the uapi is concerned.
>
> Sort of, see below:
>
> > struct mlx5_create_cq {
> >         struct ibv_create_cq            ibv_cmd;
> >         __u64                           buf_addr;
> >         __u64                           db_addr;
> >         __u32				cqe_size;
> > };
> >
> > struct iwch_create_cq {
> >         struct ibv_create_cq ibv_cmd;
> >         uint64_t user_rptr_addr;
> > };
> >
> > Love to hear ideas on a way forward that doesn't involve rewriting
> > everything :(
>
> We stil always have the common structure first.  And at least for
> cgroups supports that's what matters.
>
> Re the actual structures - we'll really need to make sure we
>
>  a) expose proper userspace abi headers in the kernel for all code
>     in the RDMA subsystem
>  b) actually use that in the userspace components
>
> I've posted some initial work toward a) a while ago, and once we
> agree on adopting your common repo I'd really like to start through
> with that work.  I think it's a pre-requisite for any major new
> userspace ABI work.

I started to work on it over weekend and it is worth do not do same work twice.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OGW1Z2JKiS9bXo17
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1WuqAAoJEORje4g2clinfoQP/3M+kGCupijOyPSS3+GMh3q/
+DTtqRdLLAl3eKjYRCGmV5P2du0JxBdTAMKa8VlEoZxjZySLaiCCb6PdHZ3ct4+y
mb1G5Q2gwoZVtxMI3ba7HNa1Oveh+q/svtHrtojzgTBf8Y5k5YKqm7KpjQt64Rl+
3gPe112BiCg/sQ0yxFyd7G8VWmICdO1gbTSyM7ZjoM1wVlZPPXc8Q/3NgeDPP+Ir
I+EQB1gSml6Rgb4Ka0TGIJPF0F9RxwfEgW+PdDIf4THgAAQK8uBnwiVzcOEsdR6c
KBsVZFDZiX4/P1XugWb5slKJd3sE90VBqOvGGArBMANxbktI4NaTQ4bUkxPRPDJU
5KMV8EzVRxsvK9vLHg+9Qw51E+i5n11GtbG/c29t/hcVPeX2J1BnRg+OOACQiN+1
WJmOi6SLgp5ZpHaNIuOREJpdPPyltieopUJP0i2o67BTIRi6dtM8YGN7nVFVV0YY
QRhki3JiMGzRKhmjS1o6SZ9Qsz3+/8n0y38QU6TgcK3JnDXNIYKJTsY3bN7M5uuN
wRevrZIEgVwu/xMCUpBaATeBwmYV6SJSWR3fzOQWQmxvItsnDlYXss/zivrX5FDO
pr3xfH9ku3vlChhqwoXZGqeuUusOicCMGpxkuFyc/hntcd6j7bPzOzVODClIHuUR
Nz7oQ/JE4Jm78WD9errv
=+G9z
-----END PGP SIGNATURE-----

--OGW1Z2JKiS9bXo17--
