From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Use kvmalloc in cgroups-v1
Date: Wed, 7 Aug 2019 11:40:50 -0700
Message-ID: <20190807184050.GO136335@devbig004.ftw2.facebook.com>
References: <20190806132412.92945-1-marc@koderer.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G/k7GjX7actKY3ZvBhXdU3H/Qr3MiRhENkA6l010uvs=;
        b=LYvjXlm2BFEjDPmfW8e/+v5eAaXWtqMFvTIXCTr/2Dcj3s8L/diONyZq6DkHlabtdB
         tlSCUvvAl0aErFOwrmUS/ojOMX+xf35thBmmsjwWUZ2CIvx2GIO0RV+POFBh1BcT67/j
         ElLjBgNW1YuZ5CQz73fCLLw2Bf4XJgegV0xVCu6HSLb30f2xR7Te9pNFu0LOap9vj7/F
         E6X9iPLWjuz+gs0fKtQO3TYOxmgyv2UPzUEf2s84xxZzGtCOmqWBT+kkZ+EDJzZPVnKY
         VM9A+vCmfxpAyFsJXPiXgh5/siHQAAle7TSplwahn16dqsW1XsMWnaOvdeOwU1v+n5l6
         wPUQ==
Content-Disposition: inline
In-Reply-To: <20190806132412.92945-1-marc@koderer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marc Koderer <marc@koderer.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 06, 2019 at 03:24:12PM +0200, Marc Koderer wrote:
> Instead of using its own logic for k-/vmalloc rely on
> kvmalloc which is actually doing quite the same.
> 
> Signed-off-by: Marc Koderer <marc@koderer.com>

Applied to cgroup/for-5.4.

Thanks.

-- 
tejun
