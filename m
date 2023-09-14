From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Thu, 14 Sep 2023 20:23:31 +0100
Message-ID: <20230914192331.GK800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
 <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
 <20230914165805.GJ800259@ZenIV>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4hr36i5Cv0yOjN7Qm9aK+O+t73F0SaG9UQf71oo3coc=; b=TUQ6R0vfZi/dderGJyPUNMNW1S
        bGBX6G1t2V5wN0IJDFy3lSyvNLxteUnMS7i8LrmlKHnBX7D/46D3VL1LLp3PmhIcrV8xp75QBNrph
        uhKRrW8158NAtE6Nld12BbWmWTk6GDXfhxGjKJ9K5AQbTyVr5vCqN6iZU3CFmXLSa9W49CQKDf8JC
        uvti6ZvkSk3v9U6tCGhbhjUC3u1Cko0dd2WrfufnlEMkfYxRNpLRW3s38xAwwJL3hK3fj7qLAGb4y
        tqzNWInzV2Fz4nBN2aLW1MikDwXWL39jXoxSvpcwL0QBKsfKL2xUZIlLl6IopWufWXsm7kdFdP6cK
        o/GMz/RA==;
Content-Disposition: inline
In-Reply-To: <20230914165805.GJ800259@ZenIV>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TaqPxH82wqD4g@public.gmane.org

On Thu, Sep 14, 2023 at 05:58:05PM +0100, Al Viro wrote:

> Incidentally, I'm going to add a (belated by 10 years) chunk in porting.rst
> re making sure that anything in superblock that might be needed by methods
> called in RCU mode should *not* be freed without an RCU delay...  Should've
> done that back in 3.12 merge window when RCU'd vfsmounts went in; as it
> is, today we have several filesystems with exact same kind of breakage.
> hfsplus and affs breakage had been there in 3.13 (missed those two), exfat
> and ntfs3 - introduced later, by initial merges of filesystems in question.
> Missed on review...
> 
> Hell knows - perhaps Documentation/filesystems/whack-a-mole might be a good
> idea...

Actually, utf8 casefolding stuff also has the same problem, so ext4 and f2fs
with casefolding are also affected ;-/
