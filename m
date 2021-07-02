From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v5.14-rc1
Date: Thu, 1 Jul 2021 14:32:02 -1000
Message-ID: <YN5egtsVvp3xIqCl@mtj.duckdns.org>
References: <YN4rzCdUR+/2LgaP@mtj.duckdns.org>
 <CAHk-=wgcyjLGcoRho5iw7b3Yx+R05rXwyJmP_LhOqsHgjiZugQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S7GtzayBonC8NXc3VVE0on7/iur23UaGBI7PatPPRKM=;
        b=H/u4c/hymNgAID7Wp67NBhcBAjGZwLzZ7zRqFx+h8z2wsf38WglwFA0aWj8YA4tf7X
         6hqu5BrC0s+b/4hFo4R7JjVJD/HUBl3u+qa4pJej4Gv+7N9OWafAjHyFxvz3JSmchGDe
         ggfzuBlxzNCGTTntNZcxSLVJWmhr67FXIfBRTe9eZUro1ppaML51amNUeDKX9nm032/w
         SjQJYQIhJ7oN1bMgepUhuQp5H9CiqP0fs7brc0wCE2xbgcIcCnj6QQhOnB109dEyRkkR
         FOybLuD9UbnD1NhEzoNPfNoLCrTymMu5VSIVHukjPMdaUwFbMFyKraJCvO7CbMDG6V+Y
         hPbQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgcyjLGcoRho5iw7b3Yx+R05rXwyJmP_LhOqsHgjiZugQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Jul 01, 2021 at 05:25:59PM -0700, Linus Torvalds wrote:
> On Thu, Jul 1, 2021 at 1:55 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.14
> 
> I've pulled it, but let me vent about this history a bit.
> 
> Look at commit c2a11971549b ("Merge branch 'for-5.13-fixes' into for-5.14").
> 
> Now tell me how that commit explains why it exists.
> 
> Merge commits need commit messages too.
> 
> In particular, they need commit messages that *explain* why they exist
> in the first place, not just a one-liner that says what it does (and
> does so badly at that).

for-5.13-fixes had comment updates across the file and I pulled them into
for-5.14 to avoid trivial context conflicts down the line. Yeah, I should
have commented on the rationale. Will add explanations from now on.

Thanks.

-- 
tejun
