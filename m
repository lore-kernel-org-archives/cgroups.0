Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794479728;
	b=F/gcq5Ik4lI2yc5I7I/rslH9EA3Hg1utHJn1Ss61uXr8y4tlr2NCdEw2NGz1dq6SJqB2
	 U8R18GW6CE7bx25XMA8/Vb8at6aGCaNOHnMP3kT/Yq23BgVW3AWhxcz/EzwbkX3dTMZ1c
	 0hVIbyxj6623ldIPZFlsunMoFIK9nS8Ah4yFMglrk+4Iu4Aeu56Xw5PmmV6OU0WtB9Evi
	 oZpfTceveJm4oIE/cGNeqAlPRXWMrAx1YaaiDF/xZz1TZ4b/2BlXfEzPhCodPpqY/kvnr
	 6ZuKrz7rdaXePj81f9pN2fyV2BUWzQpmcrbJvsljgWIQVIt3NwG7J10sb1sPB3Qcp/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794479728;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
	b=ArhDt1XT5hkHOAR5pKq1UXT3YsVbAKQPm11Dbo+pAwVLYypNT96v3c98f47m3imzOxXE
	 7PFQJtHpLJFZBgmCiEpzH/7nsU5YOm3IDetzcCQqOEJI88DI3s4vIJcabjWmyOtTYCWKF
	 HrMuD9xVj+aRGWoGH5ZDYcz1SiEq1qVwN0AbrZVOnY75xCJB9m5p0W7WnGXchg1t0n7Ns
	 108JfPJwNxwabxG7Z3IolMfWy+vGk4cpZXemMQwxfGYW19xm7vMHK2YGPWBLTVMmODjmd
	 PRtTX9dtlmvsiNSiWHtFnkEEvN0SEFhEj9tFR1UXcyK9TTq9LQuaQwceaVVwLZ7KTnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HJbPw53Y;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dm6rE4TZ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FC1606A88B
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 10:35:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9FC1606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HJbPw53Y;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dm6rE4TZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794479726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
	b=HJbPw53YKZOGWNmnPPkNsudLUEjOYvusApPtLfY/7aq5TIIvbJj6sf2ojmHLfarJyyIX9K
	LdLQmSKIZoS8UwHc1/r6J7oD9Mpic3linCBHMzovsgQCv3rQyEKXDcPQSWSJg1nfel1/2H
	DsCl+XpmYvf1uui+LMEwZ0t4uuVRIaY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-yuusGc41PJyMXKP_xTa1_w-1; Thu, 12 Nov 2026 05:35:24 -0500
X-MC-Unique: yuusGc41PJyMXKP_xTa1_w-1
X-Mimecast-MFC-AGG-ID: yuusGc41PJyMXKP_xTa1_w_1794479723
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48fbcf023dcso2467197f8f.2
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 02:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794479723; x=1795084523; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
        b=dm6rE4TZC3j5U903/gydUu/dtGyQSVdSMLGcSHtW6rDtCEGIFUre9DDZMeoj76BOTe
         DpqPpd8vK4k6lHQqkVnvOsufE4zZmXI6TXZyc7+C/Tkse6jIewAchZLTGQy1eGx9tObK
         oOjgVW7G3gSnfdrpnmqhm9U4TngqC74sN3bCTpvJikfqMk5DjudilQc4lAmoz8kpItoD
         tlyQkn43IMDCm2QLNfJI82HbIKu++ujdUmEJqZgktlbz2O+ocOc87H7JnHEXYx9V3E3k
         vIAmSOZKkD4yYexwjyilgwj7B4LyzjiThlkqR1Y9gYJbVvWPZ88SPT+7ix6bdX0gcZk8
         Zp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794479723; x=1795084523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
        b=GiD3XRhbWltEM3ESP8TcsbAe9nCV6WGcnA5wxXPBQv/QtncJjLws8vKLOHCmpsk5Gm
         qkkVMDwWfMKvnxcVg4C8VOnLKK2AGi59rNKfIew7JUlAQpSTBJHhxqRxMKcL4AfJHb1u
         iIpXn2bk+sKzA784cr1s7bCaQ/P2oTzjRQFKldJ7XSLsXL0qnbhT816TYM9xbdy03qj3
         z21L8qIToyVsFsZxgts2BHRpeID8WvIFhJ9xKZVv2DsGSljkNGS9DIwG1Pu8PWFarbTg
         Rw7n1VT6T1WmyJ68onfsLCTxHC1WwEIKIjsMN6BSZ5xcQk7o9qWlBnuehMVfmi45P4uL
         Pc+A==
X-Forwarded-Encrypted: i=1; AL+hErGclWwzEe9ttKu0TjlkqaCdVzKagHOYkhIJImXrg82qLJnbbsE2QcZzoteKrdJLpAcu525GGniB@vger.kernel.org
X-Gm-Message-State: APuU4Z9qkf63E/3fUzt64s9yMPeagiPh3AlVmFw4DrtofWx0EzX7A4KD
	EFfCUDs8AiABwJg950qJTJmFs2k9Asp0TrGQtBqlrl3BPL3sXWlj3J/bNM32RtR71Rx1Vblo7eQ
	mk7WcWFZtihhbmYvNc6J2XOWKbfwMkV2rk3MNtaIM4B+IiCKbxCa4R06u3kI=
X-Gm-Gg: AYBFou2VzWlBURfln75g6LSQS5vapujuU+HzOj0Ue3vmETyxIFTdxyS1qJpATaDH9Qp
	xOP4VmLvrHVk0ATewKk+EtqkfP13xQ5vA02PdTXuv4UUR8Wn6fWuxjsPImhXlkt6Z3HimQ+soIj
	V75ogqIKP8P/jsOezOEHnuJDhksjqPv0LmhWI1Xuz1K/wvfjO6oCxWoYCQmOoSlXuUFmUV/CgGX
	9TP0e2LuWB9EcDu9O3XjF8TuMyr1YOSvZN2Iq/1ZibKVX4BvJ6RmNxxJxQ1LENZEr8n6Btiseok
	1uM+UazbZlW8l78w8FzvGzmQ7tnxlfo99z5Vz88f4IIsq6vgRgYWFw8+i61AvmaiUwl4YeKt0Jh
	LchsR3xZcJHJX45XsVS703Jz6ssL3pOlsdx0xP8gvSe8=
X-Received: by 2002:a05:6000:2085:b0:491:8462:20cc with SMTP id ffacd0b85a97d-499c83c0f21mr9326439f8f.37.1794479722829;
        Thu, 12 Nov 2026 02:35:22 -0800 (PST)
X-Received: by 2002:a05:6000:2085:b0:491:8462:20cc with SMTP id ffacd0b85a97d-499c83c0f21mr9326382f8f.37.1794479722342;
        Thu, 12 Nov 2026 02:35:22 -0800 (PST)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49895f4e6ffsm14747224f8f.16.2026.11.12.02.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 02:35:21 -0800 (PST)
Date: Thu, 12 Nov 2026 11:35:20 +0100
From: Albert Esteve <aesteve@redhat.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Jens Wikland er <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org
Subject: Re: [Linaro-mm-sig] [PATCH v4 2/8] dma-heap: charge dma-buf memory
 via explicit memcg
Message-ID: <avWWaMg42vIJM2Ot@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
 <3fdad4e17008cd59bc528ab22e34c0c913a6d50f.camel@linux.intel.com>
 <avWNWnXCXm1sUYch@aesteve-thinkpadp1gen8.rmtes.csb>
 <22b3ca8cd78b61ecf652a34c5b6b23d7d46208d2.camel@linux.intel.com>
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
In-Reply-To: <22b3ca8cd78b61ecf652a34c5b6b23d7d46208d2.camel@linux.intel.com>

On Thu, Nov 12, 2026 at 11:04:54AM +0100, Thomas Hellström wrote:
> On Thu, 2026-11-12 at 10:56 +0100, Albert Esteve wrote:
> > On Thu, Nov 12, 2026 at 08:42:18AM +0100, Thomas Hellström wrote:
> > > On Wed, 2026-11-04 at 12:09 +0100, Albert Esteve wrote:
> > > > On embedded platforms a central process often allocates dma-buf
> > > > memory on behalf of client applications. Without a way to
> > > > attribute the charge to the requesting client's cgroup, the
> > > > cost lands on the allocator, making per-cgroup memory limits
> > > > ineffective for the actual consumers.
> > > > 
> > > > Add charge_fd to struct dma_heap_allocation_data. When set to
> > > > a valid pidfd or cgroupfd, DMA_HEAP_IOCTL_ALLOC resolves the
> > > > target
> > > > task's or cgroup's memcg and charges the buffer there via
> > > > mem_cgroup_reserve_dmabuf() inside dma_heap_ioctl_allocate(). The
> > > > resolved memcg is passed through dma_buf_export_info so that
> > > > dma_buf_export() stores it and updates the MEMCG_DMABUF stat.
> > > > Without charge_fd, and with the mem_accounting module parameter
> > > > enabled, the buffer is charged to the allocator's own cgroup.
> > > > The __GPF_ACCOUNT flag is removed from system heap allocations
> > > > to avoid double counting.
> > > > 
> > > > Usage examples:
> > > > 
> > > >   1. Central allocator charging to a client at allocation time.
> > > >      The allocator knows the client's PID (e.g., from binder's
> > > >      sender_pid) and uses pidfd to attribute the charge:
> > > > 
> > > >        pid_t client_pid = txn->sender_pid;
> > > >        int pidfd = pidfd_open(client_pid, 0);
> > > > 
> > > >        struct dma_heap_allocation_data alloc = {
> > > >            .len         = buffer_size,
> > > >            .fd_flags    = O_RDWR | O_CLOEXEC,
> > > >            .charge_fd   = pidfd,
> > > >        };
> > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > >        close(pidfd);
> > > >        /* alloc.fd is now charged to client's cgroup */
> > > > 
> > > >   2. Default allocation (no pidfd, mem_accounting=1).
> > > >      When charge_fd is not set and the mem_accounting module
> > > >      parameter is enabled, the buffer is charged to the
> > > > allocator's
> > > >      own cgroup:
> > > > 
> > > >        struct dma_heap_allocation_data alloc = {
> > > >            .len      = buffer_size,
> > > >            .fd_flags = O_RDWR | O_CLOEXEC,
> > > >        };
> > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > >        /* charged to current process's cgroup */
> > > > 
> > > > Current limitations:
> > > > 
> > > >  - Single-owner model: a dma-buf carries one memcg charge
> > > > regardless
> > > > of
> > > >    how many processes share it. Means only the first owner (and
> > > > exporter)
> > > >    of the shared buffer bears the charge.
> > > >  - Only memcg accounting supported. While this makes sense for
> > > > system
> > > >    heap buffers, other heaps (e.g., CMA heaps) will require
> > > > selectively
> > > >    charging also for the dmem controller.
> > > > 
> > > > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > > > ---
> > > >  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
> > > >  drivers/dma-buf/dma-buf.c               |  5 ++++
> > > >  drivers/dma-buf/dma-heap.c              | 28 +++++++++++++++++--
> > > > -
> > > >  drivers/dma-buf/heaps/cma_heap.c        |  3 ++-
> > > >  drivers/dma-buf/heaps/system_heap.c     | 21 +++++++++++----
> > > >  drivers/tee/tee_heap.c                  |  3 ++-
> > > >  include/linux/dma-buf.h                 |  4 +++
> > > >  include/linux/dma-heap.h                |  3 ++-
> > > >  include/linux/memcontrol.h              |  7 +++++
> > > >  include/uapi/linux/dma-heap.h           |  7 +++++
> > > >  mm/memcontrol.c                         | 47
> > > > +++++++++++++++++++++++++++++++++
> > > >  11 files changed, 120 insertions(+), 13 deletions(-)
> > > > 
> > > > diff --git a/Documentation/admin-guide/cgroup-v2.rst
> > > > b/Documentation/admin-guide/cgroup-v2.rst
> > > > index a3265a4a953e..66ddba678784 100644
> > > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > > @@ -1663,8 +1663,9 @@ The following nested keys are defined.
> > > >  		structures.
> > > >  
> > > >  	  dmabuf (npn)
> > > > -		Amount of memory used for exported DMA buffers
> > > > allocated by the cgroup.
> > > > -		Stays with the allocating cgroup regardless of
> > > > how
> > > > the buffer is shared.
> > > > +		Amount of memory used for exported DMA buffers
> > > > allocated by or on
> > > > +		behalf of the cgroup. Stays with the allocating
> > > > cgroup regardless
> > > > +		of how the buffer is shared.
> > > 
> > > This doesn't sound right. Graphics buffers exported as DMA buffers
> > > are
> > > typically charged elsewhere, like gpu_active, and a transfer of
> > > their
> > > charge would likely stay in that key? To be consistent, shouldn't
> > > this
> > > be related to dma-heap memory and called dmaheap or something
> > > similar.
> > 
> > Although this work initially targeted dma heaps only, in its current
> > form is meant to stay generic (while solving the central allocator
> > problem). The memory exported as dma-bufs has no memory.stat of its
> > own, and an exporter allocating plain pages (e.g., V4L2) has nowhere
> > else to report it.
> > 
> > > We should have a tighter definition of exactly what memory is to be
> > > registered here.
> > 
> > Yes, I will be more specific and clearly state that an exporter
> > whose memory is already accounted must not opt in. That also
> > naturally disallows transfers.
> 
> I would suspect (although not sure TBH) a system that uses a
> centralized allocator for gpu memory (even if it's accounted as
> gpu_active) might want to be able to transfer the charge as well, so I
> think the transfer mechanism might want to be generic enough to handle
> that.

That makes sense as a direction, but my aim for this series was
to tackle the central allocator problem, that is, memory charge at
dma-buf level to the cgroup an allocation is made for, and moved
afterwards if needed.

For allocators that charge per page (as in Dave's series) a transfer
would move each page's charges between objcgs, which is a different
mechanism from the dma-buf level charge in this series.

But iiuc you feedback is in line with Christian's feedback that uAPI
should not block later extension. To that end, XFER_CHARGE ioctl has a
reserved flags field, so more buffer types can be potentially supported
later, as they opt-in, without uAPI changes.

> At least the initial design should IMO allow for a future hook to
> handle such transfers even for !dma-buf memory?

Not sure what you mean by hook here. A callback in the exporter?
A charge op in dma_buf_ops was already objected before [1].

[1] https://lore.kernel.org/lkml/5cc27a05-8131-ce9b-dea1-5c75e994216d@amd.com/


> 
> Thanks,
> Thomas
> 
> 
> > 
> > > 
> > > Also says "Stays with the allocating cgroup regardless of how the
> > > buffer is shared", which isn't correct after the series? Perhaps
> > > that's
> > > changed in a later patch.
> > 
> > I missed updating the text after having added XFER_CHARGE to the
> > series. I'll fix the wording in this patch and mention the transfer
> > in the next one.
> > 
> > BR,
> > Albert
> > 
> > > 
> > > Thanks,
> > > Thomas
> > > 
> > > 
> > > 
> > > 
> > > >  
> > > >  	  workingset_refault_anon
> > > >  		Number of refaults of previously evicted
> > > > anonymous
> > > > pages.
> > > > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-
> > > > buf.c
> > > > index 1c6b9cee7ac2..837666273550 100644
> > > > --- a/drivers/dma-buf/dma-buf.c
> > > > +++ b/drivers/dma-buf/dma-buf.c
> > > > @@ -714,6 +714,7 @@ struct dma_buf *dma_buf_export(const struct
> > > > dma_buf_export_info *exp_info)
> > > >  	struct dma_resv *resv = exp_info->resv;
> > > >  	struct file *file;
> > > >  	size_t alloc_size = sizeof(struct dma_buf);
> > > > +	unsigned int nr_pages = PAGE_ALIGN(exp_info->size) >>
> > > > PAGE_SHIFT;
> > > >  	int ret;
> > > >  
> > > >  	if (WARN_ON(!exp_info->priv || !exp_info->ops
> > > > @@ -750,6 +751,7 @@ struct dma_buf *dma_buf_export(const struct
> > > > dma_buf_export_info *exp_info)
> > > >  	dmabuf->size = exp_info->size;
> > > >  	dmabuf->exp_name = exp_info->exp_name;
> > > >  	dmabuf->owner = exp_info->owner;
> > > > +	dmabuf->memcg = exp_info->memcg;
> > > >  	spin_lock_init(&dmabuf->name_lock);
> > > >  	init_waitqueue_head(&dmabuf->poll);
> > > >  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf-
> > > > >poll;
> > > > @@ -771,6 +773,9 @@ struct dma_buf *dma_buf_export(const struct
> > > > dma_buf_export_info *exp_info)
> > > >  
> > > >  	DMA_BUF_TRACE(trace_dma_buf_export, dmabuf);
> > > >  
> > > > +	if (dmabuf->memcg)
> > > > +		mod_memcg_state(dmabuf->memcg, MEMCG_DMABUF,
> > > > nr_pages);
> > > > +
> > > >  	return dmabuf;
> > > >  
> > > >  err_file:
> > > > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-
> > > > heap.c
> > > > index 8a6c2b6e0cc6..7bd416ae2c23 100644
> > > > --- a/drivers/dma-buf/dma-heap.c
> > > > +++ b/drivers/dma-buf/dma-heap.c
> > > > @@ -10,6 +10,8 @@
> > > >  #include <linux/device.h>
> > > >  #include <linux/dma-buf.h>
> > > >  #include <linux/dma-heap.h>
> > > > +#include <linux/memcontrol.h>
> > > > +#include <linux/sched/mm.h>
> > > >  #include <linux/err.h>
> > > >  #include <linux/export.h>
> > > >  #include <linux/list.h>
> > > > @@ -78,6 +80,7 @@ static struct dma_buf
> > > > *dma_heap_ioctl_allocate(struct file *file, void *data)
> > > >  	struct dma_heap_allocation_data *heap_allocation = data;
> > > >  	struct dma_heap *heap = file->private_data;
> > > >  	struct dma_buf *dmabuf;
> > > > +	struct mem_cgroup *memcg = NULL;
> > > >  	int fd;
> > > >  	size_t len;
> > > >  
> > > > @@ -90,15 +93,34 @@ static struct dma_buf
> > > > *dma_heap_ioctl_allocate(struct file *file, void *data)
> > > >  	if (heap_allocation->heap_flags &
> > > > ~DMA_HEAP_VALID_HEAP_FLAGS)
> > > >  		return ERR_PTR(-EINVAL);
> > > >  
> > > > +	if (heap_allocation->__padding != 0)
> > > > +		return ERR_PTR(-EINVAL);
> > > > +
> > > > +	if (heap_allocation->charge_fd) {
> > > > +		memcg = mem_cgroup_get_from_fd(heap_allocation-
> > > > > charge_fd);
> > > > +		if (IS_ERR(memcg))
> > > > +			return ERR_CAST(memcg);
> > > > +	}
> > > > +
> > > > +	if (!memcg && mem_accounting)
> > > > +		memcg = get_mem_cgroup_from_mm(current->mm);
> > > > +
> > > >  	len = PAGE_ALIGN(heap_allocation->len);
> > > > -	if (!len)
> > > > +	if (!len) {
> > > > +		mem_cgroup_put(memcg);
> > > >  		return ERR_PTR(-EINVAL);
> > > > +	}
> > > >  
> > > >  	dmabuf = heap->ops->allocate(heap, len, heap_allocation-
> > > > > fd_flags,
> > > > -				     heap_allocation-
> > > > >heap_flags);
> > > > +				     heap_allocation-
> > > > >heap_flags,
> > > > memcg);
> > > >  
> > > > -	if (IS_ERR(dmabuf))
> > > > +	if (IS_ERR(dmabuf)) {
> > > > +		mem_cgroup_put(memcg);
> > > >  		return dmabuf;
> > > > +	}
> > > > +
> > > > +	if (memcg && !dmabuf->memcg)
> > > > +		mem_cgroup_put(memcg);
> > > >  
> > > >  	fd = get_unused_fd_flags(heap_allocation->fd_flags);
> > > >  	if (fd < 0) {
> > > > diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-
> > > > buf/heaps/cma_heap.c
> > > > index 3fb4b946c91a..04de88b468a8 100644
> > > > --- a/drivers/dma-buf/heaps/cma_heap.c
> > > > +++ b/drivers/dma-buf/heaps/cma_heap.c
> > > > @@ -281,7 +281,8 @@ static const struct dma_buf_ops
> > > > cma_heap_buf_ops
> > > > = {
> > > >  static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> > > >  					 unsigned long len,
> > > >  					 u32 fd_flags,
> > > > -					 u64 heap_flags)
> > > > +					 u64 heap_flags,
> > > > +					 struct mem_cgroup
> > > > *memcg)
> > > >  {
> > > >  	struct cma_heap *cma_heap = dma_heap_get_drvdata(heap);
> > > >  	struct cma_heap_buffer *buffer;
> > > > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-
> > > > buf/heaps/system_heap.c
> > > > index c8959eadc71d..2bd245e1eab8 100644
> > > > --- a/drivers/dma-buf/heaps/system_heap.c
> > > > +++ b/drivers/dma-buf/heaps/system_heap.c
> > > > @@ -17,6 +17,7 @@
> > > >  #include <linux/err.h>
> > > >  #include <linux/highmem.h>
> > > >  #include <linux/mem_encrypt.h>
> > > > +#include <linux/memcontrol.h>
> > > >  #include <linux/mm.h>
> > > >  #include <linux/set_memory.h>
> > > >  #include <linux/module.h>
> > > > @@ -388,8 +389,6 @@ static struct page
> > > > *alloc_largest_available(unsigned long size,
> > > >  		if (max_order < orders[i])
> > > >  			continue;
> > > >  		flags = order_flags[i];
> > > > -		if (mem_accounting)
> > > > -			flags |= __GFP_ACCOUNT;
> > > >  		page = alloc_pages(flags, orders[i]);
> > > >  		if (!page)
> > > >  			continue;
> > > > @@ -401,11 +400,13 @@ static struct page
> > > > *alloc_largest_available(unsigned long size,
> > > >  static struct dma_buf *system_heap_allocate(struct dma_heap
> > > > *heap,
> > > >  					    unsigned long len,
> > > >  					    u32 fd_flags,
> > > > -					    u64 heap_flags)
> > > > +					    u64 heap_flags,
> > > > +					    struct mem_cgroup
> > > > *memcg)
> > > >  {
> > > >  	struct system_heap_buffer *buffer;
> > > >  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > > >  	unsigned long size_remaining = len;
> > > > +	unsigned int nr_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> > > >  	unsigned int max_order = orders[0];
> > > >  	struct system_heap_priv *priv =
> > > > dma_heap_get_drvdata(heap);
> > > >  	bool cc_shared = priv->cc_shared;
> > > > @@ -416,10 +417,15 @@ static struct dma_buf
> > > > *system_heap_allocate(struct dma_heap *heap,
> > > >  	struct page *page, *tmp_page;
> > > >  	int i, ret = -ENOMEM;
> > > >  
> > > > -	buffer = kzalloc_obj(*buffer);
> > > > -	if (!buffer)
> > > > +	if (!mem_cgroup_reserve_dmabuf(memcg, GFP_KERNEL,
> > > > nr_pages))
> > > >  		return ERR_PTR(-ENOMEM);
> > > >  
> > > > +	buffer = kzalloc_obj(*buffer);
> > > > +	if (!buffer) {
> > > > +		ret = -ENOMEM;
> > > > +		goto cancel_charge;
> > > > +	}
> > > > +
> > > >  	INIT_LIST_HEAD(&buffer->attachments);
> > > >  	mutex_init(&buffer->lock);
> > > >  	buffer->heap = heap;
> > > > @@ -473,11 +479,14 @@ static struct dma_buf
> > > > *system_heap_allocate(struct dma_heap *heap,
> > > >  	exp_info.size = buffer->len;
> > > >  	exp_info.flags = fd_flags;
> > > >  	exp_info.priv = buffer;
> > > > +	if (memcg)
> > > > +		exp_info.memcg = memcg;
> > > >  	dmabuf = dma_buf_export(&exp_info);
> > > >  	if (IS_ERR(dmabuf)) {
> > > >  		ret = PTR_ERR(dmabuf);
> > > >  		goto free_pages;
> > > >  	}
> > > > +
> > > >  	return dmabuf;
> > > >  
> > > >  free_pages:
> > > > @@ -498,6 +507,8 @@ static struct dma_buf
> > > > *system_heap_allocate(struct dma_heap *heap,
> > > >  	list_for_each_entry_safe(page, tmp_page, &pages, lru)
> > > >  		__free_pages(page, compound_order(page));
> > > >  	kfree(buffer);
> > > > +cancel_charge:
> > > > +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
> > > >  
> > > >  	return ERR_PTR(ret);
> > > >  }
> > > > diff --git a/drivers/tee/tee_heap.c b/drivers/tee/tee_heap.c
> > > > index 007c00156520..83e2fbd6960b 100644
> > > > --- a/drivers/tee/tee_heap.c
> > > > +++ b/drivers/tee/tee_heap.c
> > > > @@ -167,7 +167,8 @@ static const struct dma_buf_ops
> > > > tee_heap_buf_ops
> > > > = {
> > > >  
> > > >  static struct dma_buf *tee_dma_heap_alloc(struct dma_heap *heap,
> > > >  					  unsigned long len, u32
> > > > fd_flags,
> > > > -					  u64 heap_flags)
> > > > +					  u64 heap_flags,
> > > > +					  struct mem_cgroup
> > > > *memcg)
> > > >  {
> > > >  	struct tee_dma_heap *h = dma_heap_get_drvdata(heap);
> > > >  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > > > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > > > index 23ec0ff23fba..85dd747c9b36 100644
> > > > --- a/include/linux/dma-buf.h
> > > > +++ b/include/linux/dma-buf.h
> > > > @@ -505,6 +505,9 @@ struct dma_buf_attachment {
> > > >   * @flags:	mode flags for the file
> > > >   * @resv:	reservation-object, NULL to allocate default one
> > > >   * @priv:	Attach private data of allocator to this buffer
> > > > + * @memcg:	memcg to charge for this buffer's memory. Set
> > > > only
> > > > for
> > > > + *		buffers backed by system memory where @size
> > > > reflects
> > > > the
> > > > + *		actual allocation in bytes.
> > > >   *
> > > >   * This structure holds the information required to export the
> > > > buffer. Used
> > > >   * with dma_buf_export() only.
> > > > @@ -517,6 +520,7 @@ struct dma_buf_export_info {
> > > >  	int flags;
> > > >  	struct dma_resv *resv;
> > > >  	void *priv;
> > > > +	struct mem_cgroup *memcg;
> > > >  };
> > > >  
> > > >  /**
> > > > diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
> > > > index 648328a64b27..2d69f8432bd2 100644
> > > > --- a/include/linux/dma-heap.h
> > > > +++ b/include/linux/dma-heap.h
> > > > @@ -23,7 +23,8 @@ struct dma_heap_ops {
> > > >  	struct dma_buf *(*allocate)(struct dma_heap *heap,
> > > >  				    unsigned long len,
> > > >  				    u32 fd_flags,
> > > > -				    u64 heap_flags);
> > > > +				    u64 heap_flags,
> > > > +				    struct mem_cgroup *memcg);
> > > >  };
> > > >  
> > > >  /**
> > > > diff --git a/include/linux/memcontrol.h
> > > > b/include/linux/memcontrol.h
> > > > index 4d1e82cf0833..f8ec751b7d7b 100644
> > > > --- a/include/linux/memcontrol.h
> > > > +++ b/include/linux/memcontrol.h
> > > > @@ -671,6 +671,8 @@ int mem_cgroup_charge_hugetlb(struct folio*
> > > > folio, gfp_t gfp);
> > > >  int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned
> > > > short id,
> > > >  				   struct mm_struct *mm, gfp_t
> > > > gfp);
> > > >  
> > > > +struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
> > > > +
> > > >  bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t
> > > > gfp,
> > > >  			       unsigned int nr_pages);
> > > >  
> > > > @@ -1178,6 +1180,11 @@ static inline int
> > > > mem_cgroup_swapin_charge_folio(struct folio *folio,
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static inline struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> > > > +{
> > > > +	return ERR_PTR(-EOPNOTSUPP);
> > > > +}
> > > > +
> > > >  static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup
> > > > *memcg,
> > > >  					     gfp_t gfp,
> > > >  					     unsigned int
> > > > nr_pages)
> > > > diff --git a/include/uapi/linux/dma-heap.h
> > > > b/include/uapi/linux/dma-
> > > > heap.h
> > > > index a4cf716a49fa..bfcd1c25bc7e 100644
> > > > --- a/include/uapi/linux/dma-heap.h
> > > > +++ b/include/uapi/linux/dma-heap.h
> > > > @@ -29,6 +29,11 @@
> > > >   *			handle to the allocated dma-buf
> > > >   * @fd_flags:		file descriptor flags used when
> > > > allocating
> > > >   * @heap_flags:		flags passed to heap
> > > > + * @charge_fd:		optional pidfd or cgroupfd whose cgroup
> > > > should be
> > > > + *			charged for this allocation; 0 means
> > > > charge
> > > > the calling
> > > > + *			process's cgroup when the mem_accounting
> > > > module parameter
> > > > + *			is enabled, or skip charging otherwise
> > > > + * @__padding:		reserved, must be zero
> > > >   *
> > > >   * Provided by userspace as an argument to the ioctl
> > > >   */
> > > > @@ -37,6 +42,8 @@ struct dma_heap_allocation_data {
> > > >  	__u32 fd;
> > > >  	__u32 fd_flags;
> > > >  	__u64 heap_flags;
> > > > +	__u32 charge_fd;
> > > > +	__u32 __padding;
> > > >  };
> > > >  
> > > >  #define DMA_HEAP_IOC_MAGIC		'H'
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index e53dd7eebc3b..17fdefc56b97 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -5661,6 +5661,53 @@ void mem_cgroup_flush_workqueue(void)
> > > >  	flush_workqueue(memcg_wq);
> > > >  }
> > > >  
> > > > +/**
> > > > + * mem_cgroup_get_from_fd - resolve a memcg from a cgroupfd or
> > > > pidfd
> > > > + * @fd: file descriptor (cgroupfd or pidfd)
> > > > + *
> > > > + * Tries @fd as a cgroupfd first; if that fails, tries it as a
> > > > pidfd.
> > > > + * On success returns a referenced memcg pointer. On failure
> > > > returns
> > > > + * an ERR_PTR.
> > > > + */
> > > > +struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> > > > +{
> > > > +	struct cgroup_subsys_state *css;
> > > > +	struct mem_cgroup *memcg;
> > > > +	struct cgroup *cgrp;
> > > > +	struct task_struct *task;
> > > > +	struct mm_struct *mm;
> > > > +	unsigned int pidfd_flags;
> > > > +
> > > > +	cgrp = cgroup_get_from_fd(fd);
> > > > +	if (!IS_ERR(cgrp)) {
> > > > +		rcu_read_lock();
> > > > +		css = cgroup_css(cgrp, &memory_cgrp_subsys);
> > > > +		if (!css || !css_tryget_online(css)) {
> > > > +			rcu_read_unlock();
> > > > +			cgroup_put(cgrp);
> > > > +			return ERR_PTR(-ENOENT);
> > > > +		}
> > > > +
> > > > +		memcg = mem_cgroup_from_css(css);
> > > > +		rcu_read_unlock();
> > > > +		cgroup_put(cgrp);
> > > > +		return memcg;
> > > > +	}
> > > > +
> > > > +	task = pidfd_get_task(fd, &pidfd_flags);
> > > > +	if (IS_ERR(task))
> > > > +		return ERR_CAST(task);
> > > > +
> > > > +	mm = get_task_mm(task);
> > > > +	put_task_struct(task);
> > > > +	if (!mm)
> > > > +		return ERR_PTR(-ESRCH);
> > > > +
> > > > +	memcg = get_mem_cgroup_from_mm(mm);
> > > > +	mmput(mm);
> > > > +	return memcg ?: ERR_PTR(-ENOENT);
> > > > +}
> > > > +
> > > >  /**
> > > >   * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf
> > > > allocation
> > > >   * @memcg: memcg to charge (may be %NULL)

