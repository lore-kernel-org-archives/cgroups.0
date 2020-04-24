From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Fri, 24 Apr 2020 12:43:38 -0400
Message-ID: <CAOWid-f0dKfZ=bAzLzdt-wCx2C2orYs3RrKi1MrfjO2=jJVyyw@mail.gmail.com>
References: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
 <20200424162557.GB99424@carbon.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H68jxc60NCBa62+Fg4wVWPgLDcgA+0ooiSEDMATOMsI=;
        b=tlKi6OHWtdMwTXbTU5n6tNSfDV/jjq7GaCV01wT/RTuP89B+4GOBQGHSsGe+YAvlju
         rloxSUkLKeouoqO0pfGKcCY91zJ/eMlZ2IXEGHFT3zFHsMcpFpgGR9HNoLyIS/2CmTQP
         6JFSz98PVxiChKK4as9QzKu7Ijklv7Nmnu/Ru9G9NlkyBbxn7jIWMz5bjkDDtJa4yYDh
         8tEdyvRBHomAFpvdVULpjK4L1WMe6VuDazthv28D24pBDUbXyejjLBnbO8RVP0Vz20kz
         dd9iay2sNQSWBwY5zYpXkVvHogwDhk230eG9ujSbiBKRbYmDA1jBWoTVt0KaoURBnSz2
         0tFA==
In-Reply-To: <20200424162557.GB99424-esYZh5BkUNV+urZeOPWqwQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Roman,

I am thinking of using the cgroup local storage as a way to implement
per cgroup configurations that other kernel subsystem (gpu driver, for
example) can have access to.  Is that ok or is that crazy?

Regards,
Kenny

On Fri, Apr 24, 2020 at 12:26 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Fri, Apr 24, 2020 at 12:17:55PM -0400, Kenny Ho wrote:
> > Hi,
> >
> > From the documentation, eBPF maps allow sharing of data between eBPF
> > kernel programs, kernel and user space applications.  Does that
> > applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
> > way to access the cgroup storage from the linux kernel? I have been
> > reading the __cgroup_bpf_attach function and how the storage are
> > allocated and linked but I am not sure if I am on the right path.
>
> Hello, Kenny!
>
> Can you, please, elaborate a bit more on the problem, you're trying to solve?
> What's the goal of accessing the cgroup storage from the kernel?
>
> Certainly you can get a pointer to an attached buffer if you have
> a cgroup pointer. But what's next?
>
> Thanks!
