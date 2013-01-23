From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Wed, 23 Jan 2013 15:06:08 -0800
Message-ID: <20130123230608.GJ2373@mtj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
 <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
 <50FD3123.6090003@parallels.com>
 <20130123010226.GF5359@htj.dyndns.org>
 <CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
 <20130123165657.GC2373@mtj.dyndns.org>
 <CAMbhsRRj9svWubn01wb+f=jSwVWC5u7DqJ5c8P23vAp0E2L8Rg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=PQGz3b2EXbsCNafLJQEXVfmCmt7rit3yK5zLAcYAaUk=;
        b=JZWSI/JA2t6cmXxTuiW6QVbq0nLZgv/4VercoohLSPv+3KQJjstaUQnaVUPTtacbab
         XVfV2w2sk0PLJY+1sIg3Izlu3fRa6ToBGnn1U454P9WNTnay0OVkkZEN7p6ZUoLufLin
         vhpnAlMK0+nBypTZuhxzgKrUPjIUbKPsFoKEOyLQVHiHfviu9mlwKYmf6XOoGupMkWpT
         EWFIKy3i0b1TywS5i8y8kHtkEY85CnsZTaOziatdE8YYujI1mPHok2AkmSAegD0IkNWm
         nn5QZPR/nnBYYUDXZRA5cQpn3vUJJCKuben2qI4cu40WbPw+MofIuLh4PW6x+lJap62F
         FBIA==
Content-Disposition: inline
In-Reply-To: <CAMbhsRRj9svWubn01wb+f=jSwVWC5u7DqJ5c8P23vAp0E2L8Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Collin.

On Wed, Jan 23, 2013 at 02:41:46PM -0800, Colin Cross wrote:
> I think some of it is just historic, we previously did not group
> application threads in the scheduler, so it would cause a change in
> behavior if we started grouping them.  I will investigate switching to
> a co-mounted hierarchy so hopefully you can deprecate cpuacct in the
> future.

Yeah, it's gonna be many years, if ever, before we can actually
deprecate cpuacct and multiple hierarchies but it would be really nice
to move at least popular uses away from them sooner than later.

Also, maybe I'm misunderstanding what you were saying but isn't it the
case that only single application is "foreground" in at least vanilla
android?  Maybe multi-window support is scheduled for future releases
but it wouldn't count as behavior change in that case, right?

At any rate, IMHO, it's simply the better and correct to not depend on
the number of threads in use as a measure of CPU resource
distribution.

> We can't factor the number of threads into the policy decision,
> because it depends on how many threads are runnable at any time in any
> particular application, and we have no way to track that.  It would
> have to be a cgroup scheduler feature.

My understanding of android is very limited but the number of threads
in dalvik apps are controlled by the base system rather than
application itself, no?  If so, factoring that into scheduling params
shouldn't be difficult.  For native processes, if the number of
threads just *have* to be factored in some way, we can resort to
sampling.  That said, as native apps can easily thread-bomb out of
fairness, there are way more reasons to avoid basing the resource
policy decision on the number of threads in use.

Thanks.

-- 
tejun
