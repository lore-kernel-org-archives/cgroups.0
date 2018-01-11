From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): extending man-pages documentation for cgroups v2
Date: Thu, 11 Jan 2018 01:16:10 +0100
Message-ID: <CAKgNAkgfFZjXGi9r326izingyeBSB6_vnuU2Xjphw2UOMa9vbg@mail.gmail.com>
References: <7e5b2a80-9439-4229-0ad0-eecca026a282@gmail.com>
 <20180108122911.GM3668920@devbig577.frc2.facebook.com> <bd719e73-a5e0-f327-8925-4e1e6356295d@gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=VjYYquKU315wVIX5ib0IjPFNoecm+tpKuxLdxqHYIn8=;
        b=nHOwcHqepu1HvLUF+k3v8ayJjmkg/Y29f6tRB4pP2SdHUqZ1v326eDJCO3INIYUAIH
         KW3ekjpakFMditGUCCDn3AVOSPedocCtrqC3lx28TTnWzZiuBdnFr+DipYSSG58h6R/7
         nahXXCFUNuOcdRDJyRvYEEq6c6BgbCIGiYOefiqfmnvHTXynbBlVVbAKcRhKuM9gXEjk
         94Qaeh82XZwiEDGZW67l0DRHkS62invEqZKaVg2Y2ztesxAeVgIyPDfh+Ru1e/WS0kO8
         lnKWQ5TfTisJ4x+PXOvxwKaydaTu5dhoNj3kCHuvibtVp6rQpIuMonIbae/5L0gyIGa4
         LQyg==
In-Reply-To: <bd719e73-a5e0-f327-8925-4e1e6356295d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Tejun, and Roman,

Thanks for all your responses to my many mails. I think I've now
resolved all my outstanding questions.

Cheers,

Michael


On 9 January 2018 at 00:32, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello Tejun,
>
> On 01/08/2018 01:29 PM, Tejun Heo wrote:
>> Hello, Michael.
>>
>> On Tue, Jan 02, 2018 at 07:21:27PM +0100, Michael Kerrisk (man-pages) wrote:
>>> There are some older features, as well as new features in
>>> cgroups v2 that have not so far been documented in the cgroups(7)
>>> manual page. I have been working on patches to add documentation
>>> for these features, and the man-pages branch containing these
>>> patches can be found at:
>>> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates
>>>
>>> I will send the updates as a series of plain text messages,
>>> and CC relevant people on the various patches. Would it be
>>> possible for you to review these patches please.
>>
>> Yes, will do.  Sorry about the delay.  Was traveling and then caught a
>> cold.
>
> Thanks for your comments so far. That did result also in some
> other new text that I sent you for review, sorry :-}.
>
> Also, it may be that you are still reviewing my other mail,
> "cgroups(7): documenting cgroups v2 thread mode"
> but I just remind you of it, in case you missed it.
>
> Cheers,
>
> Michael
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
