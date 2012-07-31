From: richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Date: Tue, 31 Jul 2012 11:29:25 +0200
Message-ID: <CAFLxGvy396+BfYSaSnvAwJb0GO4WZCKbPXSbU7YfrOJTo6zk6A@mail.gmail.com>
References: <500D09C9.7060903@parallels.com>
	<500D1116.7070301@parallels.com>
	<CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
	<50179CF0.7050200@parallels.com>
	<CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
	<5017A053.9000206@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=5TmAXZ5ZYkQ/KrJ3+MaWAPU+liwuZmoWWOI8dgva7mU=;
        b=XkUO9PzKDnPUJ5Lm0x3D5mh+81QXwngFJQXGN4dvQwLCFLEyL6C9vCguvJOBZo3bNV
         Kj6PSi0l5lQSVzRvP1ApjWBrxQ86eMeUCDmkZHgr7QAsscG71NIJyVt0UbNWExPJyzIx
         YRJyiEzaXEtE6k6PgK0q51WKGo6Tznegik4DQbujSBocyzJw84IDjMQ+rQ3fxeg1UHk1
         VwzMghz5YwTmcvdeJ3CupDM0BLAJcxTLvoZx6SCQT8v+3GhwUGi2wBAl3L2dRd/tWvFH
         wEsNbFv01qXLyHLYQ4yBfIlDpPjQdp4cikBOcvQV7dn/wQ8tlxnWwdRe02yx2iFdCBbw
         fSqQ==
In-Reply-To: <5017A053.9000206-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lwn-T1hC0tSOHrs@public.gmane.org" <lwn-T1hC0tSOHrs@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jul 31, 2012 at 11:07 AM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> Sorry :( However, if you can help with patches on that issue that would be
> highly appreciated :)
>

Yeah, but I fear it's not that easy.
We'd have to change crtools to work without ptrace().

-- 
Thanks,
//richard
