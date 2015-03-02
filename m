From: Christoph Lameter <cl@linux.com>
Subject: Re: [patch v2 1/3] mm: remove GFP_THISNODE
Date: Mon, 2 Mar 2015 09:46:33 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1503020944200.5540@gentwo.org>
References: <alpine.DEB.2.10.1502251621010.10303@chino.kir.corp.google.com> <alpine.DEB.2.10.1502271415510.7225@chino.kir.corp.google.com> <54F469C1.9090601@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F469C1.9090601@suse.cz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
	s=q20140121; t=1425311195;
	bh=DYUEaHt7pKMpZWPD7v/v4GSmdsWVMzL/061RgDBQFIE=;
	h=Received:Received:Received:Received:Date:From:To:Subject:
	 Message-ID:Content-Type;
	b=T5LV+jahKA35t3gljf333BYptB3TeltL3KnBNULZqjFbdtrpqhmd/CoFzy2L/K+ww
	 bNWlq04V/xUmk3eRz1pAw9mFCU1FqI6KTHDAVMrVoSWOF8sMJBffUffsa7spudOl10
	 K6qVnUu69SgD0TRoUaSxvdYEnxI+2rJgV+KW/nYqKi/b5lPbDITqWIv74Xagght+5Y
	 0QzsDsubWGHkCFlcHLAq8Wj2C5aE8qXSrUWmNtOckMwgF12XdgX7VggPpe+VXH8YBq
	 hxm5IQmY/1SjhbzmZJgHo9fddsG9v+AA2MPAtIqRXRGyEg0KWJIALwsqhr5F6/9VAt
	 VRITHruu4MGvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Pravin Shelar <pshelar@nicira.com>, Jarno Rajahalme <jrajahalme@nicira.com>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, dev@openvswitch.org

On Mon, 2 Mar 2015, Vlastimil Babka wrote:

> So it would be IMHO better for longer-term maintainability to have the
> relevant __GFP_THISNODE callers pass also __GFP_NO_KSWAPD to denote these
> opportunistic allocation attempts, instead of having this subtle semantic

You are thinking about an opportunistic allocation attempt in SLAB?

AFAICT SLAB allocations should trigger reclaim.
