From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] sock, cgroup: add sock->sk_cgroup
Date: Tue, 17 Nov 2015 17:21:27 -0500
Message-ID: <20151117222127.GJ22864@mtj.duckdns.org>
References: <1447789240-29394-1-git-send-email-tj@kernel.org>
 <1447789240-29394-5-git-send-email-tj@kernel.org>
 <564BA036.4000602@iogearbox.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I073myZ5VZf1s8ZaZ/mP0wl4pgM3mcjKsW8R+ZeF91I=;
        b=X/r6RfgEsa9senhoaAhOv1KwApgWvON1V3StoPnesy5mcNFhyuF2wdspy/AYDg6X2T
         3WnW5HuxOq6ItCvk1TL+mx2NgpZY+MsH4TkU/7yFvHwOkVNzKAcJ7ukGbrGQP++pBenK
         VlA5fxtPbQx4O12aof0v6XtWMWKARZKDDX/vSyKOLyd9uMESF4Hytvh2UCO5lM90YSGA
         d0EtEQHEmIhrJJfd4WR3Do8imeOJIwLuyeDNefLSAPYz24S25FyfSX4ZhW9WxbB6CqiY
         72C78v/MoJ7S754SKtLra5j2pu2+kQgOoD54nBvJz5cJIEKeU6Hxshn9JXxEDiZ3lq7Q
         ZkJQ==
Content-Disposition: inline
In-Reply-To: <564BA036.4000602-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org

Hello, Daniel.

On Tue, Nov 17, 2015 at 10:46:30PM +0100, Daniel Borkmann wrote:
> Do you see a way forward where the new behavior could be enabled f.e.
> as an extra mount option (that long-term would be made default, while
> deprecating the current behavior) on net_cls et al? There are various
> more users at least on the net_cls side (nft and tc as well). Would be
> really great, if sk_cgroup could abstract that somehow away for all of
> them w/o adding a second version to all users.

I'm not really sure I'm following what you mean but no matter how we
go about it net_cls and prio won't be broken.  I likely will end up
making the two sets mutually exclusive once configured run-time but
there's no reason to use both at the same time anyway.

Thanks.

-- 
tejun
