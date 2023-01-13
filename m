From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Fri, 13 Jan 2023 07:16:13 -1000
Message-ID: <Y8GR3V3RsdS+XYzh@slm.duckdns.org>
References: <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
 <Y77s0f741mFfGlTO@slm.duckdns.org>
 <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
 <Y8CrloCDGhbU42OH@slm.duckdns.org>
 <efa1c73b-e94f-373f-e535-2cfc32ce2433@huaweicloud.com>
 <Y8CwwghZ0adMsHFC@slm.duckdns.org>
 <ac95dfb8-b1b6-8916-bde8-1edb573e7ca5@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=52MNpdUJgF3+oIlWggDDfrxPPD9Ztp6sCT03jqLjxgI=;
        b=qoUH+lwlmFLafVPNtyZsi5g+/lFmY4VRICVR8nxpfZhir2UA9+ZTFVSHv+aWHGONgc
         prVifwhDZCRV7oQCr4MZQ5QVlmQFFdwuzZLzjKHmn4QCNEXbKj7Cy0Fdsv86hLM5l/pi
         oT7ITQFfR39idU7/bOxREINUvmmagDFYP136gv8nIIUarzMSDfpAK54f5xmEWMH88iEj
         X2gTJ4rdxMOuLkRlsUeaLFdN/vX01WRDAfvjOsO2FkaL/sN5xX3K039opZjKA08lXh8E
         vcQ7X2mwFgpX7DvPYjhRZ5d+/IAt+3QxtgfHvI3o/dEEvRQw2nigPv6L/aUng/Kf9Rlp
         fExA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ac95dfb8-b1b6-8916-bde8-1edb573e7ca5-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Jan 13, 2023 at 09:25:11AM +0800, Yu Kuai wrote:
> I think hold the lock in blkg_free_workfn() is too late, pd_free_fn()
> for parent from blkcg_deactivate_policy() can be called first.
> 
> t1: remove cgroup t1/t2
> blkcg_destroy_blkgs
>  blkg_destroy
>   percpu_ref_kill(&blkg->refcnt)
>    blkg_release
>     blkg_free
>      schedule_work(&blkg->free_work)
>      // t1 is done
> 
> t2: handle t1 from removing device
> blkcg_deactivate_policy
>  pd_free_fn
>  // free parent
> 				t3: from t1
> 				blkg_free_workfn
> 				 pd_free_fn
> 				 // free child

As we discussed before, you'd have to order the actual freeing by shifting
the ref puts into the free_work. If you move `blkg_put(blkg->parent)` and
`list_del_init(&blkg->q_node)` to blkg_free_workfn() (this will require
adjustments as these things are used from other places too), the free work
items will be ordered and the blkg would remain iterable - IOW,
deactivate_policy would be able to see it allowing the two paths to
synchronize, right?

Thanks.

-- 
tejun
