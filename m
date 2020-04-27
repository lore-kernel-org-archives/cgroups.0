From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Mon, 27 Apr 2020 08:25:20 -0700
Message-ID: <20200427152520.GB114719@carbon.DHCP.thefacebook.com>
References: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
 <20200424162557.GB99424@carbon.lan>
 <CAOWid-f0dKfZ=bAzLzdt-wCx2C2orYs3RrKi1MrfjO2=jJVyyw@mail.gmail.com>
 <20200424170754.GC99424@carbon.lan>
 <CAOWid-fw=jaxWTVLTESrPf9XPE3PMnrQkk7GZnaPSkqFN_3e_g@mail.gmail.com>
 <CAOWid-f6Kjds2sQ-auOPzixWaCa4twD6BQ+NbCipfU6remn1Hw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ezbbos40caactUrIw62Vvg0Gqm6QkAM0zVUZyiv0MHM=;
 b=SgnZTEmx1qAsPuiMtKLR0x+qBNFvs3/Je6GgymkWp3A0/DUn/fQJUsxC8gZ8eAe5jeb8
 ww/Day/+rWYye/uT+5Qrgsnvn48yrUjPsVWKAnUNzQSJkxbAYr5sWZIJL6KrMgAG9dM7
 x3Ld9+Mh3gTAGHY/gjfRXAT7CC7WtTueJeE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ezbbos40caactUrIw62Vvg0Gqm6QkAM0zVUZyiv0MHM=;
 b=AklV6wHGDtTNukQZxgCDuWPpjPhdQrEkZUhdoWqg7XVwrZFKjSGFXjSK3SvJ7CGXXJVMOG+jiWmJ6/anZlPrQwNNGngftakNut5s5h9LeG28Au1a1B1m4zZ5tCIv53QnAp/WjcZyvPYHiWrmGBAbujhdPoC4c5VPNDobdlp+p0s=
Content-Disposition: inline
In-Reply-To: <CAOWid-f6Kjds2sQ-auOPzixWaCa4twD6BQ+NbCipfU6remn1Hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 24, 2020 at 05:33:11PM -0400, Kenny Ho wrote:
> Hi Roman,
> 
> To be more specific, I have been looking at the bpf-cgroup
> implementation of device cgroup and I cannot wrap my head around how
> the bpf-cgroup implementation would be able to enforce "[a] child
> cgroup can never receive a device access which is denied by its
> parent."  I am either missing some understanding around device cgroup
> or bpf cgroup or both.  Any pointer you can give me would be much
> appreciated.

So as I wrote in the previous e-mail, if a program is attached
to a parent cgroup, it's effectively attached to all children cgroups.
So if something is prohibited on the parent level, it's also
prohibited on the child level.

If there is an additional program attached to the child cgroup, both
programs will be executed one by one, and only if both will grant the access,
it will be allowed.

The only exception is if the override mode is used and the program
on the child level is executed instead of the parent's program.

Overall, I'd suggest you to look at kselftests and examples provided
with the kernel: you can find examples of how different attach flags
are used and how it works all together.

Thanks!


> 
> Regards,
> Kenny
> 
> On Fri, Apr 24, 2020 at 1:28 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > Hi Roman,
> >
> > Um... I am not sure yet because I don't think I understand how
> > bpf-cgroup actually works.  May be you can help?  For example, how
> > does delegation work with bpf-cgroup?  What is the relationship
> > between program(s) attachted to the parent cgroup and the children
> > cgroups?  From what I understand, the attached eBPF prog will simply
> > replace what was attached by the parent (so there is no relationship?)
> >  Sequentially running attached program either from leaf to root or
> > root to leaf is not a thing right?
> >
> > Regards,
> > Kenny
> >
> > On Fri, Apr 24, 2020 at 1:08 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > >
> > > On Fri, Apr 24, 2020 at 12:43:38PM -0400, Kenny Ho wrote:
> > > > Hi Roman,
> > > >
> > > > I am thinking of using the cgroup local storage as a way to implement
> > > > per cgroup configurations that other kernel subsystem (gpu driver, for
> > > > example) can have access to.  Is that ok or is that crazy?
> > >
> > > If BPF is not involved at all, I'd say don't use it. Because beside providing
> > > a generic BPF map interface (accessible from userspace and BPF), it's
> > > just a page of memory "connected" to a cgroup.
> > >
> > > If BPF is involved, let's discuss it in more details.
> > >
> > > Thanks!
> > >
> > > >
> > > > Regards,
> > > > Kenny
> > > >
> > > > On Fri, Apr 24, 2020 at 12:26 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > > >
> > > > > On Fri, Apr 24, 2020 at 12:17:55PM -0400, Kenny Ho wrote:
> > > > > > Hi,
> > > > > >
> > > > > > From the documentation, eBPF maps allow sharing of data between eBPF
> > > > > > kernel programs, kernel and user space applications.  Does that
> > > > > > applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
> > > > > > way to access the cgroup storage from the linux kernel? I have been
> > > > > > reading the __cgroup_bpf_attach function and how the storage are
> > > > > > allocated and linked but I am not sure if I am on the right path.
> > > > >
> > > > > Hello, Kenny!
> > > > >
> > > > > Can you, please, elaborate a bit more on the problem, you're trying to solve?
> > > > > What's the goal of accessing the cgroup storage from the kernel?
> > > > >
> > > > > Certainly you can get a pointer to an attached buffer if you have
> > > > > a cgroup pointer. But what's next?
> > > > >
> > > > > Thanks!
