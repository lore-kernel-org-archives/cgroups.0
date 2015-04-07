From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Tue, 7 Apr 2015 10:00:26 -0400
Message-ID: <20150407140026.GK10582@htj.duckdns.org>
References: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
 <1427878641-5273-4-git-send-email-cyphar@cyphar.com>
 <20150401160258.GP9974@htj.duckdns.org>
 <CAOviyai9dvCTGK=VUm0uDSo7XbmKk1BFDrRzL15ppAWf8YjG3w@mail.gmail.com>
 <20150406150536.GA10582@htj.duckdns.org>
 <CAOviyagYWk1VJW3upKsOS8rOiBQFTn752eJA_C2SkHnCh7EUrw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=q93F8bMyMHE0M3mhxZJwsXqTWOy13HyqwDX2Z0ZhYMw=;
        b=Xb077pH2GOQEXtxD775zdxDgWSgqj+8xhGQr8kPyxN+kVxDLvKuB5lIkWHW9vUlwM6
         4zY+Frus2laj+7h5i6pYpowVnsi/XQ3EEpzzk0G+zUo8pXc8qNPCKCEnT+2YtkchNcRr
         q4N5TYpGtpz+IBKtnLIgKftFSXAWXTiBvyKkt20qLjJC0LphKUl6Huk6gYd62h3Vsty+
         RdE28QhSwXUNGjFQol/7lmz58H04nG29oqlbED8iaegJKLjQ0o3rngG+nPXLWD0VgMaF
         ocNitmdvpw//ewevKGN5f7TcI27tebleTVgZyjwDoAy3ZorXtUtlFpAq4fJXToutIiJz
         8VVQ==
Content-Disposition: inline
In-Reply-To: <CAOviyagYWk1VJW3upKsOS8rOiBQFTn752eJA_C2SkHnCh7EUrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 07, 2015 at 11:47:02PM +1000, Aleksa Sarai wrote:
> > [...] I don't
> > think it's a good idea to send the patches as-are because we can't
> > debug and fix them properly, right? [...]
> 
> In what way are they hard to debug?

Some failures can happen before console init and figuring out what's
going on can be tricky.

...
> difference between having an array of CGROUP_SUBSYS_COUNT pointers or
> CGROUP_PREFORK_COUNT is the few bytes of memory you've "saved" (at the expense
> of making the callback code essentially unreadable).

Hmmm?  Just define a marker macro so that the index can be extracted
and loop over the indices and call the callbacks?  Why would this be
any more complex than anything else?

-- 
tejun
