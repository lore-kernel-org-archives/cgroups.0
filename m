From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Date: Tue, 31 Jul 2012 13:00:39 +0400
Message-ID: <20120731090039.GB2396@moon>
References: <500D09C9.7060903@parallels.com>
 <500D1116.7070301@parallels.com>
 <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
 <50179CF0.7050200@parallels.com>
 <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=B2E1vFLgbTmrFspUcCXuU7v+LZ7c/xHTZy1YJPIOb7w=;
        b=mVdA6mypksB3bUCwvYELJC6RjFND/wIl6fI5BD2laKdk+lyFmq9j+ijxmKL0zY3yVS
         roLMkP1AIDSlHTRqPbz8TsPy3buBEJaoXOm5m81qhZ/wTa9JPvDx3RNITrdNVxcJyzDm
         tuEFAsum+23OT/jpM7UGKXtfdiRyhlaMrKw4IiYei8gfwkNNk8+tUkwbUbMjGlBjlIPU
         xjVgPWZeLgNgnxS09cie6CsocnUrLfZlP1lLCnjwglYPQ6QM6i8yuM7seyxMUPE3PK+H
         DzdRAdAJmA7tM9V/sCEdsJA0FN+ao4691RPSUXNfHmQiNBRPLgfzmASL4P8kl8kTDJ7i
         GbSA==
Content-Disposition: inline
In-Reply-To: <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lwn-T1hC0tSOHrs@public.gmane.org" <lwn-T1hC0tSOHrs@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jul 31, 2012 at 10:57:58AM +0200, richard -rw- weinberger wrote:
> >
> >> crtools seem to use ptrace() to execute parasite system calls.
> >> AFAIK this will only work if the target process is currently not
> >> ptraced() by another process.
> >>
> >
> > Yup, exactly.
> 
> Dammit, I hoped we can get suspend/resume for UserModeLinux for free
> with CRIU. 8-)

We have plans to implement seizing on traced tasks but no dates at the moment ;)

	Cyrill
