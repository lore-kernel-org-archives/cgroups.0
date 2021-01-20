From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/10] docs: cgroup nits and fixes
Date: Wed, 20 Jan 2021 11:43:46 -0500
Message-ID: <YAhdwtMS98iPma+S@mtj.duckdns.org>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=02Z6TkAFxEXED71l0h/isCElQR7bDCewo1h0J01+Wq0=;
        b=ZFT116uGUty55tAT/lPBU+jK/pTkJif9rwc6f69o4n9DiLgm279sPG57CMy/5rnzVk
         PfBUJZPULqvQU9M3UuFhTEVVFQDbx3agVb/qSmGHKpFGfnZmuW/e6sNCi6YPr7pj/UGw
         V0kAZCN/2Pw+FzXKWB1Sk0RImOk4aaOwceptZTX94mOmjK08NFcsuHETyfHdkx8u/qL8
         k4bgiPA2PWl7kPfKTu2hHcPmNAgfukZKjldhOkoPIHLfQDSGrwkhs/9uRnn+ifaD/sM5
         ip1lcO42mVBRGiI1C9pdaeE+nTYOlrDsPgYHzi+vSOkighBozKL5FHt/uXzdZp75U53F
         fczw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: corbet-T1hC0tSOHrs@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 19, 2021 at 04:18:14PM -0800, Kir Kolyshkin wrote:
> These are mostly formatting fixes for a few cases where html
> looks plain wrong, plus a couple of added cross-references,
> and a typo.
> 
> All issues spotted while reading cgroup docs. Results are checked
> manually for both html and pdf, using both Sphinx 2.4.4 and 3.2.1
> for rendering.
> 
> All commits are against docs-next@52042e2db

For the series,

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I suppose it'd be best to route this through the doc tree?

Thanks.

-- 
tejun
