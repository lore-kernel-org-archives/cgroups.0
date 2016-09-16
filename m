From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: blkcg throttle settings page cache writes
Date: Fri, 16 Sep 2016 11:57:36 -0400
Message-ID: <20160916155736.GC26371@htj.duckdns.org>
References: <57D9098D.3020403@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nAGBm6m2PZHopifUNjHh/PdCKXsRYGi5VqrneCk+9kU=;
        b=BHcdaca4gpzrilK3pYnGGJjA1ELDRPF3TrlyXODpBAvO8LjLvl/ddvfI0ohLFS0D53
         3TP8kfLpbX5Vl6m+aeVk8uIyuE4yNt/bGyvmdCXJudy3IRRvZYehjD1EZ19yPcKi1q6w
         gIKwscAj7NIMTBMV17fIrGGLXfYu+l4aLkudsIy5pr0tQU9okA8Ep3o3Lmh+ESITSAik
         erR8Pw37XwtpUpduSQKSaPwHXSgUyXr0mCjvttLv1vwl0F33j6tbaQ/GjIeGc50iJrN5
         xR83HfrWuzH7kWDs5In7tUzIU5aNGhe4LWxPOgeeJjBfn3bK7bmmyCnQdc7qF1hX+mf9
         wRIA==
Content-Disposition: inline
In-Reply-To: <57D9098D.3020403-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

Hello,

On Wed, Sep 14, 2016 at 11:25:49AM +0300, Nikolay Borisov wrote:
> Hello,
> So Tejun, my question is what is the problem for the blkcg information
> to be transferred alongside the bio (which I believed to be happening
> with the blkcg_association calls) so that even buffered writes are
> throttled via the cgroup policies? Or are the numbers I'm seeing in
> iostat actually the writes to the page-cache and not the underlying
> block device?

You gotta use cgroup v2 for that.  Controlling buffered writes
requires coordination between memory and io controllers which isn't
possible with cgroup v1.

Thanks.

-- 
tejun
