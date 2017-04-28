From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup writeback support
Date: Fri, 28 Apr 2017 17:19:20 -0400
Message-ID: <20170428211920.GC22354@htj.duckdns.org>
References: <CAEC-ZVGrPu6_BZJX3SBbysMnccOHiCXAzskwqZnRhK1=bN7dbg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=jNMllhbs1THPkJllOLw+xFy/hrLtezDqv/cDw+zr9Ys=;
        b=GgAiQ70Hqfe1U3rM+T9R0a3HzVlv8+5j6/3Mv05NFxtz6YdDHcT+6GBpTCBcXOXQS4
         thThQ1AQGs7Y36CA2BOeHu6VOlLj6hAsAvLlkSdu8nAWvTj016a/uKdSSwL4+57opjSi
         0bXWDOhulLtPTZvUo/O5/WLHwqjC0dEtSDOeNg7xdjVZ70SsDd9MrVOVa4yKMF2EkP/Q
         X0t0Ki6GpQg/wuGluU1mqk9Wdr7NRrwesgre4TFYISBiNYNpaxFEy1XAkBuD3guVxt2k
         PNJi6Prw8fpvQ9YNe03deUT6Qg7FStpjy7eHPEqfs07G0vtqeRAXExSz1ujN/BXDBII1
         Wq6A==
Content-Disposition: inline
In-Reply-To: <CAEC-ZVGrPu6_BZJX3SBbysMnccOHiCXAzskwqZnRhK1=bN7dbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?5byg5pys6b6Z?= <zblgeqian-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Apr 19, 2017 at 05:58:56PM +0800, 张本龙 wrote:
> Is it because I did something wrong or missed anything? As I find many
> branches exist in kernel/git/tj/cgroup.tj, it would be great if you
> could help explain the roles of the different branches and how the

Heh, those are from a long time ago.  These are all work-in-progress
branches and trying to chase down which branch was for what won't be
easy.  They're mostly ad-hoc.

> repo works in general. Especially, I want to know the first repo
> branch/linux release that has writeback support so it's easier to
> learn how it's built up step by step from the commit log.

If it's for tracking down the commits to help understanding the code,
I'd recommend tracking down the history with git whatchanged on the
main files (fs/fs-writeback.c and mm/backing-dev.c and
mm/page-writeback.c) and then browse the commits from there.

Thanks.

-- 
tejun
