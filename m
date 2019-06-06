From: Christoph Hellwig <hch@lst.de>
Subject: blk-cgroup cleanups
Date: Thu,  6 Jun 2019 12:26:18 +0200
Message-ID: <20190606102624.3847-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q4DI0TxjJulybTNuYmEqPyem4/mI+9Yg8Jh1qLDvwK4=; b=H2hUvq+nyaYp6S4MTr90JVR+1
        B8EgOOul3RJx6BFSYrr8aBDMo9szU9kjAmcGHfG+wxVvnCbT02v8AQQLoG4iwKPm87ClXsLQMMD6y
        nxpVcyw7J22nrTRm+2IogmsZSKK3toOOlrylSdrNnpqzdEAfHAVWqaf/QdXB/S4Z8j/U5gq+UsVJF
        uuU+3HvJRTJz22nZFqlvDPzSzpQqO1k8yOzt0WIYOXurnoiJqSDgmmxuyUoUeraTI/rv5+92Xkg81
        IvAW/L5n/dLOzRjvJ0p+i/NI35LYrtYpxHNwxevnI1+FaW6EbzKsdj0TQoLhiN4GRl3DQAKg2VQck
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi all,

below are a couple of cleanups I came up with when trying to understand
the blk-cgroup code.
