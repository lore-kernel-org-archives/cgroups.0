Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F220397321
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338691; cv=none; b=ufhoBdzaw051zQpERSth+qhS9JN3/ofp8lNjsAxb6wbUgYyn29kj5SxgP4QAA4rhEMksTmxuydkVd5ans3ksZtVdgrOSOnuGKLeQupjhsmTDuekrkM/rxMvc/FcWgVFVqncgNJBmrh//mWLDb+FW+KN5lCy0HswjSAe0phr4BeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338691; c=relaxed/simple;
	bh=nUrrX6fvJ8xXWDGBUO+9oVkzQeBBL3WL+YrpDDcGXjk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IXs0BXFfMcSAauZiW1wKAyOS+yaAx+Df+IzajKOjYGOhT3p8ssy1LVYRJJGu24GOktPOb5qsPj2kdK/cu1guPWl2OlOF6q8r+2K0GsurRB/6Y8Pmos2UVGQSAn6Bvlq1jplHa4xQx/KDu2vazteiLcX4rmbv1lpaFx5PGz2l0Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzEWO/Tw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RqbbnNPr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzEWO/Tw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RqbbnNPr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/jSTYPb5+iqfnKrVpM0EYbQbnYNP4KDzbEmhzVmVac=;
	b=WzEWO/Tw76GRudJ95zTyQrd5kr+1XokUgMqRsJlk40AYhmkn3m1rkrRya1XUYEp82bNY5g
	QnD8WXlTppQtgOuLp2oqfKIOU+4Ls3pWV2kssfImTwqGqLQpSMAUhXi67XUBlPbS2E0ZWv
	ceV+MW7qSPv1R/aGsCmvyzTnv0urRMQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-vhIhXXeiMGu4CaSVMXGrMg-1; Fri, 21 Aug 2026 14:58:07 -0400
X-MC-Unique: vhIhXXeiMGu4CaSVMXGrMg-1
X-Mimecast-MFC-AGG-ID: vhIhXXeiMGu4CaSVMXGrMg_1787338687
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51bf321d786so12354601cf.1
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338687; x=1787943487; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G/jSTYPb5+iqfnKrVpM0EYbQbnYNP4KDzbEmhzVmVac=;
        b=RqbbnNPrQpdUFOXnIcCmfqjz78gnIKTFTulla98SVS9yyqQxUD+SM6fPZaUyyNcEt2
         iqN12iiMW+l70aZPA+NRYVdTAQvajKeLjy+k7J7HcgxgmTiYjVLY8FAC4TOQsdaGYDZ1
         0fH1HA4vLr16P5bAqXeV8qgN3NGcEywgi7MTJ3IF15bj4Eck+ZBTgMkE8ds2AZ1fL2A5
         VhxfseF5rsEksM7BC9+W2OZAypaf3axoW5Sa4L+Zz9bUkqOJyBTGywWfYvVGnOPkhY48
         cJvq/SxzlwPXAZxHxU7aJJZnSlU83/8tRUfGVjBQD6YyvpfzMQlfmlIKq+ixBawMPVCe
         /z+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338687; x=1787943487;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/jSTYPb5+iqfnKrVpM0EYbQbnYNP4KDzbEmhzVmVac=;
        b=miRFLsnZeA6xasOTyLV3BYO66mkcG/5Y7Olvmj05OmHQdAT5smMyZ/h/QGptb7QBxx
         X6nFpBGgldKQdNp31e2vjl4LP4KXuGbNq0kD+60V1caU7GrXHeABLl8UJUUHU/O5CU2I
         R3150Zs1UnTVdxl6VenzpchJ0fj66TeXKYjDXmsKg3+u+HhLZJyvaJ4wXj4+/QBrqnQi
         QilFoeQckZvSLZt0n9CXr3u4VojIkPYHYNaciQU2pDa2oTG6Rq+ao0z737DySoxPGPAN
         3ayRfbNGN6PQyqzbYbA+kAsIO4lm92EM8DyzCDNAByh55ZFJhXn7Eta2vvsccGfHUoGP
         v58g==
X-Forwarded-Encrypted: i=1; AHgh+Rro2K38e7EaZR2SGqsDEKq6AhyBYdOHBKTfLDDRKefkaX7qUNOUUceA8tYWg6c3zpLwT6X61ljZ@vger.kernel.org
X-Gm-Message-State: AFuF++nbwglHhAFOgH9bBYO41Vg6IeOJQ9/z7XYzlh5QDdzKdKjKShNq
	VwS7ZhNCePBM5ZwTcTbhhEhEHc4063btyZdqzVn/hj1WwOA9yU390UYAOEwQZNrcgnfpk0ghfUP
	5QEVLDFtOPM5POzTOyATqZhj9eo2SzDHfu5YrXX0mnKAc6Xy3hEOvB0hBtZ0=
X-Gm-Gg: AR+sD107UCCp4zPIo/9XglaVSmKNlmg8jxlgGAMZcL/0zg5r+G0u8sytRS3ZHQxKO55
	SgIZrxR/JzmOkBwolUqvltqyaCBQNAeyfnWOI+CdXcgi83nppu5FqPGgAKfNY4iBMEFD9xDW/9c
	0cMKBgCJjeSrhp7mma6F8V+rS00/yW68kJfgPGjJHe/P8LLaYMv/RlFl5DxrjD7cZglNEZ7cq7C
	iJvkroYe9Iq5AyAPD1mVCK48b+BcJQjkn5jx/6BMGAOf/sltTIugbmJKg3wdXz3Xvq5hupOEq3I
	7FWmo4mGNkmhj/XibpYo06r01Zi+Cxy+RG9GqjXd8SQKv/rdaU9FiQ35kKsWzvVuKuWK0VDN5vm
	vuMU42BeTOweHVahwHGmgAiXUOtiR7KHX7dnz9Rqv0Jx5
X-Received: by 2002:a05:622a:1353:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-52df5a08383mr81012301cf.25.1787338687121;
        Fri, 21 Aug 2026 11:58:07 -0700 (PDT)
X-Received: by 2002:a05:622a:1353:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-52df5a08383mr81011751cf.25.1787338686645;
        Fri, 21 Aug 2026 11:58:06 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e099a8331sm1163531cf.9.2026.08.21.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:05 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:59 -0400
Subject: [PATCH 07/11] selftests: cgroup: add cma configs for cgroup
 selftest suite
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cma-memcg-regions-v1-7-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3

Enable CMA and the dma-buf CMA heap. The CMA memcg tests will use the
dma-buf heap to allocate in the CMA and exercise the charge/uncharge
accounting.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/config | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..c4f7df4f1b24 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_CMA=y
+CONFIG_DMA_CMA=y
+CONFIG_DMABUF_HEAPS=y
+CONFIG_DMABUF_HEAPS_CMA=y

-- 
2.53.0

