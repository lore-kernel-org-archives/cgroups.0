From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v6 00/16] memcg accounting from OpenVZ
Date: Tue, 27 Jul 2021 07:44:49 +0300
Message-ID: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <fdb0666c-7b8e-2062-64f4-5bef64fad950@virtuozzo.com>
 <20210726.225931.53899469422140706.davem@davemloft.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=/+c65/gT4Io1ufXamU1e2psgnYkOi5vjG8kGJF++OHo=; b=Ui+jyG8CSoRsIhhdk
        CgYVGe+dD8MtMbyE9CEOdC4C2Toq4wq6hHORYH5UyU1pz03B+ZK3/1TFXc3+X96ZASFPJ/fWQFcdu
        mFeW/8GMwrtOgRkkMWE3BsNlLXvF5m+1Ntd1aA6IZ9l+D+Kb4qH/GtNobsZES4dxVFFlLZm8/HzNk
        =;
In-Reply-To: <20210726.225931.53899469422140706.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, 0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/27/21 12:59 AM, David Miller wrote:
> 
> This series does not apply cleanly to net-next, please respin.

Dear David,
I found that you have already approved net-related patches of this series and included them into net-next.
So I'll respin v7 without these patches.

Thank you,
	Vasily Averin
