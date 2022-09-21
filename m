From: Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Wed, 21 Sep 2022 17:44:56 +0300
Message-ID: <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g@mail.gmail.com>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org> <20220918092849.GA10314@u164.east.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Lf5LYGsOy9w2pimVzOjMT59tZyyzJccX8FyNGOapJA0=;
        b=nXuWLyoKm9JEsGeMZHprR8y8IhAFmuvphrPxBHz/Xe5VA82lKthn7sQH/IQ4pFuQCY
         A/sYFvdbT3PmD7QhE2+guMQK6nzbxlyV4Nt349nGlH7klhpKze03D7MPScpGXKMzlFcQ
         L3GQdwb9xY5hSUaq4OZmJPextDDtBJgLobgg7SjzqLr2FKQeW0vw6LqhWLDReX5Hbdt7
         mW+1BQEEY7S1m3L65FcmTW6Z5Vh4c3KpwyUL3nrjoo6HJJQ2cKPKmFoDj8FQU9Q9RBMA
         jrIGdiT7n3nGon9Cpp2kh55bz9VNZGEiu6S5eZRSZeSKo7DrBm5kiyPLhUSTxRCI9qhk
         fAtg==
In-Reply-To: <20220918092849.GA10314-DK4qA7C3Vp/Dd9xlW2Tctw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sparc kernel list <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Sep 18, 2022 at 12:39 PM Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
> I'm unable to boot my sparc64 VM anymore (5.19 still boots, 6.0-rc1 does not),
> bisected up to this patch,
>
> mator@ttip:~/linux-2.6$ git bisect bad
> 1d0403d20f6c281cb3d14c5f1db5317caeec48e9 is the first bad commit
> commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9

reverting this patch makes my sparc64 box boot successfully.

mator@ttip:~$ uname -a
Linux ttip 6.0.0-rc6-00010-gb7f0f527dc3c #377 SMP Wed Sep 21 17:34:50
MSK 2022 sparc64 GNU/Linux
