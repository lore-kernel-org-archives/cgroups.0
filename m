From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 1/4] memcg: Track exported dma-buffers
Date: Tue, 24 Jan 2023 15:59:58 +0100
Message-ID: <Y8/ybgp2FW+e3bjc@dhcp22.suse.cz>
References: <20230123191728.2928839-1-tjmercier@google.com>
 <20230123191728.2928839-2-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674572399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XLqxBQfQ00tnQcihjlqxyWWIteOiPhmeVkN+U5n5QiU=;
        b=ioVsAhbBdV1YHrLBEs6yIdAAV1QXNCZMBuzPaF312N9LCK2343XbyDbjM+FY8t1ZkxHq4n
        Oiz2oPGK3yovgBjLtnfOF0kKVLRWhKt1RSD2ksahTFWRZVbES3/JrtXujjXbbOKWjgqA2O
        iC2w/WyjLdNarJQAiedANs3mQbkKCFc=
Content-Disposition: inline
In-Reply-To: <20230123191728.2928839-2-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, daniel.vetter@ffwll.ch, android-mm@google.com, jstultz@google.com, jeffv@google.com, cmllamas@google.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org

On Mon 23-01-23 19:17:23, T.J. Mercier wrote:
> When a buffer is exported to userspace, use memcg to attribute the
> buffer to the allocating cgroup until all buffer references are
> released.

Is there any reason why this memory cannot be charged during the
allocation (__GFP_ACCOUNT used)?
Also you do charge and account the memory but underlying pages do not
know about their memcg (this is normally done with commit_charge for
user mapped pages). This would become a problem if the memory is
migrated for example. This also means that you have to maintain memcg
reference outside of the memcg proper which is not really nice either.
This mimicks tcp kmem limit implementation which I really have to say I
am not a great fan of and this pattern shouldn't be coppied.

Also you are not really saying anything about the oom behavior. With
this implementation the kernel will try to reclaim the memory and even
trigger the memcg oom killer if the request size is <= 8 pages. Is this
a desirable behavior?
-- 
Michal Hocko
SUSE Labs
