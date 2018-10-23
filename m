From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Cgroup v2 thread mode oddity: "domain invalid" cgroup with
 threaded controller enabled
Date: Tue, 23 Oct 2018 18:09:05 +0200
Message-ID: <CAKgNAkgEeHSYCFGdXOBQHBALg0KgWP_1=dEFYD_R6wCaV99MJg@mail.gmail.com>
References: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com> <20181017161958.GT270328@devbig004.ftw2.facebook.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Fgm4tFmb3aCVBUqVRe/lYD1am1ANjqT3rkKG73BHrA0=;
        b=ZqKtQQotqtvSi/BvgAxSrFvgRLYJqUDOhA0kxHrEufBXnxNntz5BcbEzjTuayF1q7a
         0ysmOTlaBB+WHtnpemnIlA/t4rb5kqzUEHJKk8CNYvwvzcCKhGTFPlmpi7sx84OdpqwC
         8Fpj9q7UjGZ/wYOAuDU9+6mJbyiLfEuTMUjmIZl6oa/KzgyoVhV0KXZfEXwxBk9qRxva
         2nvc5uYKDSHXh7VZgFQnqdkjztLS1KwAd3u+xOoLi8XEiuibW+jHKfdffMlOJ2mAqS3k
         poLVZH36Cf8KMyHe0E0lQX+sMTVMvywClNw5s+LZUK1BP1hGZV03qVj6QhIr7CPb8nLh
         AnYA==
In-Reply-To: <20181017161958.GT270328@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>

Hi Tejun
On Wed, 17 Oct 2018 at 18:20, Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Michael.
>
> Sorry about the delay.
>
> On Thu, Oct 04, 2018 at 09:40:57PM +0200, Michael Kerrisk (man-pages) wrote:
> > This seems odd. x/y is now of "domain invalid" type with a controller
> > enabled! This feels like a violation of the rules, since we can't
> > in other circumstances do anything with a "domain invalid" cgroup
> > except convert it to "threaded". In particular, we can't create
> > child cgroups under a "domain invalid" cgroup, or add member processes
> > to the cgroup, or *enable controllers in the cgroup*. In fact, when
> > doing the
> >
> >     # echo threaded > x/z/cgroup.type
> >
> > I had expected a write(2) error because the state of x/y should
> > (I thought) not be permitted.
>
> So, both the interim (before turning x/z into threaded) and final
> (after) are completely fine - the cgroups are empty and whether
> threaded controllers like pids are enabled or not don't really change
> things that much.
>
> Maybe it is a bit inconsistent to then deny enabling threaded
> controllers on invalid domain cgroups.  We can lift that restriction
> but I personally can't see why that'd be clearly better.

So, I also can't see anything that seems harmful in the scenario I
described; it's just an odd inconsistency, and I supposed it was
unintended/overlooked behavior, and I wanted to alert you to it, in
case it seemed problematic. However, as long as you have no concerns,
I see no reason to change the existing behavior.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
