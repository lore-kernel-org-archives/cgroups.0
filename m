From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup: revert fa06235b8eb0 ("cgroup: reset css on
 destruction")
Date: Thu, 27 Jul 2017 09:52:40 -0400
Message-ID: <20170727135240.GE742618@devbig577.frc2.facebook.com>
References: <20170726083017.3yzeucmi7lcj46qd@esperanza>
 <20170727130428.28856-1-guro@fb.com>
 <20170727130428.28856-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tduT3S5mtmsNf9tFYhFQC9Nt3OHd4w+sTKoPRR7DQsg=;
        b=O0xBq4ij2EU8fKnY4+AxM8zaqh5j1d86IHgYtkbFC9fSKE0Qvtd7QiVUhL6x+s+3Rr
         KCef+sR/Lzqxm45gzocD6pRLizee1mnzUYr6dWVO8R6uZzhYyxG5p5e7hmcUcrnloMbR
         Qt/HdaRcCLxHla22ga7+2t6Rsu50P++Q+CWEzP6acKm4vg1BpEL/xvfGZmE00UYtQR+R
         4ZsmaLkWOcJboFH7TbHtODQhEZYLWQXcbl2s7DdBv48q2CkBP3hJ9Z6KveDkcm6/PECg
         Jq8hxbLQ1hsCsDrp9mC1RFCSFZoCEih/zEKEsnBMD0moBgaguRdYAfp9ri4TxvrArM6x
         GyjQ==
Content-Disposition: inline
In-Reply-To: <20170727130428.28856-2-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, Jul 27, 2017 at 02:04:28PM +0100, Roman Gushchin wrote:
> Commit fa06235b8eb0 ("cgroup: reset css on destruction") caused
> css_reset callback to be called from the offlining path. Although
> it solves the problem mentioned in the commit description
> ("For instance, memory cgroup needs to reset memory.low, otherwise
> pages charged to a dead cgroup might never get reclaimed."),
> generally speaking, it's not correct.
> 
> An offline cgroup can still be a resource domain, and we shouldn't
> grant it more resources than it had before deletion.
> 
> For instance, if an offline memory cgroup has dirty pages, we should
> still imply i/o limits during writeback.
> 
> The css_reset callback is designed to return the cgroup state
> into the original state, that means reset all limits and counters.
> It's spomething different from the offlining, and we shouldn't use
> it from the offlining path. Instead, we should adjust necessary
> settings from the per-controller css_offline callbacks (e.g. reset
> memory.low).
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with the previous patch through -mm.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
