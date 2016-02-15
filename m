From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: cpu.stats reset counters support
Date: Mon, 15 Feb 2016 16:15:53 -0500
Message-ID: <20160215211553.GP3965@htj.duckdns.org>
References: <56C23F9D.2020705@collins.email>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vsJcZJvsq3Nkx51ChwRRRRAOAltdcWjvtjQH8AlW6MU=;
        b=0PmjPtWNiA6+6NcnpLEeUjgXNHffU9oHcKHkrPQiNjv8bPoAIZzV/95q2aNp9a87mi
         Smh0PVRKDC3pnxAR8vUewghXrgcNvB+BjMmTb+h3nBxbJ/Fyb8VA1SdvrkK7MEeoIvlV
         bcTa6JNjOSE+HFWnAFMCMnrJ5ADNIuF5ObU/+3pX5TgdjuccCCkmAGRb9wRfTUceR6kL
         lii3GXMNjBWS0r8txFxFeaK1BuR418nXguPRmeqomzbnHWpVNWI9U6iw7xT6csVILOy4
         DJdhsrIY3f4H88NH5qzEBdId7Sp90arAhrSWSBNhyIuk6h0AG4m67SMNrRde/A3sW71F
         n/Gg==
Content-Disposition: inline
In-Reply-To: <56C23F9D.2020705-GOU7F2WGkdXPplzRYGY9Cw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Collins <david-GOU7F2WGkdXPplzRYGY9Cw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-PnRKb+1yrG7L5xMBEfyS8A@public.gmane.org

On Mon, Feb 15, 2016 at 03:14:05PM -0600, David Collins wrote:
> This patch allows the cpu.stats values to be reset in cgroups without having to remove and recreate it. I wrote this patch because I've had use cases where resetting the counters made it much easier to read, and it may help with custom userland scripts when parsing statistics.
> 
> Many other components of cgroups allows stats to be reset, such as cpuacct.stats. To reset the stats counters, simply `echo 0 > cpu.stats`

Please don't do this.  The right thing to do is to read accumluative
values from userland and calculate the delta.  Going forward, no other
cgroup stat files are gonna support resetting.

 Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
