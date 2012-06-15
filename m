From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf: Use css_tryget to avoid propping up css refcount.
Date: Fri, 15 Jun 2012 10:40:07 +0900
Message-ID: <20120615014007.GA12624@mtj.dyndns.org>
References: <20120614223108.1025.2503.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=W7ODQg1DheXEzIeaf1ppQPkEBYJcC/TNZU1hyicxb/A=;
        b=T854YsHI5E/wzch78QdttgLBMUtHbQP0p1RKlnhhD7hciCjF0mai25gdo7MMirHNCg
         C0F3xsCgOTVRedmlvX7cJ89ua4CdUiWMuQRDY2rTS/qAtAk/CFQ7UCpAJntCrJzzSwcQ
         yHpjBtPFqEVIDa3wGDB12DmY2MkTxxHKYA7IMDEdJjqY3RtuwDHToxbmtlSXVj+nuEo9
         YB3gI3a0y+M4SpXdAfyLSza4nB6I1otnKNESrxm9fC6qDDUYN2VJCb6vL+N7TBEvbwD8
         4Fb63Aipt9R4jyzYjo811ZxMuvmVBCduNep2kejDtr2JTg14N55eIQX8vBJdEwR92AZB
         cJKQ==
Content-Disposition: inline
In-Reply-To: <20120614223108.1025.2503.stgit-Oz2bD8w/QAX+Wsei8lUk51LMcqb5oVE02SarAXORi/o@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 14, 2012 at 03:31:09PM -0700, Salman Qazi wrote:
> An rmdir pushes css's ref count to zero.  However, if the associated
> directory is open at the time, the dentry ref count is non-zero.  If
> the fd for this directory is then passed into perf_event_open, it
> does a css_get().  This bounces the ref count back up from zero.  This
> is a problem by itself.  But what makes it turn into a crash is the
> fact that we end up doing an extra dput, since we perform a dput
> when css_put sees the ref count go down to zero.
> 
> css_tryget does not fall into that trap. So, we use that instead.
> 
...
> Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Peter, can you please pick up this one?

Thanks.

-- 
tejun
