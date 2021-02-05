From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/7] mm: memcontrol: fix cpuhotplug statistics flushing
Date: Fri, 5 Feb 2021 12:50:13 -0500
Message-ID: <YB2FVc7tNL2RUNm0@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-2-hannes@cmpxchg.org>
 <20210202230747.GA1812008@carbon.dhcp.thefacebook.com>
 <20210203022853.GG1812008@carbon.dhcp.thefacebook.com>
 <YBxLNZJ/83P7H8+H@cmpxchg.org>
 <20210204193446.GA2053875@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YE/YQGTHwZ7gbs66msaBXwH+40vFYJVzTcKrkbmzw0I=;
        b=IVvwgK3FTWbjgP5nm2j9BXlUlBzZ1hTRtXk/4fib3jzaTm1sVv7WdBvZvfPD2jKDUa
         khdknLUh6qENaXt8+w9ONS1Gu3Mm3HlFqtPsNS11qBVaQI/GtdJnxSCYwe3+1nHILCej
         0BRSBSa3l5/AgXY1OxiHgJsINK+yfsx4V6yMLTh8CQndgAhldR0OKcFwtH1X2Z2MkHh3
         6y9mkW3fa6UldKMrsp0IbaRUP+9vFdq/WRDG1KDLDncCT+2z6GzAZmCVzFxBdhcW5aRp
         Llr5FFaJEbG/2Z/I2K0Dxv6rB5qT3Fx8r6CY+SuqmO0W8Ta9j3DakS+/MsLgCRSzuBvZ
         Kp1A==
Content-Disposition: inline
In-Reply-To: <20210204193446.GA2053875-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 04, 2021 at 11:34:46AM -0800, Roman Gushchin wrote:
> On Thu, Feb 04, 2021 at 02:29:57PM -0500, Johannes Weiner wrote:
> > It even passes with a reduced margin in the patched kernel, since the
> > percpu drift - which this test already tried to account for - is now
> > only on the page_counter side (whereas memory.stat is always precise).
> > 
> > I'm going to include that data in the v2 changelog, as well as a patch
> > to update test_kmem.c to the more stringent error tolerances.
> 
> Hm, I'm not sure it's a good idea to  unconditionally lower the error tolerance:
> it's convenient to be able to run the same test on older kernels.

Well, an older version of the kernel will have an older version of the
test that is tailored towards that kernel's specific behavior. That's
sort of the point of tracking code and tests in the same git tree: to
have meaningful, effective and precise tests of an ever-changing
implementation. Trying to be backward compatible will lower the test
signal and miss regressions, when a backward compatible version is at
most one git checkout away.
