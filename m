From: Peter Dolding <oiaohm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Single process controlling all cgroups sounds like looking in
 right direction but wrong solution.
Date: Wed, 17 Jul 2013 08:06:50 +1000
Message-ID: <CANA3KFVeYkvidYu=1rV_We3JLH5QEsogCnYQEdA6VGBKD2sbYw@mail.gmail.com>
References: <CANA3KFV6LmfKYUo305Fo2Yv_0kJGSSa7OjnGi8BMb+0Ys9e8NA@mail.gmail.com>
	<20130715032551.GA3046@ac100>
	<CANA3KFWdKbrpZDHHsqKeh-vugK7NjJ1xrFcXyYSRaKn0mUYewg@mail.gmail.com>
	<20130715123216.GA5663@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Cp3a1nvkhtFw0z9cFLwBuI1Zfqdz28kyMrqusQkmYrg=;
        b=hPFd5BDuyZ9UbeooQHbVKJV7Iv9/uH8tIoAm/rG6x5zHJ5z0kipzEaOhUFW8cNegrG
         n5JYC4EjIQs2DuzNJ94UUBGBAo9Vg4kv4xhL49aa/3W2XXLst603F/YNDrEMvdBGkG4r
         94MnfxxpFU3MVESnWLZXk6uIQwNnG0HbqLryLq0mmEqHm4XgAqUljV1gd27XUvIcIKx3
         uIlqXbKcCoz57ZCeJYlaNW4a7/T8tT27+J+7pSdIcuQZCOI4qTmzy4vkPtrxvwwH8dmY
         0dgV2GDmZCqPb6JekhSfbZUUfyU4sgxWHdtt9f3FKhA7QMFPatmAsutNTeN4pm0bhd7G
         yYSw==
In-Reply-To: <20130715123216.GA5663@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, webmaster-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Serge You took it the wrong way I was not trying to be defensive.
That was my version of what the heck is wrong response.  Followed
policy and it wrong you kinda want to find out what is wrong.  Its if
something is out like this other people are going to go south.

So this is interesting there is a miss match between git and what the
website displays.   Fact that its old it the webmaster needs to be
informed so it can be fixed.      I have changed the who this is going
to.

Webmaster https://www.kernel.org/doc/linux/MAINTAINERS   and the
Maintainers file in git don't match.    Would suspect other sections
in doc directory are also out.

https://www.kernel.org/doc/linux/   Apparently this is one of the
things that broke when kernel.org was breached and has not been fixed
yet.   Nothing in that section of kernel.org appears to be updated
since the 19 Aug 2011.   Kernel.org breach was the 31 of Aug 2011.
So I would say the script or whatever was done to sync there has not
been operating because it was removed cleaning up from the breach.
If its never going to be operating sections there should be just
deleted so it does not lead people up garden path..

On Mon, Jul 15, 2013 at 10:32 PM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Peter Dolding (oiaohm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>> I followed the Maintainers File.  https://www.kernel.org/doc/linux/MAINTAINERS
>> CONTROL GROUPS (CGROUPS)
>> M:    Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> M:    Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> L:    containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>
> Odd, my version has
>
> L:      containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> L:      cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> The cgroups entry was added in November 2011 according to git-blame.
> I don't know why the kernel.org version is so old.
>
> Still I think that should be patched to remove containers@.  I
> originally objected to the cgroup@ list creation, but since I
> do not believe the relevant cgroup folks read the containers@
> list any more, I don't think containers@ should be listed -
> certainly not first.
>
>> S:    Maintained
>> F:    include/linux/cgroup*
>> F:    kernel/cgroup*
>> F:    mm/*cgroup*
>>
>>
>> Apparently by your response this might be a bit out of date.  I just read
>> lwm and *Tejun Heo is not even as a main maintainer.  Listed as a sub part
>> maintainer.   By the maintainers file discussions should be in *
>> containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org where I sent this.
>>
>> Tejun Heo please inform if this is still correct.  Its either update this
>> or tell lwn.net to get your title correct in future.
>>
>> Serge I am trying to follow policy that is why I posted here in the first
>> place.
>
> That sounds unnecessarily defensive - I wasn't complaining, just trying
> to help your email get to where it would be best discussed  :)  Sorry
> that it involves an extra step (resending), but I didn't want to simply
> reply cc:ing cgroups@, as the email thread tends to get funky that way.
>
> -serge
