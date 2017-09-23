From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Sat, 23 Sep 2017 06:44:02 -0700
Message-ID: <20170923134402.GI828415@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170922180530.GG828415@devbig577.frc2.facebook.com>
 <20170923133731.uq5qekjypndpjv2l@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WNuLKCy/gD+hBl0vBFzFO1/5okDUL1kpOidSmmM0Tnk=;
        b=Or1t+ovkJSxgqxmGtlcU12mxTtV4Uo6TwSqJud7sejimjsYCcKeKOqMr/S6XArRRoG
         1lXIVuH0KCAQzmXKhwxGvsSJ0DS1fG+jACs4T88hb2m9rt/9hibdM4oCnRfXW3VgVW2+
         4uTIDPBwc2M+YWMtfZoQos6FxI/t4iccifH3+IvYOI3sVA1UIaJHyRFH6m5AIbzUIM2z
         O/q2cRUYhKaTFRqhWsd+zjq7YZ4Tg5BxoGkDJHBcjCgECzMDEfQ52FI/KkF6BrjR/8gy
         jmlhCL+2s3HNE+/lig0La5IYgfULo3+SrjYqvYueEa1jSep6ElinH/hXPNvNsEQL92hu
         +V4A==
Content-Disposition: inline
In-Reply-To: <20170923133731.uq5qekjypndpjv2l-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Peter.

On Sat, Sep 23, 2017 at 03:37:31PM +0200, Peter Zijlstra wrote:
> On Fri, Sep 22, 2017 at 11:05:30AM -0700, Tejun Heo wrote:
> > Peter, ping?
> 
> Humm,. So I think I was good, but I was under the impression you'd send
> a new version better explaining the need/design of that iteration stuff.
> Could be I lost the plot somehow.

The updated version was posted quite a while ago.

  http://lkml.kernel.org/r/20170829174325.GS491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org

Thanks.

-- 
tejun
