Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F673E2754
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338712; cv=none; b=sXdCLUzp3B2/W2OjTcWJ/rcRKZBOCZMK4ykIEgVdVBhWD4njYUwvO2dA8q1iqpWYdb9cerg4n+ClbVBiGL3ElDgv+PYwbyknfpXjrPGkrRCWznfduD37KWTF+CztQYhFybrei42xTEBVRHKoGBCZZNiVZ1Mq4F6uK67wDTNgq5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338712; c=relaxed/simple;
	bh=rkPzVVDgoOEfaKV2nREKbkjAXfc0pbvyd/oIWLflpYE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o+rQ/jPWTRvzWweJ2gVsRJeA2ILupAPu+Tq+OyMzSEb4YcBNYENinxXynsjyUeEB4qFySsGMZEIPyS7joYOe5hWWWvfzGkEyPeItxIwMKpB1pt0FQ7ZSoC5P+4VUwX63xfgIep9l/fYAV3nItUZavuz2jt2ZFjcpIy0A48f/Ux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=huhKudR5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rxlCG2kq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="huhKudR5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rxlCG2kq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8joInrEG3wyxgyxVErJ5zORrPbi9GYjPiUJzUhqISA=;
	b=huhKudR5sNOHrDNbmXudXqA3O8wBP1P1J6YuUdiK3sVXvHHxx7SV5352pi+99G01S7i9HE
	o+mTZxXDirSkOTKHFd+649VSOWzm5cfGd1CBH92Nm1Abp7wi2WCe0SJ9JPfxb26IZF/SrU
	RpOpAy8AX/QYGwPlnUTOGuIUxWg3E28=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-cVKkCoMAN6Ch_Y4_Rfqx2Q-1; Fri, 21 Aug 2026 14:58:17 -0400
X-MC-Unique: cVKkCoMAN6Ch_Y4_Rfqx2Q-1
X-Mimecast-MFC-AGG-ID: cVKkCoMAN6Ch_Y4_Rfqx2Q_1787338697
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8eeba1d9e47so9186016d6.2
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338697; x=1787943497; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/8joInrEG3wyxgyxVErJ5zORrPbi9GYjPiUJzUhqISA=;
        b=rxlCG2kqriWBMcgab2d3GVQ2Te0Knk3Gk4AHZpf0049aZuDbpX0tXN239B8k7QTrqf
         iUaUtwvyPYN9SDqseT28lrdjCReapuR89ef8EWveh8gf+P4A4HhjwpVuuoI0jfRLcWZH
         rYuCF/eh/pEk+Bh+a3g3VmCdp4cf7wAqOBoNF0Lae4Y765+br/2ZntD1Br8pvineUH82
         Wvk9lHF5TCtAJYcNB6ofA4I/aukQMANFbZ0YKPY/uZ+GKlcwT4TBeJC5B5zzLyDQHF/C
         zB/f72Q1qqGRI5/FZyI2qKM5tb98p4fOoZo2lHutQ+Q3byGFmJJQsD7JSR45gfqRa3CS
         9yJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338697; x=1787943497;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/8joInrEG3wyxgyxVErJ5zORrPbi9GYjPiUJzUhqISA=;
        b=ddfzuKeeNqD2Hmh2zf1mleW6o2t25mQaYiYXC6n2j3ptObB9hUH/8HPpWy5xMc+c4W
         iYNPryRgU5m3XKV1gHUV7N/YC3WwNmLPJLp+zqa7cRQkQymqspxNYwvnBNxonhSG7D/k
         eau5tsMpUHev/wxASWOv3HAuyTdxqzudSn9ZUSHRuu+ULBLaivpywCrGzkEizaCo13SM
         RolN5dN044yg+7Aol8n3baH2BQjrTOmeAktsn/fXXbG3yxiXwM9F4jD6pC6tOi47or+V
         oCjBoKkxUJzmLOPYzz1RUc7S0mI52Fc3zCjp/PJKyXbyMZ0Skxlla3pX/uqflQH9pBDG
         nlxg==
X-Forwarded-Encrypted: i=1; AHgh+Ro3MhfkamfxJcM0YeeqimS7ixxMJfvNNkoc5CZ1K19cYVPRXk+yL9dDQDrPEG4dtl7VTlJqy5wf@vger.kernel.org
X-Gm-Message-State: AFuF++nE1Kx57XOfb7oJBafVCPInIA1mp2AaInol9ZK5dFb56LvJbFGj
	gGAreACEeLq9efHmPZMsT6QeipBDtkqVk8Bhx2QoZte0d/sVOxMILnRW1v4Ttl7bXjZo3DBc+cy
	JVwl/trCJj2iaxtwHaJ88weXC9vs71Cq8/boFhh0aUVQxi9iwtaLXw1QtV60=
X-Gm-Gg: AR+sD12CGjeIDlSTk9y+KLjT8Hj/7LY/2FAnyjzrWmrNxEMQB5ZEbLccuTJc/DVbkmI
	1XgAntRFKrQ19nd7bmZSgn9n91kMWYsXIaNcwoDCLeh8ACR3zZzPu9/FEMcDw6kKdT7WkVbiojP
	wkMFA97GjXavsZ4ecdygLlZOx5l56ePCgS5EjCjsi6t2O8JU8N7WM0+0Nr+sw8M175wmFzkCA8N
	a1BXDEzPvmcvUAVEBsxjY/JEoVZEdDbSH8dYgOctXpAB/40IdCsm8jEj/4E20WlOH2BSsw1pUOq
	Q+XTSfsJ6GEYu8N4zUdxp/BhEF+1B4uKdiFTMM1pcnq/DoGtbwr1cdxvE6kYnbxEGW5IXPUHuv+
	GhyGkAoc3lTxB8D/qBY514u8ZznvsCNq6T6lvpgvTsvIC
X-Received: by 2002:a05:6214:21cb:b0:8f3:cf36:15ca with SMTP id 6a1803df08f44-90c8098e804mr82074696d6.9.1787338697312;
        Fri, 21 Aug 2026 11:58:17 -0700 (PDT)
X-Received: by 2002:a05:6214:21cb:b0:8f3:cf36:15ca with SMTP id 6a1803df08f44-90c8098e804mr82074206d6.9.1787338696872;
        Fri, 21 Aug 2026 11:58:16 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2905d6sm68917236d6.29.2026.08.21.11.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:16 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:03 -0400
Subject: [PATCH 11/11] selftests: cgroup: amend vmtest-memcg to run the
 hugetlb cma tests
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cma-memcg-regions-v1-11-d21b165b8440@redhat.com>
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

Add HUGETLBFS to the selftest configuration. Amend the vmtest script to
pass hugetlb_cma=1G and hugetlb_cma_only=1. In order for hugepages to be
available, ask qemu for 3G of memory so the CMA reservation succeeds.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/config          | 1 +
 tools/testing/selftests/cgroup/vmtest-memcg.sh | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index c4f7df4f1b24..1c9034017682 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -8,3 +8,4 @@ CONFIG_CMA=y
 CONFIG_DMA_CMA=y
 CONFIG_DMABUF_HEAPS=y
 CONFIG_DMABUF_HEAPS_CMA=y
+CONFIG_HUGETLBFS=y
diff --git a/tools/testing/selftests/cgroup/vmtest-memcg.sh b/tools/testing/selftests/cgroup/vmtest-memcg.sh
index b19b96731784..534a95ef5e07 100755
--- a/tools/testing/selftests/cgroup/vmtest-memcg.sh
+++ b/tools/testing/selftests/cgroup/vmtest-memcg.sh
@@ -116,7 +116,8 @@ vm_start() {
 		--qemu="$(command -v "$QEMU")" \
 		--user root \
 		--ssh "$SSH_GUEST_PORT" \
-		--append "cma=64M" \
+		--memory 3G \
+		--append "cma=64M hugetlb_cma=1G hugetlb_cma_only=1" \
 		--rw &>"$logfile" &
 
 	local vng_pid=$!

-- 
2.53.0

