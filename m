From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v5.19-rc1
Date: Wed, 25 May 2022 09:56:15 -1000
Message-ID: <Yo6J3/cVHu4huZH1@slm.duckdns.org>
References: <Yowcc/ZOBIIs2JtZ@slm.duckdns.org>
 <CAHk-=wiGsJgFTJ=yqYwWA2vcTWQy=2QQ6to6vd3ETutaE0cDxQ@mail.gmail.com>
 <Yo6HMpEodz36o4Dc@slm.duckdns.org>
 <CAHk-=wj4Q2++KfQ4NhMtjmJF_1bjC-573U61o1acuHfqmsvCKA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=URc4hQQOFWu8kbxQu3QsbQGjnzXbOZhtvLuWIaavPVo=;
        b=RZi+79Hik/m6u3wnR25JW2Eu4n1JgneXWTduAnjWgkibjAUptWSbRpJ/yAkrdLMjD2
         zVtQrJbZvvXIbaN/kJoEuTcBz6tB/iee0q14OliDGrfzioIgl0m3OgDlE1isO5jQ5M0U
         Hf23JVDQ/CwVGy+7Sm5UGNzwt977TJUB3VgbByqxwV7r8zrqKiDxC4OF+i4K4Xn1pFi6
         WwPsrbOGhlzEftQRcxP5RFv0Q6eW4lNDFABhcKo7fyqy8bOVX6fqm/72xWOA1s9Xt7/U
         hZk44k/5mvppgUzxRkGckH0bPkbgdvkowstF1bfh3lckOFCuOXdD1Rr1K5o+Ucy/LSHf
         rmSQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wj4Q2++KfQ4NhMtjmJF_1bjC-573U61o1acuHfqmsvCKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 25, 2022 at 12:47:48PM -0700, Linus Torvalds wrote:
> On Wed, May 25, 2022 at 12:44 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Hahaha, yeah, I lost my private key many years ago, so gotta get that sorted
> > out first. Will do the signed pull from now on.
> 
> You have a pgp key for your kernel.org account, you can just use that. No?
>
> (That way I'll also be able to just pick it up from the pgp key repo
> that Konstantin maintains).

I don't have the private part of that pgp key anymore and have been just
using the same ssh key. Nothing really requires the private key that I lost
at least 5 years ago. On the plus side, the pgp key has been as secure as it
gets. :) So, I gotta generate new keys, get it signed and replace the korg
key and so on. I've just been really lazy.

Thanks.

-- 
tejun
