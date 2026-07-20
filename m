Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD874DC522
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576175; cv=none; b=RyH8XHzLVWtfgFbIe/CTobDKOBZBa+ZXbpj8epaei5DDf8TMSG/8UGUnyIGSIXDB0AWrg4u8U+TZyzTRy3kVB3E2pzDHtDTMupTscfRmrwlWbB90JNC2Qx/RKdoVuAzcnsIVDdC9bLgD/Dn/0gigTW/Jwju7eXkgNBv0eeIvpyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576175; c=relaxed/simple;
	bh=d0vgqTeVUGBqlLAIGlg3lxl0DoS6vjZ3OvWpJ8TltpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccKpRlJNoluhTYeOONs8nCX+2WqL6MBSAKX4vKFt5VIm1ZJU5JemBbAoEF8Dyky7ixLc5wRu3LAzhAauccMuYlJTIdPl8mhtZwWsKqhm6BPOmBxkREXb2gQWl7zaLi1XVJLfGpc3sp45WSBms0bYHzt2I1gVmiCHs3o5GZfcvbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BAB7AlDv; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BAB7AlDv"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e622cc874so782491985a.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576171; x=1785180971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=agF9dzqU876M91BxnILPGKGHMrmtsRIzpFbV5gzpkC4=;
        b=BAB7AlDvWJHSFPAvkomx/HPQLnjetc2eOumGasbyoiIdK7eAEQ8neaEEzMLwN9RfJI
         sGalEaKcKCfYycRERfXaRftbJoKXpjSbEvWDQKqpa9bV3KIep8Roae0eTcde9XoC6VCw
         z0g+gazO+csCoUmzqtME3Wz61SMtIyoU5zys2pAN+rZN85E+V4s1q6QtKpIIRf9QMg4L
         LimFgt7swKdS6GjcdZOH4ks/op8FvYadLCVyG/VXBQYNL2+9mb2AELxtJwtbyTSNRYCE
         RJnBP/Q2J2U+5bb6SrgwoL0Htg+z514Ij3bXMBvEuYyHAntLtQrElBX1niXS2N2K5zeD
         d8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576171; x=1785180971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=agF9dzqU876M91BxnILPGKGHMrmtsRIzpFbV5gzpkC4=;
        b=EXPPaluukhI2jiSBm0Riywrm8ZtOeyVge5PImUQIvAqp/jrEWfr4ukVKU9rAC7zV6w
         xeQBsolsgdumN4+U3747ysj8ld3jsIrJPDNycRcvmWqVb5mPNW5wzZylneUdN9bWubq7
         aM0gQVNFhighHfVjFzWC9giVlRQHGPQhICpgykLUW7qTVV9Xz0Uh7WLP9e6w3NjDsRPO
         p3gfd+cXSvPNaGwi+gvZcdOFs0HugcFEn832mRXfmsHrqEJjED6XB03rdI0nNqz8dYP0
         1169jqnl+U4dSCL4RUqAe1XMQLwsZwpTXGcpRBgc6ZomFRN7VW9xVVVeL25H/afQz6tw
         HN2A==
X-Forwarded-Encrypted: i=1; AHgh+Rr7H/ue5SqVBFnaky4L+FUe8X6ue3Rcz1mfk7VicIGfAB2flgmrp490nc8pOuTfbkRh3yi7oIf6@vger.kernel.org
X-Gm-Message-State: AOJu0YyDeVbW9s6Cz3qCulqHlShesg3JPEbItVFUvpJvEXfvznOug85M
	JfEJyC/49Mb22C0G40db8Bk+GaWhrwYcswYQ27uMKDZED+VxT8ryUseMj4dgnS3YtxM=
X-Gm-Gg: AfdE7cm4UbHUrfdSfi5gMO5oWbQMxW7qtdZjXLyyJ9+u96BFlnpIG0/XnF9R1QKzK1L
	4SxiPCG5z5GR7WEBC/Tyd+zlxmPr8rHiDo1xq1FDARlRXxMcRCFbH2AuFnS5PXED0TyB4Bp8Npt
	tHa6TrNfo02e+C49nfeHXrtpZKVSGLkRYCgGCslkqFv1G5KeMZDWyacgu18FcVY6hNaQ0ac6D+h
	pT/z6DCsV9NRWkp68a8EQ64KQ0SRsD+oeTD2JSbT7kKR0E7YQ2654Jb7uphVbVfskehsBRJS1FG
	ARXKGNpsc3K/mePG0HCu0z2alwBzahMwGPcM+lWJLec2P1IlswUtVWvrxY0PrrkeC7/u+0ZZDFs
	Ag3chvFCgAmxfiENGzKBd1FSyFrOQezTsmgVWZcm6X/QK7lN6CRgDO6Z4u6MPXGafIktRh/iCNT
	YzMC0Az+imeyKZYjc4QjliLkhE0MQVAHnBibN4cz+nm+bI8jHcVfxJIJD0lnbVo1vpuP57ZAHGA
	g==
X-Received: by 2002:a05:620a:4082:b0:92e:59b0:df08 with SMTP id af79cd13be357-930b3ec7086mr1655803085a.3.1784576170762;
        Mon, 20 Jul 2026 12:36:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:10 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 35/36] KVM: guest_memfd: bind backing memory to a NUMA node at creation
Date: Mon, 20 Jul 2026 15:34:29 -0400
Message-ID: <20260720193431.3841992-36-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

guest_memfd presently allocates its page-cache folios through a
per-inode shared mempolicy (kvm_gmem_get_folio()).

Today that policy can only be set after the fact, via mbind() on
a host mmap of the fd. This requires the fd to be mmap-able and
cannot reach folios that are only ever guest-faulted (no host VMA).

Neither holds for a non-mappable (confidential) guest_memfd.

Add GUEST_MEMFD_FLAG_BIND_NODE.

When set, KVM builds an MPOL_BIND policy for the requested node and
installs it over the whole inode's shared policy, so every folio
is allocated on the requested node with no userspace mbind().

The flag is advertised through KVM_CAP_GUEST_MEMFD_FLAGS only when
CONFIG_NUMA is enabled.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-8
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  5 ++++-
 virt/kvm/guest_memfd.c   | 39 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d31..f6448a73d464c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -739,6 +739,9 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		flags |= GUEST_MEMFD_FLAG_BIND_NODE;
+
 	return flags;
 }
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8e..a8ff150e2cbb7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1654,11 +1654,14 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_BIND_NODE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__u32 node;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f0e5da4908660..de320df08e0ff 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -456,6 +456,26 @@ static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
 	 */
 	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
 }
+
+static int kvm_gmem_bind_node(struct inode *inode, int node)
+{
+	struct mempolicy *pol;
+	int err;
+
+	pol = mpol_bind_node(node);
+	if (IS_ERR(pol))
+		return PTR_ERR(pol);
+
+	err = mpol_set_shared_policy_range(&GMEM_I(inode)->policy, 0,
+					  MAX_LFS_FILESIZE >> PAGE_SHIFT, pol);
+	mpol_put(pol);
+	return err;
+}
+#else
+static int kvm_gmem_bind_node(struct inode *inode, int node)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_NUMA */
 
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
@@ -557,7 +577,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int node)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -598,6 +618,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	GMEM_I(inode)->flags = flags;
 
+	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
+		err = kvm_gmem_bind_node(inode, node);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -630,6 +656,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
+	int node = NUMA_NO_NODE;
 
 	if (flags & ~kvm_gmem_get_supported_flags(kvm))
 		return -EINVAL;
@@ -637,7 +664,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
+		if (args->pad || args->node >= MAX_NUMNODES)
+			return -EINVAL;
+		node = args->node;
+	} else if (args->node || args->pad) {
+		return -EINVAL;
+	}
+
+	return __kvm_gmem_create(kvm, size, flags, node);
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-- 
2.53.0-Meta

