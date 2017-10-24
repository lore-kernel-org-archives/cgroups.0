From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.15] cgroup, sched: Move basic cpu stats from
 cgroup.stat to cpu.stat
Date: Tue, 24 Oct 2017 07:59:15 -0700
Message-ID: <20171024145915.GC8598@devbig577.frc2.facebook.com>
References: <20171023231827.GA8598@devbig577.frc2.facebook.com>
 <20171024083504.GM3165@worktop.lehotels.local>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3Nwm2NUdXa5IxB7NlNwOCKwypQZ8aWHQ2EhcKVqedH4=;
        b=GrW7Dm1miSGykGyf36sxJS8NQFlstxq6U27h7aR78zkrtaDuG/iXQuFBxd2wIYjC9Q
         XL4Ugf43ClGSuGoF5QQvqdhX5vFdzaRNX2AsO+5dOJbvjVTMxZqM6t/JeQJqAzxxuDjw
         6CZ4yFs4KVwg2ThJuJTcMygnmlwoGaJWHZMsaWsvgj7KtCsg9e5XdMbkJCK980EmVupq
         kGwGbiSeumzVDOn4MHoa1Feh1qpWz7zriw9kde1YVmRrIxfCNDkW7tG2F5qFy+zUUgro
         bwZiTNq3i/MkmwH2sKXbycFMz+20OvJc6FOL3mY6IM+5hPskjzvTzp3MvK1Vp6GU6gRd
         jY4g==
Content-Disposition: inline
In-Reply-To: <20171024083504.GM3165-IIpfhp3q70x9+YH6RuovlLjjLBE8jN/0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Peter.

On Tue, Oct 24, 2017 at 10:35:04AM +0200, Peter Zijlstra wrote:
> > The more I think about showing cpu stat in cgroup.stat, the uglier it
> > seems. 
> 
> I've not been paying much attention to this, could you elaborate on the
> problems there?

Sure, so, on cgroup2, the basic stat collects cpu usage info whether
cpu controller is enabled or not.  As the hot path overhead is always
per-cpu and constant, there's no reason to not to and always having
the information is useful, especially as enabling cpu isn't free of
side-effects.  This is similar to what cpuacct did in cgroup1 but
cgroup2's single hierarchy makes the dedicated controller unnecessary.

The issue at hand with this patch is how the stat is presented when
the controller is not enabled.  There were two alternatives.

1. Make it available in the core file cgroup.stat with subsystem
   prefix ("cpu." for cpu).

   This is easy to implement but a bit ugly because when the
   controller is enabled, the same information is available in two
   places - cgroup.stat and cpu.stat.  Access from userspace becomes
   ugly too especially in cases where we make more fields available in
   basic stat.

2. Make $SUBSYS.stat available whether the controller is enabled or
   not.  Show the basic stat when the controller is disabled, show the
   full thing when enabled.

   This is somewhat more complicated to implement and having a
   subsystem specific file around when the controller is not enabled
   might be a bit confusing.  However, it ensures that a given piece
   of information is available in only one place and makes it less
   awkward to make more information available through basic stat.

The original implementation went for #1 and this patch switches it to
#2.

> > This patch flips it so that "cpu.stat" is always available
> > with basic cpu stat instead.  It only changes the presentation and
> > changes to the scheduler code is minimal.  Will route with the other
> > cpu controller changes through cgroup/for-4.15 unless there are
> > objections.
> 
> And this is -v2 only? I'm a little lost on how all that connects.

Yeap, basic stat is v2 only.  We can't do it against multiple
hierarchies with constant overhead.

Thanks.

-- 
tejun
