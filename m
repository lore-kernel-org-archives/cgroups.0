From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] NULL pointer de-ref when setting io.cost.qos on LUKS
 devices
Date: Thu, 5 Mar 2020 10:20:21 -0500
Message-ID: <20200305152021.GA6939@mtj.thefacebook.com>
References: <1dbdcbb0c8db70a08aac467311a80abcf7779575.camel@sipsolutions.net>
 <20200303141902.GB189690@mtj.thefacebook.com>
 <24bd31cdaa3ea945908bc11cea05d6aae6929240.camel@sipsolutions.net>
 <20200304164205.GH189690@mtj.thefacebook.com>
 <71515f7a143937ab9ab11625485659bb7288f024.camel@sipsolutions.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0admXbkeoND1jB4YkR5jDFX42s3DFHa7Q+/Pf5rMHxg=;
        b=dJ2qpBCFGhzqmF9KAojSaaJXA6caHwbTwtepgtX4hoRV3GshwPgGWkjF/pjEhhksLo
         77swNzS8tc5Or1BssMWTMsI/RfvLXMFg8An8cc9XNlvfIoCNVPoUhqEfRSKSDeYcn7zG
         dbjo4MOTwYXYsMXylSk2vrqTN4aJpDjJQpZoOUR/Js5M51yfgtuls1UNPcAYLEfXqcjS
         ncpR6ia/zTgUEaSrW3Vk1flwXJyuOfPnILYfgTWVRMcEkzzvPGbTvU+u0fI2P3+H8eIe
         t4i/LDSO/n6h/hhDa8r+i3t4hoRuwh6pWqGhq+4mtzdQBSMnLMv0U9QXpl2Ssi0fERuF
         lvlQ==
Content-Disposition: inline
In-Reply-To: <71515f7a143937ab9ab11625485659bb7288f024.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Mar 05, 2020 at 11:31:29AM +0100, Benjamin Berg wrote:
> > In the longer term, what we wanna do is controlling at physical
> > devices (sda here) and then updating dm so that it can maintain and
> > propagate the ownership correctly but we aren't there yet.
> 
> Perfect, so what I am seeing is really just a small systemd bug. Thansk
> for confirming, I'll submit a patch to fix it.

IO control is a bit confusing right now. Here's the breakdown.

* There are four controllers - io.latency, io.cost, io.max and bfq's
  weight implementation.

* io.latency and io.cost when combined with btrfs can control all IOs
  including metadata IOs and writebacks while avoiding priority
  inversions.

* wbt may interfere with IO control. It can be disabled with "echo 0 >
  /sys/block/DEV/queue/wbt_lat_usec".

* io.latency is useful to protect one thing against everything else
  but it gets tricky when multiple entities competing at different
  priority levels.

* io.cost is what we're verifying against and deploying. While
  system-level configuration is a bit involved
  (/sys/fs/cgroup/io.cost.model and /sys/fs/cgroup/io.cost.qos).
  Actual cgroup configuration is really simple. Simply enabling IO
  controller and leaving all weights at default often can achieve most
  of what's needed.

Thanks.

-- 
tejun
