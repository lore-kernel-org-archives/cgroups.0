From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 11/19] fs: add new shutdown_sb and free_sb methods
Date: Thu, 14 Sep 2023 03:07:28 +0100
Message-ID: <20230914020728.GF800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-12-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-usb+bounces-18-glug-linux-usb=m.gmane-mx.org-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zukjnbI0ncupAzDuzJlDSnQOCr1VCHsYHxFZu9nHeVo=; b=TMwdwl4gsfFqIQ2Hr49QNfqGNw
	H0N2CpxgS8iu2zTuvH1gYOE/Aelnyu6DKJr/WIH/H8WywHdkpZtIK/6qkmYkAyGBl6A9wXgV8T7Hx
	F4R28vv9+Mr1bcGPPgBjvg3RLPP2CAaYJXGfz3qdr49MpFrVSdt4ee2yS4kxJze4s4kg5Tx6hCkSs
	iYY8Hrj3pSUx121HWeGVaX6tW4g52qOyRMw3/rqJItAIWRJXkFLku/61pna1AC+a2u6HwxHv5llpA
	V02VS6bWXBIAn6AjiLfGFx4WsKED6hEtdOasjzUyHrM0rqnWh6KuSDARvsYQSe7TsNT/MVtxFgbix
	yshJCcGA==;
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:linux-usb+subscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <mailto:linux-usb+unsubscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-12-hch-jcswGhMUV9g@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TZNg+MwTxZMZA@public.gmane.org

On Wed, Sep 13, 2023 at 08:10:05AM -0300, Christoph Hellwig wrote:
> Currently super_blocks are shut down using the ->kill_sb method, which
> must call generic_shutdown_super, but allows the file system to
> add extra work before or after the call to generic_shutdown_super.
> 
> File systems tend to get rather confused by this, so add an alternative
> shutdown sequence where generic_shutdown_super is called by the core
> code, and there are extra ->shutdown_sb and ->free_sb hooks before and
> after it.  To remove the amount of boilerplate code ->shutdown_sb is only
> called if the super has finished initialization and ->d_root is set.

The last sentence doesn't match the patchset.  That aside, there
is an issue with method names.

->shutdown_sb() is... odd.  ->begin_shutdown_sb(), perhaps?  For the
majority of filesystems it's NULL, after all...

Worse, ->free_sb() is seriously misguiding - the name implies that
we are, well, freeing a superblock passed to it.  Which is not what is
happening here - superblock itself is freed only when all passive
references go away.  It's asking for trouble down the road.

We already have more than enough confusion in the area.  Note, BTW,
that there's a delicate issue around RCU accesses and freeing stuff -
->d_compare() can bloody well be called when superblock is getting
shut down.  For anything that might be needed by it (or by other
RCU'd methods) we must arrange for RCU-delayed destruction.
E.g. in case of fatfs we have sbi freeing done via call_rcu() (from
fat_put_super(), called by generic_shutdown_super()).

<checks the current tree>

Oh, bugger...  AFAICS, exfat has a problem - exfat_free_sbi() is called
directly from exfat_kill_sb(), without any concern for this:
static int exfat_utf8_d_cmp(const struct dentry *dentry, unsigned int len,
                const char *str, const struct qstr *name)
{
        struct super_block *sb = dentry->d_sb;
        unsigned int alen = exfat_striptail_len(name->len, name->name,
                                EXFAT_SB(sb)->options.keep_last_dots);

That kfree() needs to be RCU-delayed...  While we are at it, there's
this:
static int exfat_d_hash(const struct dentry *dentry, struct qstr *qstr)
{
        struct super_block *sb = dentry->d_sb;
        struct nls_table *t = EXFAT_SB(sb)->nls_io;
and we need this
        unload_nls(sbi->nls_io);
in exfat_put_super() RCU-delayed as well.  And I suspect that
        exfat_free_upcase_table(sbi);
right after it needs the same treatment.

AFFS: similar problem, wants ->s_fs_info freeing RCU-delayed.

hfsplus: similar, including non-delayed unlock_nls() calls.

ntfs3:
        /*
         * Try slow way with current upcase table
         */
        sbi = dentry->d_sb->s_fs_info;
        uni1 = __getname();
        if (!uni1)
                return -ENOMEM;
__getname().  "Give me a page and you might block, while you are
at it".  Done from ->d_compare().  Called under dentry->d_lock
and rcu_read_lock().  OK, any further investigation of that
one is... probably not worth bothering with at that point.

Other in-tree instances appear to be correct.  I'll push fixes for
those (well, ntfs3 aside) out tomorrow.

