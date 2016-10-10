From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 10 Oct 2016 07:46:23 +0300
Message-ID: <20161010044623.GI9282@leon.nu>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu>
 <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="b2u6xDyV6U2OU5E0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--b2u6xDyV6U2OU5E0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 06, 2016 at 07:19:24PM +0530, Parav Pandit wrote:
> Hi Leon,
>
> On Wed, Oct 5, 2016 at 4:52 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, Aug 31, 2016 at 02:07:24PM +0530, Parav Pandit wrote:
> >> rdmacg: IB/core: rdma controller support
> >>
> >> Overview:
> >> Currently user space applications can easily take away all the rdma
> >> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> >> applications in other cgroup or kernel space ULPs may not even get chance
> >> to allocate any rdma resources. This results into service unavailibility.
> >>
> >> RDMA cgroup addresses this issue by allowing resource accounting,
> >> limit enforcement on per cgroup, per rdma device basis.
> >>
> >> RDMA uverbs layer will enforce limits on well defined RDMA verb
> >> resources without any HCA vendor device driver involvement.
> >>
> >> RDMA uverbs layer will not do limit enforcement of HCA hw vendor
> >> specific resources. Instead rdma cgroup provides set of APIs
> >> through which vendor specific drivers can do resource accounting
> >> by making use of rdma cgroup.
> >
> > Hi Parav,
> > I want to propose an extension to the RDMA cgroup which can be done as
> > follow-up patches.
> >
> > Let's add new global type, which will control whole HCA (for example in percentages). It will
> > allow natively define new objects without need to introduce them to the user.
> >
> In other cgroup such as CPU, this is done using cpu.weight API. Where
> percentage or weight is configured by the user.
> In this mode, resources taken away from other cgroup proportionately.
> It works for cpu because its mainly stateless resource unlike rdma
> resources.
> So if we want to simplify user configuration similarly,
> percentage/weight configuration can be extended.
> This way they need not be introduced to users.
> I hope your definition of "user" is actual end-user and not rdma cgroup. Right?

Yes, "user" -> "admin".
I think that percentage is more intuitive to them and will be much easier to
explain how to use it. I always have in mind "swappiness" field and the
numerous questions on how to configure it.

> In other words, new object should be still added as new enum value in
> rdma_cgroup.h?

Yes, I had in mind something like IB_CGROUP_HCA, this is why it can be
done as a future work after accepting current patches.

> Only than it can be overwritten by specific UVERBs type as you
> described below. I think thats what you meant as you described below.

Exactly.

>
> Otherwise charging/uncharging this new percentage resource can get messy.

Agree

>
> > This HCA share will be overwritten by specific UVERBS types which you
> > already defined.
> >
> > What do you think?
>
> So to refine your proposal from cgroup perspective, instead of adding
> new resource type in rdma_cgroup.h for percentage, I prefer to have
>
> Existing
> 1. rdma.max
> 2. rdma.current
> New,
> 3. rdma.weight
> This ABI will have similar API to say
> echo "mlx4_0 50" > rdma.weight.
> Where 50 is weight of the resources.
> For example,
> for one cgroup instance weight=sum=100% resource for a given cgroup.
> for three cgroup instances percentage=(weight/sum)% = 50/(50+50+50) = 33%.
> One cgroup gets 33% resource.
>
> Weight can be in range of 1 to 10,000 similar to cpu cgroup.

This is exactly what I don't like, the percentage will remove from the
user the translation needs between weight and actual limitation.

IMHO CPU used weights because everything there is in weights :).

>
> This might work if applications running in all cgroups are similar.
> But weight doesn't do justice, when there are different type of
> applications running in each cgroup. Such as few running libfabric
> based apps, few running MPI, others directly using ibverbs.
> So as you said rdma.max configuration would be required for management
> plane to override weight (percentage) for certain resources.

Why?
The device exposes max values during initialization and if user asked
for 20% percent of HCA, he will get max*0.2.

>
>
> >
> > Except this proposal,
> > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--b2u6xDyV6U2OU5E0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+x0fAAoJEORje4g2clincRkQAJ+aamCtHVvP47/oKhA/+WWQ
M0XX+3djyw/JVKylYPQTQAJh4EydRZ7YoliRV+82zyvru3vLiBsvBnfee9ky33an
OWLKbZgfVXbv4Jv026KbTkma0VGRB1/51JG3k9ZLcdM1k2WppUcUsj1PE8AQCSvG
GvmWvEWA1XPWdT9lTyXFn+DILFIcryAV3DXIZ8GzM+51FBKeaoQegJ3KjFQ3/jJ6
gEXPI4hEphYbo33eryqEEL8en93FmLaDP5eG9HGEpcQ8JPwuFNDEt4uHfDWWFqhE
nsl7mmk3l6VK5KfE/4F7h+rm3Bv8CYE3xc0YHyU+ygRPkiOHCUAoyB/qH7Mm2lAo
U526MrRzCVG9q46qKrJVzDSwvD2mjq0WM9UlAIAl8pJiisZtE2d38BXsMTMjc0uN
EIg2vtSP24WnqnUSPI3CH6VP7V0La1RCOfD546NrATgzTyoK4bFs+vR7s20kdLjN
y20Z1RZVMd4bBtLZySQ/iYO150vYfH3OVs6UTZ3b5rWK6q0A3fumt48F5Jb8n1Jo
+OKm2amcaexSBaeKOcML084dbAztXLbu6o/6sQKKifQrjPqn64xX2uLHnsmdd5hb
1kp/WuOKlxq0p3kZmCHNMZA9N0Apl9cdXOniMhMDvEVnKFjcm7ooixX1BPB5/ICG
fLdp6IAfA8bsXHOknxhB
=cPhA
-----END PGP SIGNATURE-----

--b2u6xDyV6U2OU5E0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
