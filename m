From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 6/6] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Fri, 4 Jun 2021 11:51:02 -0400
Message-ID: <YLpL5lpaRSS8uhHl@slm.duckdns.org>
References: <20210604013159.3126180-1-guro@fb.com>
 <20210604013159.3126180-7-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uBZ/7zA0rgZN1i3qGEvYkxVHxjspKbk9HCZ8aw1XUNE=;
        b=bY59MWvfcUywNdjpMUbwtYEHsD11yoPOxdrhEQsx9FOhgynwo7kkXWedl9XQsAy9z3
         DUMRa5rEumkb0I6USrRgSlbMnbT1g2T0ibgeTGBHZujAdzzK0kYRF8HohIgYHAhRutdm
         o419IsVMLvjkT3XOL/qlApJniWX2WmLMNFU+Py1BjoYyjpb0m/FO6Ahr5GkwAnRijC3X
         ld/j5/pTft68bjR1Nh+DaF1pjzrlM1aT0U7oGqroUG5X8rDWLFSyVl0zNfRs/P2N09Gh
         oZ33WXpfnbxdaTVwqGIpxP/TZ6HzIFfhtyg0nocOAlJwxXvoTmiD3Xiwj5G5++RAZRg3
         YMwg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210604013159.3126180-7-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jun 03, 2021 at 06:31:59PM -0700, Roman Gushchin wrote:

> +bool cleanup_offline_cgwb(struct bdi_writeback *wb)
> +{
> +	struct inode_switch_wbs_context *isw;
> +	struct inode *inode;
> +	int nr;
> +	bool restart = false;
> +
> +	isw = kzalloc(sizeof(*isw) + WB_MAX_INODES_PER_ISW *
> +		      sizeof(struct inode *), GFP_KERNEL);
> +	if (!isw)
> +		return restart;
> +
> +	/* no need to call wb_get() here: bdi's root wb is not refcounted */
> +	isw->new_wb = &wb->bdi->wb;

Not a deal breaker but I wonder whether it'd be safer to migrate it to the
nearest live ancestor rather than directly to the root. As adaptive
migration isn't something guaranteed, there's some chance that this can
behave as escape-to-root path in pathological cases especially for inodes
which may be written to by multiple cgroups.

Thanks.

-- 
tejun
