From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: blkcg throttle settings page cache writes
Date: Wed, 28 Sep 2016 01:22:25 +0200
Message-ID: <20160927232225.GD16429@mtj.duckdns.org>
References: <57D9098D.3020403@kyup.com>
 <20160916155736.GC26371@htj.duckdns.org>
 <57EA57D9.6000104@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lkcu2DFQSB8xzHTwB1EAIfs2LGBSiQXa345JBmpfXQA=;
        b=kXXdSWYUWGbXfCObXhfT7BZhw/iCfyPxKY6Be2yC/pm17RXr6YZIMASku/lGsKlZ1N
         Yebu6tRM/NEAfQbOGdyfPNAcvuSRlEKtv6kQC4yfgTY/rSgX011d9y7vcn2+EBuFsY+Z
         Y6UePJzofRtDQAOsgPa9VCGR/pDZ1tkyJsegw3kWFZ6yCEQ3jVw8iy4PnHYP0zug0CG2
         24sKzAxkFVZoDWe9c56msa3yb89eOrQqF/0Uf9duLMCltJl+fgnacnYNnyaaDiDmmnwZ
         lOjD/NzquXPoL+a8xnb3jF8KKUtJ846aiiewFQD9zTtMoPCYe7U3kGbTe2oUzmsRaEof
         z6Yw==
Content-Disposition: inline
In-Reply-To: <57EA57D9.6000104-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

Hello,

On Tue, Sep 27, 2016 at 02:28:25PM +0300, Nikolay Borisov wrote:
> Thanks for the information Tejun, that makes sense. However, in my
> testing I observed that when a throttle limit is set on IOPS it's not
> being enforced for buffered writes, but when it's set on bps it is
> actually working as expected. Is this expected or are there conflating
> factors which I'm not taking into account and as such what I'm seeing -
> iostat reports perfect utilisation of a particular device according to
> the bps throttle limit.

If you're saying that you're seeing buffered writes controlled on
cgroup v1 in non-root cgroups, there's something very wrong with the
test setup.  The code simply isn't there.

Thanks.

-- 
tejun
