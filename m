Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795347541;
	b=pdkvSrXydk7wbzbdsEMB/u2ay7tsDBa8zjkXbAvpUG+7qnHrMRrRe5IYY+PJPjEgj9cM
	 0/v7Czc/gyJlhdSPTffbxoX7TaMBeluZ2/CdUmhAHqEWhXkuFwlV8aMCUYjuetqlORTY+
	 8jl+4vNDL5lBgOKjnKFaNUtT8bKrGFN4UM6vWq51lk3R2pHNCneeDFxd1howTLb4yk9/D
	 0kEy3B8D8k733YJbaL61dbYRL/qQtHBw98lqF4ziiCuM8c4G1o9r7Pb1yKhIgKTDHVm6M
	 BW+RcEh7IQn3FizEYZWmfeRt4PVmTUvPPlmGugAsVS2ry3ffJ1ULUsrJUa3vKZacgnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795347541;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9SL2nw3BljIJfL2BNxy4TtTwunpxe4OhPHoB+8Eji+8=;
	b=ycDw46hEGl4YiNb84Z36ZuIYXtEofngj/iRd2ACAbfLfQRniYGQZtzACg+9C6Cm2Zbql
	 7CE9M3SfuWPDj/Vcnm29Z+WjICV6VZQoEQuZFQIU5ehQCH+BNEjQHqXgzgnBjUyvkw5RP
	 fmcOAyKX/cfqvu2w8aR9QqkFxoWC2bDdVlz8bKUtctAWzqy2SZMI/i71YqJwJhvNb7HEG
	 pVUGtv6cG0vjsh4+NhnOc4qcu3Vm6qvNmfOk7GkfaUa5u/9bMe2/Xeqtj3+Uz8hwqs5rM
	 TrDLuMN5mgJUWy+wtv6bjGIYjqJidKr0NUdCvHARl2rBwXCwGYpi9DqcbV52U1wu8qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xWH39Jbp;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B636D606A330
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 11:39:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B636D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xWH39Jbp
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-33fb4680717so6667359eec.1
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 03:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795347540; x=1795952340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9SL2nw3BljIJfL2BNxy4TtTwunpxe4OhPHoB+8Eji+8=;
        b=xWH39JbpK+tCheqveo2u87AQgq0TnNUTvJnMZWpxRBFIlKxzsEJJc0OCsjeXDFd/Rt
         8r2t45ifgCg8vHXxBmEn6LGP+C7AcPS13+4mRxdWPaBivAKml0DlftZOdDlin+l9bTCi
         +SDVrJ5UL6FBmF0XE+CLbRFyWoYG7wFwdoIiNaxldrUJl5F0VzDOkTW8aInFIK0tjurH
         dy77usrjTK1GFy1mCLsmeN2cOt2dLUoIQfbDibM6pAZ0jM/GyNTMRl9YBtHUBR0bqiSl
         RnYS3kHMqPY4+j/rYH/gtt6AFODiGfwRIzD/ZBd/dX2PrbrHI0PO+IC/073wauJTK+zh
         QLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795347540; x=1795952340;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9SL2nw3BljIJfL2BNxy4TtTwunpxe4OhPHoB+8Eji+8=;
        b=mzvO6JT1QvEprttmFmtMqzK5uKG0l64mqV86NcMzyWqxg4azmeV99pB7BQ5RLVWviq
         sThlLkf1e0b2z0eZTKTsovDoSaiI2V0G8l5E6oTQtQ2nz+9rODGg1kq10C1GM2WBZFJY
         vl1WxJpUa+5Xh4uP4KhIOSBj/Dr+45nAEegUui7+cv7MDMB0MXuZ7Se2lAFPU3Te6RZm
         XsOo0sIiCTcO12VuFLYOYqiOeCm2/SadwxlrFESkOculo0T7QEHrrvu/Yp0MDxoE0kf2
         rvXPTyc6ZA5UHTpswCy5NNiVo2Og2fiVpOkDb9YP66I+3esh1LJvTPp/NWCkv44C52Xz
         KVzQ==
X-Forwarded-Encrypted: i=1; AL+hErGdj5S3L+dcmEJGGyCfeGgnc1GtYm2RDZZ2NXEKqKg+QQmc2rEKZVmySr0fKQEpeHwLOK4RjoLV@vger.kernel.org
X-Gm-Message-State: APuU4Z8csVssU6s9q7mP/UcBTlW0nqbvLB/gZtwa0p8zYRPrQoEIhzo/
	lIxhnG/BP+iijf88AyNHrUE0jlOO5LHfSH5dWmHz1SqCHiP1D8uB2brE
X-Gm-Gg: AZFdTZcbHTH1QvT5C6sG0v9C9reXdNAEL9Xnz82kcvFS9B1ZRFsx5zn9LXEjlXp17SG
	N+cMQxeyWyN5UBRjFzRT4Eko8My9DD9D57Dv7m+ckwZDWrtD1on+cac/3yI2NUE7EfLYskIkbhh
	aJ79/A01GnNyhkUNZBj6m/TjZvmBI9jDfqK9SQqkVXt9HoLFl3UJHiKaOVkbOuEhhk9WFUixjxo
	SH9q4theqdzOYTSoW5WtDOS2dAVOs1XVvV0SIbgqwhxTjZIBLqbq/wBId2KuosDi9jmkbhKCYfe
	P/l0c5/2BXcP7tAbTEx1I6gr6PKYpFyfpyxbZK2dDcKD9l9QF/2j8fKBI6/JiXoeBVfYcpIY5vR
	U40muF1QHUHoIb3cbKAPcpdj3i0XbR0MmPB93UzRInl1QJnQqBebQbHUha66QylFN2RCpBJ9p30
	Bj+6+7wbbrx5CIGu7xeXfvkDDlSOB+RHaPlBf6XWNIVIShGxfsH2kA9SX57uMVYJA5ynsGLyTry
	YomIVB3W3422Iozaudv1lSq2rP8NM7U7qpDmT5xYGsmqvfbwTe5Pjl29Mx7ei5L6JtuqxrOlKLL
	V3P8irpdr8oUa4GLWRrDOEhIDJ6Qo9fRmL85v4wWXhJKEyWgJlfhmt4kQQyDeEukgVHj
X-Received: by 2002:a05:7022:f509:b0:1b3:ad88:b9c5 with SMTP id a92af1059eb24-1b5568b7e07mr8368775c88.24.1795347539687;
        Sun, 22 Nov 2026 03:38:59 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386aaae4960sm3717851eec.18.2026.11.22.03.38.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 03:38:59 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: wang =?utf-8?q?lian=EF=BC=88ByteDance=EF=BC=89?= <lianux.mm@gmail.com>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Sun, 22 Nov 2026 19:38:17 +0800
Message-ID: <20261122113833.62817-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: wang lian（ByteDance） <lianux.mm@gmail.com>

Hi Kairui,

On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote:
> - Rebased onto current mm-new.

The v5 build checks on x86_64 passed without issues.
I'll continue to report results from additional tests and workloads.

So feel free to add:

Tested-by: wang lian（ByteDance） <lianux.mm@gmail.com>

Thanks,
Lian
