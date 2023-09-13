From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 12/19] fs: convert kill_litter_super to litter_shutdown_sb
Date: Wed, 13 Sep 2023 15:07:59 -0700
Message-ID: <202309131507.FAD836921D@keescook>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-13-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694642880; x=1695247680; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rfjhWaT9cZxBP5V6PIM2mr46ku8Oc99YcLOA60af1KU=;
        b=Wi1LCj86ApS9gpVrE9naZ3qyr3fYpgNUpZFYmAIAApZONcdoNpurdU6KjHPdWqqylw
         zVtzPHyIJwJKksnoF71UPDPQN8Zibhn6mMHHna6ZOqxWBnUBsojK8KYqxDGZ/drjWr0O
         YtkBgcUwAtsa65E2n39fFUZDBcixbSlgv1o6Q=
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-13-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s39

On Wed, Sep 13, 2023 at 08:10:06AM -0300, Christoph Hellwig wrote:
> Replace kill_litter_super with litter_shutdown_sb, which is wired up to
> the ->shutdown_sb method.  For file systems that wrapped
> kill_litter_super, ->kill_sb is replaced with ->shutdown and ->free_sb
> methods as needed.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> # for pstore

-- 
Kees Cook
