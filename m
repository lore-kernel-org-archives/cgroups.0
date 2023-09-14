From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 13/19] fs: convert kill_block_super to block_free_sb
Date: Thu, 14 Sep 2023 03:29:56 +0100
Message-ID: <20230914022956.GG800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-14-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QJxYibQmjq+Pbg/cA03aH9CORAW2km8XuLC8t21WRo0=; b=OhhyqIHCwHStb3YKeZZHm1zzhR
        U7O739LtvvKuHLAPD7ckbdBOFedy6E2v7i0Tfx1DmJVsyfhRU/Vf9CdQ98YAdW3hZj1GxnkaSUSC+
        f1GSWOIBvcn4DK3Ykh6+6pr5SEpqGerIj8wRKOY/SA9QQVjCllxI1qUJgW45jMDU6uUBo+xCxf0Y4
        k5s+4wc/rQVH8gvkzFdaFjW08BguRZWF58BlkNDZ78YNFfr4eRqta88fWJjbQjSxNMTHF0eZxfoc0
        alUzUlwddMgPH2Kc6JNmW0oLYbwh7FNCzEfhcmU0j2uid7Appi7wlg5hDG2mY+jkRK2sVhnOnNWGZ
        dH9DMfLg==;
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-14-hch-jcswGhMUV9g@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s39

On Wed, Sep 13, 2023 at 08:10:07AM -0300, Christoph Hellwig wrote:

> -static void affs_kill_sb(struct super_block *sb)
> +static void affs_free_sb(struct super_block *sb)
>  {
>  	struct affs_sb_info *sbi = AFFS_SB(sb);
> -	kill_block_super(sb);
> +
> +	block_free_sb(sb);
>  	if (sbi) {
>  		affs_free_bitmap(sb);
>  		affs_brelse(sbi->s_root_bh);

<checks>

Yep, that's printk + brelse()...  Could we have that
block_free_sb() (an awful name aside) done after the
if (sbi) { ... } there?
