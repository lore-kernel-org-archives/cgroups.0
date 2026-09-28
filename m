Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9BD3ACA7A
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 06:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576090; cv=none; b=lWwnSIdDqfuh6R6AsdArLN2BjlWzdA+IqoVOAFHWnvpiYnYADO+Cgjd9oTmE85fpEViMCud/qmNO3EQL9fHDEtEbLkQ7PxWMUY7WRbyWZ3RfzUgDyLJrtLlzo/FuxM5gI+Tu/1t3GXcPh1nE/WIpnniqYZ0gKgg4Pvkk6CH2/28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576090; c=relaxed/simple;
	bh=yGo84h1q5k7DqGwFtapqM3KeulWARXvoAl3BUIovgJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsPA6/Z7OJ3I5k39zVHcgRB4WmpNxozhMwaC6MkKGxAeKxsf4p4igUYLJ5vgx26N3Sh3Ngmg8N1qYWd9o3l0W3UqyXRnESZOAVj23xuT+01JBbSc6riFDIIb7zeChHRLmK6fGsr8a34jLfSuq7R5ho3yqpcmSZy7WGn7nFSc78A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YCnhyY93; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YCnhyY93"
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0aa9d356eso2105916a91.0
        for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 23:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790576065; x=1791180865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=enVf1SyIQ9oZvAJl5nReVDRZKns+mfLkqH0FfDFTL44=;
        b=YCnhyY93JpbW0Ue1tSIvHG6EbBfLXvg9uXIIzPXq9H997b5HjM+b5XTDe8Y5EUxJ/9
         m8++dvn9QoQu1KNlW/XQH9iKFSjF4fzWHXUmAtY3OnJ3xsYekVXVi0mgX/tYC8TLjZOf
         +AUOlNlXvK8RrU9BgKc11zMGFfm62iSR4cxL9BMp8r/ipaVgBNH97ormakWsk8Hr/hfs
         13z7g7B+GtI2QZP7gox5ClaZr1dOrlAY7Do01ygHx4Bt7SdHEHyyTG91F9vj+TZrLxn6
         b5lNmSVMCym6h20rEkPzeqiSFgDc7fiR2kBp353UcIWL/4/qSYWkDJXS6yYxnCxMnAsc
         YKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576065; x=1791180865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=enVf1SyIQ9oZvAJl5nReVDRZKns+mfLkqH0FfDFTL44=;
        b=Pbz3M1ZvgkuBY720dm6r16RQdl5e8oO/GU9XURueuSbDzGFvg+iEa5n1r1xCeCnXxV
         A/mB4Ty+iv4NRjZgrJ6CQpDHmipEsPRj/XFgCwtpf6CIQ/GhjUP8Z+BOm3mevZfHN3JM
         GAusUWZhJJFimXUVcymtveoH9KyQ4lLWq4e7F5Y3HffujBzoHcg2rP8Qg433i34eMcbd
         5zdKO5FKEMAuT/ypKaM6+A7ADPtil2pJRRSEcvVlVnM+YtmcwU3yignjIVVAPhpWsyNw
         LXPo2C2g/PNzJm4wFoBd6ZIHDt43QqWnHMHKxWcTULZSXczXafNQ5h2aUXqP11NcWlyw
         BWeg==
X-Forwarded-Encrypted: i=1; AKwUvBz+PGLXEa7/JFe7F/6v5DyhwQmnN0e6gTFv1OEJXNJHOL1EWGjzebMtymlyZHz1PS5E5L532GrS@vger.kernel.org
X-Gm-Message-State: AFq9FYIDQh9Um7G+veLce4wrU8VvdkMH8BJPs6fXyrKszj+8jSxL1BdE
	+Mm1Cqbo9sCcGy/njjUfTX6HhNIjCQtPyIXWHCSLZY0HBmrqmoFn/RBf
X-Gm-Gg: AYBFou3McmYkAwM2wCA7YFTgaLiUq20gOvxwguuFFFjmIXz+qJEHo7SOVOfRhb7WweZ
	+AJdlcKPzepfQLCSEXPqyFGvKEMw5DOVas9CPssZyILVYpkpuYmZpSUUKbkKG2h42r0YlkY5mtQ
	I6wNcPwyClgkj2Jd17S/Ku/pJbNyMf3NUHms0pyiOvLm5uL2g2nky5OGiZoHGT2etSSwiisPVTw
	2VCU4i05/3TqO6g17uZxSYjlW/cf/JpUaJ9z2o+thmBiZF1xggaZMMy9Nn2GOq1g2ARPX4oXckw
	ToQoSin2B8OPCLpdQxE3sKBxeS9qr6ePUhoZ9cf6YIHBtKSYLXaHfl5BsUT+pGkPr/dWMnvOyGB
	UrQwrWF9DMmlrOsFPfOwk5n5kOys4h0QJa3yU8w/y425rQNmJiy36S38nZJedfu+mmXQZ5kjCUX
	J+1pxQgI3n+qz6PwRQ7etV+T87kwbvurDabgNgedXjHwisDFZxItrBLO+wA4ZF8aWexFZCaWnLy
	UHE36xIXjuYcpsvGXNSAZ0a7BmjAxpIZX1vhcV4z/DbK0wcLCG6ZBhxR8Gv7/zgEyeenMZ1a2T4
	tmg=
X-Received: by 2002:a17:90b:4c03:b0:39e:6a82:afd6 with SMTP id 98e67ed59e1d1-3a098feb5abmr10108909a91.40.1790576064881;
        Sun, 27 Sep 2026 23:14:24 -0700 (PDT)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9892dbfsm18864088a91.11.2026.09.27.23.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 23:14:24 -0700 (PDT)
From: Peng Yu <yupeng0921@gmail.com>
To: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Peng Yu <yupeng0921@gmail.com>
Subject: [PATCH v6 2/3] cgroup: export cgroup_e_css()
Date: Sun, 27 Sep 2026 23:14:16 -0700
Message-ID: <20260928061417.1574676-3-yupeng0921@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928061417.1574676-1-yupeng0921@gmail.com>
References: <20260928061417.1574676-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nvmet invokes the cgroup_e_css for each bio and under
the rcu protection.

Signed-off-by: Peng Yu <yupeng0921@gmail.com>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Assisted-by: Claude:claude-opus-5-5 [Claude Code]
---
 kernel/cgroup/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 69b0f0cf2f3e..5a1708ed6b23 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -554,6 +554,7 @@ struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	return rcu_dereference_check(cgrp->e_css[ss->id],
 				     lockdep_is_held(&cgroup_mutex));
 }
+EXPORT_SYMBOL_GPL(cgroup_e_css);
 
 /**
  * cgroup_get_e_css - get a cgroup's effective css for the specified subsystem
-- 
2.53.0

