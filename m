From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/19] fs: reflow deactivate_locked_super
Date: Wed, 13 Sep 2023 18:35:03 +0200
Message-ID: <20230913-betuchte-vervollkommnen-0609db0eaab8@brauner>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694622910;
        bh=y6U3+knkB2KJUy0K+kKiKi2OQBqhEH8KYPTDWrdy8vw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SbSG8Ezy8yFgISuAMQN5RhWrtNTl3QqDSmiZMwwbTg+0oDugBRUdnwQc5j2qkdMD2
         1s6Rl/XAfLKNgYXUQh0tRfyK/x+EtKE0FbZoD5NKNq9bgy1vK7qgU3p3IEpfCsnpHZ
         6sTo/2em1zKqbF7iMKZUDjKUtpgdec9ZqPyZZzehDKx+RCrmR+C5zBmghTjK8bFrNZ
         r10ma5uo2ysAby9XfArHeRQFgLtpllaR49B9Kn8xBTgF/UhNB7g6WBoqm/gf219JAL
         cAjIovp8gUkGJgrlRCpYXvvezH6CR+ZkRs2Sqgqw/Ym/CEEDVjNCYnrRqY1AYdacqO
         DegJgzAJU4xUg==
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-2-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390@vge

On Wed, Sep 13, 2023 at 08:09:55AM -0300, Christoph Hellwig wrote:
> Return early for the case where the super block isn't cleaned up to
> reduce level of indentation.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/super.c | 35 ++++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 2d762ce67f6e6c..127a17d958a482 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -476,27 +476,28 @@ static void kill_super_notify(struct super_block *sb)
>  void deactivate_locked_super(struct super_block *s)

I wouldn't mind s/s/sb/ here as well. So we stop using @s in some and
@sb in other places.

Otherwise looks good to me,
Reviewed-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
