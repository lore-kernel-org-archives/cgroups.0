From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Mon, 27 Apr 2020 16:17:33 -0400
Message-ID: <CAOWid-dhbe=PkV_B9CoWO1exB5nGZjGWQgfC0PNapTgHPUdinw@mail.gmail.com>
References: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
 <20200424162557.GB99424@carbon.lan> <CAOWid-f0dKfZ=bAzLzdt-wCx2C2orYs3RrKi1MrfjO2=jJVyyw@mail.gmail.com>
 <20200424170754.GC99424@carbon.lan> <CAOWid-fw=jaxWTVLTESrPf9XPE3PMnrQkk7GZnaPSkqFN_3e_g@mail.gmail.com>
 <CAOWid-f6Kjds2sQ-auOPzixWaCa4twD6BQ+NbCipfU6remn1Hw@mail.gmail.com> <20200427152520.GB114719@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M33engiEAp9GtymvpxKX5lndqUY+8YDcH7kgkTq+ouw=;
        b=rBr9YJyOPs1+63XL3xVSuiHlBrVJPB1FBu/je7eASoyAaJePJ1ea2vNzQTMyfnc4wD
         1lYWHXEfXKpgGavrIODRBp/ZGR0nzbvOQef20TBeZ9jFAnbNj1riUm4K79NCAaoWG14e
         Xp3KW2d8OmrY9C/9YW5FX/UcBiIWTjQRX6pehw4ojBBJ4whUvpnTxwqpOpQDOpnggtPC
         UilMurnjDq7AFTyfJ+Mdn3SYmsMOiZQj2QjHolaT7UKUL6n/iFCF+Sk+bkrf/Lj1ivXM
         kOLga8zcKqhzDc8r+fpcZ9AU4YL1GF7p6e5WLd1AaPnesNiq4pM9/Dgco+xY/WBIHTDb
         53Kg==
In-Reply-To: <20200427152520.GB114719-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I see.  Thanks for the pointers.  I will look into it.

Regards,
Kenny

On Mon, Apr 27, 2020 at 11:25 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Fri, Apr 24, 2020 at 05:33:11PM -0400, Kenny Ho wrote:
> > Hi Roman,
> >
> > To be more specific, I have been looking at the bpf-cgroup
> > implementation of device cgroup and I cannot wrap my head around how
> > the bpf-cgroup implementation would be able to enforce "[a] child
> > cgroup can never receive a device access which is denied by its
> > parent."  I am either missing some understanding around device cgroup
> > or bpf cgroup or both.  Any pointer you can give me would be much
> > appreciated.
>
> So as I wrote in the previous e-mail, if a program is attached
> to a parent cgroup, it's effectively attached to all children cgroups.
> So if something is prohibited on the parent level, it's also
> prohibited on the child level.
>
> If there is an additional program attached to the child cgroup, both
> programs will be executed one by one, and only if both will grant the access,
> it will be allowed.
>
> The only exception is if the override mode is used and the program
> on the child level is executed instead of the parent's program.
>
> Overall, I'd suggest you to look at kselftests and examples provided
> with the kernel: you can find examples of how different attach flags
> are used and how it works all together.
>
> Thanks!
>
>
> >
> > Regards,
> > Kenny
> >
> > On Fri, Apr 24, 2020 at 1:28 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > Hi Roman,
> > >
> > > Um... I am not sure yet because I don't think I understand how
> > > bpf-cgroup actually works.  May be you can help?  For example, how
> > > does delegation work with bpf-cgroup?  What is the relationship
> > > between program(s) attachted to the parent cgroup and the children
> > > cgroups?  From what I understand, the attached eBPF prog will simply
> > > replace what was attached by the parent (so there is no relationship?)
> > >  Sequentially running attached program either from leaf to root or
> > > root to leaf is not a thing right?
> > >
> > > Regards,
> > > Kenny
> > >
> > > On Fri, Apr 24, 2020 at 1:08 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > >
> > > > On Fri, Apr 24, 2020 at 12:43:38PM -0400, Kenny Ho wrote:
> > > > > Hi Roman,
> > > > >
> > > > > I am thinking of using the cgroup local storage as a way to implement
> > > > > per cgroup configurations that other kernel subsystem (gpu driver, for
> > > > > example) can have access to.  Is that ok or is that crazy?
> > > >
> > > > If BPF is not involved at all, I'd say don't use it. Because beside providing
> > > > a generic BPF map interface (accessible from userspace and BPF), it's
> > > > just a page of memory "connected" to a cgroup.
> > > >
> > > > If BPF is involved, let's discuss it in more details.
> > > >
> > > > Thanks!
> > > >
> > > > >
> > > > > Regards,
> > > > > Kenny
> > > > >
> > > > > On Fri, Apr 24, 2020 at 12:26 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > > > >
> > > > > > On Fri, Apr 24, 2020 at 12:17:55PM -0400, Kenny Ho wrote:
> > > > > > > Hi,
> > > > > > >
> > > > > > > From the documentation, eBPF maps allow sharing of data between eBPF
> > > > > > > kernel programs, kernel and user space applications.  Does that
> > > > > > > applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
> > > > > > > way to access the cgroup storage from the linux kernel? I have been
> > > > > > > reading the __cgroup_bpf_attach function and how the storage are
> > > > > > > allocated and linked but I am not sure if I am on the right path.
> > > > > >
> > > > > > Hello, Kenny!
> > > > > >
> > > > > > Can you, please, elaborate a bit more on the problem, you're trying to solve?
> > > > > > What's the goal of accessing the cgroup storage from the kernel?
> > > > > >
> > > > > > Certainly you can get a pointer to an attached buffer if you have
> > > > > > a cgroup pointer. But what's next?
> > > > > >
> > > > > > Thanks!
