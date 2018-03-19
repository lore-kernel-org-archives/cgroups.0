From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 19 Mar 2018 08:34:13 -0700
Message-ID: <20180319153413.GO2943022@devbig577.frc2.facebook.com>
References: <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
 <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
 <1520624424.27998.76.camel@gmx.de>
 <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
 <20180309221736.GB5926@hirez.programming.kicks-ass.net>
 <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
 <1520653648.12749.20.camel@gmx.de>
 <20180314195711.GD2943022@devbig577.frc2.facebook.com>
 <1521082141.7100.1.camel@gmx.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZGksuuewyAPyROG/hxaBdDCdlHVZ5iQFtb03QQJTaOk=;
        b=piPQY8AkOG/ayno9JPqwnHQFGxAiFBrSsB+Npe+OZqL3M4FbOF+vBqgH/pt3TAeTlS
         lMFlPGoZYT34Ur92Wyq3jFesOxVTo/gmZY99gwTVhNQVyxX12SgmkOKn6O4BOew5fP+O
         Zv5x9k4k3AXDAzuaMEqS0Kb+ns8fvfqHLVrAeQUip71oek5QOnEG88I2eqbhxro6OHhf
         gIyde0Wwl1fTmU4Sqp19VOUZ5vlMbxTcSF9r855xtuoiNTiLxiZilUmaB2j1F+xufdQ5
         bfbIUsO3ow9XCaeXY4xda5sn+qAAa1HMBMoMCHcOAx5LMn/dNclE7/pF54fEwpV11ljJ
         5+Og==
Content-Disposition: inline
In-Reply-To: <1521082141.7100.1.camel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <efault@gmx.de>
Cc: Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello, Mike.

On Thu, Mar 15, 2018 at 03:49:01AM +0100, Mike Galbraith wrote:
> Under the hood v2 details are entirely up to you.  My input ends at
> please don't leave dynamic partitioning standing at the dock when v2
> sails.

So, this isn't about implementation details but about what the
interface achieves - ie, what's the actual function?  The only thing I
can see is blocking the entity which is configuring the hierarchy from
making certain configs.  While that might be useful in some specific
use cases, it seems to miss the bar for becoming its own kernel
feature.  After all, nothing prevents the same entity from clearing
the exlusive bit and making the said changes.

Thanks.

-- 
tejun
