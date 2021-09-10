From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] support cgroup pool in v1
Date: Fri, 10 Sep 2021 06:49:27 -1000
Message-ID: <YTuMl+cC6FyA/Hsv@slm.duckdns.org>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <YTiugxO0cDge47x6@kroah.com>
 <a0c67d71-8045-d8b6-40c2-39f2603ec7c1@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ycLk39mqr2VW20gmuwiS1O96iwebvsbUDKPqz1r4HLs=;
        b=SwFAicqGFHYDPBgQbXLMJQ0UcmZY8lvUK61PawM7D0Nd1XWOmic8A7dtlSBGftYXPp
         xi3UTO+1z1xbIjIbsiLJ8Q/9xUUKAh0J4i3hAOX/qhS/9pi0c9P6bG7g8G0gM0uAkb6P
         K7S/4G77KHQ4gsQHrP+7672jpkYyigpoj8a+VGveTJ/c/oUqO6Gd3qDKWw+OVXuKg4IK
         4qcpP/7Ha7F4kKM6LtlzziDVjx5YW6ESH4ILyPv5J8P1YHi9ghGRcFADXvv22+gJsMX0
         P7S2+oxpmBjT4bpeQbiwz4FR8BkP7FZ5aViXGFWZfpnrMbegmWV4S2CLRrM0IKHIePu2
         9anA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a0c67d71-8045-d8b6-40c2-39f2603ec7c1-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

Hello,

On Fri, Sep 10, 2021 at 10:11:53AM +0800, taoyi.ty wrote:
> The scenario is the function computing of the public
> cloud. Each instance of function computing will be
> allocated about 0.1 core cpu and 100M memory. On
> a high-end server, for example, 104 cores and 384G,
> it is normal to create hundreds of containers at the
> same time if burst of requests comes.

This type of use case isn't something cgroup is good at, at least not
currently. The problem is that trying to scale management operations like
creating and destroying cgroups has implications on how each controller is
implemented - we want the hot paths which get used while cgroups are running
actively to be as efficient and scalable as possible even if that requires a
lot of extra preparation and lazy cleanup operations. We don't really want
to push for cgroup creation / destruction efficiency at the cost of hot path
overhead.

This has implications for use cases like you describe. Even if the kernel
pre-prepare cgroups to low latency for cgroup creation, it means that the
system would be doing a *lot* of managerial extra work creating and
destroying cgroups constantly for not much actual work.

Usually, the right solution for this sort of situations is pooling cgroups
from the userspace which usually has a lot better insight into which cgroups
can be recycled and can also adjust the cgroup hierarchy to better fit the
use case (e.g. some rapid-cycling cgroups can benefit from higher-level
resource configurations).

So, it'd be great to make the managerial operations more efficient from
cgroup core side but there are inherent architectural reasons why
rapid-cycling use cases aren't and won't be prioritized.

Thanks.

-- 
tejun
