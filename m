From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 14:52:31 -0400
Message-ID: <20140423185231.GA4163@mtj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=63SYy8tIj4GLU+C1k2g/VkCAApqGFZimE1Hm6vZfbFY=;
        b=Ot6CtYufrb58LnTwfiMQ03Sj1mUMd72QJEwDLK9zsPrl/VLGTpQMOStmebkzw3Jqlk
         FhAhxuA2ocW22BS/LESpkfunqRlvAuP0wUkVRWFfWOsh19LsuGRgOCYlDvAKHURzUq0S
         SWp3+cSTGADb6bdR1dQOi5/syZ07necy9Bp6B3RCyH9AX7oDzKOeX4AhosWaZGmOIODZ
         OQ/JGInAQNrRr8xXLyUPyQf7aEedNiOGPCxpD+TvrEAL/zlGa0wryM9sd74FcVxSrN9f
         9v32RzVrFSL9/M4GRK8rncuh/f2rgLsRAjM35xTZ0oJETkWibrJdbSIjxF+53XRiPtXx
         Hrvw==
Content-Disposition: inline
In-Reply-To: <20140423171720.GF24651@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello,

On Wed, Apr 23, 2014 at 01:17:20PM -0400, Vivek Goyal wrote:
> I think we should just require two. One for measuring rate in terms
> of IOPS and other for measuring rate in terms of [kMG]B/sec.

I meant between cfq and blk-throttle.  Why do we have separate stats
for them to present ultimately the same numbers?

-- 
tejun
