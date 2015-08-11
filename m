From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] memcg: generate file modified notifications on
 "memory.events"
Date: Tue, 11 Aug 2015 14:02:36 -0400
Message-ID: <20150811180236.GE23408@mtj.duckdns.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
 <1439315889-3492-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PYB2VRHOLmEuBYRgz+suOQa2+rNAPtjugR5TkpaBXJk=;
        b=S+8YDZMrZCQkWe2Rzu7K2TvGq2CleaxQwQWcJ0X5uK1H6tdAFtuk1SP0AOrlEnoSAc
         jTu1cE5tY0cNhM8PLcWMnrDLcD33N6P05SxcFotPd9YROtzRZRTxIV+k1mwJFUnozMDm
         ug+WZqM2O5w6OsAzt2DIjgA0c0R/H82yjeAvAlwrAX8IGVcOQvUCjDz+DGh25MxRXA3I
         D4g3NURF39KEyc1TXIdrkZF8q1x7Fb7KsVPcwEPcbBRAngXIlyT3tqYABZr9HrKmtLye
         4YarYTYpuxPnbknGcZQsrBYZSxBDpkCiuTckKmptycX5KGPJF+a754QgkIS3KQc3hR9+
         YlRw==
Content-Disposition: inline
In-Reply-To: <1439315889-3492-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 11, 2015 at 01:58:09PM -0400, Tejun Heo wrote:
> cgroup core only recently grew generic notification support.  Wire up
> "memory.events" so that it triggers a file modified event whenever its
> content changes.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

So, this won't apply to the current -mm.  Once the earlier part of the
series gets applied to cgroup/for-4.3, I'll refresh this patch on top
of -mm.

Thanks.

-- 
tejun
