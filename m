From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH for-4.6-fixes] memcg: remove lru_add_drain_all()
 invocation from mem_cgroup_move_charge()
Date: Thu, 21 Apr 2016 11:51:00 -0400
Message-ID: <20160421155100.GL7822@mtj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160420212922.GH4775@htj.duckdns.org>
 <20160421032704.GA15585@dhcp22.suse.cz>
 <20160421150024.GB2749@pathway.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IwWXhpahwL88jxT56nccKCUi8UHh8EIfdCYfFhodtmc=;
        b=olsvEDcyfuUGE5YRUcyK0qcxRHd9BxvWtpK2J0HBB+qVwjlLzIe7WjsLF7SJ/PZaZc
         W32xe3fblmhiXdm/8fKSVQ3RLtjp8DbYk/sCssR/jIaliClg9k5kaEkexV268YtULGSB
         9b5WciPOkKrxrrW0BYJ1cSg15gIFeBhfvuWLj10g/h4eoeUYO6JUAXrTxFf0RmuIQusp
         o1vGSI0WSwHrjjYTGxHV4K4FiMPXvYfJWf4vk+CUyXW+l6y8tE+L9PmiZZmCUu6bFTma
         BXXxStFnrD+M36TnMQIO2kqnfSSWFhDjM6Eokq9PKtDHmkV4YxrG90xGSWr9S3uk443a
         iSIA==
Content-Disposition: inline
In-Reply-To: <20160421150024.GB2749@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Petr Mladek <pmladek@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org

On Thu, Apr 21, 2016 at 05:00:24PM +0200, Petr Mladek wrote:
> > Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Just for completeness. The problematic LTP test is running for hours
> with this patch. Feel free to add:
> 
> Tested-by: Petr Mladek <pmladek@suse.com>

Thanks, I'm gonna repost w/ Andrew cc'd and the tags added.

-- 
tejun
