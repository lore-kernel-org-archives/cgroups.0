From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/19] qibfs: use simple_release_fs
Date: Mon, 18 Sep 2023 14:41:29 +0300
Message-ID: <20230918114129.GA103601@unreal>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-usb+bounces-321-glug-linux-usb=m.gmane-mx.org-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695037293;
	bh=k5whRDb703pFSoW6vBuZiC/uLzAA5qCrmwIb0niMTaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Aq8BDUPTeZUbSi6r80BUN/6MwH1BAmiHYY4SHfZ7onFlzdMGfEKZJql8eJgFd8kcU
	 VSUGCximU6yLeulyz9sCP0KhTKpgfeEuARR1qg4bJb/2c3E2+Aaq/FI7E9KE3mXGPA
	 mMkzDccqY/MfireMOZxTAFoqx04P3/eEENahXkm++IxXno8NknhrffAlyV8usX4nkg
	 fRFkfnnveLguRIcv9+LTO4c7dt1uE+rem3E3BlUrXtrNJpo5JMLyLk57Bw4w+y0H+Q
	 CpPUMugfzFQ2rqTkkxwCEL03tDYtT39/xBNsmqTbEmsL2yuFfD5IL+86z+BlChrW+f
	 YsxfJTuf+MXoQ==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:linux-usb+subscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <mailto:linux-usb+unsubscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-7-hch-jcswGhMUV9g@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 

On Wed, Sep 13, 2023 at 08:10:00AM -0300, Christoph Hellwig wrote:
> qibfs currently has convoluted code to allow registering HCAs while qibfs
> is not mounted and vice versa.  Switch to using simple_release_fs every
> time an entry is added to pin the fs instance and remove all the boiler
> plate code.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib.h      |   4 +-
>  drivers/infiniband/hw/qib/qib_fs.c   | 105 ++++++---------------------
>  drivers/infiniband/hw/qib/qib_init.c |  32 +++-----
>  3 files changed, 36 insertions(+), 105 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

