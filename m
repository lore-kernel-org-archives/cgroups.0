From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Fri, 24 Apr 2020 13:28:09 -0400
Message-ID: <CAOWid-fw=jaxWTVLTESrPf9XPE3PMnrQkk7GZnaPSkqFN_3e_g@mail.gmail.com>
References: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
 <20200424162557.GB99424@carbon.lan> <CAOWid-f0dKfZ=bAzLzdt-wCx2C2orYs3RrKi1MrfjO2=jJVyyw@mail.gmail.com>
 <20200424170754.GC99424@carbon.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lOJjvTeknd9q+St0KOOombUF0u+c2MUeVsDvX2ufelg=;
        b=nqplw7mgBaPUfEj5oal2LRLt6imErNyt3vHO1mwM6uZswgsI0uy9/KHjjKOOiCKZgA
         UZ75MKY6c5tK52paVgE8dcoxN7YCRDFLfZglIfSuue+KoHs4pPdLVP//ijqYQ42UYmdh
         FzqjZrL4kVa7AF5SWIF5QVrLXFyIyBsUeJqEBYYAqnbgdJ5cCHiaGfO0JXQCrYJboOXL
         qkPVzlXV0PMeXK6kf+bBpjt3PCn0gOQNq4YNmSCvCdX3c9DQQLP88HmcU49LuJJjmE6f
         3UrR9WdnYmzemO/c97qk055/+7K5YS6SdSfqyPDPJBRjwgcmc/3SfSJ4hkEu3xGw3OdV
         EjqA==
In-Reply-To: <20200424170754.GC99424-esYZh5BkUNV+urZeOPWqwQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Roman,

Um... I am not sure yet because I don't think I understand how
bpf-cgroup actually works.  May be you can help?  For example, how
does delegation work with bpf-cgroup?  What is the relationship
between program(s) attachted to the parent cgroup and the children
cgroups?  From what I understand, the attached eBPF prog will simply
replace what was attached by the parent (so there is no relationship?)
 Sequentially running attached program either from leaf to root or
root to leaf is not a thing right?

Regards,
Kenny

On Fri, Apr 24, 2020 at 1:08 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Fri, Apr 24, 2020 at 12:43:38PM -0400, Kenny Ho wrote:
> > Hi Roman,
> >
> > I am thinking of using the cgroup local storage as a way to implement
> > per cgroup configurations that other kernel subsystem (gpu driver, for
> > example) can have access to.  Is that ok or is that crazy?
>
> If BPF is not involved at all, I'd say don't use it. Because beside providing
> a generic BPF map interface (accessible from userspace and BPF), it's
> just a page of memory "connected" to a cgroup.
>
> If BPF is involved, let's discuss it in more details.
>
> Thanks!
>
> >
> > Regards,
> > Kenny
> >
> > On Fri, Apr 24, 2020 at 12:26 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > >
> > > On Fri, Apr 24, 2020 at 12:17:55PM -0400, Kenny Ho wrote:
> > > > Hi,
> > > >
> > > > From the documentation, eBPF maps allow sharing of data between eBPF
> > > > kernel programs, kernel and user space applications.  Does that
> > > > applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
> > > > way to access the cgroup storage from the linux kernel? I have been
> > > > reading the __cgroup_bpf_attach function and how the storage are
> > > > allocated and linked but I am not sure if I am on the right path.
> > >
> > > Hello, Kenny!
> > >
> > > Can you, please, elaborate a bit more on the problem, you're trying to solve?
> > > What's the goal of accessing the cgroup storage from the kernel?
> > >
> > > Certainly you can get a pointer to an attached buffer if you have
> > > a cgroup pointer. But what's next?
> > >
> > > Thanks!
