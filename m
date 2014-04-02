From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 0/3] Per-cgroup swap file support
Date: Wed, 2 Apr 2014 16:54:33 -0400
Message-ID: <20140402205433.GW14688@cmpxchg.org>
References: <1396470849-26154-1-git-send-email-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=iGsPgmdjlzC1DtGFBNxnaELIYhTZsR9+8QjsOB6Mm1o=;
	b=bOIPS/78x0oiXFH8g7nQeCjyYZC9dkAGmUgZ5udCXO4yqlLrJpKgG2sQhtPkAVFmiOMw3KMmgqLZfJvqiA2/Cppr8vTolaWV/BNzfgI7PCDqTfq3Kw4KPhdi28c9t8szASpcDNzv7xRqvmUBYretykxIQB46zAd079+UnhkGYtU=;
Content-Disposition: inline
In-Reply-To: <1396470849-26154-1-git-send-email-yuzhao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, jamieliu@google.com, suleiman@google.com

On Wed, Apr 02, 2014 at 01:34:06PM -0700, Yu Zhao wrote:
> This series of patches adds support to configure a cgroup to swap to a
> particular file by using control file memory.swapfile.
> 
> Originally, cgroups share system-wide swap space and limiting cgroup swapping
> is not possible. This patchset solves the problem by adding mechanism that
> isolates cgroup swap spaces (i.e. per-cgroup swap file) so users can safely
> enable swap for particular cgroups without worrying about one cgroup uses up
> all swap space.

Isn't that what the swap controller is for?

config MEMCG_SWAP
	bool "Memory Resource Controller Swap Extension"
	depends on MEMCG && SWAP
	help
	  Add swap management feature to memory resource controller. When you
	  enable this, you can limit mem+swap usage per cgroup. In other words,
	  when you disable this, memory resource controller has no cares to
	  usage of swap...a process can exhaust all of the swap. This extension
	  is useful when you want to avoid exhaustion swap but this itself
	  adds more overheads and consumes memory for remembering information.
	  Especially if you use 32bit system or small memory system, please
	  be careful about enabling this. When memory resource controller
	  is disabled by boot option, this will be automatically disabled and
	  there will be no overhead from this. Even when you set this config=y,
	  if boot option "swapaccount=0" is set, swap will not be accounted.
	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
	  size is 4096bytes, 512k per 1Gbytes of swap.
