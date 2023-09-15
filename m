From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Fri, 15 Sep 2023 15:28:14 +0100
Message-ID: <20230915142814.GL800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
 <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
 <20230914165805.GJ800259@ZenIV>
 <20230915-elstern-etatplanung-906c6780af19@brauner>
 <20230915-zweit-frech-0e06394208a3@brauner>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LQfJYvE2Csoxjb0lVlLN4FcWufcYVyyJCyyuwAbWOnU=; b=KQXtAOeuJAErVKd6uCAVlHA6pg
        YEjxPW8qCQSdnT0BpMPpiEQUqoWgnx96ACyemvrrs070Hx49chE8bD/RX6bVGcgAlD6+Fhi1XO6xX
        Z7rkRFy5u2HkFO69DEB0fz1XiCQ6zqT0Ehti6NRcEE4vBRecafV5pY9/6maldCvxzy9GqM2PkwGUO
        zlWUKy5Hawds6CoeWyMvCxmVhsjtC1qzXqXjtAmxjElm/ZsL0IqcA07elyzjW84yZ98nj+bPoR6K2
        eCbtX9jR50Qsk1JCgWNbndDpqTBH5bhOB+TqRtHzjkA2YK2vLvSMHdrNBIgByv8unzvp4sIU6+y/M
        YHMHee/A==;
Content-Disposition: inline
In-Reply-To: <20230915-zweit-frech-0e06394208a3@brauner>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 15, 2023 at 04:12:07PM +0200, Christian Brauner wrote:
> +	static void some_fs_kill_sb(struct super_block *sb)
> +	{
> +		struct some_fs_info *info = sb->s_fs_info;
> +
> +		kill_*_super(sb);
> +		kfree(info);
> +	}
> +
> +It's best practice to never deviate from this pattern.

The last part is flat-out incorrect.  If e.g. fatfs or cifs ever switches
to that pattern, you'll get UAF - they need freeing of ->s_fs_info
of anything that ever had been mounted done with RCU delay; moreover,
unload_nls() in fatfs needs to be behind the same.

Lifetime rules for fs-private parts of superblock are really private to
filesystem; their use by sget/sget_fc callbacks might impose restrictions
on those, but that again is none of the VFS business.
