From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Proportional memory.{low,min} reclaim
Date: Mon, 15 Jul 2019 15:35:27 -0700
Message-ID: <20190715153527.86a3f6e65ecf5d501252dbf1@linux-foundation.org>
References: <20190124014455.GA6396@chrisdown.name>
        <20190128210031.GA31446@castle.DHCP.thefacebook.com>
        <20190128214213.GB15349@chrisdown.name>
        <20190128215230.GA32069@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563230128;
        bh=Dhp2+rAmaJRqgQ4W9zWGRLoTJ1hk6O5nwAes/tP0jXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OYNxeNqlSp4DM+68xBXNHVmmuaMCEc7vAD+ioCjOMRuJnlCWj5Z4QFMkH+09l0tju
         vVg15F6qj1fwZhkSrafpF5PiJWeixRExiJuHx8RGfkobzmc90Tff/7ld+JpcFve56S
         li8bTQVcIwkIthO4FJwMEpLAxdLXovL3EGbCQ+3w=
In-Reply-To: <20190128215230.GA32069@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Mon, 28 Jan 2019 21:52:40 +0000 Roman Gushchin <guro@fb.com> wrote:

> > Hmm, this isn't really a common situation that I'd thought about, but it
> > seems reasonable to make the boundaries when in low reclaim to be between
> > min and low, rather than 0 and low. I'll add another patch with that. Thanks
>
> It's not a stopper, so I'm perfectly fine with a follow-up patch.

Did this happen?


I'm still trying to get this five month old patchset unstuck :(.  The
review status is: 

[1/3] mm, memcg: proportional memory.{low,min} reclaim
Acked-by: Johannes
Reviewed-by: Roman

[2/3] mm, memcg: make memory.emin the baseline for utilisation determination
Acked-by: Johannes

[3/3] mm, memcg: make scan aggression always exclude protection
Reviewed-by: Roman


I do have a note here that mhocko intended to take a closer look but I
don't recall whether that happened.

I could

a) say what the hell and merge them or
b) sit on them for another cycle or
c) drop them and ask Chris for a resend so we can start again.
