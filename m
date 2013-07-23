From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 3/3] vmpressure: Make sure there are no events
 queued after memcg is offlined
Date: Tue, 23 Jul 2013 12:18:25 -0400
Message-ID: <20130723161825.GC21100@mtj.dyndns.org>
References: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
 <1374252671-11939-3-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QM9LcCZ7ZZOONJ6J98GXiBfYGZF+aLoecodUuw4MjfM=;
        b=llzWgh8rEKTAn2T5W3rFjPBkWXYJD7ihzFBvLaOtf69oo/6pnQ+dAKB942vhCPlkHY
         f1KJgwkF+a9+bj75fnhJ5UytkZLXB1yCWerRnAow7GB+wkdpMLO1JeiGBFpSsPnDg/8I
         qJrQrR7yo/WvyIJ2f2sLbLEj3d1JTp68zSvJrm6Q4U8FCi1wMtNIsHtPTEmBPbRPtjn4
         4RO42W9jAoR9zSKDJuT6Ct87Z97yT4YA1BCbWj6a3q/DGj54lX/Mt9VSFjXbSh/dTIfz
         fDfW7WphrfFb+gfWmkbxcATVmlZFM/2axJcP595NZyZ/KBtIu/mqNN7/FwY/1QVr2q2b
         feoA==
Content-Disposition: inline
In-Reply-To: <1374252671-11939-3-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Anton Vorontsov <anton.vorontsov@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 06:51:11PM +0200, Michal Hocko wrote:
> vmpressure is called synchronously from the reclaim where the
> target_memcg is guaranteed to be alive but the eventfd is signaled from
> the work queue context. This means that memcg (along with vmpressure
> structure which is embedded into it) might go away while the work item
> is pending which would result in use-after-release bug.
> 
> We have two possible ways how to fix this. Either vmpressure pins memcg
> before it schedules vmpr->work and unpin it in vmpressure_work_fn or
> explicitely flush the work item from the css_offline context (as
> suggested by Tejun).
> 
> This patch implements the later one and it introduces vmpressure_cleanup
> which flushes the vmpressure work queue item item. It hooks into
> mem_cgroup_css_offline after the memcg itself is cleaned up.
> 
> Reported-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
