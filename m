From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 2/2] mm: memcontrol: factor out reclaim iterator loading
 and updating
Date: Wed, 5 Jun 2013 16:06:51 -0700
Message-ID: <20130605230651.GO10693@mtj.dyndns.org>
References: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
 <1370472826-29959-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OBAuXVIQiaHComhWghRFYAZU4t1j/Kkbl4BIl0YWwuc=;
        b=T+pEUfpSCaEG8pmSV6eyEECy/b6E1lUp4A6kjHX7/W7ZzRrEOu9igxJ4r21rxl/u0Q
         4Dh2ged8O8AZG+FIzbGhx7PBL3+UZmS35XR8uFoP3oT6YAJtGEFtW/WrGJpuGdvW/BhN
         VTp8IZwaWrqgmAOKp5evZRRrWs/0n1abAbxM3Q/poT4x08msTH1tdnnIr3Z+q+msW+Cv
         fTteQUYpemWJ4qFLziCSOoi66VkFMaMNeRfnXUHBB+VI86LxWueqVt003NFuhkB6OlOu
         VBbxck79cexJnYWHAw3RZ3YfuPlwxquDWNvCjQZuqC9MxZfbAG3ehsFk545DIeuz2Ju5
         sB9A==
Content-Disposition: inline
In-Reply-To: <1370472826-29959-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 06:53:46PM -0400, Johannes Weiner wrote:
> mem_cgroup_iter() is too hard to follow.  Factor out the lockless
> reclaim iterator loading and updating so it's easier to follow the big
> picture.
> 
> Also document the iterator invalidation mechanism a bit more
> extensively.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
