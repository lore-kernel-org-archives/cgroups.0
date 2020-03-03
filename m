From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] NULL pointer de-ref when setting io.cost.qos on LUKS
 devices
Date: Tue, 3 Mar 2020 09:19:02 -0500
Message-ID: <20200303141902.GB189690@mtj.thefacebook.com>
References: <1dbdcbb0c8db70a08aac467311a80abcf7779575.camel@sipsolutions.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oblDflMFmo6oyKAhz2qvuc4P+V1BdLrKey9T3AjcUFA=;
        b=Po8WFETd8KA0o7u1QR91Uo3sKTtxSmFQ1dQuVU3C+cZJIo8Tcf/yq8ke+DHSa7ATpb
         xZpPhrp9/kE6HxZJDKRypPxMw9RBMHJYqPKZfwIb0rB+xFzzOE54jjHeZQ0KIqlqCzqR
         pStIkVP0vcAhKzeA+F0/N3GbY9hEFM6qp2JS1Fxfk7JqLxachpfCNSURnSiJnG2+Sh75
         mbLEXX2Kxyi+v+0JJ+b1r6pAYc+utUMap0TA+tDkuR4QXj1Amf7vkWvERHICuNtw7dHp
         fjPt+hC52L/6qIn6E/9ttx7spSD3Xr/qnhLGv1EJ7lMmeVNPxxKK7BWBIvjmq2wPDY3I
         NCiA==
Content-Disposition: inline
In-Reply-To: <1dbdcbb0c8db70a08aac467311a80abcf7779575.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Mar 03, 2020 at 03:13:10PM +0100, Benjamin Berg wrote:
> so, I tried to set io.latency for some cgroups for the root device,
> which is ext4 inside LVM inside LUKS.

It's pointless on compound devices. I think the right thing to do here
is disallowing to enable it on those devices.

Thanks.

-- 
tejun
