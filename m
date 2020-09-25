From: Christoph Hellwig <hch@lst.de>
Subject: RFC: sort out get_gendisk abuses
Date: Fri, 25 Sep 2020 18:14:45 +0200
Message-ID: <20200925161447.1486883-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Y2wH4RuuuVJ7MQ/4jAkTQlQ8pcaD870YXfRn/rEdzlM=; b=SLodffWn1lQtoi5MM/yWwKew1R
        MTEG36QLz4sz4acbWW05Ij1EEUpGF15Wk6lyQ984odhtMINUxwiu5MwQKHpqtKXpu98MPoha8Sd2/
        xhw2YUWpTnZFrPBQ9+bwSA/sMjCTVoIa06CD92ZuRVsEcnz9OUNdaOL/eF8HAIQFkxf1WNvuZPszV
        7oXxZzM6RX2u67NWZSfg1pgjzPVy4D91QKIawJAP3v/lO7jYfTF8mnjN+o4BrhKgI32qxLmYjh2bH
        n3k9L0rQ0w6r7nN652Ste7tORJKiS5TgOgxma13HGDwPxmwtkL0YJHMjVWocYuU9WGqz1Tvo5o9vh
        dczfcGJA==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Minho Ban <mhban@samsung.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org

Hi all,

this series tries to remove two abuses of the get_gendisk API.
The first one is fairly straigt forward and switched the blk-cgroup
configuration API to properly open the block device, but I'd love to see
it reviewed and tested by the cgroup maintainers, as I don't really know
how this code is actually used.

The other one in the hibernation code really puzzles me - it busy loops
on the gendisk lookup, just to leak a reference when it finally succeeds
and then doesn't actually do anything with the result.  My proposal for
now is to simply revert the offending change, but better proposals are
welcome.
