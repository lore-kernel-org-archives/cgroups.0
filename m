From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 10/19] USB: gadget/legacy: remove sb_mutex
Date: Thu, 14 Sep 2023 13:22:59 +0300
Message-ID: <d3935129-2ab9-0341-c606-fabac4a49010@omp.ru>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-11-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20230913111013.77623-11-hch@lst.de>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Tejun Heo <tj@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, Kees Cook <keescook@chromium.org>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel

On 9/13/23 2:10 PM, Christoph Hellwig wrote:

> Creating new a new super_block vs freeing the old one for single instance
           ^^^^^^^^^
   I can't parse that. :-)

> file systems is serialized by the wait for SB_DEAD.
> 
> Remove the superfluous sb_mutex.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
[...]

MBR, Sergey
