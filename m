From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 1/4] memcg: Track exported dma-buffers
Date: Wed, 25 Jan 2023 12:52:26 +0100
Message-ID: <Y9EX+usSpAjZ/8LS@dhcp22.suse.cz>
References: <20230123191728.2928839-1-tjmercier@google.com>
 <20230123191728.2928839-2-tjmercier@google.com>
 <Y8/ybgp2FW+e3bjc@dhcp22.suse.cz>
 <20230124194628.d44rtcfsv23fndxw@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674647547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SJ/Hov8dA5AtQwjazEvVbMXGIJ9ndLLp47N7ofQ4cx4=;
        b=pXgacsTdHgiGYyBVN9vgcoDkHPc99KMqxN2lHF4x8BCAe49JWYrvjhluYPBo8Aeiyuau/n
        HZpptJzXCIUorXumCdWJLU1ZdriRaVaJLMK8evnFcYo8OX8aItgG9bo+TU9MqtAEMbhTxh
        0FmX6ijtqb1rsOdAc8WxYlw22VbBysI=
Content-Disposition: inline
In-Reply-To: <20230124194628.d44rtcfsv23fndxw@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, daniel.vetter@ffwll.ch, android-mm@google.com, jstultz@google.com, jeffv@google.com, cmllamas@google.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org

On Tue 24-01-23 19:46:28, Shakeel Butt wrote:
> On Tue, Jan 24, 2023 at 03:59:58PM +0100, Michal Hocko wrote:
> > On Mon 23-01-23 19:17:23, T.J. Mercier wrote:
> > > When a buffer is exported to userspace, use memcg to attribute the
> > > buffer to the allocating cgroup until all buffer references are
> > > released.
> > 
> > Is there any reason why this memory cannot be charged during the
> > allocation (__GFP_ACCOUNT used)?
> > Also you do charge and account the memory but underlying pages do not
> > know about their memcg (this is normally done with commit_charge for
> > user mapped pages). This would become a problem if the memory is
> > migrated for example.
> 
> I don't think this is movable memory.
> 
> > This also means that you have to maintain memcg
> > reference outside of the memcg proper which is not really nice either.
> > This mimicks tcp kmem limit implementation which I really have to say I
> > am not a great fan of and this pattern shouldn't be coppied.
> > 
> 
> I think we should keep the discussion on technical merits instead of
> personal perference. To me using skmem like interface is totally fine
> but the pros/cons need to be very explicit and the clear reasons to
> select that option should be included.

I do agree with that. I didn't want sound to be personal wrt tcp kmem
accounting but the overall code maintenance cost is higher because
of how tcp take on accounting differs from anything else in the memcg
proper. I would prefer to not grow another example like that.

> To me there are two options:
> 
> 1. Using skmem like interface as this patch series:
> 
> The main pros of this option is that it is very simple. Let me list down
> the cons of this approach:
> 
> a. There is time window between the actual memory allocation/free and
> the charge and uncharge and [un]charge happen when the whole memory is
> allocated or freed. I think for the charge path that might not be a big
> issue but on the uncharge, this can cause issues. The application and
> the potential shrinkers have freed some of this dmabuf memory but until
> the whole dmabuf is freed, the memcg uncharge will not happen. This can
> consequences on reclaim and oom behavior of the application.
> 
> b. Due to the usage model i.e. a central daemon allocating the dmabuf
> memory upfront, there is a requirement to have a memcg charge transfer
> functionality to transfer the charge from the central daemon to the
> client applications. This does introduce complexity and avenues of weird
> reclaim and oom behavior.
> 
> 
> 2. Allocate and charge the memory on page fault by actual user
> 
> In this approach, the memory is not allocated upfront by the central
> daemon but rather on the page fault by the client application and the
> memcg charge happen at the same time.
> 
> The only cons I can think of is this approach is more involved and may
> need some clever tricks to track the page on the free patch i.e. we to
> decrement the dmabuf memcg stat on free path. Maybe a page flag.
> 
> The pros of this approach is there is no need have a charge transfer
> functionality and the charge/uncharge being closely tied to the actual
> memory allocation and free.
> 
> Personally I would prefer the second approach but I don't want to just
> block this work if the dmabuf folks are ok with the cons mentioned of
> the first approach.

I am not familiar with dmabuf internals to judge complexity on their end
but I fully agree that charge-when-used is much more easier to reason
about and it should have less subtle surprises.
-- 
Michal Hocko
SUSE Labs
