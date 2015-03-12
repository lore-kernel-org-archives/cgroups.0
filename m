From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Wed, 11 Mar 2015 21:25:20 -0400
Message-ID: <20150312012520.GD25944@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-2-git-send-email-cyphar@cyphar.com>
 <20150309030636.GC13283@htj.duckdns.org>
 <CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
 <20150309065902.GP13283@htj.duckdns.org>
 <CAOviyaj55Yqahz75Gy5=yjFteeKFp7746=80-Ufww2E62Ads_Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cZrNY8+79qCdF3WTdyu0bQYW/KrGwWjmrkdrBs7RTVI=;
        b=jpIN5q/+8xGHaoTTsUzsXjMwobD7lFstAkjif0nR0/iomCYvgLmw4+ooqyC2z1rXdb
         IwkAgAcQRQfn7Yf/GQGFSe6c6uqEVnErtsepCdyYRSxAk6x1LUHL7mH8tDU5JZsoM5c8
         Dc47HTgXQwWQNyYrKfXgAmLe0FhsGSurvLWPpuolketZga8q9sW8zGAN8/uNlhmj+vYE
         DbbzAxDGQ0+i4zEXn1hFPi6WNExBeguyKUAuLrrax6FNhRPqutvwJXaPbI40wjWjFIoj
         uSlvoBMgYRNAGO0iqlsuTJPvD2oPgPauTE3ZbTGXSads00elGbIZstAW/XABTlTTgbXW
         Wyiw==
Content-Disposition: inline
In-Reply-To: <CAOviyaj55Yqahz75Gy5=yjFteeKFp7746=80-Ufww2E62Ads_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 12, 2015 at 10:47:11AM +1100, Aleksa Sarai wrote:
> Hi Tejun,
> 
> > You can charge the parent's at can_attach(), remember which one you
> > charged, and at post_fork() if the parent's has changed inbetween, fix
> > it up. [...]
> 
> Did you mean can_fork() instead of can_attach() here?

Ah, yeah, can_fork().  Sorry about that.

-- 
tejun
