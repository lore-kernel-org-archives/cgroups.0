From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sat, 24 Oct 2015 06:36:07 +0200
Message-ID: <1445661367.3218.62.camel@gmail.com>
References: <20150824213600.GK28944@mtj.duckdns.org>
	 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
	 <20150824221935.GN28944@mtj.duckdns.org>
	 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
	 <20150825210234.GE26785@mtj.duckdns.org>
	 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
	 <20150912144007.GA8942@htj.duckdns.org>
	 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
	 <20151001184629.GB26498@mtj.duckdns.org>
	 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
	 <20151023222110.GA4390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=QG6GyMrFY+NhzKOYiMktqjTITQnV6n768MIoJOzFgjM=;
        b=uA7anNm7EGeS0Mb8unZZljyfWPvMcKQN11I2hGtaanfj8NWZufBqA0ZKnQgVOyRceI
         4Ed17mSIcwrxsgIQNDwZ8ng6Tc6VXC5rRAz+tCB/nQ4/PLceZPFRYZJ4wxbneIrXjzoz
         IAupj5oLVOLTYbm91Aoc6hNzeYZRNWc2W/fm03K3f0VZu8MQHgdMgORoN4ddVJk0OxX+
         v2dS4oYr8yIGAJ6FyJG0WZuguqDDA5Yj10m9GA09283vYjTOKfwxbT1bwEKmeuaLJmtc
         QywVbGv8t1upmCEJ7Y34bc1fesSy+kvjl+NouxmZRK/+wCQcMnU1+BYC48Yk9MsVLjOe
         FNWA==
In-Reply-To: <20151023222110.GA4390@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Sat, 2015-10-24 at 07:21 +0900, Tejun Heo wrote:

> It'd be a step back in usability only for users who have been using
> cgroups in fringing ways which can't be justified for ratification and
> we do want to actively filter those out.

Of all the cgroup signal currently in existence, seems the Google signal
has to have the most volume under the curve by a mile.  If you were to
filter that signal out, what remained would be a flat line of noise.

	-Mike
