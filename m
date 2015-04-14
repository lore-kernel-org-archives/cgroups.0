From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 14 Apr 2015 08:17:32 -0400
Message-ID: <20150414121732.GL2596@htj.duckdns.org>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
 <1428799917-15141-4-git-send-email-cyphar@cyphar.com>
 <20150413142439.GA2596@htj.duckdns.org>
 <CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4XXQuHDCFpV5ogmJJEm2BHdFoyaojI5BEoZDEEyG+Sw=;
        b=wVJ/ccqoMpI5pjyRx82sHjVI7eZJttarDAw1z6j5fkUBQ17Y8FtYcIynzK1iM+sTqy
         rNhTvbdiJN2jAN7zy9XOwF7HaEjUSrXaVZmUhm7I8qQy2UhnW0J9jlGfeBmkru1xzR9q
         Pdk2lUB5BoCAlEbsNR+cDL95W/5wrsmyOAdZ12uH7ikTx7W3jM8MaZGP0qKEPsTPEeH0
         RVWKl/JIQ5ny7RMQrucyJeUmQbEHvy5tLYjPURtABuxNdSMItyLPS9etiPevc1rLN+tz
         ITYiama9UDMbLqz3O+FXBEbRSGItGHsrYnXTIqUF1byGgK0ag2yHupBh/ykjhrubOp8K
         jZvg==
Content-Disposition: inline
In-Reply-To: <CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Apr 14, 2015 at 10:33:41AM +1000, Aleksa Sarai wrote:
> Hi Tejun,
> 
> > Ummm... is this really necessary?  Can't we do something like the
> > following?
> >
> > #define SUBSYS_TAG(tag)                                         \
> >         __##tag,                                                \
> >         tag = __##tag - 2,
> 
> Is which part necessary? That's what TAG() does. I can remove the

The complex macros.

> UNUSED_IDENT() if you want, that was just to make sure you don't get clashes
> with other unused idents. COUNT() is so that we don't have to manually add
> CGROUP_<TAG>_COUNT for every tag we add.

Let's please do the simple thing.  It just takes one two-liner macro.

Thanks.

-- 
tejun
