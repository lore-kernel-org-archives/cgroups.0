From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Fri, 22 Nov 2013 17:18:39 -0500
Message-ID: <20131122221839.GD8981@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org>
 <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
 <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Rjd8P3VcoRvCOZ1epn8IwTF2052TIHMOIv7kFHrByYE=;
        b=Wj51aqADzGWnMl6q/k61J1Ih6AzdUX1eHuOlJSNHJHB4OArAeMZEGywmoPNVrI1PRq
         U2/TtNUNARm1/kf7TVUPttfD7YEi6yRURBNvxpMmfyFtGB7Qnhtaoyx/HU0LvMAcdQoa
         kWz4aD07s6rqqrqd5VEugAMCx+7UrHKIdstK5e7AF7NARfKNDsIyU4+KRZ+D2EBYogLN
         xs+b4m0qnvR4rI4pMGzgxJeKtY0c5i/LMmqjC/ggZ36rt5gFUV0pLtADal+8+GP5GpaI
         9oi4kjX5/7P+GzoYdiMv8KCLnX3LMsUpP3RK0U0+AKN3pT40/vbfsxfGdOKD/gb/3NsL
         yygw==
Content-Disposition: inline
In-Reply-To: <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Fri, Nov 22, 2013 at 09:59:37PM +0100, William Dauchy wrote:
> Hugh, Tejun,
> 
> Do we have some news about this patch? I'm also hitting this bug on a 3.10.x

Just applied to cgroup/for-3.13-fixes w/ stable cc'd.  Will push to
Linus next week.

Thanks.

-- 
tejun
