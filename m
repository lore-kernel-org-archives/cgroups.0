From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/6] memcg: track shared inodes with dirty pages
Date: Thu, 15 Jan 2015 13:55:43 -0500
Message-ID: <20150115185543.GA28195@htj.dyndns.org>
References: <20150115180242.10450.92.stgit@buzz>
 <20150115184914.10450.51964.stgit@buzz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gDRPE5mTMxsT8cIsylHzvuu9WLrGPdXL6TWA7mFiHlY=;
        b=vcC6k/zbhWbrPZCnnpYkiHlJFoB5QiCnzDw8ZPCtP7CT97WMmkQs7ZZ2co52r02aUG
         zbVIzrOVyVXWcp5YtFUmMVOr+kF5e79Meoh+a+H+or4JG9ZHNOQktQ8Sa4mX+4MKTosT
         7CXcEYbxhH+WoEflr/Upmo+P3bGhOIaEVJ8tfq3dgCaE+FgK0eZ3lAZjaTdovHw3m+zL
         unXRfeIAiJ1XYzNq+drph/GPoxlx/zZGUgJmqLfblnCghoW5NIzOtZ8lorvSCPsUBqeM
         /d+c+uxxjeiFIEmphxfwyTQEwZEucAgrYJic1OzFi0VS8n5juxAdnYOfeRzJDZRluwnp
         HNAA==
Content-Disposition: inline
In-Reply-To: <20150115184914.10450.51964.stgit@buzz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, koct9i@gmail.com

On Thu, Jan 15, 2015 at 09:49:14PM +0300, Konstantin Khebnikov wrote:
> From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> 
> Inode is owned only by one memory cgroup, but if it's shared it might
> contain pages from multiple cgroups. This patch detects this situation
> in memory reclaiemer and marks dirty inode with flag I_DIRTY_SHARED
> which is cleared only when data is completely written. Memcg writeback
> always writes such inodes.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

This conflicts with the writeback cgroup support patchset which will
solve the writeback and memcg problem a lot more comprehensively.

 http://lkml.kernel.org/g/1420579582-8516-1-git-send-email-tj@kernel.org

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
