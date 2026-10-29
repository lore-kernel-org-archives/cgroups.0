Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291049;
	b=t8cevl8zyiT/dFTS50srJstv0grCHkEi8yChgbcc+qirkKlO0Z77liVTz0APtK7Z5vTU
	 LVaGKw8LV24m9+9yFJ8G1HkkCCYOhN+ChfEll4v+LciSGWOTULJJWfSIgSQyOE5Sagwpt
	 1jcIht6T6AEJgth/Ukzurb41/RLyoBHf6WoWqGTCLHz5gja8WiJYYEi9WxiIO27uQvdkX
	 STcw37tT/kUT2Yg2ItCXPMLkwy3010dY3rhCGyzPhF0FybUaPCLdk0NtUOcMDwv90hJXp
	 4Bc1KZYpmqiYAZ6acVM7XAnQa8/WH9wWN6p0TUP2U0UL8qcBEHaYCNDXtW5S9hllVkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291049;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
	b=TolKVEaBEouYB0ChwGxZN2rZ9NASEdxJwtC+PkHCEqYsWWnBXRB5Ehtn+fp0M93TwoZV
	 HbscoPH3pcXvgGtzNVG0mgprKaIyucLzeJuRviBEsVt9sefBpPDFf2myn71h1C5bs7Rm4
	 iCRgd3CXcBBCu2oqS8xVIvRatP9PNHxUD26j9xjpCRtp7XTBtU9N/uejxii3nR/y0icfL
	 Pocp1W7LjeaKamUzCv3z3xwlIKHCYMRQm/gG8tt5nJUX4zWWD3Xil8epos1TbJJQbZUyZ
	 LrOft7iiyRI+ThtVEyo+SVtoBVQNWSzLWHisUqCNpVWxw2xu8o1mA0Im6ooyWhAtR/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Dqq7c8MY;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=QurcO0fz;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F560A2601
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 766F560A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Dqq7c8MY;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=QurcO0fz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
	b=Dqq7c8MYkZ6iTRs571u0QboPaC7SUo9sqYmavyvk+rr36vu+HSXH3hxH89BJrEd+oQewdQ
	7/nfVEaxAoCFJbD01ku3N/fcunZ6pW/POXLpRtN77nEy+AQYFw2neBNP/inPaJ4IV1R224
	OxeLTo2vvM46ikT0xSLYvzgTPwGHo08=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-AjwsWCZFNEmX0qfvfL_9qQ-1; Thu, 29 Oct 2026 12:24:02 -0400
X-MC-Unique: AjwsWCZFNEmX0qfvfL_9qQ-1
X-Mimecast-MFC-AGG-ID: AjwsWCZFNEmX0qfvfL_9qQ_1793291041
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a35e1d2dddso21122585e9.0
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 09:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793291041; x=1793895841; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
        b=QurcO0fzPWPu13O2LAqfaFwWs+VWqIZx0Dneaae9Bt/P7OXzkq0smc25JX551nsn03
         JuvpmFZpHKGKWiGC0jQ9ZXfVsxI7wJytyPD7ibQstEZO0+LWbbQUY7ziN7XxVMMpLys3
         vtaaaf0SdM9wu4oFl+varRFgy32oAqiW6jjKMAx4IYcY/e8ggMJa3wPXXqcldfCYwZEb
         6kv5h045qhlajASIw6qqxIQkSPFCJX7aWniU91zHU3aZ5rSaJ4vqXoKLVyoomC4rSMNv
         B+2GfN0+nIH0mtj1Z+HHEziJVzLk/gwfpq5pKEeP+F0M4xssltdNJeDWlLXtpaetIuTP
         i09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291041; x=1793895841;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
        b=1pIFbCw4yg6D1UOA0N018adMG/W/tbBmADs+gltKRStvYsWNAqq8GUdTKW2p8E6WCz
         +6EXAJhcwgKog+unJQEO5u1LBLK6pShIDXu0BFJwbwc55j3CI7UybwSWJ4XKX8JvOA07
         9Nx4rj8s5FTcEBlmTQ/1u/DdYnXIMO07Op/vQ1nwdyokGTtm6V+rCj4C0MJLvrh8Bs2G
         0g3SuKI3BPV911zAeRBLFjdhMXMB9b/vnjry+qZU6bzjaaAwQipOLjyK5bFOQLQPg54m
         fYo5+NQDP0m6zSX23E5LZgteFU+t2t905L9AflJB6Zsi+Wfzy8UgF9gFB8t1prQW1mqB
         ZEfg==
X-Forwarded-Encrypted: i=1; AKwUvBysixLnCaDYqeQqgG6/1fg2SibpfdcUq3ib1dyxZj7fEH5ueChqJfm3uohlkVmZzCVhMf1RyGrC@vger.kernel.org
X-Gm-Message-State: AFq9FYKd9XhupOdhi8thZnhTrypjP7E9RYfRz2PR4NBOr56c9XmfeEcp
	hVtRkQ5O2Uun4xxujcVS/wcHjQSdmtuTp8VD3fMwJ9vaFmQqYgeG6YPpBAxnmmBxT4BMwZ2Y9Ux
	ZTGUYCLRAgG5avfD6H6E23FaPAIRI07iHF7G9euRcGQPzKVoR/u5g4BA1HOo=
X-Gm-Gg: AYBFou14s/ktt+qnU33QUFDFUwgcpbiz3RRQM3Z9sllrzaen3r7GwZPZqhsCOjM/MxX
	eUvNkjofdyn6UXtK+xbgnxVZh6UUVI/mx6adGVYwxQBgbkDjNAB/+ens/BfBWZXuJW/ji/XEPwr
	A7BaikCht6RSLF4IekHDkIsHMrmurDqu1xLQtX3bEDitwgHFSPNoALbYOm59B1O70Syf259OFfr
	sF4SDki4df9Te+deiy9uRic21zYVy2y7MONwJEHjGjaWW9UzasnvDOKFXaJULMg62tYsSDs0SZU
	3CwHdBskqcBpKUovscCxuIzDLYXfJvgFRiM6FVHEhvtGhl6kmkGWpDYQiO8hyR1VxHeR7xIBgCJ
	73urwghelS2Sv1b2Y79Lx4YonEH4y9+vrt041b2We/s0=
X-Received: by 2002:a05:600c:4455:b0:4a3:59c7:f226 with SMTP id 5b1f17b1804b1-4a965ec950amr131385355e9.6.1793291040720;
        Thu, 29 Oct 2026 09:24:00 -0700 (PDT)
X-Received: by 2002:a05:600c:4455:b0:4a3:59c7:f226 with SMTP id 5b1f17b1804b1-4a965ec950amr131384485e9.6.1793291040202;
        Thu, 29 Oct 2026 09:24:00 -0700 (PDT)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94f05e4e4sm90190855e9.3.2026.10.29.09.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:23:59 -0700 (PDT)
Date: Thu, 29 Oct 2026 17:23:58 +0100
From: Albert Esteve <aesteve@redhat.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
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
Message-ID: <auNzHjhT5xezyZ4I@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
 <d76d8bfe-e955-4e90-9f5f-e3e914c0869c@amd.com>
 <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
 <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
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
In-Reply-To: <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>

On Thu, Oct 29, 2026 at 03:16:12PM +0100, Christian König wrote:
> On 10/28/26 17:09, Albert Esteve wrote:
> > On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
> >> On 10/27/26 16:02, Albert Esteve wrote:
> >>> dma-heap already supports charging a specific cgroup at allocation
> >>> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> >>> originate from any exporter (DRM, V4L2, etc.), and the allocator may
> >>> not know the final owner at allocation time.
> >>>
> >>> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> >>> to a different cgroup after allocation. The target is identified by
> >>> charge_fd, which may be a cgroupfd or a pidfd.
> >>>
> >>> The transfer charges the new cgroup before uncharging the old one,
> >>> preserving the original charge on failure. An atomic cmpxchg on
> >>> dmabuf->memcg prevents races with concurrent transfers.
> >>>
> >>> Not all dma-buf exporters back their buffers with reclaimable system
> >>> memory. Some represent device registers, VRAM, or carved-out pools
> >>> where size is not a meaningful memory cost. Add a memcg_account flag
> >>> to dma_buf_export_info that exporters set when their buffers should
> >>> participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
> >>> for buffers that do not set the flag. Currently only the system heap
> >>> sets it, other exporters can opt in as needed.
> >>>
> >>> Usage example:
> >>>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> >>>
> >>>   struct dma_buf_transfer_charge xfer = {
> >>>       .charge_fd = cg_fd,
> >>>   };
> >>>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> >>>   /* charge now on app1's cgroup */
> >>>   close(cg_fd);
> >>>
> >>> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> >>> ---
> >>>  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
> >>>  drivers/dma-buf/heaps/system_heap.c |  1 +
> >>>  include/linux/dma-buf.h             |  5 +++++
> >>>  include/linux/memcontrol.h          |  9 ++++++++
> >>>  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
> >>>  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
> >>>  6 files changed, 125 insertions(+)
> >>>
> >>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >>> index f31f49ebd0af..07513ecedc10 100644
> >>> --- a/drivers/dma-buf/dma-buf.c
> >>> +++ b/drivers/dma-buf/dma-buf.c
> >>> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
> >>>  }
> >>>  #endif
> >>>  
> >>> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
> >>> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> >>> +				const void __user *user_data)
> >>> +{
> >>> +	struct dma_buf_transfer_charge arg;
> >>> +	struct mem_cgroup *memcg;
> >>> +	int ret = 0;
> >>> +
> >>> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> >>> +		return -EFAULT;
> >>> +
> >>> +	if (!IS_ENABLED(CONFIG_MEMCG))
> >>> +		return 0;
> >>> +
> >>> +	if (arg.flags != 0)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (!dmabuf->memcg_account)
> >>> +		return -EOPNOTSUPP;
> >>> +
> >>> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
> >>> +	if (IS_ERR(memcg))
> >>> +		return PTR_ERR(memcg);
> >>> +
> >>> +	if (dmabuf->memcg == memcg)
> >>> +		goto skip_transfer;
> >>> +
> >>> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> >>> +		ret = -ENOMEM;
> >>> +		goto skip_transfer;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +
> >>> +skip_transfer:
> >>> +	mem_cgroup_put(memcg);
> >>> +	return ret;
> >>> +}
> >>> +
> >>>  static long dma_buf_ioctl(struct file *file,
> >>>  			  unsigned int cmd, unsigned long arg)
> >>>  {
> >>> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> >>>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
> >>>  #endif
> >>>  
> >>> +	case DMA_BUF_IOCTL_XFER_CHARGE:
> >>> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> >>> +
> >>>  	default:
> >>>  		return -ENOTTY;
> >>>  	}
> >>> @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
> >>>  	dmabuf->size = exp_info->size;
> >>>  	dmabuf->exp_name = exp_info->exp_name;
> >>>  	dmabuf->owner = exp_info->owner;
> >>> +	dmabuf->memcg_account = exp_info->memcg_account;
> >>
> >> The initial charging should probably be done here as well.
> >>
> >> This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
> > 
> > The problem with doing the charge here is that it happens too late.
> > That is the reasoning for this proposal to move all the charging logic
> > into heap allocators before pages are allocated.
> 
> Oh, that is a really good point we need to talk about.
> 
> DMA-buf heaps is actually a rather simple use case, but we have way more complex things.
> 
> For example in some use cases the backing store of a DMA-buf is only allocated on first use and only then it needs to be comitted to it's memcg or dmem.

Yes. The idea is focus on heaps for now. But the uAPI is actually
agnostic of the time when the charge happens. When we deal with
lazy-allocation in the future we can just call the reserve/cancel
helpers wherever is more appropiate. As long as the pages are not
allocated, exporters do not set dmabuf->memcg, and XFER does not
work (returns -EOPNOTSUPP).

> 
> I don't mind implementing it for DMA-buf heaps first, but we should have the uAPI and it's handling so solid that it also works for future use cases.

Agreed. I think we should cover all usecases with the current status.
Your feedback helped a lot in getting there!

> > What we could do is fill the dmabuf->memcg field when the flag is set
> > (i.e., committing into the dmabuf in the patch semantics). But for that
> > we'd need adding the memcg we want to charge it to into exp_info in
> > order to support charging to cgroups other than the allocator's (for
> > the common case would be simpler as we can just look at current).
> > Maybe that's what you meant?
> 
> At least for the DMA-buf heaps use case that sounds reasonable for now.

Thanks! Next version will have the flag removed and just use
dmabuf->memcg as indicator, set within dma_buf_export().
Also, `nr_pages` will be computed within dma_buf_export(), the
contract being that exporters setting exp_info.memcg assert that
size reflects actual system memory bytes.

> 
> Regards,
> Christian.
> 
> > 
> >>
> >>>  	spin_lock_init(&dmabuf->name_lock);
> >>>  	init_waitqueue_head(&dmabuf->poll);
> >>>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
> >>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> >>> index adeea8cd328b..a764167167ba 100644
> >>> --- a/drivers/dma-buf/heaps/system_heap.c
> >>> +++ b/drivers/dma-buf/heaps/system_heap.c
> >>> @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> >>>  	exp_info.size = buffer->len;
> >>>  	exp_info.flags = fd_flags;
> >>>  	exp_info.priv = buffer;
> >>> +	exp_info.memcg_account = true;
> >>>  	dmabuf = dma_buf_export(&exp_info);
> >>>  	if (IS_ERR(dmabuf)) {
> >>>  		ret = PTR_ERR(dmabuf);
> >>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> >>> index 23ec0ff23fba..ac0ec88cab93 100644
> >>> --- a/include/linux/dma-buf.h
> >>> +++ b/include/linux/dma-buf.h
> >>> @@ -433,6 +433,9 @@ struct dma_buf {
> >>>  
> >>>  	/** @memcg: the cgroup to which this buffer is currently attributed */
> >>>  	struct mem_cgroup *memcg;
> >>> +
> >>> +	/** @memcg_account: account buffer memory to cgroup */
> >>> +	bool memcg_account;
> >>>  };
> >>>  
> >>>  /**
> >>> @@ -505,6 +508,7 @@ struct dma_buf_attachment {
> >>>   * @flags:	mode flags for the file
> >>>   * @resv:	reservation-object, NULL to allocate default one
> >>>   * @priv:	Attach private data of allocator to this buffer
> >>> + * @memcg_account:	account buffer memory to cgroup
> >>>   *
> >>>   * This structure holds the information required to export the buffer. Used
> >>>   * with dma_buf_export() only.
> >>> @@ -517,6 +521,7 @@ struct dma_buf_export_info {
> >>>  	int flags;
> >>>  	struct dma_resv *resv;
> >>>  	void *priv;
> >>> +	bool memcg_account;
> >>>  };
> >>>  
> >>>  /**
> >>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >>> index 6b30baa79fa9..36fddafbef4e 100644
> >>> --- a/include/linux/memcontrol.h
> >>> +++ b/include/linux/memcontrol.h
> >>> @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> >>>  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
> >>>  			      unsigned int nr_pages);
> >>>  
> >>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>> +				       struct mem_cgroup *new_memcg);
> >>> +
> >>>  void __mem_cgroup_uncharge(struct folio *folio);
> >>>  
> >>>  /**
> >>> @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
> >>>  {
> >>>  }
> >>>  
> >>> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>> +						     struct mem_cgroup *new_memcg)
> >>> +{
> >>> +	return true;
> >>> +}
> >>> +
> >>>  static inline void mem_cgroup_uncharge(struct folio *folio)
> >>>  {
> >>>  }
> >>> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> >>> index e827c9d20c5d..ea957f4b1d38 100644
> >>> --- a/include/uapi/linux/dma-buf.h
> >>> +++ b/include/uapi/linux/dma-buf.h
> >>> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> >>>  	__s32 fd;
> >>>  };
> >>>  
> >>> +/**
> >>> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> >>> + *
> >>> + * Any holder of a dma-buf file descriptor can perform a
> >>> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> >>> + * cost to a specific cgroup, or move it from one cgroup to
> >>> + * another.  The ioctl charges the new cgroup before uncharging
> >>> + * the old one atomically.  On failure the original charge is
> >>> + * preserved.  If the buffer has no existing charge, a new
> >>> + * charge is established.
> >>> + */
> >>> +struct dma_buf_transfer_charge {
> >>> +	/** @flags: Reserved, must be zero */
> >>> +	__u32 flags; /* unused for now */
> >>> +	/**
> >>> +	 * @charge_fd: File descriptor identifying the target cgroup.
> >>> +	 *
> >>> +	 * May be either a pidfd, in which case the charge moves to the
> >>> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> >>> +	 * by opening a cgroup v2 directory, in which case the charge moves
> >>> +	 * directly to that cgroup's memory controller.
> >>> +	 */
> >>> +	__u32 charge_fd;
> >>> +};
> >>> +
> >>>  #define DMA_BUF_BASE		'b'
> >>>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
> >>>  
> >>> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> >>>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> >>>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
> >>>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> >>> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
> >>>  
> >>>  #endif
> >>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >>> index 7b841b905759..3adc84fe6668 100644
> >>> --- a/mm/memcontrol.c
> >>> +++ b/mm/memcontrol.c
> >>> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
> >>>  		refill_stock(memcg, nr_pages);
> >>>  }
> >>>  
> >>> +/**
> >>> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> >>> + * @dmabuf: buffer to transfer charge
> >>> + * @new_memcg: target memcg; caller must hold a reference
> >>> + *
> >>> + * Transfers the charge for @dmabuf to @new_memcg and, on
> >>> + * success, stores @new_memcg in @dmabuf->memcg.
> >>> + * Returns %true on success, %false if the charge against @new_memcg
> >>> + * failed or a concurrent transfer raced on @dmabuf->memcg.
> >>> + * On failure the caller retains its reference to @new_memcg.
> >>> + */
> >>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>> +				       struct mem_cgroup *new_memcg)
> >>
> >> I would make that more generic instead of dmabuf specific. E.g. something like this:
> >>
> >> bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
> > 
> > Ah yes, I like this generalization. And the implementation remains
> > mostly the same. Thanks!
> > 
> >>
> >>> +{
> >>> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
> >>
> >>> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> >>
> >> This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
> >>
> >> Regards,
> >> Christian.
> >>
> >>> +
> >>> +	if (mem_cgroup_disabled())
> >>> +		return true;
> >>> +
> >>> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
> >>> +		return false;
> >>> +
> >>> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> >>> +
> >>> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
> >>> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
> >>> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
> >>> +		return false;
> >>> +	}
> >>> +
> >>> +	if (old_memcg) {
> >>> +		/* Uncharge old cgroup */
> >>> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> >>> +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
> >>> +		mem_cgroup_put(old_memcg);
> >>> +	}
> >>> +
> >>> +	return true;
> >>> +}
> >>> +
> >>>  /**
> >>>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> >>>   * @dmabuf: buffer to uncharge
> >>>
> >>
> > 
> 

