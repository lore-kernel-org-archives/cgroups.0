From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Tue, 24 Apr 2018 15:30:02 +0300
Message-ID: <20180424123002.utwbm54mu46q6aqs@esperanza>
References: <20180423123610.27988-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RgjmwzZ2PusUuxKAHqPTseGS5zThP/05HRpAU7JEHnM=;
        b=fhNBEluivFp9ke2Hsw0Qa+pxhG+yRWhpC6aKTN4YptcAuojD8gVYeRRLs4x6s0zXpE
         SkGo0NeVaM5EjSlRyVy4f5jpd9wveURQFfiYqWtBIYgV50iUuBgWQOboQbLDImMXrIcW
         3QOCVzjlH1X4RevLYO7+NvBbJfNH0Q4PJkHFvpcByRuWBqMvsUoZCvOX/yw+VPy6xiON
         E8cgQag4Wg2tjlLQ9oYLKfBh7xSwtpw0wuY3xSrfgvyHGjIH7BTw5gQrWS7oAKYi+0am
         ZcLWSIPdiin8ThAXsGvHeh335iXQBgMHPhAbPB8oPY8T4Il3WaIrepuM085nLTrnAy/+
         43yw==
Content-Disposition: inline
In-Reply-To: <20180423123610.27988-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>

Hi Roman,

On Mon, Apr 23, 2018 at 01:36:10PM +0100, Roman Gushchin wrote:
> +  memory.min
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "0".
> +
> +	Hard memory protection.  If the memory usage of a cgroup
> +	is within its effective min boundary, the cgroup's memory
> +	won't be reclaimed under any conditions. If there is no
> +	unprotected reclaimable memory available, OOM killer
> +	is invoked.

What will happen if all tasks attached to a cgroup are killed by OOM,
but its memory usage is still within memory.min? Will memory.min be
ignored then?

> +
> +	Effective low boundary is limited by memory.min values of
> +	all ancestor cgroups. If there is memory.min overcommitment
> +	(child cgroup or cgroups are requiring more protected memory
> +	than parent will allow), then each child cgroup will get
> +	the part of parent's protection proportional to its
> +	actual memory usage below memory.min.
> +
> +	Putting more memory than generally available under this
> +	protection is discouraged and may lead to constant OOMs.
