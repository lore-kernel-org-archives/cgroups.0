From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Mon, 30 Jul 2018 10:51:20 -0700
Message-ID: <20180730175120.GJ1206094@devbig004.ftw2.facebook.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180727220123.GB18879@amd>
 <20180730154035.GC4567@cmpxchg.org>
 <20180730173940.GB881@amd>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2GUU2NQxPe+c5GHCdzu0ZJwdHlbVGMaZie+kRtpGjyI=;
        b=oRnNB8aPWbfW1sKOERCxwdKy5HH738RdZ7KEXB7jauHElr680EK9s5FGpqz/2JejVN
         5/3I2hyM2gQp4PJ5CsOwwnOZqDd7JMsRMV2uakaab5DcDfUACwAe3/qIjt7RzGd+gVH2
         i5hEOS1UBX40YdQVb5cg/M0crv88ahLVdAXWhQ88uTBoDxYG6QMOIim77tL4xSadgghz
         bmRd4Segi+pMkuh+HevNormpOAV/kDSIUoRUH9OprFzY1s2qkeJWg5XcOXlIDX+v1v63
         ZUoWJyEELZSMYR7HCT1N3tiK3gfFauiRUwNErxaAoW2rrzCqbQM3fISqRUpTlTDOgPH/
         7VmA==
Content-Disposition: inline
In-Reply-To: <20180730173940.GB881@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Mon, Jul 30, 2018 at 07:39:40PM +0200, Pavel Machek wrote:
> > I'd rather have the internal config symbol match the naming scheme in
> > the code, where psi is a shorter, unique token as copmared to e.g.
> > pressure, press, prsr, etc.
> 
> I'd do "pressure", really. Yes, psi is shorter, but I'd say that
> length is not really important there.

This is an extreme bikeshedding without any relevance.  You can make
suggestions but please lay it to the rest.  There isn't any general
consensus against the current name and you're just trying to push your
favorite name without proper justifications after contributing nothing
to the project.  Please stop.

Thanks.

-- 
tejun
