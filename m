From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] add/update/fix BFQ docs
Date: Wed, 16 Jun 2021 11:46:25 -0400
Message-ID: <YMoc0Tu/DyeKouc1@slm.duckdns.org>
References: <20210611030737.1984343-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gAbGl9PUVrieIDOPPvfXysXyAMbFr8wfY+I6z1ScrTg=;
        b=kpgilGno7nEPvy3nM51vemWrL+pBaMW+FVRrClekQ10IdxjRw5D5h7Ty8l31rn6shF
         zdw6ht9g6WxiTgflBF/HQq73fl4sfi+TlLVcddDBpf3aiGZoQqwfYDi621CIMsA9+6LI
         9wjnTBUwbxOSohWmUHZXRqODWpx4kxTh8RUTnvJjwX6djPGvGiwR7iIoYO7F/GJdf6Iy
         Zyb0D/pitJClgTkW+PoNaIWgv0M2/1UIYK4w1CaHUtgMjBAbXBo2dFcB3hROppBNo8u4
         64F2SaDorlwRVlJljIrWAnWns76BTeysENNvocOZdFAssrNRtXtkgJePuVoqFWifdYdS
         dEJw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210611030737.1984343-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 10, 2021 at 08:07:34PM -0700, Kir Kolyshkin wrote:
> Improve BFQ docs: fix formatting, adding a missing piece.
> 
> Fix cgroup v1 blkio docs which are not updated for CFQ -> BFQ.
> 
> Patches are on top of the latest docs-next (commit acda97acb2e98c97895).

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Prolly best to go through the block tree.

Thanks.

-- 
tejun
