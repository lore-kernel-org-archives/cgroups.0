From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: PIDs Controller Limit
Date: Mon, 28 Sep 2015 11:51:24 -0400
Message-ID: <20150928155124.GD2589@mtj.duckdns.org>
References: <CAOviyajLPivBQLauYHWTW71PHyvF15X=Ocu8JDc-92s0k3XRwA@mail.gmail.com>
 <20150925153912.GG4449@mtj.duckdns.org>
 <CAOviyagSDkNWY1X7d=nAhgqkOz2fE+ck+rS9Fn_hfMbCZHRyKw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Vvi4H43/4+dzm4MmXFjmAsZxlhNoEQa+CG88Zs6r/KM=;
        b=xv3PJn6JigiJAUla+LuhMhP/33+sZ7O/Kp6yyjHIPVjzwItFjPyGOyPDesvtai+26h
         tKIBl2LTrFvGAdMoqKGnMp5k0D6keps/dHBxSPsup7kBUO2xwAwoweW55JnXD1nCAqpE
         F9Ipepr0hN0kIWt9yjPk4CNQw+A4evijDOcZmUOnUM4kApqWceM3uQqEHmBEx30GD72T
         Zomn09O/x2pltj5sI5dQ7+rf7xvTaesiXstYaUl4wLofEhiiQ6qh+5hE/c5Y1apaUSYJ
         JGx0oAHhKcTrkVmmGLP8jz/7UlyW6PJD/3/0dL2CIctlxXZ1YbQQiiRlXJF+hLYq45IW
         7NFA==
Content-Disposition: inline
In-Reply-To: <CAOviyagSDkNWY1X7d=nAhgqkOz2fE+ck+rS9Fn_hfMbCZHRyKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sat, Sep 26, 2015 at 09:11:02AM +1000, Aleksa Sarai wrote:
> Well, it might be confusing that a limit of `0` is not different from
> a limit of `1`. Especially since someone might think that a limit of
> `0` means "no processes AT ALL", which is wrong. Although, I guess
> they should've just RTFM'd in that case.

I really don't think it matters.

Thanks.

-- 
tejun
