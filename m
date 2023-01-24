From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Date: Tue, 24 Jan 2023 00:55:06 -0500
Message-ID: <20230124005356-mutt-send-email-mst@kernel.org>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org C236E416FC
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org DC19F41705
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.osuosl.org 61C3B81E87
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.osuosl.org 4CD9581E6E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1674539717;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9+nMn4Y7ib+ksp4an8hs+mxpzKixV/6cqrHGLxmxmZs=;
 b=Fv+zftM/+sdrzkt6rdetvf/WJi6bEZ2SsstXemXyQrpRJ3fmrYrDGhqUdH0JcAW3dESW+P
 hc8x7Zz6VZ53s4Vff+RN9wZqfkEXCRqOIanlbsboXXhBzAl6T7uprwDIH2qitYh2NePZVp
 j+5kgltXBJADMgAFT2cFsSDmIe1mTt8=
In-Reply-To: <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
Content-Disposition: inline
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: daniel@ffwll.ch, kvm@vger.kernel.org, jhubbard@nvidia.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org, mkoutny@suse.com, jgg@nvidia.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, surenb@google.com, tjmercier@google.com

On Tue, Jan 24, 2023 at 04:42:31PM +1100, Alistair Popple wrote:
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f78..a31dd53 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c

...

> @@ -780,6 +780,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  	u32 asid = iotlb_to_asid(iotlb);
>  	int r = 0;
>  
> +	if (!vdpa->use_va)
> +		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
> +			return -ENOMEM;
> +
>  	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
>  				      pa, perm, opaque);
>  	if (r)

I suspect some error handling will have to be reworked then, no?

> -- 
> git-series 0.9.1
