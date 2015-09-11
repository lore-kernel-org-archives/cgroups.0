From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 15:05:34 -0400
Message-ID: <20150911190534.GT8114@mtj.duckdns.org>
References: <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
 <55F25781.20308@redhat.com>
 <20150911145213.GQ8114@mtj.duckdns.org>
 <CAG53R5X5o8hJX1VJ00j5Bxuaps3FGCPNss4ey-07Dq+XP8xoBg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Zin/vS1cfseuKV8Y5yGC3eLzNmdFb1pEvwhwAKbf2O8=;
        b=vR3NhwZis/gr3RqfzKcCml16NHtop+o8Xh8I7/IuGiP/hnJ74gHGn55z1ZvgkwB3VI
         ypKggAadaFgpwIt9w6FDq1yamBKnjiECyTCzpRLeMkrxQgnsv2IVcv9s0nKZ1MAPm06e
         GjGDAThv+V0rllLjDC8FrhcW54gqRl0odwTQ1vU362/I64vqqsC6fn4inEEkXAuRUdDs
         xiBBdZsEknpkGg4/07emY7dcATBqzJMf/h3QlhBnvWOzCfdub0nou2PpZQnLSDja+6I4
         5btP+ZHI3q8m/5X1zTmXH8FaoAWcI4n2TExXiNQMeBDBLNfzjbxlY/0ZVQQidH3RyPRA
         2xxg==
Content-Disposition: inline
In-Reply-To: <CAG53R5X5o8hJX1VJ00j5Bxuaps3FGCPNss4ey-07Dq+XP8xoBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Fri, Sep 11, 2015 at 10:17:42PM +0530, Parav Pandit wrote:
> IO controller and applications are mature in nature.
> When IO controller throttles the IO, applications are pretty mature
> where if IO takes longer to complete, there is possibly almost no way
> to cancel the system call or rather application might not want to
> cancel the IO at least the non asynchronous one.

I was more talking about the fact that they allow resources to be
consumed when they aren't contended.

> So application just notice lower performance than throttled way.
> Its really not possible at RDMA level with RDMA resource to hold up
> resource creation call for longer time, because reusing existing
> resource with failed status can likely to give better performance.
> As Doug explained in his example, many RDMA resources as its been used
> by applications are relatively long lived. So holding ups resource
> creation while its taken by other process will certainly will look bad
> on application performance front compare to returning failure and
> reusing existing one once its available or once new one is available.

I'm not really sold on the idea that this can be used to implement
performance based resource distribution.  I'll write more about that
on the other subthread.

Thanks.

-- 
tejun
