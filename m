From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Thu, 14 Sep 2023 00:27:12 +0100
Message-ID: <20230913232712.GC800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pRKVep8tw/s8sIQ3F3dLcxRmfmkpqBcJ/0UUTodWZc8=; b=FSfwnimiuTJG9Nm4GWjPkE+/Wl
        tdV1zvdS6cLMU1eSiUbY8aNFgyY7VQe+ltAjMNDv/dFOBn2zXb2GJmoM0Q+HqNaldcCxZJd/HHbLS
        BS2Utl/AQSnkp62Hq1Ba8VSl5CAjDs4/vWgUYs7tXto9ItzMznllk1eotmCw7YFN4Yb//dDV7CVvc
        54SMFgAY1WobfE2n6xKuFEMcX8ZzeTOuD9dnL52KitAk8ad/sVhORTWorrkMhkBDt+Q0w1pZFo2rk
        hA7/Xa6WGJW4FOIuxYkjT6WFQJl2lC/Rrm2ri36l78qEwhTEW/mywJIOwB8jeGiEic5YnFO/2b7PA
        fXYiSf1A==;
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-4-hch-jcswGhMUV9g@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s39

On Wed, Sep 13, 2023 at 08:09:57AM -0300, Christoph Hellwig wrote:
> Releasing an anon dev_t is a very common thing when freeing a
> super_block, as that's done for basically any not block based file
> system (modulo the odd mtd special case).  So instead of requiring
> a special ->kill_sb helper and a lot of boilerplate in more complicated
> file systems, just release the anon dev_t in deactivate_locked_super if
> the super_block was using one.
> 
> As the freeing is done after the main call to kill_super_notify, this
> removes the need for having two slightly different call sites for it.

Huh?  At this stage in your series freeing is still in ->kill_sb()
instances, after the calls of kill_anon_super() you've turned into
the calls of generic_shutdown_super().

You do split it off into a separate method later in the series, but
at this point you are reopening the same UAF that had been dealt with
in dc3216b14160 "super: ensure valid info".

Either move the introduction of ->free_sb() before that one, or
split it into lifting put_anon_bdev() (left here) and getting rid
of kill_anon_super() (after ->free_sb() introduction).
