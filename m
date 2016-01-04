From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Mon, 4 Jan 2016 15:05:18 -0500
Message-ID: <20160104200518.GD3807@mtj.duckdns.org>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
 <20160104175836.GA11668@mtj.duckdns.org>
 <568ABFC3.3010803@cumulusnetworks.com>
 <20160104185936.GA3807@mtj.duckdns.org>
 <568AC534.1070308@cumulusnetworks.com>
 <20160104192301.GC3807@mtj.duckdns.org>
 <568ACF13.3030007@cumulusnetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FkGrlVpYzOLxrwlxmqWPbQHPDKiEjmifBidNu9/PcXA=;
        b=ZY9e9jc4lrTyIPqXPq1MOtoLYyaPEcIBf/4n6cDgoSonbIbshyML8B5GgSU0D3GDon
         /gPLK6AHlF6YTm5JQaiV+j+4JAXFK+hr0SwOJts2yZ0cAAoxwaHy3alIKkiMaSiu3pZo
         HGkNC5smCDzBQpns+5X2CHjWD7l4zLvOiLDioPf7eguVtEGGRLmW63FFRNGtB2wqIMgu
         GhbMnQt+zN2SuUpye7u2UePZaakTBtQYUmCj33dh5hSPL9JvSakEaBCDhlM1LUcpc/bT
         LSKZKjK2q3U5NH6UPnAdo0qBWNvgmn24aw6ixMnNZIrYaPWKIg63iOGUkvieiGQltAhN
         HbcA==
Content-Disposition: inline
In-Reply-To: <568ACF13.3030007-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shm-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org, roopa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org

Hello,

On Mon, Jan 04, 2016 at 12:59:15PM -0700, David Ahern wrote:
> cgroups have very nice properties that I want to leverage such as
> parent-child inheritance and easy tracking which subsystem instance a task
> belongs. This provides a great kernel foundation for building easy to use
> management tools.
> 
> The documentation for cgroups does not restrict a controller to physical
> resources but rather "it may be anything that wants to act on a group of
> processes." That is exactly what I am doing here - I have a network config
> that is applied to a group of processes similar to net_cls and net_prio (but
> as I stated before those are orthogonal, independent settings from the L3
> domain).

Please read the new version of cgroup documentation.

  https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/tree/Documentation/cgroup.txt?h=for-4.5

cgroup has experienced a lot of problems doing its main job -
hierarchical resource control - from trying to support random things
which want to group threads.  As shown with xt_cgroup, such
identifying usages can be implemented in a way where the subsystem
matches the membership rather than cgroup taking in configurations
which belong to the subsystem, so please investigate that direction.

Thanks.

-- 
tejun
