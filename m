From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Mon, 9 Mar 2015 15:51:17 -0400
Message-ID: <20150309195117.GW13283@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-3-git-send-email-cyphar@cyphar.com>
 <20150309033405.GE13283@htj.duckdns.org>
 <54FDED43.4050908@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zMvdNFNXDPXgavcQacD5PObgF4B+/6hlhjYkNyzAgJ0=;
        b=O+MVGQVzeERmj/kffpVUZ3Y33F2Ea8H08HI/Nu4VMzp+QGyjqKYEpAah+cmwPrN/sF
         h09CRdQfjYkZJOIyY1/HSGqmPC+lDPIZafo5m4eFC62tbHw2VgMtReZzCgIIu1/HNKiD
         aO08T+tBFtTDJ902Wa+W05f8Jg0flAGaLNnwSrLA1L0eNL8QaKLIHo6GsGVwH7ItRsK6
         sOKT8KbxdYKtvWu7V6kCPdcSkWJEwNPmdYQCyreT6c6zP2IFRPlUV1ySyGbWHyXqJ84e
         THvfmytpR9jeVu13WFNAXnBuR1NWqGUOY6BYSs2HppM1kfVqAbUMhDWRBASc2wMyl4Y8
         c5mw==
Content-Disposition: inline
In-Reply-To: <54FDED43.4050908-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Austin.

On Mon, Mar 09, 2015 at 02:58:11PM -0400, Austin S Hemmelgarn wrote:
> On 2015-03-08 23:34, Tejun Heo wrote:
> >
> >Does pids limit make sense in the root cgroup?
> >
> I would say it kind of does, although I would just expect it to track
> /proc/sys/kernel/pid_max (either as a read-only value, or as an alternative
> way to set it).

I don't think that's a good idea.  It doesn't add anything while
putting pids controller in conflict with how other controllers handle
the root cgroup.  Furthermore, I don't think it's generally a good
idea to add things because it may help convenience in some cases,
which is exactly the case here.  Why add non-orthogonal component when
the only reason is "yeah, it may be a bit more convenient in some
imaginary cases"?  We'd be restricting the design space we can move
inside for no good reason.

Thanks.

-- 
tejun
