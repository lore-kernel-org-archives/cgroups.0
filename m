From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 30/51] writeback: implement and use inode_congested()
Date: Fri, 3 Jul 2015 13:07:10 -0400
Message-ID: <20150703170710.GF5273@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-31-git-send-email-tj@kernel.org>
 <20150630152105.GP7252@quack.suse.cz>
 <20150702014634.GF26440@mtj.duckdns.org>
 <20150703121721.GJ23329@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=25WtmkDTjIeD3tNbrsPmTriToV7nDWf+RuGaLdKhWSk=;
        b=SfvG78EKoltSuuJdn54JJM4gA/rkTf84umDNGU/Cwujrn6f6lcTFBfzeihwQz3mXc3
         9Fb9XZ5XGkgVKtrSVFlTRuvko+bc/kIhHzp2x3mRoTlGX/0z9TO7+eAnR4YP+NcJ9dj1
         FPvlhte5X7kp60YpfLYOETSHQcB4HZ1Iww9EdpAgxt2894xHS3vozZ9r/hmqk4A1B6d0
         bdsJy33ppOLpCBj4BFJzEidRcj8I13XmIFtVAqKan5hlS+pIPoJu3SMxLSeUjV5TIA8O
         /mSAajnWE+E/x1yZnbTB3y68ZttjxA6gHiOUpMDIEGRMlP4y/eo2bhjmVFIy9pnJTLip
         GJjA==
Content-Disposition: inline
In-Reply-To: <20150703121721.GJ23329-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri, Jul 03, 2015 at 02:17:21PM +0200, Jan Kara wrote:
> On Wed 01-07-15 21:46:34, Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, Jun 30, 2015 at 05:21:05PM +0200, Jan Kara wrote:
> > > Hum, is there any point in supporting NULL inode with inode_congested()?
> > > That would look more like a programming bug than anything... Otherwise the
> > > patch looks good to me so you can add:
> > 
> > Those are inherited from the existing usages and all for swapper
> > space.  I think we should have a dummy inode instead of scattering
> > NULL mapping->host test all over the place but that's for another day.
> 
>   Ah, OK. A comment about this would be nice.

Will add.

Thanks!

-- 
tejun
