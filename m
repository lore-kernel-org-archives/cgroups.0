From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Date: Mon, 30 Jan 2023 21:43:52 +1100
Message-ID: <87357s1dwf.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
 <20230124005356-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TRGfffdbGVdU2djJATSOGzv2lyx21BjqOZ+X8sH9MY=;
 b=q9K4tykCpZpBAk6geGUC6YYaqIsuUWaefaTiHraoBxsVFytmHwhNCkirgBBdY/I5d6Yphxn/bGiOTVD00sm4OJ4EfaZwRmJwsEBjIATkuBByieQC0aAeLDXomtWQCIuyjWDR/EDgoCOC6g7FoTdiJrpxhqCLByRRQWCO6vloEJz/qEBDsXW32dVLujpWzbpTbbyl/g1LTHDECc811oVlQJUJxRmv+i01mdOg8i465dBUIk4yKhfLQ/WyS9IiBLC0JbkmfqJcQgWyuI1CbMqtQOQqGxOZxAGGAxKUTUML+aYyet6kJ5t3+qxtMtHXSlYlfAOM3w91nSZVeR4XzF5Jcg==
In-reply-to: <20230124005356-mutt-send-email-mst-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On Tue, Jan 24, 2023 at 04:42:31PM +1100, Alistair Popple wrote:
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index ec32f78..a31dd53 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>
> ...
>
>> @@ -780,6 +780,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>>  	u32 asid = iotlb_to_asid(iotlb);
>>  	int r = 0;
>>  
>> +	if (!vdpa->use_va)
>> +		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
>> +			return -ENOMEM;
>> +
>>  	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
>>  				      pa, perm, opaque);
>>  	if (r)
>
> I suspect some error handling will have to be reworked then, no?

Thanks. I had meant to go back and double check some of these driver
conversions. Will add something like below:

@@ -787,7 +787,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
-		return r;
+		goto out_unaccount;
 
 	if (ops->dma_map) {
 		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
@@ -798,12 +798,14 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
-	if (r) {
+	if (r)
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
-		return r;
-	}
 
-	return 0;
+out_unaccount:
+	if (!vdpa->use_va)
+		vm_unaccount_pinned(&dev->vm_account, PFN_DOWN(size));
+
+	return r;
 }
 
 static void vhost_vdpa_unmap(struct vhost_vdpa *v,

>> -- 
>> git-series 0.9.1

