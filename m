From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 14:35:39 -0500
Message-ID: <20150227193539.GO3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <54F0BC51.4050506@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jzmzxCAhxFhqR/25L2bQ8H34I3gF3QSrVinzjcUCkzw=;
        b=uEhx9XzyEUGCVV7KggLBVRSmGaVVAgd+e7BlaL6MpMyO4BBNYz4GesRwPGTJovFz5g
         b6bpX8X+evCH/o2cebO8A6y7g8vMDe/K0+Jr+ITV2Q+S2Pk7GPpa6KXDXbtyIVQolzI4
         nIkszfDp4Ii8yAamSQtu9Jddy7EUX61T+ko9B7TywI+xSczSRX0E6c2MMyO2p9nnY+NJ
         I5gtiaDN/xrfmra7OEn/KXw6zn3drgUMKD1amnKfXTReu3y64hsB5Cmy32/5NLW4Gm7a
         HWMNGD+UxGMnR4P1UbPeH1fecowM6iHFQApQmONgLUEWpxQCzYEzLv3t58Ku7iokkJPq
         fK7g==
Content-Disposition: inline
In-Reply-To: <54F0BC51.4050506-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Austin.

On Fri, Feb 27, 2015 at 01:49:53PM -0500, Austin S Hemmelgarn wrote:
> As far as being trivial to achieve, I'm assuming you are referring to rlimit
> and PAM's limits module, both of which have their own issues. Using
> pam_limits.so to limit processes isn't trivial because it requires calling
> through PAM to begin with, which almost no software that isn't login related
> does, and rlimits are tricky to set up properly with the granularity that
> having a cgroup would provide.
...
> PID's are a fundamental resource, you run out and it's an only marginally
> better situation than OOM, namely, if you don't already have a shell open
> which has kill builtin (because you can't fork), or have some other reliable
> way to terminate processes without forking, you are stuck either waiting for
> the problem to resolve itself, or have to reset the system.

Right, this is an a lot more valid argument.  Currently, we're capping
max pid at 4M which translates to some tens of gigs of memory which
isn't a crazy amount on modern machines.  The hard(er) barrier would
be around 2^30 (2^29 from futex side, apparently) which would also be
reacheable on configurations w/ terabytes of memory.

I'll think more about it and get back.

Thanks a lot.

-- 
tejun
