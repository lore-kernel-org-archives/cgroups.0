From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 15 Sep 2016 21:56:29 +0300
Message-ID: <20160915185629.GF26069@leon.nu>
References: <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de>
 <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PgLV2f+xYr9y+IUc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--PgLV2f+xYr9y+IUc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 12:36:19PM +0530, Parav Pandit wrote:
> Hi Dennis,
>
> Do you know how would HFI1 driver would work along with rdma cgroup?
>
> Hi Matan, Leon, Jason,
> Apart from HFI1, is there any other concern?
> Or Patch is good to go?

I didn't review it yet :(.
Sorry

>
> 4.8 dates are close by (2 weeks) and there are two git trees involved
> (that might cause merge error to Linus) so if there are no issues, I
> would like to make request to Doug to consider it for 4.8 early on.
>
> Parav
>
> On Mon, Sep 12, 2016 at 10:37 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Sun, Sep 11, 2016 at 11:52:35AM -0600, Jason Gunthorpe wrote:
> >> On Sun, Sep 11, 2016 at 07:24:45PM +0200, Christoph Hellwig wrote:
> >> > > > > I've posted some initial work toward a) a while ago, and once we
> >> > >
> >> > > Did it get merged? Do you have a pointer?
> >> >
> >> > http://www.spinics.net/lists/linux-rdma/msg31958.html
> >>
> >> Right, I remember that. Certainly the right direction
> >>
> >> > > However, everything under verbs is not straightforward. The files in
> >> > > userspace are not copies...
> >> > >
> >> > > user:
> >> > >
> >> > > struct ibv_query_device {
> >> > >        __u32 command;
> >> > >        __u16 in_words;
> >> > >        __u16 out_words;
> >> > >        __u64 response;
> >> > >        __u64 driver_data[0];
> >> > > };
> >> > >
> >> > > kernel:
> >> > >
> >> > > struct ib_uverbs_query_device {
> >> > >         __u64 response;
> >> > >         __u64 driver_data[0];
> >> > > };
> >> >
> >> > We'll obviously need different strutures for the libibvers API
> >> > and the kernel interface in this case, and we'll need to figure out
> >> > how to properly translate them.  I think a cast, plus compile time
> >> > type checking ala BUILD_BUG_ON is the way to go.
> >>
> >> I'm not sure I follow, which would I cast?
> >>
> >> BUILD_BUG_ON(sizeof(ibv_query_device) == sizeof(ib_uverbs_cmd_hdr) +
> >>              sizeof(ib_uverbs_query_device))
> >>
> >> ?
> >>
> >> > > I'm thinking the best way forward might be to use a script and
> >> > > transform userspace into:
> >> > >
> >> > > struct ibv_query_device {
> >> > >   struct ib_uverbs_cmd_hdr hdr;
> >> > >   struct ib_uverbs_query_device cmd;
> >> > > };
> >> >
> >> > That would break the users of the interface.
> >>
> >> Sorry, I mean doing this inside rdma-plumbing. Since the change is ABI
> >> identical the modified libibverbs would still be binary compatible
> >> with all providers but not source compatible. Since all kernel
> >> supported providers are in rdma-plumbing we can add the '.cmd.' at the
> >> same time.
> >>
> >> The kernel uapi header would stay the same.
> >>
> >> > However automatically generating the user ABI from the kernel one
> >> > might still be a good idea in the long run.
> >>
> >> My preference would be to try and use the kernel headers directly.
> >
> > I thought the same, especially after realizing that they are almost
> > copy/paste from the vendor *-abi.h files.
> >
> >>
> >> Jason

--PgLV2f+xYr9y+IUc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2u7dAAoJEORje4g2clinAUwP/A7JrZrRHCi4FWn0NSNJiwsX
epNvRd3PUZMasAy0a1d41kbnmhnjpeor/nOlgg9DP0zjLkRnD1MsQAQZxoI6q1XW
6CCBqqbQVeMH43v51y8H9BYA4RdRPX1UdJidxrfsgkQrQt7kwmUaCdAZ3duzpfc8
r0PlA6xBJ+jbhh93kuZM9YqRU8duNWoLVm94qs8In4NG+cNgiBz18I50qyKP5VIa
EiBkUblJcsQaamg62IYXQYeJL/LvXo2FKY899SL1kag4XmjnwxTvRqpBwk3VgCZu
LbTDQC4gX9d3XZywh+qMO0GkC6GSeJwWtjJrQo+xuDalcFRMj9aLJbpfIIU+Jetc
aSN88W6XJOZeXdlvOR/dx3af0YDpmkRWzvnREWUokJE7EFI21AxOAGNjKD/mqkZ3
D4I5BgBSgRm8atjCQpkRJf03SK/FZIJ//eq8n7hi/H5Qa/IPBj6oy8uCIUdKSXA4
oRj3266En88ZND/rswjLP4v5bDGUAdX7LZYMgm6V4+yHRi3azdgUWXdp5KOKN8xX
2o4K2UPkVMlMqHE0PAmSErWUG/BFWuNrYz8rRdCL2JpIR3K3eq+kC51PgcsYbmWC
pFwdq6mgDPtuesDIdUK43L7DDmy1irFmfGwdLK6iXCvhdYbiQgD6ShiJlmB7sfFT
6KIjXBN7rcWHTW61KiPR
=mvEC
-----END PGP SIGNATURE-----

--PgLV2f+xYr9y+IUc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
