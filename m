From: Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH v2 0/3] Per-cgroup swap file support
Date: Wed, 2 Apr 2014 14:29:49 -0700
Message-ID: <20140402212949.GA29322@google.com>
References: <1396470849-26154-1-git-send-email-yuzhao@google.com>
 <20140402205433.GW14688@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TCRvpUyBzP4aujbCSHZ83ZOpuvXDQX7hiTDCFhrXG+M=;
        b=Tpcm4mTpGVM1O8jyiGsAeofk3vTgvcENdWv9mj8/XhVrpgKersCkJbR3Nh6bkxe3z0
         YyjYuYjR7s/jpLn8TxYrCI3OF3YPscxAys2ti8eyH4Ybf5ty6lh/sMbpOJVB+pdllpz4
         0bvvN4Onmk+GoqOhbpixKi9TrIkRELIuMjy/MKkSW6wrl9z2XzautfD8Edzc017eByrS
         urMseNeGh+eZzlaMBwJ5yJLHaYe8gImRaNnAg+85hFVs2bgxtyy44n/de6JoOt+RhgGL
         mvPLAD+anO3BtP9qARPNnHZu4SMqU4qF3WwkbSvHcFbEHqNPvN6QLliiMfheZWat8mFc
         d3lQ==
Content-Disposition: inline
In-Reply-To: <20140402205433.GW14688@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, jamieliu@google.com, suleiman@google.com

On Wed, Apr 02, 2014 at 04:54:33PM -0400, Johannes Weiner wrote:
> On Wed, Apr 02, 2014 at 01:34:06PM -0700, Yu Zhao wrote:
> > This series of patches adds support to configure a cgroup to swap to a
> > particular file by using control file memory.swapfile.
> > 
> > Originally, cgroups share system-wide swap space and limiting cgroup swapping
> > is not possible. This patchset solves the problem by adding mechanism that
> > isolates cgroup swap spaces (i.e. per-cgroup swap file) so users can safely
> > enable swap for particular cgroups without worrying about one cgroup uses up
> > all swap space.
> 
> Isn't that what the swap controller is for?

Well, I should've used word "isolating" instead of "limiting" (and yes, the
example I gave is confusing too). MEMCG_SWAP limits swaping while per-cgroup
swap file not only limits but also isolates the swap space. In another word,
per-cgroup swap file acts like the cgroup owns its private swap file which
can be specified to a particular path when users want the cgroup to swap to
a disk volumes rather than the one used by default (system-wide) swap files.

> 
> config MEMCG_SWAP
> 	bool "Memory Resource Controller Swap Extension"
> 	depends on MEMCG && SWAP
> 	help
> 	  Add swap management feature to memory resource controller. When you
> 	  enable this, you can limit mem+swap usage per cgroup. In other words,
> 	  when you disable this, memory resource controller has no cares to
> 	  usage of swap...a process can exhaust all of the swap. This extension
> 	  is useful when you want to avoid exhaustion swap but this itself
> 	  adds more overheads and consumes memory for remembering information.
> 	  Especially if you use 32bit system or small memory system, please
> 	  be careful about enabling this. When memory resource controller
> 	  is disabled by boot option, this will be automatically disabled and
> 	  there will be no overhead from this. Even when you set this config=y,
> 	  if boot option "swapaccount=0" is set, swap will not be accounted.
> 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
> 	  size is 4096bytes, 512k per 1Gbytes of swap.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
