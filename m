From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Fri, 24 Apr 2020 10:07:54 -0700
Message-ID: <20200424170754.GC99424@carbon.lan>
References: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
 <20200424162557.GB99424@carbon.lan>
 <CAOWid-f0dKfZ=bAzLzdt-wCx2C2orYs3RrKi1MrfjO2=jJVyyw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=v+ZCaE+m/dAwGQ2MapWJPmqh1Ww3PT189gWuPzQuHWo=;
 b=pE176y8b99figdIgGuGYTeWbYNtYIYbpfJ67E9RNPPGwJhInN77t+/Nl0WZ+PhIv7eQD
 zjDQfZXNJwinc9Ah/CvnfsZLjDoPbz6L1+f1CFwelmlXmcXnWnrVJo7L5sovE9Lykbld
 YeEc2TOkl4FZc7uH/HzGLXsVFgyeHK9qAZg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+ZCaE+m/dAwGQ2MapWJPmqh1Ww3PT189gWuPzQuHWo=;
 b=SXERQEBEqAHGetNWTYQQtYPZiD64z7qvY2iMC54v10jnK9+Vx7wsyZGQSxyXQeAsdalXgzI3lcnw5b1HbaJ9uK2+OCGXtWfWlPFIBcrh5BZsdlX2Lk+X5yb4QQeJd3TUNW4PiwxN5ohyMAb5UjH/eWecqN1pYSbSNDPvkOELuGo=
Content-Disposition: inline
In-Reply-To: <CAOWid-f0dKfZ=bAzLzdt-wCx2C2orYs3RrKi1MrfjO2=jJVyyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 24, 2020 at 12:43:38PM -0400, Kenny Ho wrote:
> Hi Roman,
> 
> I am thinking of using the cgroup local storage as a way to implement
> per cgroup configurations that other kernel subsystem (gpu driver, for
> example) can have access to.  Is that ok or is that crazy?

If BPF is not involved at all, I'd say don't use it. Because beside providing
a generic BPF map interface (accessible from userspace and BPF), it's
just a page of memory "connected" to a cgroup.

If BPF is involved, let's discuss it in more details.

Thanks!

> 
> Regards,
> Kenny
> 
> On Fri, Apr 24, 2020 at 12:26 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Fri, Apr 24, 2020 at 12:17:55PM -0400, Kenny Ho wrote:
> > > Hi,
> > >
> > > From the documentation, eBPF maps allow sharing of data between eBPF
> > > kernel programs, kernel and user space applications.  Does that
> > > applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
> > > way to access the cgroup storage from the linux kernel? I have been
> > > reading the __cgroup_bpf_attach function and how the storage are
> > > allocated and linked but I am not sure if I am on the right path.
> >
> > Hello, Kenny!
> >
> > Can you, please, elaborate a bit more on the problem, you're trying to solve?
> > What's the goal of accessing the cgroup storage from the kernel?
> >
> > Certainly you can get a pointer to an attached buffer if you have
> > a cgroup pointer. But what's next?
> >
> > Thanks!
