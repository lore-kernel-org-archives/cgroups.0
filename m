From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Thu, 7 Jan 2016 10:07:18 -0500
Message-ID: <20160107150718.GC29797@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <20160105215623.GH5995@mtj.duckdns.org>
 <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TxP1DEf//Vw9U3/w3Fz9uXO9DzDy5z9Zr4s8US8OlYM=;
        b=j62HfnqgU6hH+dO/T43IML4hSSnUJxt/DQR9yJLCSGhotDWqjxLgQ/BffKA63xMeKO
         igu+MT1HmlFJHBo+XujrIopisoj2L4afU3ojC9Bj38hS6I2ya9fbPWOAljTKSojMvCNn
         KX1G11DDQHMTEnOhcfkIlew2mqgKG4eEIB5KDAVWopooyLHJqMuhZT/TPwmJhcCwoF1D
         wSho2uIeCdztHfuRQ3f2Zr6w7gXpIb8SrBpyL3Mn/6tJRYY0rCriQqw9YwmytxUU78h3
         MxPw6VzQED22Hsc+fagsWbpX2mKcTV7jeBATVbBVWo55XqLo+xBfSOWEGFKQN3xxOQ1y
         YQKg==
Content-Disposition: inline
In-Reply-To: <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Thu, Jan 07, 2016 at 04:43:20AM +0530, Parav Pandit wrote:
> > If different controllers can't agree upon the
> > same set of resources, which probably is a pretty good sign that this
> > isn't too well thought out to begin with,
> 
> When you said "different controller" you meant "different hw vendors", right?
> Or you meant, rdma, mem, cpu as controller here?

Different hw vendors.

> > at least make all resource
> > types defined by the controller itself and let the controllers enable
> > them selectively.
> >
> In this V1 patch, resource is defined by the IB stack and rdma cgroup
> is facilitator for same.
> By doing so, IB stack modules can define new resource without really
> making changes to cgroup.
> This design also allows hw vendors to define their own resources which
> will be reviewed in rdma mailing list anway.
> The idea is different hw versions can have different resource support,
> so the whole intention is not about defining different resource but
> rather enabling it.
> But yes, I equally agree that by doing so, different hw controller
> vendors can define different hw resources.

How many vendors and resources are we talking about?  What I was
trying to say was that unless the number is extremely high, it'd be
far simpler to hard code them in the rdma controller and let drivers
enable the ones which apply to them.  It would require updating the
rdma cgroup controller to add new resource types but I think that'd
actually be an upside, not down.  There needs to be some checks and
balances against adding new resource types; otherwise, it'll soon
become a mess.

Thanks.

-- 
tejun
