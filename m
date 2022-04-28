From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Date: Thu, 28 Apr 2022 07:37:00 +0300
Message-ID: <ec08a059-2a04-3e9c-cbad-a5af2d2744e0@openvz.org>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz>
 <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org> <YmnFUwhmqJwYGQ5j@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LTNCTDXwD0m5fnU3nRCZyUZ2Z4+nGspg+RVsi3XsvCA=;
        b=D9tvI1Yc8PHKlElRfTCfEiW/GgIxV8hjidcQv77IWEgZ2VsrSnRa1t4dk7eQ47p0IQ
         zPzi4kCwsaFXzkKGmV6K96vHeHOHys/YFeiSaOosFjBpT/HDLwwKL69IoqZSwKCJ6LfZ
         WXdAbqt0h0S57RV/0tyalW9ev1TiDIYbPlXhQe+v+joufiVTjHZ0nAUbqj/nx2T4+7g5
         VMl5r6q+cprizf0qxT0Sw1ck/IJYekUH24djwznD86UB9XPRQ65+gg9INgUHap7lo5Dc
         WlPq9FezKQH9gMBqRlbUDkTZ750ueKUcMLFwtp+LrG81EnQ+dHzI8Y8IDLykpLRvXOBA
         jJlA==
Content-Language: en-US
In-Reply-To: <YmnFUwhmqJwYGQ5j@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 4/28/22 01:36, Roman Gushchin wrote:
> We can point root_mem_cgroup at a statically allocated structure
> on both CONFIG_MEMCG and !CONFIG_MEMCG.
> Does it sound reasonable or I'm missing some important points?

I expect Embedded developers will be highly disagree.
Pointer only should be acceptable for them.

Thank you,
	Vasily Averin
