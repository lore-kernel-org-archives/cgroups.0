From: Qian Cai <qcai-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v21 00/19] per memcg lru lock
Date: Tue, 05 Jan 2021 17:01:37 -0500
Message-ID: <f127c35a34a391d20b05c53c17adeb72464b28ee.camel@redhat.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
         <aebcdd933df3abad378aeafc1a07dfe9bbb25548.camel@redhat.com>
         <CALvZod448Ebw7YE-HVCNXNSbtvTcTvQx+_EqcyxTVd_SZ4ATBA@mail.gmail.com>
         <49be27f2652d4658f80c95bea171142c35513761.camel@redhat.com>
         <alpine.LSU.2.11.2101051326410.6519@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609884109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DCiTIr0SkXb9xXdCM/zdjzsQYQMxU0c5XLqeexCynRw=;
        b=NBkENRmuICr3VYRHCkPxXtB0nOwfFsfgvOu2NyyJ11KvEY7BDlBN+awUXXJzcPv24YVSFW
        GvUZ0TMHu9dvSI5uiJjbsldWisMVifHf/+S7zU89Jdpj1SEhoyNPB4VHPpmpV5gr0+anlA
        Y1e5iKPfPF3NRHfrpMZKIwmT92qEktI=
In-Reply-To: <alpine.LSU.2.11.2101051326410.6519-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel test robot <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydo>

On Tue, 2021-01-05 at 13:35 -0800, Hugh Dickins wrote:
> This patchset went into mmotm 2020-11-16-16-23, so probably linux-next
> on 2020-11-17: you'll have had three trouble-free weeks testing with it
> in, so it's not a likely suspect.  I haven't looked yet at your report,
> to think of a more likely suspect: will do.

Probably my memory was bad then. Unfortunately, I had 2 weeks holidays before
the Thanksgiving as well. I have tried a few times so far and only been able to
reproduce once. Looks nasty...

