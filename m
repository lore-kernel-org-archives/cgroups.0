From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v4.15-rc7
Date: Mon, 8 Jan 2018 11:20:39 -0800
Message-ID: <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=OMp4YLQDD6GidKRzrBXThrHs0VFWsB2wySsv2xtwtRo=;
        b=EHVm6R5wVc3I/ZItwqHa+0Yf6jjmOCS+URSTRiU0nIA1ZA7JTP32Smwm3qac8+yMsL
         1i0Dap2j/tTo2Mhf+THR8oRWXvZEhw99VgupsqBed24O33BhwbSXp9HjbgByuX7uUld0
         qdaCKeiJEnrK/nSuVnwTvejqA7KHyuSk/THQpsMPn1CtLLD8ZJ8GOaced7QaLdtfeALg
         I2mJYxRYUUaqK57KQPSDk0pNxqs2X5TB6+5478ISDCVx1TmVLvBLWFpc2gvD1cHXf032
         E+DJFB/orXCC6PRukd4rcXwp8S0bQWLQh0WuR5X/OYrQotapkSAlOZafIGIWhThmcHT5
         zQlw==
In-Reply-To: <20180108145223.GS3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 8, 2018 at 6:52 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> There also are two patches to replace unlimited strcpy() usages with
> strlcpy().

Christ, people.

strlcpy() is crap. It doesn't fix anything. If you have a untrusted
source string, then strlcpy() does "strlen()" on the source, so it
will overrun the source.

And if you don't have an untrusted source, why the hell are you using
that function in the first place?

The interface was designed by morons on crack.

Use "strscpy()", which got this _right_.

We should probably just remove that sh*t-for-brains strlcpy()
function. It's broken garbage.

                Linus
