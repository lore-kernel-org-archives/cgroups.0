From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] NULL pointer de-ref when setting io.cost.qos on LUKS
 devices
Date: Wed, 4 Mar 2020 11:42:05 -0500
Message-ID: <20200304164205.GH189690@mtj.thefacebook.com>
References: <1dbdcbb0c8db70a08aac467311a80abcf7779575.camel@sipsolutions.net>
 <20200303141902.GB189690@mtj.thefacebook.com>
 <24bd31cdaa3ea945908bc11cea05d6aae6929240.camel@sipsolutions.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0xLBL5fJTc5AsUQPy+WSwVwS7vBKnygmPmF5kHtg+Ko=;
        b=JphAytlDLBqcavrEVXy4D+clSdLG2pVQ4Y2FDvGxgP1eYafwN2BgQyrmHd/m1j2EMy
         XoEpWt39eUtxargjw6ERdE8tFwlleRpoM6V+skpSS4BGl1/6SLlj1SsCqwFjXCuhLkOc
         6Qbk+dx1Mn5nqQNwgcVNUTF662gbRJqeXMwEtgLE/rr+AqJWKyGVunibVo0v0VFjWGuY
         l2WjaUuHbgVEbtKZlJFPCixJXAKkVg9LDKA6uICAsFSvQwrw6mxT60AsjL2lBgm9Fqn0
         bVOK3H/IhhzfnFZ79b1uD8SJsUFzpuLHdwJWmU5gVyIJstRv3OIZfKslcZpafLFQVdKB
         mBtg==
Content-Disposition: inline
In-Reply-To: <24bd31cdaa3ea945908bc11cea05d6aae6929240.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Benjamin.

On Tue, Mar 03, 2020 at 03:40:38PM +0100, Benjamin Berg wrote:
> I believe systemd tries to resolve to /dev/sda but that seems to fail
> for me. So I think there is a bug in that code; I'll verify that and
> submit a fix if so.
> 
> Which device should actually be selected? Is it /dev/sda or the mapper
> device that / is mounted from?

Right now, the situation isn't great with dm. When pagecache
writebacks go through dm, in some cases including dm-crypt, the cgroup
ownership information is completely lost and all writes end up being
issued as the root cgroup, so it breaks down when dm is in use.

In the longer term, what we wanna do is controlling at physical
devices (sda here) and then updating dm so that it can maintain and
propagate the ownership correctly but we aren't there yet.

Thanks.

-- 
tejun
