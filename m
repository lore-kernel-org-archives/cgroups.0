From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 17:18:23 -0400
Message-ID: <20170601211823.GC13390@htj.duckdns.org>
References: <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
 <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
 <20170601184740.GC3494@htj.duckdns.org>
 <ca834386-c41c-2797-702f-91516b06779f@redhat.com>
 <20170601203815.GA13390@htj.duckdns.org>
 <e65745c2-3b07-eb8b-b638-04e9bb1ed1e6@redhat.com>
 <20170601205203.GB13390@htj.duckdns.org>
 <1e775dcf-61b2-29d5-a214-350dc81c632b@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BF4wFyH3ZfnvLX9gEZnes+VCdvF1eVxsLVf0g5iFIXg=;
        b=O03XR1tbHJvhZEJYS7hdKV0BHTnpKKGzuGuDG3FxLtH44c3xbNOs0OclY9Ub/memFs
         z406T9tDuVNpgLXktF8nCu7ux287nomWoeos8gkKjJsKP6iaCM1by+alr9bdcRfdzZs5
         l4WZwPye8cmr0TZ6sa63mjcd7VtoYdURq3/iGY6C+v72EEGFYbgbQSGAtbsQJuhJGnWS
         hNFaswsTBy82TmXFisjlN7XX6SfuP4pTLW5fxonQm6EaXcQsh5XuCqJlAquvA2CrpazN
         U0wTdji87VWPtzxxVdu1O4snO6NrAML4JTCXoAhIIKHXsUsOKrBbXd/F30ZIm6wKBisZ
         Ra6g==
Content-Disposition: inline
In-Reply-To: <1e775dcf-61b2-29d5-a214-350dc81c632b@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Thu, Jun 01, 2017 at 05:12:42PM -0400, Waiman Long wrote:
> Are you referring to keeping the no internal process restriction and
> document how to work around that instead? I would like to hear what
> workarounds are currently being used.

What we've been talking about all along - just creating explicit leaf
nodes.

> Anyway, you currently allow internal process in thread mode, but not in
> non-thread mode. I would prefer no such restriction in both thread and
> non-thread mode.

Heh, so, these aren't arbitrary.  The contraint is tied to
implementing resource domains and thread subtree doesn't have resource
domains in them, so they don't need the constraint.  I'm sorry about
the short replies but I'm kinda really tied up right now.  I'm gonna
do the thread mode so that it can be agnostic w.r.t. the internal
process constraint and I think it could be helpful to decouple these
discussions.  We've been having this discussion for a couple years now
and it looks like we're gonna go through it all over, which is fine,
but let's at least keep that separate.

Thanks.

-- 
tejun
