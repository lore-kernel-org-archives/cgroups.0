From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Fri, 15 Sep 2023 16:40:06 +0200
Message-ID: <20230915-brust-gratis-156b7572a7c9@brauner>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
 <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
 <20230914165805.GJ800259@ZenIV>
 <20230915-elstern-etatplanung-906c6780af19@brauner>
 <20230915-zweit-frech-0e06394208a3@brauner>
 <20230915142814.GL800259@ZenIV>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694788814;
        bh=PvlOjbLkc3tgSHNCaVnS82ty1H0lvym1p0dyZTkOFDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GsMXd6mZ8RM6Ehv3+oeXSFdJBK4XfA1s5jG3qJW397E3aH+o329rZ/VtgcJhEI2Ek
         GIJfdrxXDV/D+2h214W5hbDliVTBm3yN1eUgvtUVVZ1/ZgLJyELtBnprCB74Mvp2bO
         Y9yAjyDUJYhLQ2LABIiRFS7SjQAloadGL5GvZIH6h3ow+QooG9ilUBP37mYSe/gnfx
         Oe0um8v+i1YG5HcXkyDRJwPVS8rwGOnzAUkEZB8JlS5KwPI8HWoWokIviZ30JYSJLI
         VjWkPZQ6+IEwE3hlmnfM8EB719A4Al+/b90kwWaliUnxciX021zodiQcb+zRxyFzBc
         v2OPDzI9ovPwA==
Content-Disposition: inline
In-Reply-To: <20230915142814.GL800259@ZenIV>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Lifetime rules for fs-private parts of superblock are really private to

Fine, I'll drop that. It's still correct that a filesystem needs to take
care when it frees sb->s_fs_info. See the RCU fun you just encountered.


