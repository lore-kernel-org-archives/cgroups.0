From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Mon, 30 Jul 2018 11:40:35 -0400
Message-ID: <20180730154035.GC4567@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180727220123.GB18879@amd>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Iehqudg7CKqI1RcAVqsYmuSRAZls32znE68LmEY9744=;
        b=JUWDBi++8tdTDhWMmCZNk+2ryfskvCC2KHCWHh2YOifEyrUUNGbnLKhEFH/K8a/FXV
         IlN71yO9e84YO9sqCOLMC2ndIDrvwUIWDSO8/bbOE56D7ppMnzwWVwYwUfWpGw2xwtKn
         bvKp5btEUMa4iSzczGRBf6Z7h+1v5Trxy6V7g+t4lYXMp9XUe7Lu1KtROskDJVX9kAiR
         opdhgldh01iCHrN/DX65/ZD8seeZWnRs9VNOO9Vjt1dMbW6a8MG5bcGGdvai7KVOIrsN
         PnDOYyzTYi2xxPrZ/rBHkkN5tL+fWM/O7tzcP15wxcuXMNTSpPsrF0D4In6dAGl4lpah
         y7Rw==
Content-Disposition: inline
In-Reply-To: <20180727220123.GB18879@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Sat, Jul 28, 2018 at 12:01:23AM +0200, Pavel Machek wrote:
> > 		How do you use this feature?
> > 
> > A kernel with CONFIG_PSI=y will create a /proc/pressure directory with
> > 3 files: cpu, memory, and io. If using cgroup2, cgroups will also
> 
> Could we get the config named CONFIG_PRESSURE to match /proc/pressure?
> "PSI" is little too terse...

I'd rather have the internal config symbol match the naming scheme in
the code, where psi is a shorter, unique token as copmared to e.g.
pressure, press, prsr, etc.

The prompt text that the user primarily sees spells out "Pressure", so
I don't think this is confusing.
