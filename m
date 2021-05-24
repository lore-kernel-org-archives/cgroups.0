From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: fix spelling mistakes
Date: Mon, 24 May 2021 12:46:13 -0400
Message-ID: <YKvYVQAK/vq4+W1D@slm.duckdns.org>
References: <20210524082943.8730-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xb83GxWuZ4lA/TU3wPWgTdHTzlUcMb9aPuUp5f5l1bc=;
        b=J267Mg6sPL7xE5r9tBvmjLBHGaBUmRVpD3f92Vtj67ZkwORZs3Q4mDEy1QhHVfEflK
         HzJjehPKFCqWxXQ6rpg8xm3BFOitPCoAgWbvCGUEti0QxKOxkZJmYbLQ34H9xvgQEsnI
         ujKY84Y6zP9TNU4RKNXw8cJiimowP9K8MEVQdHzIUmugq97OA1r4Wajn4Qnrb42G4cxj
         HxFv93uMSj/LWyB+rr++cTQ2ltzpGeCZmQjRqS5TYdSqgs7dB5pSfOUeyloG5u1jbQ1w
         9pnhZfgEeUqE3nNCrOLcEC5m/wlwxRednw3NF7KhUXdX1xLPjxqXT+C1xRnfYMl6aReR
         4dPw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210524082943.8730-1-thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 24, 2021 at 04:29:43PM +0800, Zhen Lei wrote:
> Fix some spelling mistakes in comments:
> hierarhcy ==> hierarchy
> automtically ==> automatically
> overriden ==> overridden
> In absense of .. or ==> In absence of .. and
> assocaited ==> associated
> taget ==> target
> initate ==> initiate
> succeded ==> succeeded
> curremt ==> current
> udpated ==> updated
> 
> Signed-off-by: Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.13-fixes.

Thanks.

-- 
tejun
