From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix display of forceidle time at root
Date: Fri, 17 Mar 2023 12:20:34 -1000
Message-ID: <ZBTnsp43Ntxl0Tns@slm.duckdns.org>
References: <20230315214029.899573-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679091636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=86HCB7S150EkF3xf7sNbiXNVW2Gd/6ux0I4CN70WrJw=;
        b=av/HdkRFs1UjV/iFhDAs7Ba1VDfC1Vt0wim9zm6HUxebjUmjjqT4gp+O8YpsvVUSkN
         iSXCT7rt/BiHxAIs3EKCk+cM741/H7ghJUwVcl8t3t9pZ8YA8nIQWS+wA4gXokp4hHrQ
         BKYp8sA+TCvvPqXE6+lbX4BaOULl914oS6zCmx0caJ5oDQmTl9lysUu4vEBb0Wwlgwbr
         huMjjx+8y8ZPIL9kFOtcBX2sa+k7YZFhQBuQsEhEuYHEL/7QC6Y8w5pURAXKIqPco5Tz
         UR7YpmofoMf9Hgy4vLsCQG5iJa6fQlNlE6M2Q0zbrsMxlglWw4roBJsokhH1GiFk5EWo
         SBOA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230315214029.899573-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 15, 2023 at 02:40:29PM -0700, Josh Don wrote:
> We need to reset forceidle_sum to 0 when reading from root, since the
> bstat we accumulate into is stack allocated.
> 
> To make this more robust, just replace the existing cputime reset with a
> memset of the overall bstat.
> 
> Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.3-fixes w/ Fixes tag added and stable cc'd.

Thanks.

-- 
tejun
