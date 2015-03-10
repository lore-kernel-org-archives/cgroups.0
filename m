From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 10 Mar 2015 08:47:01 -0400
Message-ID: <20150310124701.GB28730@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-2-git-send-email-cyphar@cyphar.com>
 <20150309030636.GC13283@htj.duckdns.org>
 <CAOviyaip7Faz98YWzGoTaXGYVb72sfD+ZL4Xa89reU9+=43jFA@mail.gmail.com>
 <20150309065902.GP13283@htj.duckdns.org>
 <CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=N2m50NR5mNbVUs+UAlCjHUu6YN0hY1BxeXFM4OTyqnw=;
        b=mMOClZM99L7CX4f9KhY2sNdxN8uvnfrzPCElZ7CdhAlj7W44Zb4ePNcZax8hc+b9U1
         N6+lxbKv/j3kRj5HTY8hA8JCi+Hz5H0P9wwOxTREOHGRzYu5M3g+2dnT+NPMuRjIiG/U
         4b6tBqv00Vl4YVVcIeSJCmZ+QxDd4YFOsZ6Po6AtV4KQa+wc55nGQdpRsRjTYR5wPIHc
         q7kPmkqbLZ0dDrGVi3PoM0ZDqP6np+dYvaVAeU7+DqBQQZGpbzDeNFgSzdnA6VlPmTBj
         XvviSSIuxSGGfte/gWBkZy6U5N9p9iDJdl0iz86MV5LERP/mq6RKKHSmTJ4JywIz+HkY
         a14A==
Content-Disposition: inline
In-Reply-To: <CAOviyaj3mf66ho15WrD8qB=ECxKWYTAkWodxWaFVMWeZG4d0FQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Tue, Mar 10, 2015 at 07:19:06PM +1100, Aleksa Sarai wrote:
> I'm not sure how to check for equality between two `css_set`s (or just two
> `css`s). Is there a function to do so? Also, I'm not sure if there's a nice way

You can compare the css pointers for equality.

> of doing a charge that stops if you hit a certain `css` (unless we start
> passing `css_set`s to the fork/exit callbacks -- and then we can uncharge the
> old css_set and charge the new one).

We'll have to pass the pointer from can_fork side to post_fork.  I'm
not sure how that should be done either.

Thanks.

-- 
tejun
