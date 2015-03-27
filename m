From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 21/48] writeback: make backing_dev_info host
 cgroup-specific bdi_writebacks
Date: Fri, 27 Mar 2015 17:41:54 -0400
Message-ID: <20150327214154.GE638@htj.duckdns.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
 <1427086499-15657-22-git-send-email-tj@kernel.org>
 <20150327210612.GA23840@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ft90k6WW96sCTYcUIviVIoYPAC/U4S6bD7QCGnXc6TY=;
        b=JPCMTQozZZqnjcyrIdbp4od9aetM1ORjPEDTe6irVtN/FTjzoHkQDs+XTDFGqZJMag
         wKItt8SnNO5HrVtW5YdaRINGVUMokC0gA8DJ5g+tch0oatIIKc4HyD/Va3B2Vx/eihv1
         aJZkMu+wfe4wPiuMpNt1J77E9aNo1a4rUVbAYj+6E+noPYrk9MMszzc4LdGTrTO0bWvx
         2frP8xWAu7jNBfUClPtlfXwPOegd2usx065Ff6jgvE7thO6NuenpJxkjJruhmMLJdhbB
         Ep3iZsTAKyPsU71yva22g6VcvWa2Xt+Tkkk6+nsPnUNeNJXaOIX7oKdahNhdtAS85YnM
         iOsg==
Content-Disposition: inline
In-Reply-To: <20150327210612.GA23840@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

Hello Vivek.

On Fri, Mar 27, 2015 at 05:06:13PM -0400, Vivek Goyal wrote:
> I was curious to know that why do we need this "struct page *page" when
> trying to attach a inode to a bdi_writeback. Is using current's cgroup
> always not sufficient?

So, memcg's page ownership is first-use based and it never gets
updated once set till the page is released which means that there can
be corner cases where an inode is mostly faulted in by one cgroup and
then constantly dirtied by another.  Because the ownership belongs to
the initial cgroup which instantiated those pages, cgroup writeback
ends up considering the pages as belonging to that initial cgroup and
the foreign detection will trigger if it's being written by a
different cgroup.  Hmmmm... this isn't a huge problem as once the
foreign detection triggers, the problem will be corrected but still
when the page is availalbe, I think it makes sense to attach to the
page as that's what actually defines the ownership.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
