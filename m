From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 11/28] x85/sgx: Return the number of EPC pages that
 were successfully reclaimed
Date: Mon, 31 Jul 2023 11:10:55 +0000
Message-ID: <CUGB8HJ4IYB9.1VVYV9GK75UYX@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-12-haitao.huang@linux.intel.com>
 <ZMUKd7KY6Kquubjf@duo.ucw.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690801861;
        bh=GQE4ikJOGvMhp7gKtfrRyBB/OigQHtCUYCx9FoUAlLg=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=c+5iI4lBI1Xr9Q6XgHXyYMgH7oUBx77jiwy8HUfsDonzUm3db0QulCo65lQZsc8z+
         nboML0pAKixv0122Jd994M03a17edVOcADc4PO1XrXlJYoyeBaXt2NUKWDSrDau2Zn
         GezQAPLMzstIeqp0hm4UIGUVXM2XVVmXCZhehBnHVDFOKZkWhZXhl8XPtxsgQ6v+fe
         Ma/G2MSniOQNEY7Mst43pQWrr5k4qTh2GlNuOAGS4WIx7+UPem1oqBmX08c4lckeOp
         osm1Rug37jBNdHdOpauhHvqBBvA0t4gFQYQYQeE04fG2cETavr1hxmQ6YVutpXFH39
         xxqsBqNSBtCxw==
In-Reply-To: <ZMUKd7KY6Kquubjf-1kjADaKPMenrBKCeMvbIDA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sat Jul 29, 2023 at 12:47 PM UTC, Pavel Machek wrote:
> Hi!
>
> > From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > Return the number of reclaimed pages from sgx_reclaim_pages(), the EPC
> > cgroup will use the result to track the success rate of its reclaim
> > calls, e.g. to escalate to a more forceful reclaiming mode if
> > necessary.
>
> Subject says x85. While some would love to see support of Linux on
> Intel 8085, I guess it should be x86.

hmm... that could potentially be also a step towards also to zilog z80
compatibility :-)

BR, Jarkko
