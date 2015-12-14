From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup_pids: fix a typo.
Date: Mon, 14 Dec 2015 14:54:58 -0500
Message-ID: <20151214195458.GC4026@mtj.duckdns.org>
References: <1450037588-13260-1-git-send-email-rami.rosen@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xno08RAUiDZ/7fehgQrq5G4VNbcO9vuEAHG0v9Pq35g=;
        b=uAD8kcTgm4CNV53MSCmqLuyPxxw6tq67gW//jwW45xOKdgOdfYmOhyTTbLS5IlnlcX
         OgwpLec2Dq5+60nTGVwLQJbm5sX3CceSCyQ1gxU1WefK9Q6aYvNygrqffu/F2lWOIgpx
         TGCYC44xhVw/7JpWb0WkospxQ6yUEs3URbTwQXjhjF4IXUZL8jg0bwJwDzYQgOAE6g9W
         B3AG7XXj2JuqWoJ8DMA8czGG+bHSGqIaQViW1T2njuI3F7VTTzJ4/vruYEavB7nTCBvz
         biZebDNJWQbbBj55qAF88xFU206lTU/hdrznYyDUmjaE4v4eZ1AsIe/5KDEtUGFWRP7/
         dmrQ==
Content-Disposition: inline
In-Reply-To: <1450037588-13260-1-git-send-email-rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org

On Sun, Dec 13, 2015 at 10:13:08PM +0200, Rami Rosen wrote:
> This patch fixes a typo in pids_charge() method.
> 
> Signed-off-by: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.5.

Thanks.

-- 
tejun
