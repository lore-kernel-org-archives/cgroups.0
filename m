From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v13 13/16] vmscan: take at least one pass with shrinkers
Date: Tue, 10 Dec 2013 16:38:46 +0400
Message-ID: <CAA6-i6pWF-iiqLEUwcODKUCr+ng-H0Wc=L7+WFxUxo=Yr7MM8A@mail.gmail.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<5287164773f8aade33ce17f3c91546c6e1afaf85.1386571280.git.vdavydov@parallels.com>
	<20131210041826.GB31386@dastard>
	<52A6FFF0.6080207@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=lkrXguvgbWBXFR9tsRNVYqDxVzKto2NiUuy2WLTQmbA=;
        b=qNpQg9Dn4rnke81TiMBg7hFBGF7nDclCNRZNk+c3TtMWjGcKeFDalUa2YuR+OT20pD
         WySdrAuktnOQOcKvOoG3uxE5+pU68Pa74uMFPDbCLSfQf/vRaPr0yOYLmU4P48OZovKQ
         IN+T52oi2uok3b1PP6ncASqo5wHAeVlpw0Gx3/BMbweXLoIBs4o6vUlW+Y+C1Snem2kV
         ee9uSPON5nZQo+hoTvfFJNU3tHRv9wbfUXnuOq3GDVuIXyTrIYqJUw1sysgEI/Zetfc0
         yuAIEBARZAFVi6/+6BYy/EatDS1nhxYgH7tiGnBf6DH2ZRUgOvjh5ruUcsGToc38xsUj
         WLXw==
In-Reply-To: <52A6FFF0.6080207-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Glauber Costa <gloomer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Dec 10, 2013 at 3:50 PM, Vladimir Davydov
<vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 12/10/2013 08:18 AM, Dave Chinner wrote:
>> On Mon, Dec 09, 2013 at 12:05:54PM +0400, Vladimir Davydov wrote:
>>> From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>>>
>>> In very low free kernel memory situations, it may be the case that we
>>> have less objects to free than our initial batch size. If this is the
>>> case, it is better to shrink those, and open space for the new workload
>>> then to keep them and fail the new allocations.
>>>
>>> In particular, we are concerned with the direct reclaim case for memcg.
>>> Although this same technique can be applied to other situations just as
>>> well, we will start conservative and apply it for that case, which is
>>> the one that matters the most.
>> This should be at the start of the series.
>
> Since Glauber wanted to introduce this only for memcg-reclaim first,
> this can't be at the start of the series, but I'll move it to go
> immediately after per-memcg shrinking core in the next iteration.
>
> Thanks.

So, the reason for that being memcg only, is that the reclaim for
small objects triggered
a bunch of XFS regressions (I am sure the regressions are general, but
I've tested them using
ZFS).

In theory they shouldn't, so we can try to make it global again, so
long as it comes together
with benchmarks demonstrating that it is a safe change.

I am not sure the filesystem people would benefit from that directly,
though. So it may not be worth the hassle...
