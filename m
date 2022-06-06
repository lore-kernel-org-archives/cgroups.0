From: Qian Cai <quic_qiancai-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH memcg v6] net: set proper memcg for net_init hooks
 allocations
Date: Mon, 6 Jun 2022 14:43:38 -0400
Message-ID: <Yp5K2iupKdVdQXUc@qian>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org>
 <Yp4F6n2Ie32re7Ed@qian>
 <0e714a5a-d2ed-9b44-fdbe-04b5595165da@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654541023; x=1686077023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zBGk5qIFMqfmDlZW092e3SVIsz61LPw9vTaFM7k3klM=;
  b=orIbPEgg2DQ6ZywvWiICzRipAfzZvFmhWlFY1h686HxZICe0IxqzQxKa
   1l6aWalGQ65yCRbXnglPxVEZfP9OCw7TwY9KYQdRikzNsIhMxHLq967+F
   yuVbg9bvVRgsEvnJYatEMGVHbKYhWjuKeJkz2G+XY+Qqqb6wQDrL+iB2f
   s=;
Content-Disposition: inline
In-Reply-To: <0e714a5a-d2ed-9b44-fdbe-04b5595165da-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 06, 2022 at 08:37:26PM +0300, Vasily Averin wrote:
> On 6/6/22 16:49, Qian Cai wrote:
> > This triggers a few boot warnings like those.
> > 
> >  virt_to_phys used for non-linear address: ffffd8efe2d2fe00 (init_net)
> >  WARNING: CPU: 87 PID: 3170 at arch/arm64/mm/physaddr.c:12 __virt_to_phys
> 
> Thank you for reporting the problem,
> Could you please provide me your config file via private email?

$ make ARCH=arm64 defconfig debug.config
