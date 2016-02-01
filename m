From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Mon, 1 Feb 2016 13:40:46 -0500
Message-ID: <20160201184046.GD14091@mtj.duckdns.org>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
 <1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
 <20160130183015.GP32380@htj.duckdns.org>
 <CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
 <20160131100237.GS32380@htj.duckdns.org>
 <CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
 <20160131110420.GV32380@htj.duckdns.org>
 <CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FLzjta3lZAKNl5p+zQ8VmLW6zZ/n2+L+uZk8O4V1V4I=;
        b=q2nuhKC/jJJuZxL5OeWw/banKo4YtkZzIvr2oQpRbDMUpAfnYTHT4L1Ofetbzmn1tS
         QUGBEXT1A5IWrDWTPo0gRTyHwqQJ4YOxofFG2OEpwNtCXidb+SrziuQyYa28mZjwXb0l
         4MFKEZXIcZjb+RNB7IiIR7hbIhMrcl1iMkCSwdxrQJBJouCx4tKBIqy+dMFB8Yiz1BOA
         XhFUNz6hKbF8jPi2+99uXkA6cie7LMoMI6xGTEUyUo2TLq5OAGhi1hTIlN7Y4ERD8QTn
         Ul4ClCVlSiaSEsWA/F/hqKMABOMq+F5Ja9Ddhuc67WCqLwPBtkRKAWkNun7xWMK9DhOW
         oqrg==
Content-Disposition: inline
In-Reply-To: <CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Sun, Jan 31, 2016 at 11:20:45PM +0530, Parav Pandit wrote:
> > Yes, it can.  It just becomes a part of kernel ABI that the IB stack
> > module depends on.
> >
> o.k. Its doable, but I believe its simple but its restrictive.

The whole point is to make it somewhat restrictive so that low level
drivers don't go crazy with it and the defined resources are clearly
identified and documented.

> If rest of the RDMA experts are ok with it, I will change it to do it that way.
> We get to hear their feedback before we put this as ABI.

So, I'm really not gonna go for individual drivers defining resources
on their own.  That's a trainwreck waiting to happen.  There needs to
be a lot more scrutiny than that.

> >> Now coming to remove command's need.
> >> If user has previously configured limit of say mr=15. Now if wants to
> >> remove that configuration and don't want to bother for the limit.
> >> So the way, its done is by issuing "remove" command.
> >> Should I name is "reset".
> >
> > How is this different from setting the limits to max?
>
> We can set it to max. But during freeing time, checking array of 10+
> elements whether its max or not, didn't find efficient either.

So, in terms of user interface, it doesn't buy anything, right?  It's
generally a bad idea to mix implementation details like "checking 10+
elems on free" with interface decisions.  If the overhead of scanning
the array matters, it can easily be resolved by keeping the count of
non-max values.

It could be that setting all attributes to "max" is inconvenient from
interface POV (I don't think this would be a common use case tho).  If
so, please justify that, update the interface conventions along with
other similar knobs.  Don't introduce one-off custom thing.

...
> If we don't do this, and wait until device destruction, rpool just
> keeps growing!
>
> I think above is more important design aspect than just saving memory to me.
> 
> Let me know if you have different design thought here.
> (Like engineering can_attach() callback in rdma_cgroup, which I don't
> see necessary either).

Pin the css while things are in flight and free from css_free?

> > If you wanna insist on freeing them dynamically, free them when both
> > their usages and configs are nil.
> Agree. Thats what the code is doing using marking object type being default.
> If I remove the object type, as alternative,

You don't need object type for that.  Think about it again.  All you
need is a refcnt and cgroup already has a facility for that.

Thanks.

-- 
tejun
