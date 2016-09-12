From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 12 Sep 2016 08:07:17 +0300
Message-ID: <20160912050717.GE8812@leon.nu>
References: <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160911175235.GB13442-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 11, 2016 at 11:52:35AM -0600, Jason Gunthorpe wrote:
> On Sun, Sep 11, 2016 at 07:24:45PM +0200, Christoph Hellwig wrote:
> > > > > I've posted some initial work toward a) a while ago, and once we
> > >
> > > Did it get merged? Do you have a pointer?
> >
> > http://www.spinics.net/lists/linux-rdma/msg31958.html
>
> Right, I remember that. Certainly the right direction
>
> > > However, everything under verbs is not straightforward. The files in
> > > userspace are not copies...
> > >
> > > user:
> > >
> > > struct ibv_query_device {
> > >        __u32 command;
> > >        __u16 in_words;
> > >        __u16 out_words;
> > >        __u64 response;
> > >        __u64 driver_data[0];
> > > };
> > >
> > > kernel:
> > >
> > > struct ib_uverbs_query_device {
> > >         __u64 response;
> > >         __u64 driver_data[0];
> > > };
> >
> > We'll obviously need different strutures for the libibvers API
> > and the kernel interface in this case, and we'll need to figure out
> > how to properly translate them.  I think a cast, plus compile time
> > type checking ala BUILD_BUG_ON is the way to go.
>
> I'm not sure I follow, which would I cast?
>
> BUILD_BUG_ON(sizeof(ibv_query_device) == sizeof(ib_uverbs_cmd_hdr) +
>              sizeof(ib_uverbs_query_device))
>
> ?
>
> > > I'm thinking the best way forward might be to use a script and
> > > transform userspace into:
> > >
> > > struct ibv_query_device {
> > > 	struct ib_uverbs_cmd_hdr hdr;
> > > 	struct ib_uverbs_query_device cmd;
> > > };
> >
> > That would break the users of the interface.
>
> Sorry, I mean doing this inside rdma-plumbing. Since the change is ABI
> identical the modified libibverbs would still be binary compatible
> with all providers but not source compatible. Since all kernel
> supported providers are in rdma-plumbing we can add the '.cmd.' at the
> same time.
>
> The kernel uapi header would stay the same.
>
> > However automatically generating the user ABI from the kernel one
> > might still be a good idea in the long run.
>
> My preference would be to try and use the kernel headers directly.

I thought the same, especially after realizing that they are almost
copy/paste from the vendor *-abi.h files.

>
> Jason

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1jgFAAoJEORje4g2clinwkMP/11uVCZnr++BF25V91qYAo8R
5f9mGW8KTRYAVNr8eEmsN7/BV1sjKxzeznHYgQ6HRiezOOMzcRGbFgSwujYSoo9m
+X2t2ynpD/Y6zco95+GrGPHjoznWk9Stc7ME00jFaON2Inzpzi2SiPSCXvgF4zF2
+woXeW1UHxk5VSQaZlLDlHBFRFvZciVkU9SKN1z8zvuUPjVqgHzlrhhvTU9hiMRy
VPLXGu34bqtZqsKByDZc34zgh0b1EhxCYl8x3cIjisrL9UWpmKtOPzaRkVtDuUxb
o/iBnoiwaS3/4+RjBSaHb/e9IxmZtUVwfgcd6hOUSKgoTyvD0ra9U27nBWqDbtLW
9ogMbUK9lHxAba+zy64DcZt76s4K6hw4fcaTBrG5Zye4sQt6gArodQteHJB7ier3
9ABeYpMkYrVE/BLUBowixYGIl3i24YQmM2ZxD50kpRxMu8Lv57NN/EzTLlQV3klr
O0cGi42TDw+9zdkpszxfXfBEVB/tv8M7Z1vN90x3t/HIek7nKGvZsEpOTV4/ODze
FgCs5ajuuau8s3WW8CqvwT0YxKpYEKTfcJ+SNnvmCClPSLi4E5Q5lUssEDWRkzJX
nYD1OZL4g/ScGaUnTa6G6rTbLj+Iq2UPq6ybywI7gUdq+igh0icMqcTucqrHaFYq
+B98vS847xmahqYy/y+U
=TV33
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
