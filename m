From: Li RongQing <roy.qing.li@gmail.com>
Subject: Re: [PATCH][V2] mm: memcontrol: fix the margin computation in mem_cgroup_margin
Date: Thu, 26 May 2016 09:28:13 +0800
Message-ID: <CAJFZqHwYC_BbTNG=5=LYxo+6q6HadEMDkVTcZS1eCqXoD=6HnA@mail.gmail.com>
References: <1464068266-27736-1-git-send-email-roy.qing.li@gmail.com>
	<20160525155122.GK20132@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=o/Aj9cNHZwAH8yd4ua4WtSyz1V6ombgl6fYjXbzJvGc=;
        b=BFFvPshydvPzbwVjeGoLGbpBTijwsCPOcetkojJK5laYr3oGjZY0vd1Ri8unBk4RY7
         lOfp6Y3jaavzL/OycfhcfM5yfzdAx0Qc5f6Vj2w/qx6EMz4hvBhLbBTKs3VJfwgAsjtr
         lublxVQGjBp5FPaRSKH5OppVjXuE4isQ3vTiYySskeSWSyf3ygTXHGC1EfEAmQGeqw8d
         g7ZjLMIaPeBhIDtGLwLwTPPpMjHithBTbZOZ6Bi68BbQPdfLVrqG8H8lbFKdrE0zcCjN
         UVUP87d9/rLUfbh5awAbNE2v+OS1Sg8b7c3IBCqiGR4bcUSR6Rz0DDYYowKja45IH7hi
         78eQ==
In-Reply-To: <20160525155122.GK20132@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>

On Wed, May 25, 2016 at 11:51 PM, Michal Hocko <mhocko@kernel.org> wrote:
> This is quite hard for me to grasp. What would you say about the
> following:
> "
> mem_cgroup_margin might return memory.limit - memory_count when
> the memsw.limit is in excess. This
> doesn't happen usually because we do not allow excess on hard limits and
> memory.limit <= memsw.limit but __GFP_NOFAIL charges can force the charge
> and cause the excess when no memory is really swapable (swap is full or
> no anonymous memory is left).


Sorry for my poor English, thanks for your description, hope it can be
into the log

-Roy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
