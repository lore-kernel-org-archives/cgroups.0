From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Wed, 20 Nov 2013 16:47:37 -0600
Message-ID: <20131120224737.GA12883@sbohrermbp13-local.rgmadvisors.com>
References: <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org>
 <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
 <20131118201025.GA2747@sbohrermbp13-local.rgmadvisors.com>
 <528AD316.10001@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=m5Ot00P+ZxkPzcOCQLK/efD/izr7Rps7Bv5Mlt9W/tQ=;
        b=XvNawMJBfMMR01i6Ezblhs77NHLaMbdcbmdONDg27xEnzTQqt9QntIu8QWDXptFg+H
         3AQRQxLB5RYu4ahzqrWJxbjIyoG/ktpqZjGaNRUVnZooavNWzvwAULqbYbchm+9YRAjD
         8q1w4neNvN6LL7bcOwqa44XYOaml2AtpAbW36VKVTdj1Fs2wKLiRCJen+NNFAfVLYAEW
         hjyLqWSm+pxfSVBc4vCLoUtDMgbd6zNojp46VxVJGpzVfsO1477ipIWK51jMHscTwwtY
         S78V7PWNQK3FzVUmKEgRl1ikcdPuDLylzAzfbK9xDzwfA6PWhav4tR7aXw6aFThsQj9d
         OTTw==
Content-Disposition: inline
In-Reply-To: <528AD316.10001-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Tue, Nov 19, 2013 at 10:55:18AM +0800, Li Zefan wrote:
> > Thanks Tejun and Hugh.  Sorry for my late entry in getting around to
> > testing this fix. On the surface it sounds correct however I'd like to
> > test this on top of 3.10.* since that is what we'll likely be running.
> > I've tried to apply Hugh's patch above on top of 3.10.19 but it
> > appears there are a number of conflicts.  Looking over the changes and
> > my understanding of the problem I believe on 3.10 only the
> > cgroup_free_fn needs to be run in a separate workqueue.  Below is the
> > patch I've applied on top of 3.10.19, which I'm about to start
> > testing.  If it looks like I botched the backport in any way please
> > let me know so I can test a propper fix on top of 3.10.19.
> > 
> 
> You didn't move css free_work to the dedicate wq as Tejun's patch does.
> css free_work won't acquire cgroup_mutex, but when destroying a lot of
> cgroups, we can have a lot of css free_work in the workqueue, so I'd
> suggest you also use cgroup_destroy_wq for it.

Well, I didn't move the css free_work, but I did test the patch I
posted on top of 3.10.19 and I am unable to reproduce the lockup so it
appears my patch was sufficient for 3.10.*.  Hopefully we can get this
fix applied and backported into stable.

Thanks,
Shawn
