From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting for veth queues
Date: Wed, 27 Apr 2022 09:58:54 -0700
Message-ID: <20220427095854.79554fab@kernel.org>
References: <1c338b99-8133-6126-2ff2-94a4d3f26451@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651078736;
        bh=FmfW5mMXWhX2Mi+Sbzj2wt7tROQxvWHwctYg2Qae4Bs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kJEVq7HesLGTQJq0kIoH1ndsPmZ40qDReAmWZS3ti4uUl2G/kn9RMhEPqshgxYuMF
         lGJaIqTtcb4mcnCDfdf/OonSC6z2Af/PcKHGWs98w32UM1488iy1uz+ZNYkWwRKJa6
         b+D7b6pS34Y6LmzCkItPYwixCmyXYgCoCyUF/FsOsl6rXGCVi2pR60nKFZZWOS5mXC
         CevsIgWlc1zSpToivy+avqALh9jYDmynXs7DtjEErefOuq0UZ1/xaFJMGTqJ3GQ8pa
         b5DVuBoD+dssYoLYK2Hfdmz9EE5QREy9P5CNDR9GAtoh18aG/O8Bx0Z4rzDpM5zw+Z
         Iyd+tjZb5I7tg==
In-Reply-To: <1c338b99-8133-6126-2ff2-94a4d3f26451-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, 27 Apr 2022 13:34:29 +0300 Vasily Averin wrote:
> Subject: [PATCH] memcg: enable accounting for veth queues

This is a pure networking patch, right? The prefix should be "net: ",
I think.

> veth netdevice defines own rx queues and allocates array containing
> up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
> is quite huge and should be accounted to memcg.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
