From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Fri, 21 Oct 2022 10:40:16 -0700
Message-ID: <20221021104016.407cbda9@kernel.org>
References: <20221021160304.1362511-1-kuba@kernel.org>
        <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
        <CANn89iKTi5TYyFOOpgw3P0eTi1Gqn4k-eX+xRTX78Q4sAunm2Q@mail.gmail.com>
        <CALvZod5di3saFdDJ1cwFDgvLPmnEJ7XB9P8YBTJ3uzfBKAFi3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666374017;
        bh=1oenVn7qVDln5aafmQiPCgANd8wRAgIk+bXpPnLDZsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TyiQM07qPB6Cv/z8nDgK0NOV1aJgSDEs1i937iZ1okeKYZ8y3iazAymLSoawO945+
         3XVLXxJMOkYFJ/Q/ZQyp5e2FBLkeW3xFzOn2oKZRC15VsN0rFEefXzaqYfwEPKiej1
         viz9uQhe67D8kMYoNTDZs9+hOu5aVyD77Dl4EAqQ2r72waZCyAyaW8jp/g9A7h/US+
         HpQ5FG096N6H5S8o3aXb3Vxe/BJNmwANKnpHZE6kIU6rwIsgThDgh7iEb/0kw8INzw
         PwaO0GfANQLt4JnlSo/+aH4rhHTtTa3N/wYuGQwgQMkHBkDtwRFzlSX9ao2QYsUKT4
         u27B6ZoIN7V7Q==
In-Reply-To: <CALvZod5di3saFdDJ1cwFDgvLPmnEJ7XB9P8YBTJ3uzfBKAFi3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, 21 Oct 2022 09:34:20 -0700 Shakeel Butt wrote:
> > > How about just using gfp_any() and we can remove gfp_memcg_charge()?  
> >
> > How about keeping gfp_memcg_charge() and adding a comment on its intent ?
> >
> > gfp_any() is very generic :/  

That was my thinking, and I'm not sure what I could put in a comment.
Wouldn't it be some mix of words 'flags', 'memory', 'cgroup' and
'charge'... which is just spelling out the name of the function? 

I mean:

	/* Alloc flags for passing to cgroup socket memory charging */

does not add much value, right? 
