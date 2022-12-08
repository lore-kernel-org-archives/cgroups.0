From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] blk-cgroup: Fix typo in comment
Date: Thu, 08 Dec 2022 09:20:13 -0700
Message-ID: <167051641300.134647.14873607646556634784.b4-ty@kernel.dk>
References: <20221206093307.378249-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rgqBZ3uFNI/h6T8HpUKkmoQedKjgYsWFROeZ8YebM4=;
        b=vqBtQLqW+3MVCuOlb6qXeONN9af1mNtua+frx9RZmop1vht1R/RvkDRCPWV4UpgcdI
         wM3J1ua5XNHyWSunTTkdCvZiReucRWu8u+N6Bx1L9mlXLC6yFuuQtIdR4ez+VDBMZvFj
         om422svafQlJ+atSNFNXBEjfDWBsSm/XMYQvmUSw+GItcNCcxmvF3jsiEeFdLZOOgm2h
         5bGl92+9PVAK9yfiQ8z1UtSju8kg/reXrvTrIimAgyFpG/k4rsBNMH4IWvonGwbxQKzx
         eUICFsZqtRmmswI3ZBbPaEP9LlvfEqdC/u0HAGt4SnZJtCykAFQ+QU745Y763IGg20DV
         tWXw==
In-Reply-To: <20221206093307.378249-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, Kemeng Shi <shikemeng@huaweicloud.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang26@huawei.com


On Tue, 06 Dec 2022 17:33:07 +0800, Kemeng Shi wrote:
> Replace assocating with associating.
> Replace intiailized with initialized.
> 
> 

Applied, thanks!

[1/1] blk-cgroup: Fix typo in comment
      commit: 37754595e94779db869e6ef803f038fa956d08ff

Best regards,
-- 
Jens Axboe


