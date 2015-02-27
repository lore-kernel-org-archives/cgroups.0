From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 12:56:19 -0500
Message-ID: <20150227175619.GN3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PKda7dLuwxVQdaI0Lvpi/Cb/P1qc0TYxsVB4dTQXRMM=;
        b=yZbIc5uk/8ERH5o3Hwoa7qBPZzwHK6S1JDH1tPiJrxuXbWrupGIhj7gxYYLrQ8pi2H
         S7d1eGvACo/JADtU6qkwjp3QlXrOYxtDZypUhPFIf5j/U9YFJ5Lvx74EG1k7p7a5PI8/
         iZhkDC8ZouaaighEaT7pxCirLIQWkTcyscfdiNyvdj47dbW6/YXnr5oUk8SXWvLINzaj
         FiJXyDYXHo0NpJnEUbVlBjRq4uzzB6mzOaySfqndsCh8o7C9EP+/3WpGGuvTsOrTsee6
         I6pYhwBKTHm+F0SS4YmaYDL0z/hm3kIwLaFLLWl4czheNY283foMLmwL/iS9X/f1nKEK
         1J9Q==
Content-Disposition: inline
In-Reply-To: <20150227174503.GM3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 27, 2015 at 12:45:03PM -0500, Tejun Heo wrote:
> If your complaint is that this is taking too long, I hear you, and
> there's a certain amount of validity in arguing that upstreaming a
> temporary measure is the better trade-off, but the rationale for nproc
> (or nfds, or virtual memory, whatever) has been pretty weak otherwise.

Also, note that this is subset of a larger problem.  e.g. there's a
patchset trying to implement writeback IO control from the filesystem
layer.  cgroup control of writeback has been a thorny issue for over
three years now and the rationale for implementing this reversed
controlling scheme is about the same - doing it properly is too
difficult, let's bolt something on the top as a practical measure.

I think it'd be seriously short-sighted to give in and merge all
those.  These sorts of shortcuts are crippling in the long term.
Again, similarly, proper cgroup writeback support is literally right
around the corner.

The situation sure can be frustrating if you need something now but we
can't make decisions solely on that.  This is an a lot longer term
project and we better, for once, get things right.

Thanks.

-- 
tejun
