From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Wed, 10 Jan 2018 14:27:26 -0800
Message-ID: <20180110222726.GG3460072@devbig577.frc2.facebook.com>
References: <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
 <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
 <20180110142640.GB3668920@devbig577.frc2.facebook.com>
 <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
 <20180110193907.GC3460072@devbig577.frc2.facebook.com>
 <fdfc4c27-f87c-fab8-894c-f9f21374bab2@gmail.com>
 <20180110221418.GF3460072@devbig577.frc2.facebook.com>
 <5207cfc8-5525-b932-baee-6b0160886178@gmail.com>
Mime-Version: 1.0
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nuYo2rjGVEShUm5c52fD7yzDxGPdWSiuKHnND/dzh6s=;
        b=V5695BZW9NxFFfhn2mzd/kS5v3Z6xdHoGMAVMB4RDH6yyB0HI3qW3RHt5xbOry8Xbl
         hhfO5UlPszcOI6nNJlHnQDyG27HTRQeDWDmYgzYkFcVZhneWs4tYG4c9oIhIkjxC1lLJ
         sGeTSx3rw4HKD0iHcvBwyMNqIJgWuM86dOER8va5o5h3K6RPWEew+xvW8T26rRJjIr6r
         VlvLtnFYbTe37Jx/edakcbK4CkgtsGioWD237fuV5c7L5FXyJkbLMRxIdk84JDSentiE
         RXV7lHTZJVBWgOK2HzL8kJcKWU7NNwHOsTyU9/zgtdmZ3pD2SGQKO8qcHUTRE4mBB0yr
         DONA==
Content-Disposition: inline
In-Reply-To: <5207cfc8-5525-b932-baee-6b0160886178-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello,

On Wed, Jan 10, 2018 at 11:24:05PM +0100, Michael Kerrisk (man-pages) wrote:
> > Oh, I'm probably mixing up two things.
> > 
> > 1. When delegating, cgroup.threads should be delegated.  Doing that
> >    selectively doesn't achieve anything meaningful.
> 
> Understood. But surely delegating cgroup.threads is effectively
> meaningless when delegating a "domain" cgroup tree? (Obviously it's
> not harmful to delegate the the cgroup.threads file in this case;
> it's just not useful to do so.)

Yeap, unless we can somehow support non-root mixed domains.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
