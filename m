From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm: Make mem_cgroup_id_get_many() __maybe_unused
Date: Thu, 5 Mar 2020 12:22:48 -0500
Message-ID: <20200305172248.GB2508@cmpxchg.org>
References: <20200305164354.48147-1-vincenzo.frascino@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fYgwNPn+hzRISUrcnyS4RtnmnpZ3Kb0VaVci8GbrKTU=;
        b=o3YE+cY0AMvX9FIW61axswC5hLklVI8JTAIAQgcBVazuzotTqc/h+Pg/g6abfRuyzX
         4tXglOcKGcpc3Vagoluun7pQ18V4NCAMAXN4KVIey9I3n/1BsqLmzHVTuYyPZDoMVbS9
         GO/1VbUKbSM4tglRQh3iDgaRKj9fi/5oH2waIvdNhUu7AFyImdXwXpx21mwDy2i4i583
         gsNE50sIgAG7q8VTCuKUIRa9C0XTWAXjU/lPN0+zsdp6Mhxfvpxo9x0ciDBWiSofPoLW
         XYl/9twPKE5N9aeDYfS3VDDx0eVriYJZRqtpPPdiX7+DsxzXzILz+SDuaSXU9Xn3dwjf
         PB3w==
Content-Disposition: inline
In-Reply-To: <20200305164354.48147-1-vincenzo.frascino@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Mar 05, 2020 at 04:43:54PM +0000, Vincenzo Frascino wrote:
> mem_cgroup_id_get_many() is currently used only when MMU or MEMCG_SWAP
> configuration options are enabled. Having them disabled triggers the
> following warning at compile time:
> 
> linux/mm/memcontrol.c:4797:13: warning: ‘mem_cgroup_id_get_many’ defined
> but not used [-Wunused-function]
>  static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned
>  int n)
> 
> Make mem_cgroup_id_get_many() __maybe_unused to address the issue.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Vincenzo.
