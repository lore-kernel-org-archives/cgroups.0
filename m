From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Sun, 17 May 2015 21:24:32 -0400
Message-ID: <20150518012432.GA22064@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-5-git-send-email-cyphar@cyphar.com>
 <20150422162954.GF10738@htj.duckdns.org>
 <CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
 <20150424153657.GC24029@htj.duckdns.org>
 <CAOviyah9yyXJG0eUeizpb5ZnzNUAKfxXGkXJw-5sNw7sQOAEuA@mail.gmail.com>
 <20150513172906.GY11388@htj.duckdns.org>
 <CAOviyaimfHD=Jg1+FEwyapwO=zdaL0bvq8YDA1Cnq90YbfGENQ@mail.gmail.com>
 <20150513174707.GA11388@htj.duckdns.org>
 <CAOviyaiJnxmiRPEGFutEXiV-D5XwJUhwRJ1w8P3Yn2QLGO9bbw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9VibIOWFDgSwTm+HtkpK6V9GnOFcJCcEGuugpYKUAqA=;
        b=ZVRNG0nV/U+w2Q424LJwKoFUG79XfJRC23ZzJ/yyMRlkLYZ9ytOxVI1B//ZmjGiNPl
         +/i94ADt5Z+GosnZ4Y5kmsI3kgW5sMUQ44tFtn6osQ/MXI55jBXkuzlihFIZnm/yW5I+
         AoshXCmMnh58PFLA/R4OCeXfB8tPQtIBaywzhek6FSTasH+4kNa0KMr6LN+5dFPCaVCH
         wGotnCXGvG47HSOJHKRhNDTdraYw+JT6pvIPyTIX6pU9iKaYgvhxKBnKs2vgKOQFcCTK
         u4DnhlOKkmvkjLljoccD5WtJqKDaPmKhbA1A1WXSm4wEa3ZOSykdEH2zdnKXVNP783Hp
         kJFw==
Content-Disposition: inline
In-Reply-To: <CAOviyaiJnxmiRPEGFutEXiV-D5XwJUhwRJ1w8P3Yn2QLGO9bbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 16, 2015 at 01:59:09PM +1000, Aleksa Sarai wrote:
> One question RE: defaults for .config. What is the kernel policy for
> deciding if a particular subsystem should be made enabled-by-default?

Just default to N.

Thanks.

-- 
tejun
