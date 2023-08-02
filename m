From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: clean up printk()
Date: Wed, 2 Aug 2023 09:36:44 -1000
Message-ID: <ZMqwTLAYE9OMNLlS@slm.duckdns.org>
References: <20230801072217.103554-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691005006; x=1691609806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XwvIHK2FntGoMwY6+ktOdJ0iSpGWmfPz9OaqA6nqQMA=;
        b=fWFpdXo3X7T77St6fMoMfYSA6kgUoa6yDMZruNO4apxP086MfZNIZ7S9R/Cm0p/srm
         Lo009Ee26Se427vu5jcnCdo5KYB42534jWdlsa0TtJrgC6dOlSVfFsc9d0P09EVubWpP
         cd9g9bcwIeBSJjnVn0GocsO/fojG9LHBrO30GmW+LRRpe2cCZ0qxxSr84neXhjJS7IJo
         f4Pu0WT8TleEjuJIhVuwkfFmBLw5mLbCaUprwFYjdjq7C52IVa1FKjTzGG8UFIU1DO7f
         BkKUu7OrLlsAIZSh1jwiz1JXgf3/4/HefbHcxHjgTblVZ8MF+2pj6VrBSLDZNWp5qvX6
         M8UQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230801072217.103554-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 01, 2023 at 12:52:14PM +0530, Kamalesh Babulal wrote:
> Convert the only printk() to use pr_*() helper. No functional change.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
