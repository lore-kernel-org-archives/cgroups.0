From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 10:09:12 -0400
Message-ID: <20150505140912.GQ1971@htj.duckdns.org>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=L043/NIYsahbv/XcbulgqROzyG3cGs3DCYQ29YeJLcI=;
        b=LdpnH5d3Eekdi/RHTEMJbBkcAdPEkWVqiVnw3jWTxrWvnZF80X8Wgv4N5TYPrto9VU
         uuyrWK1BH/Xsh9uxdiimLd0pkD5T9qK+2xeP+Z7Wk8YwtShqUzt7dfIiTNbUOVGFF18C
         x8yZYYONA9bwnZK7Ww6E2EIZv84q+6DfDfuFVH1ytvQttV1Jnb+2j4xaXjYsPZ3QRp0b
         z7yYCfjuvx9OZday7QEJVTCO4l6OCQaZD1IZdUqH5hcmHJgIcqsyW/dNRjgFV8mYLinD
         xq4/7kYmXcimnTz/0RNZ/JIYF7SWHy6Y4AP+lfZs0x/Grp1jozSHA3nkeKVCoici1soF
         XPBQ==
Content-Disposition: inline
In-Reply-To: <1430717964.3129.62.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Mike.

On Mon, May 04, 2015 at 07:39:24AM +0200, Mike Galbraith wrote:
> > > Some degree of flexibility is provided so that you may disable some controllers
> > > in a subtree. For example:
> > > 
> > > root                  ---> child1
> > > (cpuset,memory,cpu)        (cpuset,memory)
> > >                       \
> > >                        \-> child2
> > >                            (cpu)
> > 
> > Whew, that's a relief.  Thanks.
> 
> But somehow I'm not feeling a whole lot better.
> 
> "May" means if you don't explicitly take some action to disable group
> scheduling, you get it (I don't care if I have an off button), but that

In the new interface, hierarchy setup and controller configuration are
two separate steps.  Creating subhierarchy doesn't enable controller
automatically and as long as specific controllers are concerned
nothing changes when subhierarchy is created and processes are moved
inbetween them.  If control over specific resources is necessary in a
given hierarchy, the matching controllers should be enabled
explicitly.

Thanks.

-- 
tejun
