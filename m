From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: Proportional memory.{low,min} reclaim
Date: Mon, 15 Jul 2019 23:57:29 +0100
Message-ID: <20190715225729.GA19191@chrisdown.name>
References: <20190124014455.GA6396@chrisdown.name>
 <20190128210031.GA31446@castle.DHCP.thefacebook.com>
 <20190128214213.GB15349@chrisdown.name>
 <20190128215230.GA32069@castle.DHCP.thefacebook.com>
 <20190715153527.86a3f6e65ecf5d501252dbf1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7VSl4WMlmc5jmN5dNuL2dV5fcPROFvmtmokhA+NF36I=;
        b=FupgII/o9bbimWyh0bR/UkrMCpIcBrEpJ9ja2EO6K5VA/hOxrdLwUrKeytS0QyP0Y0
         OhXsBBkmUiEHwe9vHBVKjTY1KbQ8/G/lcXfmnhG5kapCPmdHusIlp+cwSXAld52Wnqa/
         nRh649s69N06QxHZL6McwutEtJnh9SDnxj+SU=
Content-Disposition: inline
In-Reply-To: <20190715153527.86a3f6e65ecf5d501252dbf1@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

Hey Andrew,

Andrew Morton writes:
>On Mon, 28 Jan 2019 21:52:40 +0000 Roman Gushchin <guro@fb.com> wrote:
>
>> > Hmm, this isn't really a common situation that I'd thought about, but it
>> > seems reasonable to make the boundaries when in low reclaim to be between
>> > min and low, rather than 0 and low. I'll add another patch with that. Thanks
>>
>> It's not a stopper, so I'm perfectly fine with a follow-up patch.
>
>Did this happen?

Yes, that's "mm, memcg: make memory.emin the baseline for utilisation 
determination" :-)

>I'm still trying to get this five month old patchset unstuck :(.

Thank you for your help. The patches are stable and proven to do what they're 
intended to do at scale (both shown by the test results, and production use 
inside FB at scale).

>I do have a note here that mhocko intended to take a closer look but I
>don't recall whether that happened.
>
>I could
>
>a) say what the hell and merge them or
>b) sit on them for another cycle or
>c) drop them and ask Chris for a resend so we can start again.

Is there any reason to resend? As far as I know these patches are good to go.  
I'm happy to rebase them, as long as it doesn't extend the time they're being 
sat on. I don't see anything changing before the next release, though, and I 
feel any reviews are clearly not coming at this series with any urgency.

Thanks for the poke on this, I appreciate it.
