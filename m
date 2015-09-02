From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Wed, 2 Sep 2015 11:32:55 -0400
Message-ID: <20150902153255.GH22326@mtj.duckdns.org>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZAFjSgNKcBbxyjjCwUt9eLT2aCsv9qJFYykFtlqC8h8=;
        b=1FpEuIBUhAuCBd1D2CF4SxMsMjayCxk0QOTN7ZrhyOs1fcCdym4qYnHg6na1xQWNvo
         /zmS/bXurwU/BaM/1X7lVIJkARJaBocGI314Xsk8IFlJOaM7jbNjUnaDRu/xiWd0mb/X
         Zo5YmWCWZaOuVGWDT/8F9mtNWknJ6lgE4XjTARiZVgpsWU1McrUq+zJk4X4Jh355nT00
         VuWJYL+icWvLK0IMlMWSasaR4Atu7MQmrUV9FvWMpSC4XJJQ6FK6wxJykzQT0KNECvU+
         QHop3h7ryDJwLwoiE0niO7dWSIY/VvbRGDcEurcaJCJOCWCtMcvZAZ6r74xWcmLewOJG
         uHgw==
Content-Disposition: inline
In-Reply-To: <20150902145307.GG22326-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Sep 02, 2015 at 10:53:07AM -0400, Tejun Heo wrote:
> On Sun, Aug 30, 2015 at 08:30:41AM -0400, Josh Boyer wrote:
> I think the offending commit is 776687bce42b ("block, blk-mq: draining
> can't be skipped even if bypass_depth was non-zero").  It looks like
> the patch makes shutdown path travel data structure which is already
> destroyed.  Will post the fix soon.

Hmm... I can't reproduce it here or see how such oops would happen.

* Is the problem reproducible on v4.2?  If so, can you please describe
  the steps to reproduce?  How is cgroup set up?

* Can you please run gdb or addr2line on it and report which line is
  causing the oops?

Thanks.

-- 
tejun
