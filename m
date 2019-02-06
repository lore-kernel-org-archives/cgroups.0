From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4] mm: Make memory.emin the baseline for utilisation
 determination
Date: Wed, 6 Feb 2019 15:31:17 +0100
Message-ID: <20190206143117.GA30357@cmpxchg.org>
References: <20190129191525.GB10430@chrisdown.name>
 <20190201051810.GA18895@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aCkiqYNvxX1a9nJPU/Nbyv1sM4Ffext0Xrvmi7ouJ9w=;
        b=hz72O9Y3uWIkSfq8uoOTQBadfjKQoIu+JKa5XW82YFIX8YDAvNP66Bge7LiyeLclz6
         iPBBiywri00HnOkmsvfIc/NksPb07HSk8jXer0XE78ZW8L7mFpxmioQ+3EfmHPNsJTF5
         JykLNcbGm7+TicqSMwxXi2uVkhSjTHKf3tRMBTcDtSC2qmmWv0LS2Ns9wLSFiI2qXghd
         i4EHmd1mj1w/ML9rhwhf4shb5qGzH76VAeA1OghmUVOb9Ttn6cUxUKMEv3kneBKuZvWh
         ffvmXiQLHx75vnbCqvd6U/66s1f1zBv9QW353zZVBTPVbgi1gEyY0r/2TMhKQhoHWj2f
         xmrg==
Content-Disposition: inline
In-Reply-To: <20190201051810.GA18895@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Fri, Feb 01, 2019 at 12:18:10AM -0500, Chris Down wrote:
> Roman points out that when when we do the low reclaim pass, we scale the
> reclaim pressure relative to position between 0 and the maximum
> protection threshold.
> 
> However, if the maximum protection is based on memory.elow, and
> memory.emin is above zero, this means we still may get binary behaviour
> on second-pass low reclaim. This is because we scale starting at 0, not
> starting at memory.emin, and since we don't scan at all below emin, we
> end up with cliff behaviour.
> 
> This should be a fairly uncommon case since usually we don't go into the
> second pass, but it makes sense to scale our low reclaim pressure
> starting at emin.
> 
> You can test this by catting two large sparse files, one in a cgroup
> with emin set to some moderate size compared to physical RAM, and
> another cgroup without any emin. In both cgroups, set an elow larger
> than 50% of physical RAM. The one with emin will have less page
> scanning, as reclaim pressure is lower.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Suggested-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
