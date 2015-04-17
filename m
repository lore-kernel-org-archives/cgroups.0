From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 17 Apr 2015 10:45:19 -0400
Message-ID: <20150417144519.GC1954@htj.duckdns.org>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
 <1428799917-15141-4-git-send-email-cyphar@cyphar.com>
 <20150413142439.GA2596@htj.duckdns.org>
 <CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ@mail.gmail.com>
 <20150414121732.GL2596@htj.duckdns.org>
 <CAOviyaj6eQ6s50+DrQN8yFAp7q5Y6b4ReFOT8XT0UufPb5J0xQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Xr+1DOxSVJI22EXyd8Son+vVW05gclsQQh98ztyKo90=;
        b=fejDSLKwaMXDyFeLScdrqc19CmCvDZK1Q0n4NkqwF7agnw+IYx1RSlAt099RrIk8YK
         8Kg7tiQIyST/U9UdV53FOsLJCmWtfyarNNhGds/UU7wYz8Gdp4bd8pfl8t2sOk+XoZ9O
         wQ5r/n2D0mgNB88dePp7rSkLNWiYTdYBvT7ZJCxwnYBUF7EPo4p71hDog7L1H+T34+zk
         WD46Q8lC10wJEiarGYfOq5/lq+Obf30T4/09cVcf8m/EfNhxX5t/j9z1Alp/mss4okob
         7EhQdDePUhO3Oqb0PV2yFo6h4nVtxA2DqTEWO3d2vqEGLqEw6HbTm78X2/7SiSUyL5dp
         Mu6g==
Content-Disposition: inline
In-Reply-To: <CAOviyaj6eQ6s50+DrQN8yFAp7q5Y6b4ReFOT8XT0UufPb5J0xQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 16, 2015 at 11:57:29PM +1000, Aleksa Sarai wrote:
> Do you also want me to completely drop the COUNT macro? IMO it makes
> the CGROUP_<TAG>_COUNT consolidation much nicer.

What's wrong with simply having start and end tags?

-- 
tejun
