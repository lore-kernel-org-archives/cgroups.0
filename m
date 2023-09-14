From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 05/19] fs: assign an anon dev_t in common code
Date: Thu, 14 Sep 2023 01:34:24 +0100
Message-ID: <20230914003424.GD800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-6-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zW8A+jmgUiM8HsI9YE4GX2QGkquAFh76d1jbcjosgrA=; b=i9wJCjYQOucX6E86EF3igFqgNG
        hPekTdaRPjXMgVVF9cHAjxTrTvqnkb2YWAqeRe/SlrLFW2JxYuNraUHvU/ZhVluyELRRLTA8dnTUf
        bCcE37si7zygJaX6tL94iOo+1nM5ExW1S2xAa0yfEq5dkj5Dk/ay7GeLEv6O2gB79BuvXtM0YltTz
        wFwYZahAPPGBtE8/apUAiG4j8kjGKksuWA7bGqa2YoptfKxXsW5EthC9/ga+Tt3593pFKFm+IzvXm
        tfhntSvAeWAXDW0zkl9/OHF7UAQBVfzmiAEVFQqM3C3iwJMealto2WwHuNdsLMT7Racfb/DsrPhNP
        7rj5NAAw==;
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-6-hch-jcswGhMUV9g@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s39

On Wed, Sep 13, 2023 at 08:09:59AM -0300, Christoph Hellwig wrote:

> diff --git a/fs/super.c b/fs/super.c
> index bbe55f0651cca4..5c685b4944c2d6 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -787,7 +787,7 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	struct super_block *s = NULL;
>  	struct super_block *old;
>  	struct user_namespace *user_ns = fc->global ? &init_user_ns : fc->user_ns;
> -	int err;
> +	int err = 0;
>  
>  retry:
>  	spin_lock(&sb_lock);
> @@ -806,14 +806,26 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	}
>  
>  	s->s_fs_info = fc->s_fs_info;
> -	err = set(s, fc);
> -	if (err) {
> -		s->s_fs_info = NULL;
> -		spin_unlock(&sb_lock);
> -		destroy_unused_super(s);
> -		return ERR_PTR(err);
> +	if (set) {
> +		err = set(s, fc);
> +		if (err) {
> +			s->s_fs_info = NULL;

Pointless (as the original had been); destroy_unused_super() doesn't
even look at ->s_fs_info.

> +			goto unlock_and_destroy;
> +		}
>  	}
>  	fc->s_fs_info = NULL;

Here we are transferring the ownership from fc to superblock; it used to sit
right next to insertion into lists and all failure exits past that point must
go through deactivate_locked_super(), so ->kill_sb() would be called on those
and it would take care of s->s_fs_info.  However, your variant has that
ownership transfer done at the point before get_anon_bdev(), and that got
you a new failure exit where you are still calling destroy_unused_super():

> +	if (!s->s_dev) {
> +		/*
> +		 * If the file system didn't set a s_dev (which is usually only
> +		 * done for block based file systems), set an anonymous dev_t
> +		 * here now so that we always have a valid ->s_dev.
> +		 */
> +		err = get_anon_bdev(&s->s_dev);
> +		if (err)
> +			goto unlock_and_destroy;

This.  And that's a leak - fc has no reference left in it, and your
unlock_and_destroy won't even look at what's in ->s_fs_info, let alone know
what to do with it.

IOW, clearing fc->s_fs_info should've been done after that chunk.

And looking at the change in sget(),

> +	if (set) {
> +		err = set(s, data);
> +		if (err)
> +			goto unlock_and_destroy;
>  	}
> +
> +	if (!s->s_dev) {
> +		err = get_anon_bdev(&s->s_dev);
> +		if (err)
> +			goto unlock_and_destroy;
> +	}

I'd rather expressed it (both there and in sget_fc() as well) as
	if (set)
		err = set(s, data);
	if (!err && !s->s_dev)
		err = get_anon_bdev(&s->s_dev);
	if (err)
		goto unlock_and_destroy;

That's really what your transformation does - you are lifting the
calls of get_anon_bdev() (in guise of set_anon_super()) from the
tails of 'set' callbacks into the caller, making them conditional
upon the lack of other errors from 'set' and upon the ->s_dev left
zero and allow NULL for the case when that was all that had been
there.

The only place where you do something different is this:

> @@ -1191,7 +1191,6 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>  static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>  {
>  	struct ceph_fs_client *fsc = s->s_fs_info;
> -	int ret;
>  
>  	dout("set_super %p\n", s);
>  
> @@ -1211,11 +1210,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>  	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
>  
>  	ceph_fscrypt_set_ops(s);
> -
> -	ret = set_anon_super_fc(s, fc);
> -	if (ret != 0)
> -		fsc->sb = NULL;
> -	return ret;
> +	return 0;

fsc->sb = NULL has disappeared here; it *is* OK (the caller won't look at
fsc->sb after failed sget_fc()), but that's worth a mention somewhere.
A separate commit removing that clearing fsc->sb in ceph_set_super(),
perhaps?
