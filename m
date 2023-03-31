From: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: move bio cgroup punting into btrfs
Date: Fri, 31 Mar 2023 19:25:35 +0200
Message-ID: <20230331172535.GX10580@twin.jikos.cz>
References: <20230327004954.728797-1-hch@lst.de>
 <20230327231837.GK10580@twin.jikos.cz>
Reply-To: dsterba-AlSwsSmVLrQ@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680283911;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8HVcYQ1lSsLr0GGFaE6/gSgA/f1Cg/CbSrd2aXGyFRA=;
        b=Ow3RWOlzRUBW8wpoNPTzbrksZDXeObeFutiyKa61eSyCNTORcP19dQ5lrR2RihL5DMkd74
        dAMq0btppv6NADshsmtDxHlMX+OvtghonwIMIRKf392Vc5WT9a9bc2BBCLerwazmIBCW8j
        hwPqGF2X6m+F85ySt16qtmkhVhJK0jM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680283911;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8HVcYQ1lSsLr0GGFaE6/gSgA/f1Cg/CbSrd2aXGyFRA=;
        b=82hiKoK+DdfxxJKLniClLSsiWpAoAys8G8yDDzVcJ2WorrPaC1AIl3h3Xl0YsV0ez53bEn
        2RTkg7CB4mvF8yBQ==
Content-Disposition: inline
In-Reply-To: <20230327231837.GK10580-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 01:18:37AM +0200, David Sterba wrote:
> On Mon, Mar 27, 2023 at 09:49:46AM +0900, Christoph Hellwig wrote:
> > Hi all,
> > 
> > the current code to offload bio submission into a cgroup-specific helper
> > thread when sent from the btrfs internal helper threads is a bit ugly.
> > 
> > This series moves it into btrfs with minimal interference in the core
> > code.
> 
> I can't speak for the cgroup side, but as btrfs is the only user of the
> REQ_CGROUP_PUNT flag pushing it down to the IO submission path makes
> sense. Code looks ok, it's a direct conversion.
> 
> When the mm/block changes get an Ack I can put it to btrfs for-next.

Patchset added to for-next.
