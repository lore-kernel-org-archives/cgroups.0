From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Thu, 26 Mar 2015 18:18:23 -0400
Message-ID: <20150326221823.GG1953@htj.duckdns.org>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
 <1426307835-5893-3-git-send-email-cyphar@cyphar.com>
 <20150316165335.GC8353@htj.duckdns.org>
 <CAOviyahTq1K6zBRfmXfepabiQ7xU8ZoNdq0jPd3nP4Q-0H1DDQ@mail.gmail.com>
 <20150326150223.GA1953@htj.duckdns.org>
 <CAOviyah+5DFxYtUo1=LMdQLAte=YR1s4JYoH_DNZEfpoBUfSRw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=g4ip0y7XEKFnO2FtBGlael2n+u0WQqrgzjGckcr9dus=;
        b=c5QBTVeUNHh5FJKWd4DC9CjBXSgCjbNKNcpwKrk5sHJTJ6m6wFB64SdEPArXWMZ3JR
         Lhaug23Fqmbo+Glsz8DVbkxqYlpwK4NZJAhtXPp1ZIdiqDYZcI5rEaWu/8uwaNskHp0u
         aXU2oOjDEtjnKCnkdDBFQ++SIpyBOSQVdil7fCGEEVA2T9+CMtvzk3bTajUU6xu8MvqL
         gjzj20Kk1GQgcYx3gEENQ+59AtNQTOVr/C3FNcb09UL+j9PyxsUaM4Eej7IhYcsDyFxO
         t/R0iiMf1MQ84o43zjQKSVJc+dCjGr0STKUOGhaLnEuTDSoTEtWyGppMb4szZ7mdPsU8
         OYvw==
Content-Disposition: inline
In-Reply-To: <CAOviyah+5DFxYtUo1=LMdQLAte=YR1s4JYoH_DNZEfpoBUfSRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 27, 2015 at 08:41:05AM +1100, Aleksa Sarai wrote:
> > You can't pin css_set from inside cgroup callbacks.  It's a construct
> > which in general shouldn't be accessible outside cgroup core.
> 
> Yeah, sorry I meant css (you aren't pinning, but you're still saving under RCU
> and dealing with the association-related stuff inside post_fork).

How would that work without pinning?  What'd keep the css from going
away between pre and post?

Thanks.

-- 
tejun
