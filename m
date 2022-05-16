From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Mon, 16 May 2022 08:42:37 -1000
Message-ID: <YoKbHXZq5Knzl7LM@slm.duckdns.org>
References: <20220516173930.159535-1-bh1scw@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zfv6htmGomNEyvT4/mYlApRKn0/2gUiM5SY4HLzky7k=;
        b=GplBN0T/LVrKP/XISTvqaoVFkSl2pbtPN40wsW6anFajOkK7UTiSW3WGv0fnjcQtge
         50XorcIu8S0HDAV9BOZSwbaYiFQnVa5Z/HJ1NMUKSbyNIe5ItCma/u68lCrb+4UPAjFl
         y9wPtaO5MeIIIbzcyH4iAFLA09Qk2UWDtvuvZp027Alp0lHKdAw4kemili37K0stSiR2
         3d3352oB8pz/xXGjl4nFotNKezCb2+3/0ixz3zvuZft6aUqidrU/wRDgsiQJKAT/hW5x
         SRJkPGOsErEga1DSBQxzxT8bqsq8MC+l6DEqr1rI0j+d9R8R0kCwBDDMHHWJOhhaxM9F
         Y7CQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220516173930.159535-1-bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Tue, May 17, 2022 at 01:39:30AM +0800, bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Fanjun Kong <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
> Which can serve as RCU read-side critical region, so remove
> rcu_read_lock/unlock().
> 
> Signed-off-by: Fanjun Kong <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
