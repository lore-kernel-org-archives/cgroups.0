From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Date: Tue, 24 Jan 2023 10:34:24 -0400
Message-ID: <Y8/scE3jhEQ+d69C@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Nb+m5UlpQ87pZNKMXBesdYeexw+krH9tx/p0ltBTvk=;
 b=lHs1gCWG920Ac22lyz/4Js9V94UGYXmQxq0/otZeFUi0RdT8SRFnDbZdyZCGWetWNd9zPNwO7rDcG5CivFK28G2jtF1Gfrt+wnqZKS3imqZXEJSPtZn7ccA6ItgrFwL27QhfHjA+6fDxLjqF9pK8tIjWTz0VsknkJpzWTtwby5Yc7DMTp11lVHRlkoiNb8eSTpwpzOqgTSlEpvhJVluZXOXErCGlAwpEbvv4ALAB9RZGYXHAjE7vqsn/DZjb024ieBrqdlceqfQf54Nv3zyS7oyv0NLnMv8TcJX3S8pKNCLeVb++xtpLf3F5nc36ResQRv21nHNCIvu53EfbrRVJnA==
Content-Disposition: inline
In-Reply-To: <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:31PM +1100, Alistair Popple wrote:

> @@ -799,9 +803,6 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  		return r;
>  	}
>  
> -	if (!vdpa->use_va)
> -		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);

Mention in the commit message this fixes a "bug" where vhost didn't
respect the limits

Jason
