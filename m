From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc4
Date: Mon, 8 Sep 2014 13:50:54 +0900
Message-ID: <20140908045054.GA8526@mtj.dyndns.org>
References: <20140908012025.GF5061@mtj.dyndns.org>
 <CA+55aFw+L1EUDEmAATDtGj_ngHos842jHLddAszboRy4b0pn2A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VBCdTFlWXP2osE4oZvXfszA12hRQvsw+nr3dcrowrwk=;
        b=K2b+kEfio9/8iYlU6vgnnhPhvjj74UHUTnj5ROlZ5rCIvNZmtAknEX1VeFS6PjRxLe
         5PC9+44R0kpk1vux6/Gaw5WQtK+FJAEGq7rKirwaC9X3FYZUslur92IehEJn6fasE17s
         ZYihQEUPvDEPeHG1stwSkE6tgpEnQz9ZRhJOK80O5QkB0eP+YFLIlcX40c8kPPL2VeFL
         7/yqR8hdEw4aD5u6bxbPtOd77tp3OQFD3BzclEPQsEkVrRGAsOgPwu3NNtFB69DcID7j
         qvPrg4o+TOBi/ZwRMClSkeg/RcM6oRmhsncjMiDF0lf0FsBf7oZD3jIMAe5JimoIvTR2
         1V0g==
Content-Disposition: inline
In-Reply-To: <CA+55aFw+L1EUDEmAATDtGj_ngHos842jHLddAszboRy4b0pn2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

On Sun, Sep 07, 2014 at 08:17:11PM -0700, Linus Torvalds wrote:
> In other words, I'll happily pull this, but your excuses for it are
> wrong-headed. There is no "crazyness justifies this". That's crap. But
> the argument of "nobody does this, so let's fix it before anybody
> _starts_ doing it" is perfectly valid - with the deep and implicit
> understanding that if it turns out somebody *does* do it, the change
> gets reverted asap.

Yeap, that's the intention which I failed to articulate.  It's highly
unlikely to be in use currently and would already be noticeably
breaking things.  Given that it's justified to try to ban '\n' usage
and see whether anybody reports regression from that.  Will describe
similar situations more accruately from now on.

Thanks.

-- 
tejun
