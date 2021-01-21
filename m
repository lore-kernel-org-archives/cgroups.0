From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH 00/10] docs: cgroup nits and fixes
Date: Thu, 21 Jan 2021 11:42:48 -0700
Message-ID: <20210121114248.1c60c394@lwn.net>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
        <YAhdwtMS98iPma+S@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 96974615D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1611254569; bh=KxfdKf8J8tSGmZBq7yUG1lQFeXM6uq332DkLkZd7fX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RiCC6D6hJcmhA73DYZ9EDpdyYi7l9DJ+s/6X+ShfHRxUdJ0YlVFWKaYHLmwvVmgbT
         w4Zz225icshrnee3FBiQ60Mlud887sRzamj0xhfGjEXRMGUMU76VfKvkyPHwtA8a1M
         V2N0Xo2kPQeej5Bf849DoW6Q1P7lVEQWmXGfZkk7o4g7Dne0uYsRNiprEi/I/KA2EY
         h+8J0F98aqslMz1BGRVUl5d/PYhFY2xhVoeCcSlqmIqxQcUhm1Pj4B0GYzfMndKrk/
         IPaPJwZSJL5Avg6PrhyKkAK9s2bhWynEmOPuZldsLbgPpFvOTZJrO2D7DTjjJ7HJnj
         k+zC1l/gXD3Iw==
In-Reply-To: <YAhdwtMS98iPma+S-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 20 Jan 2021 11:43:46 -0500
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> For the series,
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> I suppose it'd be best to route this through the doc tree?

Works for me.

I've applied the set with the exception of #4, which still seems
unnecessary to me; Kir, I can reconsider that if you want to argue the
case.

Thanks,

jon
