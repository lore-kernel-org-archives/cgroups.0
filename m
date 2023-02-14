From: Christoph Hellwig <hch@lst.de>
Subject: revert blk-cgroup changs
Date: Tue, 14 Feb 2023 19:33:03 +0100
Message-ID: <20230214183308.1658775-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=kWj+QDtOKr8glFIwA9Ck7BAHXoUxqGc38pTRMscjd4M=; b=DXDNex9bH48IWfe6v7z2dGe8Xi
        tw7kBJqf94FGe8wW7OKdBLsO8MCOtgpbM/Uiarul/joEQxghyHKaGcnQU7QKGkkPfWKdYUFzvkukj
        bHJxBCJ7c72D+Nis1OX3gbP8Ghnem6iJQaTkMbKIQc7Q10RXl+M70JfE6rwhMjgQMinkF2+BKmlLt
        dxw5eQ00TvtNrI+5v1g32Xdd8VQUTuPAjqPhbfWaB1Gp54DyYqPAptyHCFLbRIBdMOHkB9dYzTqPk
        46qImg0ka5zW1JLJBUqgHRh2OPaFL/nXEw4AZS8i+StgcRr186SwKmUGWnMjP1G5bA1ynr6OonGX5
        KoFRQ88A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

Hi Jens,

this series reverts a bunch of blk-cgroup patches as one of them
caused a problem for which the time is running out to fix for this
merge window
