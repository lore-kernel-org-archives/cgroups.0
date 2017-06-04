From: Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] swap: cond_resched in swap_cgroup_prepare()
Date: Sun, 4 Jun 2017 12:38:50 -0700
Message-ID: <20170604193850.GA15369@google.com>
References: <20170601195635.20744-1-yuzhao@google.com>
 <20170602081855.GE29840@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tvYWOLh58itKLgqg77cyP+Nq9k/fggR0aX+R33Zstmo=;
        b=lzGF/2osMlWoUYbVITcyVA+qDr90XgxnSxfDcGdUK2z1foEkLrNiXCMFtL7bmUovk+
         YjcAUzqMA1E2Vcz4WoGRiu9pz5EBzW980wn0VYbp4ePRRtxFKyJAtRN7z2StHBQ1U5om
         EubfTP7pjvkadhonsh3B46nhBXPseWKDw8URyI9TpypNLGLQyFajib+CkY9sA2YtWvIR
         oA2zwohjJLQA73GloGwLDzTXE1DRTEsjzabZuYmVvf2MM40qH8+TQqYUlVkd7HeC9zZb
         yGE60UlhL7ZkE1DrE357iL77fRdj5NIgS7OCzTNvKXXQbcsSuxb6wikE7VD0SEhGpngR
         4GXg==
Content-Disposition: inline
In-Reply-To: <20170602081855.GE29840@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jun 02, 2017 at 10:18:57AM +0200, Michal Hocko wrote:
> On Thu 01-06-17 12:56:35, Yu Zhao wrote:
> > Saw need_resched() warnings when swapping on large swapfile (TBs)
> > because page allocation in swap_cgroup_prepare() took too long.
> 
> Hmm, but the page allocator makes sure to cond_resched for sleeping
> allocations. I guess what you mean is something different. It is not the
> allocation which took too look but there are too many of them and none
> of them sleeps because there is enough memory and the allocator doesn't
> sleep in that case. Right?
> 
> > We already cond_resched when freeing page in swap_cgroup_swapoff().
> > Do the same for the page allocation.
> > 
> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> 
> The patch itself makes sense to me, the changelog could see some
> clarification but other than that
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks, I'll clarify the problem in the commit message and resend the
patch.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
