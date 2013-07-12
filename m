From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup 1/2] cgroup: move module ref handling into
 rebind_subsystems()
Date: Fri, 12 Jul 2013 13:10:02 -0700
Message-ID: <20130712201002.GH23680@mtj.dyndns.org>
References: <20130629041231.GA31353@htj.dyndns.org>
 <51DFC650.9010801@huawei.com>
 <51DFC787.7080703@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1tN1BQ80+F15unFladxx1LC+TWfHWRQtd1LBA5pGKQ0=;
        b=Ngd8SnPKsdBlwoF+2TfG9xuNjg5GUk40LBEoIqgvgP90rwS+t6Y8pI3vwSWjdHvtIC
         EaeQlZQNHObyAnl8iyYVYpNRXDfCXec9Fm73/PaFCdaNuC2eYgqVP4JJMFYPPEcFqrSN
         F6ixZYZEeeq5j6pEW5rIhkpVNDwm2HcKLBzuhHcl2TwxgnEMCbm46bdaQGG2837Q+RK9
         xfJjalbC9riK7c29fRhRZjLeWzn1M1UwVeJi3E2DDP6pR0FhLxASngII7/xp3+3Nfdtm
         xEzirpgMsXMy09/5ZCeTMW3gImlWbV13dqnO2X47b8FpxmnWr62F23ktZVuj/CxwS916
         LnEg==
Content-Disposition: inline
In-Reply-To: <51DFC787.7080703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 12, 2013 at 05:08:23PM +0800, Li Zefan wrote:
> > so a modular cgroup subsystem can be unloaded inbetween, say it's net_cls, and
> > then it's possible that:
> > 
> > 	# mount -t cgroup -o net_cls xxx /cgroup
> > 
> > The above operation succeeds but it's not binded to cgroupfs as it just got
> > unloaded.

Ooh, right, it'd be excluded from the iteration.

> for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> 	...
> 	if (!subsys[i] && (added_mask & (1 << i))
> 		return -EINVAL;
> 	...
> }
> 
> This should work.

Yeah, I kinda dislike the raw iteration tho.  I wonder whether setting
the actually added mask and comparing would be cleaner.  I'll
experiment with it and post the updated patch.

Thanks!

-- 
tejun
