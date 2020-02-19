From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 11:12:22 -0500
Message-ID: <20200219161222.GF698990@mtj.thefacebook.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
 <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com>
 <20200219151922.GB698990@mtj.thefacebook.com>
 <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com>
 <20200219154740.GD698990@mtj.thefacebook.com>
 <59426509.702.1582127435733.JavaMail.zimbra@efficios.com>
 <20200219155202.GE698990@mtj.thefacebook.com>
 <1358308409.804.1582128519523.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vu5V5rWZHyaueFfLFkEzCLEhOtHzeZSUWOLy/RNDYxo=;
        b=fWD0BpDlqjIvBRJjxFbuwfxPTi9xvRf58lXoOBdijX4wsvutNd7gBZtp/BuDfPcGfg
         QRY3Kyh5b7R0i/9gzorKY6Lh5L1wJTmDQY/3u4KIybAc206Ujo1rKsoUZgWlqEjLTbwg
         5qMIAz9gG7ke+PkPchTBy/Xx4F/OWSz7dviJnzyczN1sHo6xWJmPEHkl/z3qehySpQT6
         2YFQgdXnPD57KPnU3Pz1f3qZgTT9+6afevkoDpKxZW850MzDMZBsET9mvMKmYLtthANn
         wVQEUWUrronURe4HGk3bIHkZq5r0xkPuxwffXu1TAdxc8DfbDzMxzQ1icJi+MttU+cxJ
         EalQ==
Content-Disposition: inline
In-Reply-To: <1358308409.804.1582128519523.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On Wed, Feb 19, 2020 at 11:08:39AM -0500, Mathieu Desnoyers wrote:
> I wonder if applying the online cpu masks to the per-thread affinity mask
> is the correct approach ? I suspect what we may be looking for here is to keep

Oh, the whole thing is wrong.

> the affinity mask independent of cpu hotplug, and look-up both the per-thread
> affinity mask and the online cpu mask whenever the scheduler needs to perform
> "is_cpu_allowed()" to check task placement.

Yes, that's what it should have done from the get-go. The way it's
implemented now, maybe we can avoid some specific cases like cpuset
not being used at all but it'll constantly get in the way if you're
expecting thread affinity to retain its value across offlines.

-- 
tejun
