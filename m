From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: disallow rename(2) if
 sane_behavior
Date: Mon, 17 Jun 2013 10:06:49 -0700
Message-ID: <20130617170649.GC32663@mtj.dyndns.org>
References: <20130614034717.GA31533@htj.dyndns.org>
 <20130616071648.GA1978@tango.0pointer.de>
 <20130616221556.GC28587@htj.dyndns.org>
 <20130617130029.GB3212@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1aCDOgU8lo9h2TknpjC5Q7hE3+JxqljT5bizspNzP18=;
        b=kcjUnbXakbc3P7pOtlDWg2bl3lh+w1LZLTO6inibz/bqk61Uy8oYctEkqnoKy2E59z
         zVXLCmgfSdOdKgpQTLKmMNf/AunMz3Ne7ZItEwcTwOL8auXVu8cSP6amFJJyRRfPcN74
         G+0sNXcmZwEUEO+b9ryBUBXgJzTIXI8HugMAGo7ffLZeaP4ehohmQJvUz7Q7ZH2EkVTg
         a8fhhODV9vv9gl0YYxPdFoUbzFrYdKD99FxBJrbN/JXqU/zn0HGZlV5r4E0eLAnrdHI3
         8JN1oTMS81nVqIrgTMF11xcLLtonG6vCYuVVukSzkhCWDUxtpxahHARMnZjeN2IqiB1U
         tR4g==
Content-Disposition: inline
In-Reply-To: <20130617130029.GB3212-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Aristeu.

On Mon, Jun 17, 2013 at 09:00:29AM -0400, Aristeu Rozanski wrote:
> sure, I'm on it. that sounds like one of the versions of the hierarchy
> patchset - having the local configuration saved but only applying what's
> possible based on parent's state.

Yes, basically, any configuration should be allowed but its
application would be confined by its ancestors and a parent changing
configuration should propagate the effective limits down the hierarchy
but shouldn't affect the configurations directly - ie. if an ancestor
adds a device to the list of disallowed devices and then removes it
back, the whole subtree should return to the original state.

As we're introducing an incompatible interface with
cgroup_sane_behavior() anyway, if necessary, devcg can also change
behaviors dependent on the flag.  Not encouraged but given the breadth
of the changes we're making with the flag, I don't think devcg would
stand out too much by doing so.

Thanks.

-- 
tejun
