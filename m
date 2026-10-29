Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793262160;
	b=af9j7qXIsS9QD4fzaKzoXYJVyTO8c4/3vH6ci/o2Stkg2KawXoMonWSwU6O3YZgwFDNl
	 SSWFsPoGlSe6+amN3+jGVF3RHtWpDZ23VdFXcWGIwtfxyhrzkvfwHWQxPAwdaJaIvVPOF
	 GF0NLuDwXYA5idrybS6h6vZFPj581fLQYg5+qU7jWch3J6w2FkYFla94TVhOdizZna8x9
	 Y/v/2pnIgHZnNteYvmU600zv7U0WvtWKaC5neR41G43VyHfmQTwLgkRnvR58ojwxVCJ2D
	 OZImJxORsqZ1zj6AvKPrFHMwYkujbS5sVvIGn+Ch/2+0/EBPjP+R0iSLReI1AKbvJ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793262160;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=94uB/DHgfg1qZqyJ7zAIFQRDjTgpiQBipF8LX3G5vmw=;
	b=UtPRMY4324xC8a7RLuYzqlaa5ck9mN+i2gweS8JGY2aw/9Pdenti1kGLTGqkuhRJY+5j
	 cQ+hMV+8HCF01WEfnoBAzlP3Ohf4tKSO3P78PXSTGjtxh4x8uwhim4L1+KPqK5gwCxJr8
	 gfqNOS2vvcNlQde9Kwv7HUoq1OiMXxZSbN0MhmGVGabLjxkHWkakZYAFbI5LadWwDb7cz
	 z5Ig7zklo5Oe/zYsslVXpkopsYPy0hx/F3UonWL556c5OPdmur8/xMzVl5wAZp/mcy4XP
	 TZ4PfMKKbntum0087XTEdwYXeGx1nBj01Hsl+2kswNWSY4bnLf6BnI1VbAB8NPTvzqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=D8F2Lqr9;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=O7hUkgt0;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FD6606A320
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 08:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79FD6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=D8F2Lqr9;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=O7hUkgt0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793262158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94uB/DHgfg1qZqyJ7zAIFQRDjTgpiQBipF8LX3G5vmw=;
	b=D8F2Lqr94iFaFMQhKbDaKj66BtjrQYy5KEPcX7WZfBGnko6VlgTWGZ225w7NJO4DrFUMrj
	0s9ft3cARF1LkXfqiK8Ebyhr+a9638A0XKECjLBNxF4PjQfnmPRa5nftd45GDDBGA4gcTV
	iaYTVo1CCv664sD9j85dEVG4PDTGNWM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-fJ9Bbx-DNl6FMNuX8NR85Q-1; Thu, 29 Oct 2026 04:22:36 -0400
X-MC-Unique: fJ9Bbx-DNl6FMNuX8NR85Q-1
X-Mimecast-MFC-AGG-ID: fJ9Bbx-DNl6FMNuX8NR85Q_1793262156
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a318cd95e8so4403025e9.0
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 01:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793262155; x=1793866955; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=94uB/DHgfg1qZqyJ7zAIFQRDjTgpiQBipF8LX3G5vmw=;
        b=O7hUkgt0CCrij9nr2cfINSY8Ddx4H3r21X8Fc2s7yj+tgr51vFv/W1LeqtT89X45RH
         HAgJKmn7SPmkXJEkPknyJS/JrvGzMiRsbOsgkHxDQavVmH28zuF3Si9djX3I7HSwN1dI
         QDtQbhvk8sraUlw+l4ca6oct1PMQ0Mg8o9pdWCQ9qSiNYoNmt8bSNc47FSUEZhesFkO3
         I9DFngDv8nB7SNNZBwV4mmvxmeIRNNCvqC2kWvN5QCaIHfR4Aa2Djc9wDCqSh5wkAhOZ
         MJBb7BAD6PCJAMWRTubDPytkO5qcp0NJ9u0bZgTUJlPZ9BBoN6dI5xinFmqRdAT0nLbc
         UeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793262155; x=1793866955;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=94uB/DHgfg1qZqyJ7zAIFQRDjTgpiQBipF8LX3G5vmw=;
        b=q8wFhAOTzsQDHxOTyWTANaLg/lViNSOgWaipWZOHQuwKYkpjbOaDak7FmkRL7rg6Pn
         CgW7gLwEYyLHSql9NoUTq0SF+enQv296L8wFvbuiD6INZ3AfOwln2LXgHNi3V1k3AsIW
         w9xHqK0Z+AlA/blg6PDSWELAah1Hio64GWqdhCRE0eeX4HjQIhg2Y2sdkrNHbTOrH2Eb
         qUf5W2JhzZaYBDokGBjkd+eokOeQHDoAwR4XZ9FK6+7tE5aX72H3Nlf8BFPiKtJ7ib6C
         m1R+0SsmAC0IreJHsVKKw8NN/HZ9NX6e6TtUD07W6z34bjpHSGgJeYkTwcbDMXaag0c7
         8hOw==
X-Forwarded-Encrypted: i=1; AKwUvByiNe7xtEnXMC2XPDmhYWCmAGw7n/uialGlDclQzeghU477TJ6md1bsBZPG0XGY9tXQmulsSVDe@vger.kernel.org
X-Gm-Message-State: AFq9FYJCyKrw/hrViRfXmPmhS0PyR+ONU/tU5qGE8RxOAnA7i+PC2ixF
	SphQ29ST+QS6UoF7N3Q6ENbJDDsmdkDC+JyxivEyKKBfH17uwXsoEjVLCs9Fr4/Smaagu9/awtn
	yGHVzKeB+P45S5s8qy9RfOEnsCT2+X4vl+JZf6DnILq/fa5w7mBC/DtnHU+g=
X-Gm-Gg: AYBFou3uM53uRaUujGNAh1W85wQ9k1NWXsy+hsPFH3Is1OIAAOI8p3YptSW3naDl0lb
	RDvGEOxvcov7jj8nW+cxFX0JZHBwWpNEVZwzMbkZOjFptYP1vwq4FWAHcrUcvgqzjSNNi65fshc
	vJhv7BxsA5pLyPczpy60LrJz4YFmgz9d/6usurdqfbatQP148VagvfMkXXShTY1iFYwbyqDKGty
	KYzhzghn78DBnaEaET2syIIHoplqB8iagVVbynVRnLzn7XNCvj6ubCNt+lXy+dUEmKj+2vMkZ7X
	mTPK7TWx5vNfDQdyZdJy/0fkdrv03D4JZD+8jSxCl8YWC0frSrccLi7b3zNAT5SYsybztV/dxYP
	80oo6SdLAP6xzAkbjvBGp0I8DO/SoK1/sP4VVUxnu8fg=
X-Received: by 2002:a05:600c:e48b:b0:4a1:d291:d863 with SMTP id 5b1f17b1804b1-4aa8a1e90demr32611265e9.4.1793262155519;
        Thu, 29 Oct 2026 01:22:35 -0700 (PDT)
X-Received: by 2002:a05:600c:e48b:b0:4a1:d291:d863 with SMTP id 5b1f17b1804b1-4aa8a1e90demr32610685e9.4.1793262154992;
        Thu, 29 Oct 2026 01:22:34 -0700 (PDT)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ece14a1sm34322198f8f.57.2026.10.29.01.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 01:22:34 -0700 (PDT)
Date: Thu, 29 Oct 2026 09:22:33 +0100
From: Albert Esteve <aesteve@redhat.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org,
	echanude@redhat.com, mripard@kernel.org
Subject: Re: [PATCH v3 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
Message-ID: <auMCSb-punIgJOmA@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
 <d76d8bfe-e955-4e90-9f5f-e3e914c0869c@amd.com>
 <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>

On Wed, Oct 28, 2026 at 05:09:37PM +0100, Albert Esteve via OP-TEE wrote:
> On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
> > On 10/27/26 16:02, Albert Esteve wrote:
> > > dma-heap already supports charging a specific cgroup at allocation
> > > time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> > > originate from any exporter (DRM, V4L2, etc.), and the allocator may
> > > not know the final owner at allocation time.
> > > 
> > > Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> > > to a different cgroup after allocation. The target is identified by
> > > charge_fd, which may be a cgroupfd or a pidfd.
> > > 
> > > The transfer charges the new cgroup before uncharging the old one,
> > > preserving the original charge on failure. An atomic cmpxchg on
> > > dmabuf->memcg prevents races with concurrent transfers.
> > > 
> > > Not all dma-buf exporters back their buffers with reclaimable system
> > > memory. Some represent device registers, VRAM, or carved-out pools
> > > where size is not a meaningful memory cost. Add a memcg_account flag
> > > to dma_buf_export_info that exporters set when their buffers should
> > > participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
> > > for buffers that do not set the flag. Currently only the system heap
> > > sets it, other exporters can opt in as needed.
> > > 
> > > Usage example:
> > >   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> > > 
> > >   struct dma_buf_transfer_charge xfer = {
> > >       .charge_fd = cg_fd,
> > >   };
> > >   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> > >   /* charge now on app1's cgroup */
> > >   close(cg_fd);
> > > 
> > > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > > ---
> > >  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
> > >  drivers/dma-buf/heaps/system_heap.c |  1 +
> > >  include/linux/dma-buf.h             |  5 +++++
> > >  include/linux/memcontrol.h          |  9 ++++++++
> > >  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
> > >  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
> > >  6 files changed, 125 insertions(+)
> > > 
> > > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > > index f31f49ebd0af..07513ecedc10 100644
> > > --- a/drivers/dma-buf/dma-buf.c
> > > +++ b/drivers/dma-buf/dma-buf.c
> > > @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
> > >  }
> > >  #endif
> > >  
> > > +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
> > > +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> > > +				const void __user *user_data)
> > > +{
> > > +	struct dma_buf_transfer_charge arg;
> > > +	struct mem_cgroup *memcg;
> > > +	int ret = 0;
> > > +
> > > +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> > > +		return -EFAULT;
> > > +
> > > +	if (!IS_ENABLED(CONFIG_MEMCG))
> > > +		return 0;
> > > +
> > > +	if (arg.flags != 0)
> > > +		return -EINVAL;
> > > +
> > > +	if (!dmabuf->memcg_account)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
> > > +	if (IS_ERR(memcg))
> > > +		return PTR_ERR(memcg);
> > > +
> > > +	if (dmabuf->memcg == memcg)
> > > +		goto skip_transfer;
> > > +
> > > +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> > > +		ret = -ENOMEM;
> > > +		goto skip_transfer;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +skip_transfer:
> > > +	mem_cgroup_put(memcg);
> > > +	return ret;
> > > +}
> > > +
> > >  static long dma_buf_ioctl(struct file *file,
> > >  			  unsigned int cmd, unsigned long arg)
> > >  {
> > > @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> > >  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
> > >  #endif
> > >  
> > > +	case DMA_BUF_IOCTL_XFER_CHARGE:
> > > +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> > > +
> > >  	default:
> > >  		return -ENOTTY;
> > >  	}
> > > @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
> > >  	dmabuf->size = exp_info->size;
> > >  	dmabuf->exp_name = exp_info->exp_name;
> > >  	dmabuf->owner = exp_info->owner;
> > > +	dmabuf->memcg_account = exp_info->memcg_account;
> > 
> > The initial charging should probably be done here as well.
> > 
> > This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
> 
> The problem with doing the charge here is that it happens too late.
> That is the reasoning for this proposal to move all the charging logic
> into heap allocators before pages are allocated.
> 
> What we could do is fill the dmabuf->memcg field when the flag is set
> (i.e., committing into the dmabuf in the patch semantics). But for that
> we'd need adding the memcg we want to charge it to into exp_info in
> order to support charging to cgroups other than the allocator's (for
> the common case would be simpler as we can just look at current).
> Maybe that's what you meant?

Actually if I do this we can remove the memcg_account flag and just
uses exp_info->memcg as both the memcg to set *and* the flag when
it is != NULL. Exporters that set the memcg info are implicitly
flagging the dmabuf as chargeable (and transfereable).

The only thing is that mod_memcg_state() still needs nr_pages
and we cannot use size as that varies from one exporter to another as
you explained before. So that can be left for the exporter to call. WDYT?

> 
> > 
> > >  	spin_lock_init(&dmabuf->name_lock);
> > >  	init_waitqueue_head(&dmabuf->poll);
> > >  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
> > > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> > > index adeea8cd328b..a764167167ba 100644
> > > --- a/drivers/dma-buf/heaps/system_heap.c
> > > +++ b/drivers/dma-buf/heaps/system_heap.c
> > > @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> > >  	exp_info.size = buffer->len;
> > >  	exp_info.flags = fd_flags;
> > >  	exp_info.priv = buffer;
> > > +	exp_info.memcg_account = true;
> > >  	dmabuf = dma_buf_export(&exp_info);
> > >  	if (IS_ERR(dmabuf)) {
> > >  		ret = PTR_ERR(dmabuf);
> > > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > > index 23ec0ff23fba..ac0ec88cab93 100644
> > > --- a/include/linux/dma-buf.h
> > > +++ b/include/linux/dma-buf.h
> > > @@ -433,6 +433,9 @@ struct dma_buf {
> > >  
> > >  	/** @memcg: the cgroup to which this buffer is currently attributed */
> > >  	struct mem_cgroup *memcg;
> > > +
> > > +	/** @memcg_account: account buffer memory to cgroup */
> > > +	bool memcg_account;
> > >  };
> > >  
> > >  /**
> > > @@ -505,6 +508,7 @@ struct dma_buf_attachment {
> > >   * @flags:	mode flags for the file
> > >   * @resv:	reservation-object, NULL to allocate default one
> > >   * @priv:	Attach private data of allocator to this buffer
> > > + * @memcg_account:	account buffer memory to cgroup
> > >   *
> > >   * This structure holds the information required to export the buffer. Used
> > >   * with dma_buf_export() only.
> > > @@ -517,6 +521,7 @@ struct dma_buf_export_info {
> > >  	int flags;
> > >  	struct dma_resv *resv;
> > >  	void *priv;
> > > +	bool memcg_account;
> > >  };
> > >  
> > >  /**
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 6b30baa79fa9..36fddafbef4e 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> > >  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
> > >  			      unsigned int nr_pages);
> > >  
> > > +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> > > +				       struct mem_cgroup *new_memcg);
> > > +
> > >  void __mem_cgroup_uncharge(struct folio *folio);
> > >  
> > >  /**
> > > @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
> > >  {
> > >  }
> > >  
> > > +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> > > +						     struct mem_cgroup *new_memcg)
> > > +{
> > > +	return true;
> > > +}
> > > +
> > >  static inline void mem_cgroup_uncharge(struct folio *folio)
> > >  {
> > >  }
> > > diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> > > index e827c9d20c5d..ea957f4b1d38 100644
> > > --- a/include/uapi/linux/dma-buf.h
> > > +++ b/include/uapi/linux/dma-buf.h
> > > @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> > >  	__s32 fd;
> > >  };
> > >  
> > > +/**
> > > + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> > > + *
> > > + * Any holder of a dma-buf file descriptor can perform a
> > > + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> > > + * cost to a specific cgroup, or move it from one cgroup to
> > > + * another.  The ioctl charges the new cgroup before uncharging
> > > + * the old one atomically.  On failure the original charge is
> > > + * preserved.  If the buffer has no existing charge, a new
> > > + * charge is established.
> > > + */
> > > +struct dma_buf_transfer_charge {
> > > +	/** @flags: Reserved, must be zero */
> > > +	__u32 flags; /* unused for now */
> > > +	/**
> > > +	 * @charge_fd: File descriptor identifying the target cgroup.
> > > +	 *
> > > +	 * May be either a pidfd, in which case the charge moves to the
> > > +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> > > +	 * by opening a cgroup v2 directory, in which case the charge moves
> > > +	 * directly to that cgroup's memory controller.
> > > +	 */
> > > +	__u32 charge_fd;
> > > +};
> > > +
> > >  #define DMA_BUF_BASE		'b'
> > >  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
> > >  
> > > @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> > >  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> > >  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
> > >  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> > > +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
> > >  
> > >  #endif
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 7b841b905759..3adc84fe6668 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
> > >  		refill_stock(memcg, nr_pages);
> > >  }
> > >  
> > > +/**
> > > + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> > > + * @dmabuf: buffer to transfer charge
> > > + * @new_memcg: target memcg; caller must hold a reference
> > > + *
> > > + * Transfers the charge for @dmabuf to @new_memcg and, on
> > > + * success, stores @new_memcg in @dmabuf->memcg.
> > > + * Returns %true on success, %false if the charge against @new_memcg
> > > + * failed or a concurrent transfer raced on @dmabuf->memcg.
> > > + * On failure the caller retains its reference to @new_memcg.
> > > + */
> > > +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> > > +				       struct mem_cgroup *new_memcg)
> > 
> > I would make that more generic instead of dmabuf specific. E.g. something like this:
> > 
> > bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
> 
> Ah yes, I like this generalization. And the implementation remains
> mostly the same. Thanks!
> 
> > 
> > > +{
> > > +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
> > 
> > > +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> > 
> > This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
> > 
> > Regards,
> > Christian.
> > 
> > > +
> > > +	if (mem_cgroup_disabled())
> > > +		return true;
> > > +
> > > +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
> > > +		return false;
> > > +
> > > +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> > > +
> > > +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
> > > +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
> > > +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (old_memcg) {
> > > +		/* Uncharge old cgroup */
> > > +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> > > +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
> > > +		mem_cgroup_put(old_memcg);
> > > +	}
> > > +
> > > +	return true;
> > > +}
> > > +
> > >  /**
> > >   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> > >   * @dmabuf: buffer to uncharge
> > > 
> > 
> 

