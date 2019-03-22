From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] fixup: vmscan: Fix build on !CONFIG_MEMCG from
 nr_deactivate changes
Date: Fri, 22 Mar 2019 15:06:45 +0000
Message-ID: <20190322150645.GC32163@chrisdown.name>
References: <155290128498.31489.18250485448913338607.stgit@localhost.localdomain>
 <20190322150513.GA22021@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mQ9n0LJWHq04GQyycgsbt63+kUhUfjFPp6Imgiozptc=;
        b=t4bfZHjqYlNcpYtbOTd0L2aL8YCrHmtR9jw4IXOpS4MH7a1j9hEA/EkLAVaIrYVSWW
         iG+Ru2fd+5vRNzfAq1wUg4XcUy8wpr9g+pnjcj3GOM8Kg6cwiTXlHWm8+mVQ4jxWDwBT
         mKqwDN8vorH0l/niQI2Vwwxw7HlAhsNq75efQ=
Content-Disposition: inline
In-Reply-To: <20190322150513.GA22021@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Chris Down writes:
>"mm: move nr_deactivate accounting to shrink_active_list()" uses the
>non-irqsaved version of count_memcg_events (__count_memcg_events), but
>we've only exported the irqsaving version of it to userspace, so the
>build breaks:

Er, "with !CONFIG_MEMCG", not "to userspace". No idea where that came from...
