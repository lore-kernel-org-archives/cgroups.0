From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Thu, 7 Jan 2016 15:41:10 -0500
Message-ID: <20160107204110.GH1898@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
 <20160105220128.GJ5995@mtj.duckdns.org>
 <CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
 <20160107152936.GE29797@mtj.duckdns.org>
 <CAG53R5Vg9jULp9EU23yd+iUqMDyTMNmUycD8ygX_j98O=JUDmA@mail.gmail.com>
 <20160107202818.GF1898@mtj.duckdns.org>
 <CAG53R5UuCNwCKWAuub=n3FkJR6Z5oyF6cVPeW=5nk-JrURY=jw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=13Vv00/bCjlcfnuWvkXSFsfS2wx8lcd+zdwAzxSpmdU=;
        b=rAgciwvv8xg2u+79U4vqdSkIU0+9EFIyPKd9sOH/KvH4BaH/dCY8nHCHLfVshZ62Jl
         9/wl37oIYM5Be7cf+FdBkJnqLc+FB1ifRH+aJ1jJ4ih26M/G8NDjlolJKdlrxAqvaIxG
         WtyBUA9OKui2PibSpDFW8V33IMqqfaVOuihO94pNl3WFdqBx+lXGbOHAMtJeEf/RKRiv
         jJANdzTIOQjqwNvETKIMCXZXxtIEPz7ntKsoAJdK9u2uc/R6CfntbbA/vACmGpHn3bNL
         1mbKB//Kc7lQw6eJo27vyZ1u34YKPNce2uI8eD2TgdwDWSA5J0+L+OJtTVQz0LFhR9cC
         zH4g==
Content-Disposition: inline
In-Reply-To: <CAG53R5UuCNwCKWAuub=n3FkJR6Z5oyF6cVPeW=5nk-JrURY=jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Fri, Jan 08, 2016 at 02:09:23AM +0530, Parav Pandit wrote:
> > Hmmm, what happens after the following?
> >
> > 1. A process allocates some rdma resources and get registered on the
> >    hash table.
> >
> > 2. The process gets migrated to a different cgroup.
> >
> > 3. The process allocates more rdma resources.
> >
> > Which cgroup would the resources from #3 be attributed to?
> 
> Since the pid/tgid of the process doesn't change in step_3, it
> allocates from original cgroup of step_1.

It shouldn't work that way.

> However in next patch V2, as described below, since IB resource will
> store rdma_cg pointer,
> in step_3, new resource will be allocated from new cgroup.
> old resource will be freed from older cgroup.
> This is what you are expecting, right?

Yeap.

Thanks.

-- 
tejun
