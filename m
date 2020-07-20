From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v16 07/22] mm/thp: remove code path which never got into
Date: Mon, 20 Jul 2020 11:43:25 +0300
Message-ID: <20200720084325.fb6apppq5kvnw5eo@box>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-8-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2//ZirLZY8WUjufK4xWqlnUTAHx3aYPuLBIOLa7IvsM=;
        b=JYUDdhKTdn0PXDzqfyY8YfJq/9wrEPXYDXNQ2OX7FljO4qpB54LSndW8nr+4SmlARw
         Yrl4dxRuSDxwdROtDrErQYiHhp19afoSagdTmg9S9EB01SYQx4fTLdf1dCYISs6g9ABP
         G1iJjIeT6Jq5AC4VOx419ci7L8AbFkd9QApQXTxRpe6tT9pbYO4MrHLHQEDX0Z6JhIeo
         DVkQLUlsneyc4mXfuoSRjd/TH/DTejiSpwhW/jGTG3WbxPvsQhEZKvtTtFjlMmqDpvia
         eWYVCqFdw3wUSa/KPPh7OuIUyGB+vE3j0THkliuI4PrH/Vu88/QD5Nr+/jHDg+1sCtQJ
         Irsg==
Content-Disposition: inline
In-Reply-To: <1594429136-20002-8-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sat, Jul 11, 2020 at 08:58:41AM +0800, Alex Shi wrote:
> split_huge_page() will never call on a page which isn't on lru list, so
> this code never got a chance to run, and should not be run, to add tail
> pages on a lru list which head page isn't there.
> 
> Although the bug was never triggered, it'better be removed for code
> correctness.
> 
> BTW, it looks better to have BUG() or soem warning set in the wrong

s/soem/some/

> path, but the path will be changed in incomming new page isolation
> func. So just save it here.

Yeah, WARN() would be great. Otherwise I'm okay with the patch

Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

-- 
 Kirill A. Shutemov
