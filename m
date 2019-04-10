From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: [PATCH 0/1] cgroup: Fix low cpu usage with high throttling by removing slice expiration
Date: Wed, 10 Apr 2019 17:20:49 -0500
Message-ID: <1554934850-7002-1-git-send-email-chiluk+linux@indeed.com>
References: <CAC=E7cV_2QtXQ-mx4-GfHLyAWxW+7Ub75UmMvOLxLXzot47TWw@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=jt+tlrlxq1U99mUFvJJ0Clgx8Lqjonh9gtRs1JZIcgo=;
        b=BTGUiLPEhvIkVNwbVz1FOvJqbxiUmqLK+F38mxsYWq2yoiPTu7AW8BAhc04MUfklVk
         1e6fv0zScY2voVzys1UHN0Po9AHABPU8TWL2dH8PZUVCSOPjaJPtV2d3VDxSdj8dmdPt
         z7fmwdZZGTUeomGxRYAPUChDDglRb2RnCOKxA=
In-Reply-To: <CAC=E7cV_2QtXQ-mx4-GfHLyAWxW+7Ub75UmMvOLxLXzot47TWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>


The following patch is an implementation of option 2 from my earlier e-mail.
Option #2 was the removal of all runtime_expires and related slice expiration
logic.

This is a very early iteration of this patch, and testing/comments are very
appreciated.

Thanks,
Dave.
